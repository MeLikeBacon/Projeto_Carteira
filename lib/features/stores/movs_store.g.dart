// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'movs_store.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_brace_in_string_interps, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic, no_leading_underscores_for_local_identifiers

mixin _$MovsStore on _MovsStore, Store {
  late final _$movsAtom = Atom(name: '_MovsStore.movs', context: context);

  @override
  List<Movimento> get movs {
    _$movsAtom.reportRead();
    return super.movs;
  }

  @override
  set movs(List<Movimento> value) {
    _$movsAtom.reportWrite(value, super.movs, () {
      super.movs = value;
    });
  }

  late final _$movsLoadedAtom =
      Atom(name: '_MovsStore.movsLoaded', context: context);

  @override
  bool get movsLoaded {
    _$movsLoadedAtom.reportRead();
    return super.movsLoaded;
  }

  @override
  set movsLoaded(bool value) {
    _$movsLoadedAtom.reportWrite(value, super.movsLoaded, () {
      super.movsLoaded = value;
    });
  }

  late final _$loadMovsAsyncAction =
      AsyncAction('_MovsStore.loadMovs', context: context);

  @override
  Future loadMovs({String initialDate = '', String finalDate = ''}) {
    return _$loadMovsAsyncAction.run(
        () => super.loadMovs(initialDate: initialDate, finalDate: finalDate));
  }

  late final _$_MovsStoreActionController =
      ActionController(name: '_MovsStore', context: context);

  @override
  dynamic emptyMovs() {
    final _$actionInfo =
        _$_MovsStoreActionController.startAction(name: '_MovsStore.emptyMovs');
    try {
      return super.emptyMovs();
    } finally {
      _$_MovsStoreActionController.endAction(_$actionInfo);
    }
  }

  @override
  String toString() {
    return '''
movs: ${movs},
movsLoaded: ${movsLoaded}
    ''';
  }
}
