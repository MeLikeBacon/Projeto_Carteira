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

  late final _$nomeControlAtom =
      Atom(name: '_PessoasStore.nomeControl', context: context);

  @override
  TextEditingController get nomeControl {
    _$nomeControlAtom.reportRead();
    return super.nomeControl;
  }

  @override
  set nomeControl(TextEditingController value) {
    _$nomeControlAtom.reportWrite(value, super.nomeControl, () {
      super.nomeControl = value;
    });
  }

  late final _$emailControlAtom =
      Atom(name: '_PessoasStore.emailControl', context: context);

  @override
  TextEditingController get emailControl {
    _$emailControlAtom.reportRead();
    return super.emailControl;
  }

  @override
  set emailControl(TextEditingController value) {
    _$emailControlAtom.reportWrite(value, super.emailControl, () {
      super.emailControl = value;
    });
  }

  late final _$senhaControlAtom =
      Atom(name: '_PessoasStore.senhaControl', context: context);

  @override
  TextEditingController get senhaControl {
    _$senhaControlAtom.reportRead();
    return super.senhaControl;
  }

  @override
  set senhaControl(TextEditingController value) {
    _$senhaControlAtom.reportWrite(value, super.senhaControl, () {
      super.senhaControl = value;
    });
  }

  late final _$minimoControlAtom =
      Atom(name: '_PessoasStore.minimoControl', context: context);

  @override
  TextEditingController get minimoControl {
    _$minimoControlAtom.reportRead();
    return super.minimoControl;
  }

  @override
  set minimoControl(TextEditingController value) {
    _$minimoControlAtom.reportWrite(value, super.minimoControl, () {
      super.minimoControl = value;
    });
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
  dynamic clearAllControls() {
    final _$actionInfo = _$_PessoasStoreActionController.startAction(
        name: '_PessoasStore.clearAllControls');
    try {
      return super.clearAllControls();
    } finally {
      _$_PessoasStoreActionController.endAction(_$actionInfo);
    }
  }

  @override
  String toString() {
    return '''
currentUser: ${currentUser},
pessoas: ${pessoas},
pessoaLoaded: ${pessoaLoaded},
nomeControl: ${nomeControl},
emailControl: ${emailControl},
senhaControl: ${senhaControl},
minimoControl: ${minimoControl}
    ''';
  }
}
