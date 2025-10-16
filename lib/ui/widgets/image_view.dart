import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:hudayi/ui/widgets/action_Bar.dart';

class ImageView extends StatelessWidget {
  final String image;
  const ImageView({Key? key, required this.image}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Container(
        color: Colors.white,
        child: Stack(
          children: [
            const ActionBar(menuseItem: []),
            Center(
              child: image.contains("assets")
                  ? Image.asset(
                      image,
                    )
                  : CachedNetworkImage(
                      imageUrl: image,
                      maxHeightDiskCache: 500,
                      maxWidthDiskCache: 500,
                      memCacheHeight: 500,
                      memCacheWidth: 500,
                      placeholder: (context, url) => const CircularProgressIndicator(),
                      errorWidget: (context, url, error) => const Icon(Icons.error),
                      fit: BoxFit.contain,
                    ),
            ),
          ],
        ),
      ),
    );
  }
}
