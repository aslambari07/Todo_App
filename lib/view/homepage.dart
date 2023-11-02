import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:todo_list2/models/todomodel.dart';
import 'package:todo_list2/view/dialog_helper.dart';
import 'package:todo_list2/view/showfrom.dart';
import 'package:todo_list2/widgets/search_widget.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  CollectionReference dataToDo =
      FirebaseFirestore.instance.collection('Activity');

  final GlobalKey<FormState> formKeySignin = GlobalKey<FormState>();
  final TextEditingController titleText = TextEditingController();
  final TextEditingController subTitleText = TextEditingController();
  final TextEditingController tagText = TextEditingController();
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  String? dropDownValue = '';
  List<ToDoModel> dataActivity = <ToDoModel>[];
  bool isLove = false;

  void textClear() {
    titleText.clear();
    subTitleText.clear();
  }

  Future<void> deleteActivity(String id) async {
    try {
      await dataToDo.doc(id).delete();
      print("Activity Deleted");
    } catch (error) {
      print("Failed to delete Activity: $error");
    }
  }

  Future<void> updateActivity(id) async {
    try {
      await dataToDo.doc(id).update({
        'Title': titleText.text,
        'Deskripsi': subTitleText.text,
        'Keperluan': dropDownValue.toString(),
      });
      print("Activity Updated");
    } catch (error) {
      print("Failed to Update Activity: $error");
    }
  }

  void handleSubmit() {
    print(titleText.text);
    print(subTitleText.text);
    print(dropDownValue);
  }

  final Stream<QuerySnapshot> streamActivity =
      FirebaseFirestore.instance.collection('Activity').snapshots();

  void addToDo() {
    dataToDo
        .add({
          'Title': titleText.text,
          'Deskripsi': subTitleText.text,
          'Keperluan': dropDownValue.toString(),
        })
        .then((value) => print("Activity Added"))
        .catchError((error) => print("Failed to add Activity: $error"));
  }

  late FormDialog formDialog;

  @override
  void initState() {
    formDialog = FormDialog(
      titleText: titleText,
      subTitleText: subTitleText,
      dropDownValue: dropDownValue,
      dataToDo: dataToDo,
    );
    textClear();
    super.initState();
  }

  List<Color> colorsTag = [
    Colors.redAccent,
    Colors.teal,
    Colors.green,
    Colors.grey,
  ];

  void showForm() {
    formDialog.showForm(context, textClear, addToDo);
  }

  final TextEditingController searchController = TextEditingController();
  List<DocumentSnapshot> searchResults = [];

  Future<void> searchData(String searchTerm) async {
    searchTerm = searchTerm.toLowerCase();
    QuerySnapshot querySnapshot = await FirebaseFirestore.instance
        .collection('Activity')
        .where('Title', isEqualTo: searchTerm)
        .get();

    print("Search Term: $searchTerm");
    print("Query Snapshot: ${querySnapshot.docs.length} documents found");

    if (querySnapshot.docs.isNotEmpty) {
      setState(() {
        searchResults = querySnapshot.docs;
      });
    } else {
      setState(() {
        searchResults.clear();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    DateTime selectDate = DateTime.now();

    return Scaffold(
      appBar: AppBar(
        title: const Text('TO DO APP'),
        centerTitle: true,
        actions: [
          IconButton(
            padding: const EdgeInsets.symmetric(horizontal: 30),
            onPressed: () {
              showDatePicker(
                context: context,
                initialDate: selectDate,
                firstDate: selectDate,
                lastDate: DateTime(2500),
              );
            },
            icon: const Icon(
              Icons.date_range_outlined,
              size: 40,
            ),
          ),
        ],
      ),
      extendBody: true,
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          showForm();
        },
        child: const Icon(
          Icons.add_circle_outline,
          size: 50,
        ),
      ),
      bottomNavigationBar: BottomAppBar(
        clipBehavior: Clip.antiAlias,
        shape: const CircularNotchedRectangle(),
        color: Theme.of(context).primaryColor.withAlpha(255),
        elevation: 0,
        child: BottomNavigationBar(
          elevation: 0,
          backgroundColor: Theme.of(context).primaryColor.withAlpha(0),
          selectedItemColor: Theme.of(context).colorScheme.onSurface,
          items: [
            BottomNavigationBarItem(
              icon: Icon(
                Icons.list_alt_rounded,
                size: 40,
                color: Theme.of(context).colorScheme.onBackground,
              ),
              label: 'Home',
            ),
            BottomNavigationBarItem(
              icon: Icon(
                Icons.label,
                size: 40,
                color: Theme.of(context).colorScheme.onBackground,
              ),
              label: 'Edit',
            ),
          ],
        ),
      ),
      body: Column(
        children: [
          SearchWidget(
            searchController: searchController,
            onSearch: searchData,
          ),
          Expanded(
            child: StreamBuilder<QuerySnapshot>(
              stream: streamActivity,
              builder: (BuildContext context,
                  AsyncSnapshot<QuerySnapshot> snapshot) {
                if (snapshot.hasError) {
                  return const Text('Something went wrong');
                }

                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Text("Loading");
                }

                return ListView(
                  padding: const EdgeInsets.all(5),
                  children: (searchResults.isNotEmpty
                          ? searchResults
                          : snapshot.data!.docs)
                      .map((DocumentSnapshot document) {
                    ToDoModel toDoModel = ToDoModel.fromMap(
                        document.data() as Map<String, dynamic>);

                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        ListTile(
                          style: ListTileStyle.list,
                          title: Text(toDoModel.title ?? ''),
                          subtitle: Text(toDoModel.deskripsi ?? ''),
                          leading: Container(
                            height: 10,
                            width: 10,
                            decoration: BoxDecoration(
                              color:
                                  toDoModel.isLove ? Colors.red : Colors.blue,
                              borderRadius: BorderRadius.circular(20),
                            ),
                          ),
                          trailing: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              IconButton(
                                icon: Icon(
                                  toDoModel.isLove
                                      ? Icons.favorite
                                      : Icons.favorite_border,
                                  color: toDoModel.isLove ? Colors.red : null,
                                ),
                                onPressed: () {
                                  setState(() {
                                    toDoModel.isLove = !toDoModel.isLove;
                                  });
                                  dataToDo
                                      .doc(document.id)
                                      .update({'IsLove': toDoModel.isLove});
                                },
                              ),
                              PopupMenuButton(
                                itemBuilder: (context) {
                                  return [
                                    const PopupMenuItem<int>(
                                      value: 0,
                                      child: Text("Edit"),
                                    ),
                                    const PopupMenuItem<int>(
                                      value: 1,
                                      child: Text("Delete"),
                                    ),
                                  ];
                                },
                                onSelected: (value) async {
                                  if (value == 1) {
                                    showDialog(
                                      context: context,
                                      builder: (context) {
                                        return AlertDialog(
                                          alignment: Alignment.center,
                                          title: const Text(
                                            'Delete Task?',
                                            textAlign: TextAlign.center,
                                          ),
                                          content: Column(
                                            mainAxisSize: MainAxisSize.min,
                                            children: [
                                              const Text(
                                                'Are You Sure Want To Delete This Item?',
                                              ),
                                              const SizedBox(
                                                height: 25,
                                              ),
                                              Text(
                                                toDoModel.title ?? '',
                                                style: const TextStyle(
                                                    fontSize: 20),
                                              ),
                                            ],
                                          ),
                                          actions: [
                                            ElevatedButton(
                                              style: ElevatedButton.styleFrom(
                                                backgroundColor: Colors.green,
                                              ),
                                              onPressed: () {
                                                Navigator.of(context).pop();
                                              },
                                              child: const Text('Cancel'),
                                            ),
                                            ElevatedButton(
                                              style: ElevatedButton.styleFrom(
                                                backgroundColor: Colors.red,
                                              ),
                                              onPressed: () {
                                                setState(() {
                                                  deleteActivity(document.id);
                                                  Navigator.of(context).pop();
                                                  ScaffoldMessenger.of(context)
                                                      .showSnackBar(
                                                    const SnackBar(
                                                      content: Text(
                                                        'You Have Successfully Deleted an Activity',
                                                      ),
                                                    ),
                                                  );
                                                });
                                              },
                                              child: const Text('Delete'),
                                            ),
                                          ],
                                        );
                                      },
                                    );
                                  } else if (value == 0) {
                                    if (toDoModel != null) {
                                      titleText.text = toDoModel.title ?? '';
                                      subTitleText.text =
                                          toDoModel.deskripsi ?? '';
                                      dropDownValue = toDoModel.kategori ?? '';

                                      showEditDialog(
                                        context,
                                        titleText,
                                        subTitleText,
                                        dropDownValue!,
                                        document.id,
                                        updateActivity,
                                      );
                                    }
                                  }
                                },
                              ),
                            ],
                          ),
                        ),
                      ],
                    );
                  }).toList(),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
