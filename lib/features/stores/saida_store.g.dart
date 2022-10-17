// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'saida_store.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_brace_in_string_interps, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic, no_leading_underscores_for_local_identifiers

mixin _$SaidaStore on _SaidaStore, Store {
  late final _$saidasAtom = Atom(name: '_SaidaStore.saidas', context: context);

  @override
  List<SaidaModel> get saidas {
    _$saidasAtom.reportRead();
    return super.saidas;
  }

  @override
  set saidas(List<SaidaModel> value) {
    _$saidasAtom.reportWrite(value, super.saidas, () {
      super.saidas = value;
    });
  }

  late final _$saidaLoadedAtom =
      Atom(name: '_SaidaStore.saidaLoaded', context: context);

  @override
  bool get saidaLoaded {
    _$saidaLoadedAtom.reportRead();
    return super.saidaLoaded;
  }

  @override
  set saidaLoaded(bool value) {
    _$saidaLoadedAtom.reportWrite(value, super.saidaLoaded, () {
      super.saidaLoaded = value;
    });
  }

  late final _$loadSaidasAsyncAction =
      AsyncAction('_SaidaStore.loadSaidas', context: context);

  @override
  Future loadSaidas(
      {String initialDate = '', String finalDate = '', int? personId}) {
    return _$loadSaidasAsyncAction.run(() => super.loadSaidas(
        initialDate: initialDate, finalDate: finalDate, personId: personId));
  }

  late final _$_SaidaStoreActionController =
      ActionController(name: '_SaidaStore', context: context);

  @override
  dynamic emptySaidas() {
    final _$actionInfo = _$_SaidaStoreActionController.startAction(
        name: '_SaidaStore.emptySaidas');
    try {
      return super.emptySaidas();
    } finally {
      _$_SaidaStoreActionController.endAction(_$actionInfo);
    }
  }

  @override
  String toString() {
    return '''
saidas: ${saidas},
saidaLoaded: ${saidaLoaded}
    ''';
  }
}
