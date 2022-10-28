import 'package:brasil_fields/brasil_fields.dart';
import 'package:flutter/cupertino.dart';
import 'package:mobx/mobx.dart';
import 'package:projeto_carteira/features/account/daos/pessoa_dao.dart';
import 'package:projeto_carteira/features/account/controllers/pessoa_controller.dart';
import 'package:collection/collection.dart';
import 'package:projeto_carteira/features/account/models/formfields_model.dart';

import '../models/pessoa_model.dart';

// Include generated file
part 'pessoas_store.g.dart';

// This is the class used by rest of your codebase
class PessoasStore = _PessoasStore with _$PessoasStore;

// The store-class
abstract class _PessoasStore with Store {
  final PessoaController _pessoaController = PessoaController();

  @observable
  PessoaModel currentUser = PessoaModel();

  @observable
  PessoaModel editedUser = PessoaModel();

  @observable
  PessoaModel firstLowerUser = PessoaModel();

  @observable
  List<PessoaModel> pessoas = [];

  @observable
  bool pessoaLoaded = true;

  @action
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
  Future setFirstUser() async {
    firstLowerUser = await _pessoaController.findLowerPessoa(currentUser.tipo!) ?? PessoaModel();
  }

  @action
  void deleteUser(int id) {
    emptyPessoas();
    _pessoaController.deletePessoa(id);
    loadPessoas();
  }

  @action
  logout() {
    clearForms();
    currentUser = PessoaModel();
  }

  @action
  loadPessoas() async {
    pessoaLoaded = false;
    pessoas = await _pessoaController.getUsers();
    pessoaLoaded = true;
  }

  @action
  emptyPessoas() {
    pessoas = [];
  }

  @observable
  FormFields forms = FormFields(TextEditingController(), TextEditingController(), TextEditingController(),
      TextEditingController(), TextEditingController(), '');

  @action
  setUserType(value) {
    forms.typeControl = value;
  }

  @action
  clearForms() {
    forms.clearAll();
  }

  @action
  setAllControllers(PessoaModel pessoa) {
    forms.nomeControl.text = pessoa.nome!;
    forms.emailControl.text = pessoa.email!;
    forms.senhaControl.text = pessoa.senha!;
    forms.minimumControl.text = pessoa.minimo!.toString();
    forms.typeControl = pessoa.tipo!;

    forms.minimumControl.text = UtilBrasilFields.obterReal(editedUser.minimo!, moeda: false);
  }

  @action
  PessoaModel getTempPessoa() {
    PessoaModel temp = PessoaModel();

    temp
      ..nome = forms.nomeControl.text
      ..email = forms.emailControl.text
      ..senha = forms.senhaControl.text
      ..minimo = UtilBrasilFields.converterMoedaParaDouble(
          forms.minimumControl.text.isNotEmpty ? forms.minimumControl.text : '0')
      ..tipo = forms.typeControl;

    return temp;
  }
}
