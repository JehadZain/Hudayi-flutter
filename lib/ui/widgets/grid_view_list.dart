import 'dart:convert';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:focused_menu/focused_menu.dart';
import 'package:focused_menu/modals.dart';
import 'package:hudayi/main.dart';
import 'package:hudayi/models/user_model.dart';
import 'package:hudayi/screens/profiles/profile_Page.dart';
import 'package:hudayi/ui/helper/App_Colors.dart';
import 'package:hudayi/ui/helper/App_Functions.dart';
import 'package:hudayi/ui/helper/App_Icons.dart';
import 'package:hudayi/ui/helper/String_Casing_Extension.dart';
import 'package:hudayi/ui/widgets/Circule_Progress.dart';
import 'package:hudayi/ui/widgets/TextFields/search_Text_Field.dart';
import 'package:hudayi/ui/widgets/anmiation_card.dart';
import 'package:hudayi/ui/widgets/no_Internet.dart';
import 'package:provider/provider.dart';

class GridViewList extends StatefulWidget {
  final TextEditingController searchController;
  final ScrollController controller;
  final String pageType;
  final Widget? addPage;
  final Future? future;
  final String? futureListName;
  final List? list;
  final List<Widget> tabs;
  final bool? permmission;
  final void Function(dynamic)? itemClick;
  final bool? isClickable;
  final int? teacherClassRoomId;
  final int? property_id;
  final String? property_type;
  final void Function()? onTap;
  final Future<void> Function(dynamic, dynamic)? onEditPressed;
  final Future<void> Function(dynamic, dynamic)? onDeletePressed;
  final Future<void> Function(dynamic, dynamic)? onTransferPressed;
  final Future<void> Function() onRefresh;
  final Function(dynamic)? onSearch;
  final bool? isEmpty;
  final bool? isLoading;
  const GridViewList({
    super.key,
    required this.searchController,
    required this.controller,
    this.onSearch,
    this.isEmpty,
    this.isLoading,
    required this.pageType,
    this.property_type,
    this.itemClick,
    this.futureListName,
    this.property_id,
    this.list,
    required this.addPage,
    this.future,
    this.onTap,
    required this.tabs,
    this.onEditPressed,
    this.onDeletePressed,
    this.permmission,
    this.teacherClassRoomId,
    this.onTransferPressed,
    this.isClickable,
    required this.onRefresh,
  });

  @override
  State<GridViewList> createState() => _GridViewListState();
}

class _GridViewListState extends State<GridViewList> {
  List finalList = [];

  @override
  void initState() {
    setState(() {
      finalList = widget.list!;
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        if (!isConnected) const NoInternet(),
        //TODO:translate
        SearchTextField(
          searchController: widget.searchController,
          title: translate(context).search,
          onChanged: (value) async {
            if (widget.onSearch != null) {
              widget.onSearch!(value);
            }
            setState(() {});
          },
        ),
        Expanded(
          child: widget.future != null
              ? FutureBuilder(
                  future: widget.future,
                  builder: (BuildContext context, AsyncSnapshot snapshot) {
                    if (snapshot.connectionState == ConnectionState.done) {
                      List details = snapshot.data == null
                          ? []
                          : widget.futureListName == null
                              ? snapshot.data["data"]
                              : snapshot.data["data"][widget.futureListName] ?? [];
                      return WeshouldDeleteThisGridViewAfterAddingAllFutures(
                        widget: widget,
                        details: details,
                      );
                    }
                    return const CirculeProgress();
                  })
              : WeshouldDeleteThisGridViewAfterAddingAllFutures(
                  widget: widget,
                  details: widget.list!,
                ),
        ),
      ],
    );
  }
}

class WeshouldDeleteThisGridViewAfterAddingAllFutures extends StatelessWidget {
  const WeshouldDeleteThisGridViewAfterAddingAllFutures({
    Key? key,
    required this.widget,
    required this.details,
  }) : super(key: key);

