import 'package:flutter/material.dart';

class TextBox extends StatefulWidget {
  final TextEditingController controller = TextEditingController();
  final String hintText;
  final bool decorationPassword;
  TextBox({Key? key, required this.hintText, this.decorationPassword = false})
      : super(key: key);

  @override
  State<TextBox> createState() => _TextBoxState();
}

class _TextBoxState extends State<TextBox> {
  late bool hidePassword;
  late String text;

  @override
  void initState() {
    super.initState();
    hidePassword = widget.decorationPassword;
  }

  @override
  void dispose() {
    widget.controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: TextField(
        controller: widget.controller..text,
        decoration: widget.decorationPassword
            ? InputDecoration(
                hintText: "Password",
                hintStyle: const TextStyle(color: Colors.grey),
                border: InputBorder.none,
                suffixIcon: IconButton(
                    onPressed: () {
                      setState(() {
                        hidePassword = !hidePassword;
                        text = widget.controller.text;
                      });
                    },
                    icon: const Icon(Icons.remove_red_eye_outlined),
                    splashRadius: 20.0,))
            : InputDecoration(
                hintText: widget.hintText,
                hintStyle: const TextStyle(color: Colors.grey),
                border: InputBorder.none,
              ),
        style: const TextStyle(color: Colors.black),
        obscureText: hidePassword,
        enableSuggestions: false,
        autocorrect: false,
      ),
    );
  }
}
