import 'package:flutter/material.dart';
import 'package:mysql1/mysql1.dart';
import 'package:ocean_station_auto/src/screens/home/home_page.dart';
import 'package:ocean_station_auto/src/screens/login_page/components/textBox.dart';
import 'package:ocean_station_auto/src/utils/connectDb.dart';
import 'package:ocean_station_auto/src/utils/hashPw.dart';

class SignUpScreen extends StatefulWidget {
  final VoidCallback onReturn;
  const SignUpScreen({Key? key, required this.onReturn}) : super(key: key);

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  bool hidePassword = true;
  var db = Mysql();
  late Future<MySqlConnection> connection;
  String type = 'Employee';
  String username = '';
  String password = '';
  String displayName = '';
  late List<TextBox> userBoxes;

  @override
  void initState() {
    super.initState();
    db.setConn();
    connection = db.conn;
    userBoxes = [
      TextBox(
        hintText: 'Username',
        text: username,
      ),
      TextBox(
        hintText: 'Password',
        decorationPassword: true,
        text: password,
      ),
      TextBox(
        hintText: 'Display Name',
        text: displayName,
      ),
    ];
  }

  void uploadData() {
    username = userBoxes[0].controller.text;
    password = userBoxes[1].controller.text;
    displayName = userBoxes[2].controller.text;
    String encryptedPw = getEncrypt(password, username);
    int typeId = 4;
    switch (type) {
      case 'General Manager':
        {
          typeId = 1;
          break;
        }
      case 'Station Manager':
        {
          typeId = 2;
          break;
        }
      case 'Repairer':
        {
          typeId = 3;
          break;
        }
      case 'Employee':
        {
          typeId = 4;
          break;
        }
    }
    connection.then((conn) {
      String sql = '''INSERT INTO user (name, displayName, password, typeId) 
          VALUES ("$username", "$displayName", "$encryptedPw", $typeId)''';
      conn.query(sql).then((_) {
        conn.close();
      });
    });
    AlertDialog alert = AlertDialog(
      title: const Text("Sign up complete"),
      content: const Text("Successfully sign up. Bringing you back to log in."),
      actions: [
        TextButton(
          child: const Text("OK"),
          onPressed: () {
            widget.onReturn();
            Navigator.of(context).pop(true);
          },
        )
      ],
    );
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        const SizedBox(
          height: 60,
        ),
        Container(
          decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(10),
              boxShadow: const [
                BoxShadow(
                    color: Color.fromRGBO(225, 95, 27, .3),
                    blurRadius: 20,
                    offset: Offset(0, 10))
              ]),
          child: Column(
            children: <Widget>[
              Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                      border:
                          Border(bottom: BorderSide(color: Colors.grey[200]!))),
                  child: Column(
                    children: [
                      ...userBoxes,
                      Row(children: [
                        const Text(
                          'Type:',
                          style: TextStyle(color: Colors.grey, fontSize: 15.0),
                        ),
                        const SizedBox(
                          width: 50.0,
                        ),
                        DropdownButton<String>(
                          value: type,
                          icon: const Icon(
                            Icons.arrow_downward,
                            color: Colors.black,
                          ),
                          elevation: 16,
                          underline: Container(
                            height: 2,
                            color: Colors.black,
                          ),
                          onChanged: (String? newValue) {
                            setState(() {
                              type = newValue!;
                              username = userBoxes[0].controller.text;
                              password = userBoxes[1].controller.text;
                              displayName = userBoxes[2].controller.text;
                            });
                          },
                          items: <String>[
                            'General Manager',
                            'Station Manager',
                            'Repairer',
                            'Employee'
                          ].map((String value) {
                            return DropdownMenuItem<String>(
                              value: value,
                              child: Text(value),
                            );
                          }).toList(),
                          style: const TextStyle(color: Colors.black),
                          dropdownColor: Colors.white,
                        ),
                      ])
                    ],
                  ))
            ],
          ),
        ),
        const SizedBox(
          height: 40,
        ),
        InkWell(
          onTap: () => uploadData(),
          child: Container(
              height: 50,
              margin: const EdgeInsets.symmetric(horizontal: 50),
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(50),
                  color: Colors.orange[900]),
              child: const Center(
                child: Text(
                  "Sign Up",
                  style: TextStyle(
                      color: Colors.white, fontWeight: FontWeight.bold),
                ),
              )),
        ),
      ],
    );
  }
}
