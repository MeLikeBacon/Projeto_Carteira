import 'package:flutter/material.dart';

import '../components/myAppBar.dart';

class UserListView extends StatefulWidget {
  const UserListView({super.key});

  @override
  State<UserListView> createState() => _UserListViewState();
}

class _UserListViewState extends State<UserListView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: MyAppBar(title: 'Lista de usuários'),
      body: SingleChildScrollView(child: Center()),
    );
  }
}
