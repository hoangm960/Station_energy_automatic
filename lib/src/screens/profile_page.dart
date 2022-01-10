import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:ocean_station_auto/src/constant.dart';
import 'package:ocean_station_auto/src/models/user.dart';
import 'package:ocean_station_auto/src/screens/login_page/login_page.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({Key? key}) : super(key: key);

  static const routeName = '/profile';

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  User? _user;

  @override
  void initState() {
    super.initState();
    getUser().then((value) {
      setState(() {
        _user = value;
      });
    });
  }

  Future<User> getUser() async {
    Paths paths = Paths();
    final file = await paths.userFile;

    final contents = await file.readAsString();
    final Map<String, dynamic> jsonUser = json.decode(contents);
    return User.fromJson(jsonUser);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Profile')),
      body: Center(
        child: Container(
          width: getScreenSize(context).width,
          height: getScreenSize(context).height / 2,
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
              const SizedBox(
                height: 20.0,
              ),
              Text("ID:    ${_user?.id ?? ''}"),
              const SizedBox(
                height: 20.0,
              ),
              Text("Username:    ${_user?.username ?? ''}"),
              const SizedBox(
                height: 20.0,
              ),
              Text("Display name:    ${_user?.displayName ?? ''}"),
              const SizedBox(
                height: 20.0,
              ),
              Text("Type:    ${_user?.type ?? ''}"),
              const SizedBox(
                height: 20.0,
              ),
              TextButton(
                  onPressed: () => Navigator.pushNamedAndRemoveUntil(
                      context, LoginPage.routeName, (route) => false),
                  child: const Text('Log out'))
            ],
          ),
        ),
      ),
    );
  }
}
