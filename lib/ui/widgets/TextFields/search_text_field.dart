import 'package:flutter/material.dart';
import 'package:hudayi/ui/helper/App_Colors.dart';
import 'package:hudayi/ui/widgets/textfield_container.dart';

class SearchTextField extends StatelessWidget {
  final TextEditingController searchController;
  final String title;
  final void Function(String?)? onChanged;
  const SearchTextField({super.key, required this.searchController, required this.title, this.onChanged});

  @override
  Widget build(BuildContext context) {
    searchController.selection = TextSelection.collapsed(offset: searchController.text.length);

    return Padding(
      padding: const EdgeInsets.only(left: 8.0, right: 8, bottom: 15),
      child: TextFieldContainer(
        controller: searchController,
        hintText: title,
        hintTextSize: 20,
        hintTextColor: Colors.grey,
        fillcolor: Colors.white,
        errorMsg: "",
        onTap: () {
          if (searchController.selection == TextSelection.fromPosition(TextPosition(offset: searchController.text.length - 1))) {
            searchController.selection = TextSelection.fromPosition(TextPosition(offset: searchController.text.length));
          }
        },
        validator: (String? value) {
          if (value!.isEmpty) {
            return '';
          }
          return null;
        },
        keyboardType: TextInputType.name,
        onChanged: onChanged ?? (_) {},
        presuffixIcon: const Icon(
          Icons.search,
          color: AppColors.primary,
        ),
      ),
    );
  }
}
