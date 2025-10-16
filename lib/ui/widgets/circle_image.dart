import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:hudayi/ui/helper/App_Consts.dart';
import 'package:hudayi/ui/widgets/image_View.dart';

class CircleImage extends StatelessWidget {
  final String image;
  final double radius;
  const CircleImage({Key? key, required this.image, required this.radius}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      child: CircleAvatar(
        radius: radius,
        backgroundImage: image.contains("assets")
            ? AssetImage(
                image,
              )
            : CachedNetworkImageProvider(
                image,
                maxHeight: 110,
                maxWidth: 110,
              ) as ImageProvider,
      ),
      onTap: () {
        Navigator.of(context).push(createRoute(ImageView(image: image)));
      },
    );
  }
}
