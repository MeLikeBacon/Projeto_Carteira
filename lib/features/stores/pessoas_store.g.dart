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

  late final _$_PessoasStoreActionController =
      ActionController(name: '_PessoasStore', context: context);

  @override
  void login(PessoaModel newUser) {
    final _$actionInfo = _$_PessoasStoreActionController.startAction(
        name: '_PessoasStore.login');
    try {
      return super.login(newUser);
    } finally {
      _$_PessoasStoreActionController.endAction(_$actionInfo);
    }
  }

  @override
  String toString() {
    return '''
currentUser: ${currentUser}
    ''';
  }
}
