class Validator {
  Validator();

  String? email(String? value) {
    const pattern = r'^[a-zA-Z0-9._]+@[a-zA-Z0-9_]+\.[a-zA-Z_]+';
    final regex = RegExp(pattern);
    if (!regex.hasMatch(value!)) {
      return "Format email tidak sesuai";
    } else {
      return null;
    }
  }

  String? validateUsername(String? value) {
    if (value!.isEmpty) {
      return 'Dibutuhkan';
    }
    final nameExp = RegExp(r'^[A-Za-z0-9]+$');
    if (!nameExp.hasMatch(value)) {
      return 'Hanya huruf Alphabet yang di izinkan';
    }
    return null;
  }

  String? password(String? value) {
    const pattern = r'^.{6,}$';
    final regex = RegExp(pattern);
    if (!regex.hasMatch(value!)) {
      return "Password minimal 6 Karakter";
    } else {
      return null;
    }
  }

  String? name(String? value) {
    const pattern = r"^[a-zA-Z]+(([',. -][a-zA-Z ])?[a-zA-Z]*)*$";
    final regex = RegExp(pattern);
    if (!regex.hasMatch(value!)) {
      return "Karakter hanya di izinkan Alphabet";
    } else {
      return null;
    }
  }

  String? address(String? value) {
    final regex = RegExp(r'^[A-Za-z0-9,.()# -]+$');
    if (!regex.hasMatch(value!)) {
      return "Karakter hanya di izinkan Alphabet dan angka";
    } else {
      return null;
    }
  }

  String? phoneNumber(String? value) {
    if (value!.isEmpty) {
      return "Nomor handphone tidak boleh kosong";
    }
    final nameExp = RegExp(r'^[0-9+]+$');
    if (!nameExp.hasMatch(value)) {
      return "Hanya angka";
    }
    return null;
  }
}
