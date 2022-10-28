// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'pessoas_store.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_brace_in_string_interps, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic, no_leading_underscores_for_local_identifiers

mixin _$PessoasStore on _PessoasStore, Store {
  late final _$currentUserAtom =
      Atom(name: '_PessoasStore.currentUser', context: context);

  @override
  PessoaModel get currentUser {
    _$currentUserAtom.reportRead();
    return super.currentUser;
  }

  @override
  set currentUser(PessoaModel value) {
    _$currentUserAtom.reportWrite(value, super.currentUser, () {
      super.currentUser = value;
    });
  }

  late final _$editedUserAtom =
      Atom(name: '_PessoasStore.editedUser', context: context);

  @override
  PessoaModel get editedUser {
    _$editedUserAtom.reportRead();
    return super.editedUser;
  }

  @override
  set editedUser(PessoaModel value) {
    _$editedUserAtom.reportWrite(value, super.editedUser, () {
      super.editedUser = value;
    });
  }

  late final _$firstLowerUserAtom =
      Atom(name: '_PessoasStore.firstLowerUser', context: context);

  @override
  PessoaModel get firstLowerUser {
    _$firstLowerUserAtom.reportRead();
    return super.firstLowerUser;
  }

  @override
  set firstLowerUser(PessoaModel value) {
    _$firstLowerUserAtom.reportWrite(value, super.firstLowerUser, () {
      super.firstLowerUser = value;
    });
  }

  late final _$pessoasAtom =
      Atom(name: '_PessoasStore.pessoas', context: context);

  @override
  List<PessoaModel> get pessoas {
    _$pessoasAtom.reportRead();
    return super.pessoas;
  }

  @override
  set pessoas(List<PessoaModel> value) {
    _$pessoasAtom.reportWrite(value, super.pessoas, () {
      super.pessoas = value;
    });
  }

  late final _$pessoaLoadedAtom =
      Atom(name: '_PessoasStore.pessoaLoaded', context: context);

  @override
  bool get pessoaLoaded {
    _$pessoaLoadedAtom.reportRead();
    return super.pessoaLoaded;
  }

  @override
  set pessoaLoaded(bool value) {
    _$pessoaLoadedAtom.reportWrite(value, super.pessoaLoaded, () {
      super.pessoaLoaded = value;
    });
  }

  late final _$formsAtom = Atom(name: '_PessoasStore.forms', context: context);

  @override
  FormFields get forms {
    _$formsAtom.reportRead();
    return super.forms;
  }

  @override
  set forms(FormFields value) {
    _$formsAtom.reportWrite(value, super.forms, () {
      super.forms = value;
    });
  }

  late final _$setFirstUserAsyncAction =
      AsyncAction('_PessoasStore.setFirstUser', context: context);

  @override
  Future<dynamic> setFirstUser() {
    return _$setFirstUserAsyncAction.run(() => super.setFirstUser());
  }

  late final _$loadPessoasAsyncAction =
      AsyncAction('_PessoasStore.loadPessoas', context: context);

  @override
  Future loadPessoas() {
    return _$loadPessoasAsyncAction.run(() => super.loadPessoas());
  }

  late final _$_PessoasStoreActionController =
      ActionController(name: '_PessoasStore', context: context);

  @override
  List<PessoaModel> getLowerUsers() {
    final _$actionInfo = _$_PessoasStoreActionController.startAction(
        name: '_PessoasStore.getLowerUsers');
    try {
      return super.getLowerUsers();
    } finally {
      _$_PessoasStoreActionController.endAction(_$actionInfo);
    }
  }

  @override
  void changeUser(PessoaModel newUser) {
    final _$actionInfo = _$_PessoasStoreActionController.startAction(
        name: '_PessoasStore.changeUser');
    try {
      return super.changeUser(newUser);
    } finally {
      _$_PessoasStoreActionController.endAction(_$actionInfo);
    }
  }

  @override
  void setEditedUser(PessoaModel newUser) {
    final _$actionInfo = _$_PessoasStoreActionController.startAction(
        name: '_PessoasStore.setEditedUser');
    try {
      return super.setEditedUser(newUser);
    } finally {
      _$_PessoasStoreActionController.endAction(_$actionInfo);
    }
  }

  @override
  void deleteUser(int id) {
    final _$actionInfo = _$_PessoasStoreActionController.startAction(
        name: '_PessoasStore.deleteUser');
    try {
      return super.deleteUser(id);
    } finally {
      _$_PessoasStoreActionController.endAction(_$actionInfo);
    }
  }

  @override
  dynamic logout() {
    final _$actionInfo = _$_PessoasStoreActionController.startAction(
        name: '_PessoasStore.logout');
    try {
      return super.logout();
    } finally {
      _$_PessoasStoreActionController.endAction(_$actionInfo);
    }
  }

  @override
  dynamic emptyPessoas() {
    final _$actionInfo = _$_PessoasStoreActionController.startAction(
        name: '_PessoasStore.emptyPessoas');
    try {
      return super.emptyPessoas();
    } finally {
      _$_PessoasStoreActionController.endAction(_$actionInfo);
    }
  }

  @override
  dynamic setUserType(dynamic value) {
    final _$actionInfo = _$_PessoasStoreActionController.startAction(
        name: '_PessoasStore.setUserType');
    try {
      return super.setUserType(value);
    } finally {
      _$_PessoasStoreActionController.endAction(_$actionInfo);
    }
  }

  @override
  dynamic clearForms() {
    final _$actionInfo = _$_PessoasStoreActionController.startAction(
        name: '_PessoasStore.clearForms');
    try {
      return super.clearForms();
    } finally {
      _$_PessoasStoreActionController.endAction(_$actionInfo);
    }
  }

  @override
  dynamic setAllControllers(PessoaModel pessoa) {
    final _$actionInfo = _$_PessoasStoreActionController.startAction(
        name: '_PessoasStore.setAllControllers');
    try {
      return super.setAllControllers(pessoa);
    } finally {
      _$_PessoasStoreActionController.endAction(_$actionInfo);
    }
  }

  @override
  PessoaModel getTempPessoa() {
    final _$actionInfo = _$_PessoasStoreActionController.startAction(
        name: '_PessoasStore.getTempPessoa');
    try {
      return super.getTempPessoa();
    } finally {
      _$_PessoasStoreActionController.endAction(_$actionInfo);
    }
  }

  @override
  String toString() {
    return '''
currentUser: ${currentUser},
editedUser: ${editedUser},
firstLowerUser: ${firstLowerUser},
pessoas: ${pessoas},
pessoaLoaded: ${pessoaLoaded},
forms: ${forms}
    ''';
  }
}
