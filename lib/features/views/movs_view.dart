import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:projeto_carteira/features/app.dart';
import 'package:projeto_carteira/features/components/myAppBar.dart';

class MovsView extends StatefulWidget {
  const MovsView({super.key});

  @override
  State<MovsView> createState() => _MovsViewState();
}

class _MovsViewState extends State<MovsView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: MyAppBar(),
      body: Center(
        child: SingleChildScrollView(child: Column()),
      ),
    );
  }
}
