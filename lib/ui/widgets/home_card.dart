import 'package:flutter/material.dart';
import 'package:hudayi/ui/helper/AppColors.dart';
import 'package:hudayi/ui/widgets/anmiation_card.dart';

class HomeCard extends StatelessWidget {
  const HomeCard({
    Key? key,
    required this.text,
    required this.description,
    required this.image,
    required this.page,
    required this.count,
  }) : super(key: key);
  final String text;
  final String description;
  final String image;
  final int count;
  final Widget page;

  @override
  Widget build(BuildContext context) {
    return AnmiationCard(
      onTap: () {
        FocusManager.instance.primaryFocus?.unfocus();
      },
      page: Padding(
        padding: const EdgeInsets.only(left: 8.0, right: 8, top: 8, bottom: 4),
        child: Container(
          width: MediaQuery.of(context).size.width,
          height: 100,
          decoration: BoxDecoration(
            color: Colors.white,
            boxShadow: const [
              BoxShadow(
                blurRadius: 3,
                color: Color(0x411D2429),
                offset: Offset(0, 1),
              )
            ],
            borderRadius: BorderRadius.circular(16),
          ),
          child: Padding(
            padding: const EdgeInsetsDirectional.fromSTEB(8, 8, 8, 8),
            child: Row(
              mainAxisSize: MainAxisSize.max,
              children: [
                Padding(
                  padding: const EdgeInsetsDirectional.fromSTEB(0, 1, 1, 1),
                  child: Image.asset(
                    image,
                    height: 70,
                    fit: BoxFit.fill,
                  ),
                ),
                const VerticalDivider(
                  color: Colors.black,
                ),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsetsDirectional.fromSTEB(8, 8, 4, 0),
                    child: Column(
                      mainAxisSize: MainAxisSize.max,
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          text,
                          style: const TextStyle(
                            color: Color(0xFF090F13),
                            fontSize: 20,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        Expanded(
                          child: Padding(
                            padding: const EdgeInsetsDirectional.fromSTEB(0, 4, 8, 0),
                            child: Text(
                              description,
                              textAlign: TextAlign.start,
                              style: const TextStyle(
                                color: Color(0xFF7C8791),
                                fontSize: 14,
                                fontWeight: FontWeight.normal,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                Column(
                  mainAxisSize: MainAxisSize.max,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    const Padding(
                      padding: EdgeInsetsDirectional.fromSTEB(0, 4, 0, 0),
                      child: Icon(
                        Icons.chevron_right_rounded,
                        color: Color(0xFF57636C),
                        size: 24,
                      ),
                    ),
                    if (count != 0)
                      Padding(
                        padding: const EdgeInsetsDirectional.fromSTEB(0, 0, 4, 8),
                        child: Text(
                          count.toString(),
                          textAlign: TextAlign.end,
                          style: const TextStyle(
                            color: AppColors.primary,
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
      displayedPage: page,
    );
  }
}
