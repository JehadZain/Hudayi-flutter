import 'dart:convert';

import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:flutter/material.dart';
import 'package:hudayi/models/user_model.dart';
import 'package:hudayi/screens/add/add.dart';
import 'package:hudayi/services/API/api.dart';
import 'package:hudayi/ui/helper/AppConstants.dart';
import 'package:hudayi/ui/helper/AppConsts.dart';
import 'package:hudayi/ui/helper/AppDialog.dart';
import 'package:hudayi/ui/helper/AppFunctions.dart';
import 'package:hudayi/ui/widgets/CirculeProgress.dart';
import 'package:hudayi/ui/widgets/addContainer.dart';
import 'package:hudayi/ui/widgets/helper.dart';
import 'package:hudayi/ui/widgets/listViewComponent.dart';
import 'package:hudayi/ui/widgets/pageHeader.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';

class Books extends StatefulWidget {
  const Books({Key? key}) : super(key: key);

  @override
  State<Books> createState() => _BooksState();
}

class _BooksState extends State<Books> {
  final TextEditingController searchController = TextEditingController();
  ScrollController scrollController = ScrollController();
  List books = [];
  bool isScolled = false;
  bool isEmpty = false;
  bool isLoading = false;
  int page = 1;
  bool _hasNextPage = true;
  bool _isLoadMoreRunning = false;
  var authService;
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    authService = Provider.of<AuthService>(context, listen: false);
  }

  getData({String? search}) {
    if (search == null) {
      setState(() {
        _isLoadMoreRunning = true;
      });
    }
    setState(() {
      isLoading = true;
    });
    ApiService().getBooks(jsonDecode(authService.user.toUser())["token"], page: page, search: search).then((data) {
      if (data["api"] == "NO_DATA") {
        setState(() {
          _hasNextPage = false;
          isEmpty = true;
          isLoading = false;
        });
      } else {
        if (data["data"]["data"].isEmpty) {
          setState(() {
            _hasNextPage = false;
            isLoading = false;
          });
        } else {
          page += 1;
        }
        if (data["data"]["data"] != null) {
          setState(() {
            books.addAll(data["data"]["data"]);
          });
        } else {
          setState(() {
            isEmpty = true;
            isLoading = false;
          });
        }
        _isLoadMoreRunning = false;
        isLoading = false;
      }
    });
  }

  @override
  void initState() {
    FirebaseAnalytics.instance.logEvent(
      name: 'books_page',
      parameters: {
        'screen_name': "books_page",
        'screen_class': "profile",
      },
    );
    authService = Provider.of<AuthService>(context, listen: false);
    getData();
    super.initState();
    scrollController = ScrollController()
      ..addListener(() {
        double maxScroll = scrollController.position.maxScrollExtent;
        double currentScroll = scrollController.position.pixels;
        double delta = 200.0;
        if (maxScroll - currentScroll <= delta) {
          _loadMore();
        }
      });
  }

  void _loadMore() async {
    if (_hasNextPage == true && _isLoadMoreRunning == false && scrollController.position.extentAfter < 100) {
      try {
        getData();
      } catch (err) {}
    }
  }

  @override
  void dispose() {
    scrollController.removeListener(_loadMore);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            PageHeader(
              checkedValue: "noDialog",
              path: XFile(" "),
              title: translate(context).book,
              isCircle: false,
            ),
            Expanded(
              child: Column(
                children: [
                  Expanded(
                    child: ListViewComponent(
                      isEmpty: isEmpty,
                      isLoading: isLoading,
                      onSearch: (value) {
                        if (value != "") {
                          setState(() {
                            books.clear();
                            page = 1;
                            isEmpty = false;
                          });
                          getData(search: value);
                        } else {
                          setState(() {
                            books.clear();
                            page = 1;
                            _hasNextPage = true;
                          });

                          getData();
                        }
                      },
                      onRefresh: () async {
                        setState(() {
                          books.clear();
                          page = 1;
                          _hasNextPage = true;
                        });

                        getData();
                      },
                      searchController: searchController,
                      controller: scrollController,
                      list: books.asMap().entries.map((entry) {
                        return {
                          "id": entry.value["id"],
                          "name": entry.value["name"] ?? translate(context).not_available,
                          "author_name": entry.value["author_name"],
                          "size": entry.value["size"],
                          "type":getBookTypeValue(context,  entry.value["book_type"]) ,
                          "description":
                              '${entry.value["author_name"] ?? translate(context).not_available} - ${entry.value["paper_count"] ?? translate(context).not_available}/${entry.value["size"] ?? translate(context).not_available}',
                          "date": entry.value["start_at"] ?? "",
                          "paper_count": entry.value["paper_count"],
                          "image": entry.value["image"],
                          "property_type": entry.value["property_type"] == "school" ? translate(context).school : translate(context).university,
                        };
                      }).toList(),
                      addPage: AddPage(
                        englishTitle: "add_book",
                        isEdit: false,
                        fields: addBookFields,
                        title: translate(context).add_book,
                        onPressed: () async {
                          Map result = await ApiService().addABook({
                            "id": null,
                            "name": addBookFields[0]["value"],
                            "size": addBookFields[1]["value"],
                            "paper_count": addBookFields[4]["value"],
                            "author_name": addBookFields[3]["value"],
                            "property_type": addBookFields[5]["value"] == translate(context).school ? "school" : "mosque",
                            "book_type": getBookTypeKey(context, addBookFields[2]["value"]),
                            "mainImage": addBookFields[6]["value"].path == '' ? null : addBookFields[6]["value"]?.path,
                          }, jsonDecode(authService.user.toUser())["token"]);

                          if (result["api"] == "SUCCESS") {
                            setState(() {
                              books.insert(0, result["data"]);
                            });
                          }
                          return result["hints"].toString().contains("Duplicate entry") ? "Duplicate" : result["api"];
                        },
                      ),
                      onEditPressed: (item, index) async {
                        showLoadingDialog(context);
                        await AppFunctions.getImageXFileByUrl(AppFunctions().getImage(item["image"])).then((value) async {
                         addBookFields[0]["value"] = item["name"];
                         addBookFields[1]["value"] = item["size"];
                         addBookFields[2]["value"] = item["type"];
                         addBookFields[3]["value"] = item["author_name"];
                         addBookFields[4]["value"] = item["paper_count"];
                         addBookFields[5]["value"] = item["property_type"] == "school" ? translate(context).school : translate(context).university;
                         addBookFields[6]["value"] = value;
                          Navigator.of(context).pop();
                          Navigator.of(context).push(createRoute(
                            AddPage(
                              englishTitle: "edit_book",
                              isEdit: true,
                              fields:addBookFields,
                              title: translate(context).edit_book,
                              onPressed: () async {
                                Map result = await ApiService().editBook({
                                  "id": item["id"],
                                  "name":addBookFields[0]["value"],
                                  "size":addBookFields[1]["value"],
                                  "paper_count":addBookFields[4]["value"],
                                  "author_name":addBookFields[3]["value"],
                                  "property_type":addBookFields[5]["value"] == translate(context).school ? "school" : "mosque",
                                  "book_type": getBookTypeKey(context, addBookFields[2]["value"]),
                                  "mainImage": addBookFields[6]["value"].path == '' ? null : addBookFields[6]["value"]?.path,
                                }, jsonDecode(authService.user.toUser())["token"]);

                                if (result["api"] == "SUCCESS") {
                                  setState(() {
                                    books.removeAt(index);
                                    books.insert(index, result["data"]);
                                  });
                                }
                                return result["api"];
                              },
                            ),
                          ));
                        });
                      },
                      onDeletePressed: (item, index) async {
                        showCustomDialog(context, translate(context).confirm_delete, AppConstants.appLogo, "delete", () async {
                          Map result = await ApiService().deleteABook(item["id"], jsonDecode(authService.user.toUser())["token"]);

                          if (result["api"] == "SUCCESS") {
                            setState(() {
                              books.removeAt(index);
                            });
                          }
                          return result["api"];
                        });
                      },
                      tabs: const [],
                      pageType: "book",
                    ),
                  ),
                  if (_isLoadMoreRunning && books.length != 0)
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(
                        children: [Helper.sizedBoxH5, const CirculeProgress()],
                      ),
                    ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
