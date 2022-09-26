// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'entrada_store.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_brace_in_string_interps, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic, no_leading_underscores_for_local_identifiers

mixin _$EntradaStore on _EntradaStore, Store {
  late final _$entradasAtom =
      Atom(name: '_EntradaStore.entradas', context: context);

  @override
  List<EntradaModel> get entradas {
    _$entradasAtom.reportRead();
    return super.entradas;
  }

  @override
  set entradas(List<EntradaModel> value) {
    _$entradasAtom.reportWrite(value, super.entradas, () {
      super.entradas = value;
    });
  }

  late final _$_EntradaStoreActionController =
      ActionController(name: '_EntradaStore', context: context);

  @override
  dynamic loadEntradas() {
    final _$actionInfo = _$_EntradaStoreActionController.startAction(
        name: '_EntradaStore.loadEntradas');
    try {
      return super.loadEntradas();
    } finally {
      _$_EntradaStoreActionController.endAction(_$actionInfo);
    }
  }

  @override
  dynamic emptyEntradas() {
    final _$actionInfo = _$_EntradaStoreActionController.startAction(
        name: '_EntradaStore.emptyEntradas');
    try {
      return super.emptyEntradas();
    } finally {
      _$_EntradaStoreActionController.endAction(_$actionInfo);
    }
  }

  @override
  String toString() {
    return '''
entradas: ${entradas}
    ''';
  }
}
