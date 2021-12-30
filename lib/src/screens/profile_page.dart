import 'package:flutter/material.dart';
import 'package:ocean_station_auto/src/screens/login_page/login_page.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({Key? key}) : super(key: key);

  static const routeName = '/profile';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Profile')),
      body: Container(
        padding: EdgeInsetsDirectional.all(60.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const CircleAvatar(
              radius: 40.0,
              child: Icon(
                Icons.person,
                size: 40.0,
              )),
            const SizedBox(height: 20.0,),
            TextButton(onPressed: () => Navigator.pushNamedAndRemoveUntil(context, LoginPage.routeName, (route) => false), child: const Text('Log out'))
          ],
        ),
      ),
    );
  }
}
