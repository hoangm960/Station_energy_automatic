import 'package:flutter/material.dart';

class TextBox extends StatefulWidget {
  final String text;
  final String hintText;
  final bool decorationPassword;
  final controller = TextEditingController();
  TextBox(
      {Key? key,
      this.text = '',
      this.decorationPassword = false,
      required this.hintText})
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
    text = widget.text;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
          border: Border(bottom: BorderSide(color: Colors.grey[200]!)),),
      child: TextField(
        controller: widget.controller..text = text,
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
                    icon: const Icon(Icons.remove_red_eye_outlined)))
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
