import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:hudayi/main.dart';
import 'package:hudayi/models/user_model.dart';
import 'package:hudayi/screens/add/add.dart';
import 'package:hudayi/ui/helper/AppColors.dart';
import 'package:hudayi/ui/helper/AppFunctions.dart';
import 'package:hudayi/ui/widgets/anmiation_card.dart';
import 'package:provider/provider.dart';

class EditDeleteRow extends StatefulWidget {
  final Function()? editOnTap;
  final String editPageTitle;
  final Function()? deleteOnTap;
  final List<dynamic> fields;
  final Function()? onPressed;
  const EditDeleteRow(
      {super.key, required this.deleteOnTap, required this.editOnTap, required this.editPageTitle, required this.fields, this.onPressed});

  @override
  State<EditDeleteRow> createState() => _EditDeleteRowState();
}

class _EditDeleteRowState extends State<EditDeleteRow> {
  var authService;
  Map user = {};

  @override
  void initState() {
    authService = Provider.of<AuthService>(context, listen: false);
    if (authService.user.toUser() != "null") {
      user = jsonDecode(authService.user.toUser());
    }

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return isConnected
        ? Padding(
            padding: const EdgeInsets.only(top: 2.0),
            child: IntrinsicHeight(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  widget.fields.isEmpty
                      ? GestureDetector(
                          onTap: widget.editOnTap,
                          child: Text(
                            translate(context).edit,
                            style: const TextStyle(color: AppColors.primary, fontSize: 13, fontWeight: FontWeight.bold),
                          ),
                        )
                      : AnmiationCard(
                          onTap: widget.editOnTap,
                          page: Text(
                            translate(context).edit,
                            style: const TextStyle(color: AppColors.primary, fontSize: 13, fontWeight: FontWeight.bold),
                          ),
                          displayedPage: AddPage(
                              isEdit: true,
                              fields: widget.fields,
                              title: widget.editPageTitle,
                              onPressed: widget.onPressed ?? () {},
                              englishTitle: "area")),
                  if (user["role"] == "admin")
                    const VerticalDivider(
                      color: Colors.black,
                    ),
                  if (user["role"] == "admin")
                    GestureDetector(
                        onTap: widget.deleteOnTap,
                        child: Text(
                          translate(context).delete,
                          style: const TextStyle(color: Colors.red, fontSize: 13, fontWeight: FontWeight.bold),
                        )),
                ],
              ),
            ),
          )
        : Container();
  }
}
