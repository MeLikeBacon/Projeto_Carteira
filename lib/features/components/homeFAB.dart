import 'package:flutter/material.dart';
import 'package:projeto_carteira/features/stores/pessoas_store.dart';
import 'package:provider/provider.dart';

class HomeFAB extends StatefulWidget {
  HomeFAB({Key? key, required this.iconSize}) : super(key: key);

  double iconSize;

  @override
  State<HomeFAB> createState() => _HomeFABState();
}

class _HomeFABState extends State<HomeFAB> {
  late PessoasStore _pessoasStore;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _pessoasStore = Provider.of<PessoasStore>(context);
  }

  @override
  Widget build(BuildContext context) {
    return FloatingActionButton(
        heroTag: 'Home',
        onPressed: () {
          Navigator.pushReplacementNamed(context,
              _pessoasStore.currentUser.codigo == 0 ? '/adm' : '/home');
        },
        child: Icon(
          Icons.home,
          size: widget.iconSize,
        ));
  }
}
