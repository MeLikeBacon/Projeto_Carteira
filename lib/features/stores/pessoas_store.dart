import 'package:brasil_fields/brasil_fields.dart';
import 'package:flutter/cupertino.dart';
import 'package:mobx/mobx.dart';
import 'package:projeto_carteira/features/DAOs/pessoa_dao.dart';
import 'package:projeto_carteira/features/controllers/pessoa_controller.dart';
import 'package:collection/collection.dart';

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
  PessoaModel editedUser = PessoaModel();

  @observable
  List<PessoaModel> pessoas = [];

  @observable
  bool pessoaLoaded = true;

  @computed
  List<PessoaModel> getLowerUsers() {
    List<PessoaModel?> list = pessoas.map((e) {
      if (e.tipo != currentUser.tipo) {
        return e;
      }
    }).toList();

    return list.whereNotNull().toList();
  }

  @action
  void changeUser(PessoaModel newUser) {
    currentUser = newUser;
  }

  @action
  void setEditedUser(PessoaModel newUser) {
    editedUser = newUser;
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
  int userCodigo = 0;

  @observable
  TextEditingController nomeControl = TextEditingController();

  @observable
  TextEditingController emailControl = TextEditingController();

  @observable
  TextEditingController senhaControl = TextEditingController();

  @observable
  TextEditingController minimoControl = TextEditingController();

  @observable
  TextEditingController saldoControl = TextEditingController();

  @observable
  String userType = '';

  @action
  setUserType(value) {
    userType = value;
  }

  @action
  setAllControllers(PessoaModel pessoa) {
    nomeControl.text = pessoa.nome!;
    emailControl.text = pessoa.email!;
    senhaControl.text = pessoa.senha!;
    minimoControl.text = pessoa.minimo!.toString();
    saldoControl.text = pessoa.saldo!.toString();
    userType = pessoa.tipo!;

    minimoControl.text = UtilBrasilFields.obterReal(editedUser.minimo!, moeda: false);
    saldoControl.text = UtilBrasilFields.obterReal(editedUser.saldo!, moeda: false);
  }

  @action
  PessoaModel getTempPessoa() {
    PessoaModel temp = PessoaModel();

    temp
      ..nome = nomeControl.text
      ..email = emailControl.text
      ..senha = senhaControl.text
      ..minimo = UtilBrasilFields.converterMoedaParaDouble(minimoControl.text.isNotEmpty ? minimoControl.text : '0')
      ..saldo = UtilBrasilFields.converterMoedaParaDouble(saldoControl.text.isNotEmpty ? saldoControl.text : '0')
      ..tipo = userType;

    return temp;
  }

  @action
  clearAllControls() {
    nomeControl.clear();
    emailControl.clear();
    senhaControl.clear();
    minimoControl.clear();
    saldoControl.clear();
  }
}
