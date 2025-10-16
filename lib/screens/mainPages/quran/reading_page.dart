import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:flutter/material.dart';
import 'package:hudayi/models/surah.dart';
import 'package:hudayi/ui/helper/App_Colors.dart';
import 'package:hudayi/ui/widgets/drawer.dart';
import 'package:pdfx/pdfx.dart';

class SurahPage extends StatefulWidget {
  final Surah surah;
  const SurahPage({super.key, required this.surah});

  @override
  State<SurahPage> createState() => _SurahPageState();
}

class _SurahPageState extends State<SurahPage> {
  int _actualPageNumber = 0, _allPagesCount = 0;
  bool isSampleDoc = true;
  late PdfController _pdfController;
  @override
  void initState() {
    () async {
      await FirebaseAnalytics.instance.logEvent(
        name: "quran_page_${widget.surah.startPage}",
        parameters: {
          'screen_name': "quran_page_${widget.surah.startPage}",
          'screen_class': "main",
        },
      );
    }();
    _actualPageNumber = widget.surah.startPage;
    _pdfController =
        PdfController(document: PdfDocument.openAsset('assets/pdf/quran.pdf'), initialPage: widget.surah.startPage, viewportFraction: 1.25);
    super.initState();
  }

  @override
  void dispose() {
    _pdfController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: const DrawerWidget(),
      body: Stack(
        children: [
          PdfView(
            controller: _pdfController,
            onDocumentLoaded: (document) {
              setState(() {
                _allPagesCount = document.pagesCount;
              });
            },
            onPageChanged: (page) {
              setState(() {
                _actualPageNumber = page;
              });
            },
          ),
          Positioned(
              top: 20,
              child: IconButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  icon: const Icon(
                    Icons.arrow_back_ios_rounded,
                    color: AppColors.primary,
                  )))
        ],
      ),
    );
  }
}
