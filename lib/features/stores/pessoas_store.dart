import 'package:flutter/cupertino.dart';
import 'package:mobx/mobx.dart';
import 'package:projeto_carteira/features/DAOs/pessoa_dao.dart';
import 'package:projeto_carteira/features/controllers/pessoa_controller.dart';

import '../models/pessoa_model.dart';

// Include generated file
part 'pessoas_store.g.dart';

// This is the class used by rest of your codebase
class PessoasStore = _PessoasStore with _$PessoasStore;

// The store-class
abstract class _PessoasStore with Store {
  final PessoaDao _pessoaDao = PessoaDao();
  final PessoaController _pessoaController = PessoaController();

  @observable
  PessoaModel currentUser = PessoaModel();

  @observable
  List<PessoaModel> pessoas = [];

  @observable
  bool pessoaLoaded = true;

  @action
  void changeUser(PessoaModel newUser) {
    currentUser = newUser;
  }

  @action
  void deleteUser(int id) {
    emptyPessoas();
    _pessoaController.deletePessoa(id);
    loadPessoas();
  }

  @action
  logout() {
    currentUser = PessoaModel();
  }

  @action
  loadPessoas() async {
    pessoaLoaded = false;
    pessoas = await _pessoaDao.getPessoas();
    pessoaLoaded = true;
  }

  @action
  emptyPessoas() {
    pessoas = [];
  }

  @observable
  TextEditingController nomeControl = TextEditingController();

  @observable
  TextEditingController emailControl = TextEditingController();

  @observable
  TextEditingController senhaControl = TextEditingController();

  @observable
  TextEditingController minimoControl = TextEditingController();

  @action
  clearAllControls() {
    nomeControl.clear();
    emailControl.clear();
    senhaControl.clear();
    minimoControl.clear();
  }
}
