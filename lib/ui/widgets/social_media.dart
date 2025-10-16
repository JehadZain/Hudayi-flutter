import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class SocialMedia extends StatelessWidget {
  final Map socialMediaMap;
  const SocialMedia({super.key, required this.socialMediaMap});
  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: const EdgeInsets.only(bottom: 15.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (socialMediaMap["phone"] != "")
              socialMedia(context, Icons.phone, onTap: () {
                var encoded =
                    Uri.encodeFull("tel://${socialMediaMap['phone']}");
                launchUrl(
                  Uri.parse(encoded),
                  mode: LaunchMode.externalApplication,
                );
              }),
            if (socialMediaMap["whatsapp"] != "") const SizedBox(width: 8.0),
            if (socialMediaMap["whatsapp"] != "")
              socialMedia(context, Icons.wechat_sharp,
                  image: "assets/images/whtsapp.png", onTap: () {
                var encoded = Uri.encodeFull(socialMediaMap["whatsapp"]);
                launchUrl(
                  Uri.parse("https://wa.me/$encoded"),
                  mode: LaunchMode.externalApplication,
                );
              }),
            if (socialMediaMap["instagram"] != "") const SizedBox(width: 8.0),
            if (socialMediaMap["instagram"] != "")
              socialMedia(context, Icons.check_box_outline_blank,
                  image: "assets/images/instagram.png", onTap: () {
                var encoded = Uri.encodeFull(
                    "https://www.instagram.com/${socialMediaMap["instagram"]}");
                launchUrl(
                  Uri.parse(encoded),
                  mode: LaunchMode.externalApplication,
                );
              }),
            if (socialMediaMap["facebook"] != "") const SizedBox(width: 8.0),
            if (socialMediaMap["facebook"] != "")
              socialMedia(context, Icons.facebook, onTap: () {
                var encoded = Uri.encodeFull(
                    "https://www.facebook.com/${socialMediaMap["facebook"]}");
                launchUrl(
                  Uri.parse(encoded),
                  mode: LaunchMode.externalApplication,
                );
              }),
            if (socialMediaMap["email"] != "") const SizedBox(width: 8.0),
            if (socialMediaMap["email"] != "")
              socialMedia(context, Icons.mail_sharp, onTap: () {
                var encoded =
                    Uri.encodeFull("mailTo://${socialMediaMap['email']}");
                launchUrl(
                  Uri.parse(encoded),
                  mode: LaunchMode.externalApplication,
                );
              }),
            if (socialMediaMap["location"] != "") const SizedBox(width: 8.0),
            if (socialMediaMap["location"] != "")
              socialMedia(context, Icons.location_on, onTap: () {
                var encoded = Uri.encodeFull(
                    "http://www.google.com/maps/place/${socialMediaMap["location"]}");
                launchUrl(
                  Uri.parse(encoded),
                  mode: LaunchMode.externalApplication,
                );
              }),
          ],
        ));
  }
}

Container socialMedia(BuildContext context, IconData icon, {onTap, image}) {
  return Container(
    height: 35,
    width: 35,
    decoration: BoxDecoration(
      shape: BoxShape.circle,
      color: Theme.of(context).primaryColor,
    ),
    child: image != null
        ? GestureDetector(
            onTap: onTap ?? () {},
            child: Padding(
              padding: const EdgeInsets.all(6.5),
              child: Image.asset(
                image,
                height: 25,
                width: 25,
                color: Colors.white,
              ),
            ),
          )
        : IconButton(
            onPressed: onTap ?? () {},
            icon: Center(
              child: Icon(
                icon,
                color: Colors.white,
                size: 20,
              ),
            ),
          ),
  );
}
