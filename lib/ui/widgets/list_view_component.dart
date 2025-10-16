import 'package:flutter/material.dart';
import 'package:focused_menu/focused_menu.dart';
import 'package:focused_menu/modals.dart';
import 'package:hudayi/main.dart';
import 'package:hudayi/screens/profiles/profile_Page.dart';
import 'package:hudayi/screens/profiles/pages/session.dart';
import 'package:hudayi/ui/helper/App_Colors.dart';
import 'package:hudayi/ui/helper/App_Functions.dart';
import 'package:hudayi/ui/helper/String_Casing_Extension.dart';
import 'package:hudayi/ui/styles/app_Box_Shadow.dart';
import 'package:hudayi/ui/widgets/Circule_Progress.dart';
import 'package:hudayi/ui/widgets/TextFields/search_Text_Field.dart';
import 'package:hudayi/ui/widgets/add_Container.dart';
import 'package:hudayi/ui/widgets/anmiation_card.dart';

class ListViewComponent extends StatefulWidget {
  final TextEditingController searchController;
  final ScrollController controller;
  final Widget? addPage;
  final String pageType;
  final List? list;
  final Future? future;
  final String? futureListName;
  final Map? refactoredObject;
  final bool? permmission;
  final bool? isClickable;
  final bool? isAdding;

  final List<Widget> tabs;
  final Widget? itemContainer;
  final Future<void> Function(dynamic, dynamic)? onEditPressed;
  final Future<void> Function(dynamic, dynamic)? onDeletePressed;
  final Function()? onTap;
  final Function(dynamic)? disableContaineronTap;
  final Function(dynamic)? onSearch;
  final bool? isEmpty;
  final bool? isLoading;
  final Future<void> Function() onRefresh;
  const ListViewComponent(
      {super.key,
      required this.searchController,
      required this.controller,
      required this.tabs,
      this.futureListName,
      this.isAdding,
      this.list,
      this.addPage,
      this.isEmpty,
      this.isLoading,
      this.future,
      required this.pageType,
      this.refactoredObject,
      this.onEditPressed,
      this.onDeletePressed,
      this.onSearch,
      this.onTap,
      this.itemContainer,
      this.permmission,
      this.isClickable,
      this.disableContaineronTap,
      required this.onRefresh});

  @override
  State<ListViewComponent> createState() => _ListViewComponentState();
}