  final GridViewList widget;
  final List details;

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      color: AppColors.primary,
      onRefresh: widget.onRefresh,
      child: Scrollbar(
        radius: const Radius.circular(18),
        thickness: 3,
        controller: widget.controller,
        child: GridView.count(
          primary: false,
          physics: const AlwaysScrollableScrollPhysics(),
          controller: widget.controller,
          padding: const EdgeInsets.only(left: 8.0, right: 8, top: 0, bottom: 4),
          crossAxisSpacing: 10,
          mainAxisSpacing: 10,
          crossAxisCount: 3,
          children: <Widget>[
            if (isConnected)
              if (widget.permmission != false)
                widget.addPage == null
                    ? GestureDetector(
                        onTap: widget.onTap,
                        child: Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(16.0),
                              color: AppColors.primary,
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.grey.withOpacity(0.5),
                                  spreadRadius: 0,
                                  blurRadius: 1,
                                  offset: const Offset(0, 1),
                                ),
                              ],
                            ),
                            // padding: const EdgeInsets.all(15),
                            child: Column(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                              const SizedBox(height: 8),
                              const Icon(
                                Icons.add,
                                color: Colors.white,
                                size: 55,
                              ),
                              Container(
                                width: double.infinity,
                                decoration: const BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.only(
                                    bottomLeft: Radius.circular(16),
                                    bottomRight: Radius.circular(16),
                                  ),
                                ),
                                child: Center(
                                    child: Padding(
                                  padding: const EdgeInsets.only(left: 8.0, right: 8, bottom: 4),
                                  child: Text(
                                    translate(context).addItem,
                                    style: const TextStyle(
                                      fontSize: 12,
                                    ),
                                    maxLines: 1,
                                  ),
                                )),
                              )
                            ])),
                      )
                    : AnmiationCard(
                        closedElevation: 0.8,
                        page: Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(16.0),
                              color: AppColors.primary,
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.grey.withOpacity(0.5),
                                  spreadRadius: 0,
                                  blurRadius: 1,
                                  offset: const Offset(0, 1),
                                ),
                              ],
                            ),
                            // padding: const EdgeInsets.all(15),
                            child: Column(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                              const SizedBox(height: 8),
                              const Icon(
                                Icons.add,
                                color: Colors.white,
                                size: 55,
                              ),
                              Container(
                                width: double.infinity,
                                decoration: const BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.only(
                                    bottomLeft: Radius.circular(16),
                                    bottomRight: Radius.circular(16),
                                  ),
                                ),
                                child: Center(
                                    child: Padding(
                                  padding: const EdgeInsets.only(left: 8.0, right: 8, bottom: 4),
                                  child: Text(
                                    translate(context).addItem,
                                    style: const TextStyle(
                                      fontSize: 12,
                                    ),
                                    maxLines: 1,
                                  ),
                                )),
                              )
                            ])),
                        displayedPage: widget.addPage!,
                      ),
            if (widget.isEmpty == true) Center(child: Text(translate(context).noDataAvailable)),
            if (widget.isLoading == true) const CirculeProgress(),
            for (Map item in widget.searchController.text == ""
                ? details
                : details
                    .where((e) =>
                        e["name"].contains(widget.searchController.text.toTitleCase()) ||
                        e["name"].contains(widget.searchController.text) ||
                        e["name"].contains(widget.searchController.text.toCapitalized()))
                    .toList())
              if (item["left_at"] == null)
                Stack(
                  children: [
                    AnmiationCard(
                      closedElevation: 0.8,
                      displayedPage: ProfilePage(
                          tabs: widget.tabs,
                          pageType: widget.pageType,
                          profileDetails: widget.property_id == null ? item : {...item, "property_id": widget.property_id}),
                      page: GestureDetector(
                        onTap: widget.itemClick != null
                            ? () {
                                widget.itemClick!(item);
                              }
                            : (item["is_approved"] == "0"
                                ? () {}
                                : widget.isClickable == true
                                    ? null
                                    : widget.permmission != false
                                        ? null
                                        : () {}),
                        child: Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(20.0),
                            color: Colors.white,
                            border: (Border.all(
                                width: 3,
                                color: item["is_approved"] == "0"
                                    ? Colors.red
                                    : widget.teacherClassRoomId == item["id"]
                                        ? Colors.grey
                                        : item["status"] == translate(context).inactive || item["status"] =="0"
                                            ? Colors.red
                                            : Colors.white)),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.grey.withOpacity(0.5),
                                spreadRadius: 0,
                                blurRadius: 1,
                                offset: const Offset(0, 1),
                              ),
                            ],
                          ),
                          // padding: const EdgeInsets.all(15),

                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              Expanded(
                                child: Container(
                                  width: double.infinity,
                                  decoration: BoxDecoration(
                                    borderRadius: const BorderRadius.only(topLeft: Radius.circular(16.0), topRight: Radius.circular(16)),
                                    color: Colors.transparent,
                                    image: DecorationImage(
                                        fit: BoxFit.cover,
                                        onError: (context, error) {},
                                        image: item['image'] != null
                                            ? CachedNetworkImageProvider(AppFunctions().getImage(item["image"]) ?? AppIcons.branchTemp,
                                                maxHeight: 100, maxWidth: 100)
                                            : AssetImage(widget.pageType == "class" || widget.pageType == "subClass"
                                                ? AppIcons.branchAvatr
                                                : widget.pageType == "teacher"
                                                    ? AppIcons.teacherAvatar
                                                    : widget.pageType == "student" && item["gender"] == translate(context).male
                                                        ? AppIcons.studentMaleAvatar
                                                        : widget.pageType == "student" && item["gender"] == translate(context).female
                                                            ? AppIcons.studentGirlAvatar
                                                            : widget.pageType == "book"
                                                                ? AppIcons.bookAvatar
                                                                : widget.pageType == "admin"
                                                                    ? AppIcons.adminAvatar
                                                                    : AppIcons.bookAvatar) as ImageProvider),
                                  ),
                                ),
                              ),
                              Container(
                                width: double.infinity,
                                decoration: const BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.only(
                                    bottomLeft: Radius.circular(16),
                                    bottomRight: Radius.circular(16),
                                  ),
                                ),
                                child: Center(
                                    child: Padding(
                                  padding: const EdgeInsets.only(left: 8.0, right: 8, bottom: 4),
                                  child: Text(
                                    item['name'] ?? "",
                                    textAlign: TextAlign.center,
                                    style: const TextStyle(
                                      fontSize: 12,
                                    ),
                                    maxLines: 1,
                                  ),
                                )),
                              )
                            ],
                          ),
                        ),
                      ),
                    ),
                    if (widget.teacherClassRoomId == item["id"] && widget.pageType == "subClass")
                      Positioned(
                          right: 5,
                          top: 5,
                          child: FocusedMenuHolder(
                              blurSize: 5.0,
                              menuBoxDecoration: const BoxDecoration(color: Colors.grey, borderRadius: BorderRadius.all(Radius.circular(15.0))),
                              duration: const Duration(milliseconds: 100),
                              animateMenuItems: true,
                              menuWidth: 200,
                              blurBackgroundColor: Colors.black54,
                              openWithTap: true, // Open Focused-Menu on Tap rather than Long Press
                              onPressed: () {},
                              menuItems: [
                                if (widget.onEditPressed != null)
                                  FocusedMenuItem(
                                      title: Text(
                                        translate(context).edit,
                                        style: const TextStyle(color: Colors.green),
                                      ),
                                      trailingIcon: const Icon(
                                        Icons.edit,
                                        color: Colors.green,
                                      ),
                                      onPressed: () {
                                        if (widget.onEditPressed != null) {
                                          widget.onEditPressed!(item, details.indexOf(item));
                                        }
                                      }),
                                if (widget.onTransferPressed != null)
                                  FocusedMenuItem(
                                      title: Text(
                                        translate(context).transfer,
                                        style: TextStyle(color: Colors.green),
                                      ),
                                      trailingIcon: const Icon(
                                        Icons.transfer_within_a_station,
                                        color: Colors.green,
                                      ),
                                      onPressed: () {
                                        if (widget.onTransferPressed != null) {
                                          widget.onTransferPressed!(item, details.indexOf(item));
                                        }
                                      }),
                              ],
                              child: const Icon(
                                Icons.more_vert,
                                size: 18,
                                color: Colors.white,
                              ))),
                    if (item["is_approved"] != "0")
                      if (isConnected)
                        if ((widget.onEditPressed != null || widget.onDeletePressed != null) && widget.permmission != false)
                          Positioned(
                              right: 5,
                              top: 5,
                              child: FocusedMenuHolder(
                                  blurSize: 5.0,
                                  menuBoxDecoration: const BoxDecoration(color: Colors.grey, borderRadius: BorderRadius.all(Radius.circular(15.0))),
                                  duration: const Duration(milliseconds: 100),
                                  animateMenuItems: true,
                                  menuWidth: 200,
                                  blurBackgroundColor: Colors.black54,
                                  openWithTap: true, // Open Focused-Menu on Tap rather than Long Press
                                  onPressed: () {},
                                  menuItems: [
                                    if (widget.onEditPressed != null)
                                      FocusedMenuItem(
                                          title: Text(
                                            translate(context).edit,
                                            style: const TextStyle(color: Colors.green),
                                          ),
                                          trailingIcon: const Icon(
                                            Icons.edit,
                                            color: Colors.green,
                                          ),
                                          onPressed: () {
                                            if (widget.onEditPressed != null) {
                                              widget.onEditPressed!(item, details.indexOf(item));
                                            }
                                          }),
                                    if (widget.onTransferPressed != null)
                                      FocusedMenuItem(
                                          title: Text(
                                            translate(context).transfer,
                                            style: const TextStyle(color: Colors.green),
                                          ),
                                          trailingIcon: const Icon(
                                            Icons.transfer_within_a_station,
                                            color: Colors.green,
                                          ),
                                          onPressed: () {
                                            if (widget.onTransferPressed != null) {
                                              widget.onTransferPressed!(item, details.indexOf(item));
                                            }
                                          }),
                                    if (widget.onDeletePressed != null)
                                      FocusedMenuItem(
                                          title: Text(
                                            jsonDecode(Provider.of<AuthService>(context, listen: false).user.toUser())["role"] == "teacher"
                                                ? item["status"] != translate(context).inactive || item["status"] != "0"
                                                    ? translate(context).deactivateStudent
                                                    : translate(context).activateStudent
                                                : translate(context).delete,
                                            style: TextStyle(
                                                color: jsonDecode(Provider.of<AuthService>(context, listen: false).user.toUser())["role"] != "teacher"
                                                    ? Colors.redAccent
                                                    : item["status"] != translate(context).inactive ||
                                                            item["status"] !=
                                                                "0"
                                                        ? Colors.redAccent
                                                        : Colors.green),
                                          ),
                                          trailingIcon: Icon(
                                            jsonDecode(Provider.of<AuthService>(context, listen: false).user.toUser())["role"] != "teacher"
                                                ? Icons.delete
                                                : item["status"] != translate(context).inactive ||
                                                        item["status"] != "0"
                                                    ? Icons.delete
                                                    : Icons.check,
                                            color: jsonDecode(Provider.of<AuthService>(context, listen: false).user.toUser())["role"] != "teacher"
                                                ? Colors.redAccent
                                                : item["status"] != translate(context).inactive ||
                                                        item["status"] != "0"
                                                    ? Colors.redAccent
                                                    : Colors.green,
                                          ),
                                          onPressed: () {
                                            if (widget.onDeletePressed != null) {
                                              widget.onDeletePressed!(item, details.indexOf(item));
                                            }
                                          }),
                                  ],
                                  child: const Icon(
                                    Icons.more_vert,
                                    size: 18,
                                    color: Colors.white,
                                  ))),
                  ],
                )
          ],
        ),
      ),
    );
  }
}
