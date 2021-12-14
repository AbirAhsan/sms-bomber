import 'dart:io';

import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class CustomDrawer extends StatelessWidget {
  const CustomDrawer({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    double _height = MediaQuery.of(context).size.height;
    double _width = MediaQuery.of(context).size.width;
    return SafeArea(
      child: Container(
        height: _height,
        width: _width / 4,
        child: Column(
          children: [
            const Text(
              "This Project is under development",
              style: TextStyle(
                  fontSize: 32, color: Colors.red, fontWeight: FontWeight.bold),
            ),
            ListTile(
              title: const Text(
                "Contact Us",
                style: TextStyle(fontSize: 20),
              ),
              onTap: () async {
                String fbProtocolUrl;
                if (Platform.isIOS) {
                  fbProtocolUrl = 'fb://profile/716134558805812';
                } else {
                  fbProtocolUrl = 'fb://page/716134558805812';
                }

                String fallbackUrl =
                    'https://www.facebook.com/learnwithabirahsan';

                try {
                  bool launched =
                      await launch(fbProtocolUrl, forceSafariVC: false);

                  if (!launched) {
                    await launch(fallbackUrl, forceSafariVC: false);
                  }
                } catch (e) {
                  await launch(fallbackUrl, forceSafariVC: false);
                }
              },
            )
          ],
        ),
      ),
    );
  }
}
