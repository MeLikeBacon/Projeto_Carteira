import 'package:flutter/material.dart';

class MyAppBar extends StatefulWidget with PreferredSizeWidget {
  MyAppBar({super.key, this.title});

  String? title;

  @override
  State<MyAppBar> createState() => _MyAppBarState();

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}

class _MyAppBarState extends State<MyAppBar> {
  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: Colors.lightBlueAccent,
      leadingWidth: 75,
      leading: const Icon(
        Icons.wallet,
        size: 40,
        color: Color.fromARGB(255, 10, 57, 95),
      ),
      title: Text(widget.title ?? ''),
    );
  }
}