class _ListViewComponentState extends State<ListViewComponent> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SearchTextField(
          searchController: widget.searchController,
          title: translate(context).search,
          onChanged: (value) {
            widget.onSearch!(value);
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
                        details: widget.futureListName == "subjects"
                            ? details.map((item) => item["books"]).expand((element) => element).toList().asMap().entries.map((entry) {
                                return {
                                  "id": entry.value["id"],
                                  "name": entry.value["name"] ?? translate(context).not_available,
                                  "description":
                                      "${translate(context).authorName}:${entry.value["author_name"] ?? translate(context).not_available} , ${translate(context).book_pages_count}: ${entry.value["paper_count"] ?? translate(context).not_available}",
                                  "author_name": entry.value["author_name"] ?? translate(context).not_available,
                                  "paper_count": entry.value["paper_count"] ?? translate(context).not_available,
                                  "type": entry.value["size"] ?? translate(context).not_available,
                                  "date": entry.value["created_at"]?.split("T")[0] ?? translate(context).not_available,
                                };
                              }).toList()
                            : widget.refactoredObject == null
                                ? details
                                : details.asMap().entries.map((entry) {
                                    return widget.refactoredObject;
                                  }).toList(),
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

  final ListViewComponent widget;
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
        child: ListView(
          primary: false,
          physics: const AlwaysScrollableScrollPhysics(),
          controller: widget.controller,
          padding: const EdgeInsets.fromLTRB(0, 5, 0, 0),
          children: <Widget>[
            if (isConnected || widget.pageType == "quran" || widget.pageType == "session")
              if (widget.permmission != false && widget.isAdding != false)
                widget.addPage == null
                    ? GestureDetector(
                        onTap: widget.onTap,
                        child: Padding(
                          padding: const EdgeInsets.only(left: 8.0, right: 8, top: 0, bottom: 4),
                          child: Container(
                              height: 85,
                              decoration: BoxDecoration(
                                color: AppColors.primary,
                                borderRadius: BorderRadius.circular(15),
                                boxShadow: [AppBoxShadow.containerBoxShadow],
                              ),
                              child: Center(
                                  child: Text(
                                translate(context).addNewItem,
                                style: const TextStyle(color: Colors.white, fontSize: 17, fontWeight: FontWeight.bold),
                              ))),
                        ),
                      )
                    : AddContainer(
                        onTap: widget.onTap ?? () {},
                        text: translate(context).addNewItem,
                        page: widget.addPage!,
                      ),
            if (widget.isEmpty == true) Center(child: Text(translate(context).noDataAvailable)),
            if (widget.isLoading == true) const CirculeProgress(),
            for (Map item in widget.searchController.text == ""
                ? details
                : details
                    .where((e) =>
                        e["name"].contains(widget.searchController.text.toTitleCase()) ||
                        e["name"].contains(widget.searchController.text) ||
                        e["name"].contains(widget.searchController.text.toCapitalized()) ||
                        e["id"].toString().contains(widget.searchController.text.toTitleCase()) ||
                        e["id"].toString().contains(widget.searchController.text) ||
                        e["id"].toString().contains(widget.searchController.text.toCapitalized()))
                    .toList())
              widget.itemContainer != null
                  ? Padding(
                      padding: const EdgeInsets.only(left: 8.0, right: 8, top: 8, bottom: 4),
                      child: GestureDetector(
                        onTap: widget.isClickable == true
                            ? null
                            : widget.permmission != false
                                ? null
                                : () {},
                        child: Container(
                          width: double.infinity,
                          decoration: BoxDecoration(
                            color: const Color(0XFFF9F9FB),
                            boxShadow: const [
                              BoxShadow(
                                blurRadius: 5,
                                color: Color(0x44111417),
                                offset: Offset(0, 2),
                              )
                            ],
                            borderRadius: BorderRadius.circular(14),
                          ),
                          child: Padding(
                            padding: const EdgeInsetsDirectional.fromSTEB(15, 0, 15, 0),
                            child: IntrinsicHeight(
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    item["startTime"] ?? "4:01 م ",
                                    style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                                  ),
                                  VerticalDivider(
                                    color: Colors.black.withOpacity(0.3),
                                  ),
                                  Expanded(
                                      child: Padding(
                                    padding: const EdgeInsets.only(top: 8.0, bottom: 8),
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: [
                                        Row(
                                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                          children: [
                                            Expanded(child: Text("${translate(context).lessonMaterial}: ${item["subject"]}")),
                                            if (widget.permmission != false)
                                              Padding(
                                                padding: const EdgeInsets.only(top: 2.0),
                                                child: IntrinsicHeight(
                                                  child: Row(
                                                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                                    children: [
                                                      if (widget.onEditPressed != null)
                                                        GestureDetector(
                                                            onTap: () {
                                                              if (widget.onEditPressed != null) {
                                                                widget.onEditPressed!(item, details.indexOf(item));
                                                              }
                                                            },
                                                            child: Text(
                                                              translate(context).edit,
                                                              style: const TextStyle(
                                                                  color: AppColors.primary, fontSize: 13, fontWeight: FontWeight.bold),
                                                            )),
                                                      const VerticalDivider(
                                                        color: Colors.black,
                                                      ),
                                                      GestureDetector(
                                                          onTap: () {
                                                            if (widget.onDeletePressed != null) {
                                                              widget.onDeletePressed!(item, details.indexOf(item));
                                                            }
                                                          },
                                                          child: Text(
                                                            translate(context).delete,
                                                            style: const TextStyle(color: Colors.red, fontSize: 13, fontWeight: FontWeight.bold),
                                                          )),
                                                    ],
                                                  ),
                                                ),
                                              ),
                                          ],
                                        ),
                                        Text(
                                            "${translate(context).lessonDays}: ${item["day"].toString().replaceAll("[", " ").toString().replaceAll("]", " ")}"),
                                        Text("${translate(context).lessonEndDate} : ${item["endTime"]}"),
                                      ],
                                    ),
                                  )),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                    )
                  : AnmiationCard(
                      displayedPage: widget.pageType == "session"
                          ? Session(
                              details: item,
                              scrollController: widget.controller,
                            )
                          : ProfilePage(
                              tabs: widget.tabs,
                              pageType: widget.pageType,
                              profileDetails: item,
                            ),
                      page: Padding(
                          padding: const EdgeInsets.only(left: 8.0, right: 8, top: 8, bottom: 4),
                          child: GestureDetector(
                            onTap: item["is_approved"] == "0"
                                ? () {}
                                : widget.isClickable == true
                                    ? null
                                    : widget.permmission != false
                                        ? widget.disableContaineronTap != null
                                            ? () {
                                                widget.disableContaineronTap!(item);
                                              }
                                            : null
                                        : () {},
                            child: Container(
                                width: double.infinity,
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  border: (Border.all(
                                      width: 3,
                                      color: item["is_approved"] == "0"
                                          ? Colors.red
                                          : item["status"] == translate(context).inactive
                                              ? Colors.red
                                              : Colors.white)),
                                  boxShadow: const [
                                    BoxShadow(
                                      blurRadius: 5,
                                      color: Color(0x44111417),
                                      offset: Offset(0, 2),
                                    )
                                  ],
                                  borderRadius: BorderRadius.circular(14),
                                ),
                                child: Padding(
                                  padding: const EdgeInsetsDirectional.fromSTEB(4, 0, 0, 0),
                                  child: Row(
                                    mainAxisSize: MainAxisSize.max,
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Expanded(
                                        child: Padding(
                                          padding: const EdgeInsetsDirectional.fromSTEB(16, 16, 16, 12),
                                          child: Column(
                                            mainAxisSize: MainAxisSize.max,
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: [
                                              Row(
                                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                crossAxisAlignment: CrossAxisAlignment.start,
                                                mainAxisSize: MainAxisSize.max,
                                                children: [
                                                  Expanded(
                                                    child: Container(
                                                      child: Text(
                                                        item["name"] ?? '',
                                                        style: const TextStyle(
                                                          color: Color(0xFF101213),
                                                          fontSize: 18,
                                                          fontWeight: FontWeight.normal,
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                  if (item["type"] != null)
                                                    Padding(
                                                      padding: const EdgeInsets.only(top: 8.0),
                                                      child: Container(
                                                        decoration: BoxDecoration(
                                                            color: item["type"] == translate(context).methodological || item["type"] == "قرآن"
                                                                ? Colors.amber
                                                                : item["type"] == translate(context).inactive
                                                                    ? const Color.fromARGB(255, 255, 102, 91)
                                                                    : const Color(0XFFE6F5ED),
                                                            borderRadius: BorderRadius.circular(7)),
                                                        child: Padding(
                                                          padding: const EdgeInsetsDirectional.fromSTEB(20, 4, 20, 4),
                                                          child: Text(
                                                            item["type"]?.split("-")[0] ?? '',
                                                            style: const TextStyle(
                                                              color: Color(0xFF101213),
                                                              fontSize: 10,
                                                              fontWeight: FontWeight.bold,
                                                            ),
                                                          ),
                                                        ),
                                                      ),
                                                    ),
                                                ],
                                              ),
                                              Padding(
                                                padding: const EdgeInsetsDirectional.fromSTEB(0, 4, 0, 0),
                                                child: Text(
                                                  item["description"] ?? '',
                                                  style: const TextStyle(
                                                    color: Color(0xFF57636C),
                                                    fontSize: 14,
                                                    fontWeight: FontWeight.normal,
                                                  ),
                                                ),
                                              ),
                                              widget.permmission != false && widget.isAdding != false || item["is_approved"] == "1"
                                                  ? Padding(
                                                      padding: const EdgeInsetsDirectional.fromSTEB(0, 12, 0, 0),
                                                      child: Row(
                                                        mainAxisSize: MainAxisSize.max,
                                                        children: [
                                                          if (isConnected || widget.pageType == "quran" || widget.pageType == "session")
                                                            Expanded(
                                                              child: FocusedMenuHolder(
                                                                blurSize: 5.0,
                                                                menuBoxDecoration: const BoxDecoration(
                                                                    color: Colors.grey, borderRadius: BorderRadius.all(Radius.circular(15.0))),
                                                                duration: const Duration(milliseconds: 100),
                                                                animateMenuItems: true,
                                                                blurBackgroundColor: Colors.black54,
                                                                openWithTap: widget.onDeletePressed != null || widget.onEditPressed != null,
                                                                onPressed: () {},
                                                                menuItems: [
                                                                  if (isConnected)
                                                                    if (widget.onEditPressed != null)
                                                                      FocusedMenuItem(
                                                                          title: Text(
                                                                            translate(context).edit,
                                                                            style: const TextStyle(
                                                                              color: AppColors.primary,
                                                                            ),
                                                                          ),
                                                                          trailingIcon: const Icon(
                                                                            Icons.edit,
                                                                            color: AppColors.primary,
                                                                          ),
                                                                          onPressed: () async {
                                                                            if (widget.onEditPressed != null) {
                                                                              widget.onEditPressed!(item, details.indexOf(item));
                                                                            }
                                                                          }),
                                                                  if (widget.onDeletePressed != null)
                                                                    FocusedMenuItem(
                                                                        title: Text(
                                                                          translate(context).delete,
                                                                          style: const TextStyle(color: Colors.redAccent),
                                                                        ),
                                                                        trailingIcon: const Icon(
                                                                          Icons.delete,
                                                                          color: Colors.redAccent,
                                                                        ),
                                                                        onPressed: () {
                                                                          if (widget.onDeletePressed != null) {
                                                                            widget.onDeletePressed!(item, details.indexOf(item));
                                                                          }
                                                                        }),
                                                                ],
                                                                child: Text(
                                                                  translate(context).moreOptions,
                                                                  style: TextStyle(
                                                                    color: widget.onDeletePressed == null && widget.onEditPressed == null
                                                                        ? Colors.white
                                                                        : AppColors.primary,
                                                                    fontSize: 12,
                                                                    fontWeight: FontWeight.w500,
                                                                  ),
                                                                ),
                                                              ),
                                                            ),
                                                          Padding(
                                                            padding: const EdgeInsetsDirectional.fromSTEB(0, 0, 0, 0),
                                                            child: Text(
                                                              "${item["time"] ?? ''} ${item["date"] ?? ''} ",
                                                              style: const TextStyle(
                                                                color: Color(0xFF57636C),
                                                                fontSize: 12,
                                                                fontWeight: FontWeight.normal,
                                                              ),
                                                            ),
                                                          ),
                                                          const Icon(
                                                            Icons.chevron_right_rounded,
                                                            color: Color(0xFF57636C),
                                                            size: 18,
                                                          ),
                                                        ],
                                                      ),
                                                    )
                                                  : Row(
                                                      mainAxisAlignment: MainAxisAlignment.end,
                                                      children: [
                                                        Padding(
                                                          padding: const EdgeInsetsDirectional.fromSTEB(0, 0, 0, 0),
                                                          child: Text(
                                                            "${item["time"] ?? ''} ${item["date"] ?? ''} ",
                                                            style: const TextStyle(
                                                              color: Color(0xFF57636C),
                                                              fontSize: 12,
                                                              fontWeight: FontWeight.normal,
                                                            ),
                                                          ),
                                                        ),
                                                        const Icon(
                                                          Icons.chevron_right_rounded,
                                                          color: Color(0xFF57636C),
                                                          size: 18,
                                                        ),
                                                      ],
                                                    ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                )),
                          )),
                    ),
          ],
        ),
      ),
    );
  }
}
