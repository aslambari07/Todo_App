import 'package:flutter/material.dart';

class SearchWidget extends StatelessWidget {
  final TextEditingController searchController;
  final Function(String) onSearch;

  const SearchWidget(
      {super.key, required this.searchController, required this.onSearch});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: TextField(
        controller: searchController,
        decoration: InputDecoration(
          hintText: 'Search',
          prefixIcon: const Icon(Icons.search),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(20.0),
          ),
          contentPadding: const EdgeInsets.symmetric(
            vertical: 10.0,
            horizontal: 16.0,
          ),
        ),
        onChanged: onSearch,
      ),
    );
  }
}
