import 'package:mobx/mobx.dart';
import 'package:projeto_carteira/features/DAOs/entrada_dao.dart';

import '../models/entrada_model.dart';

part 'entrada_store.g.dart';

// This is the class used by rest of your codebase
class EntradaStore = _EntradaStore with _$EntradaStore;

// The store-class
abstract class _EntradaStore with Store {
  final EntradaDao _entradaDao = EntradaDao();

  @observable
  List<EntradaModel> entradas = [];

  @action
  loadEntradas() {
    entradas = _entradaDao.getEntradas();
  }

  @action
  emptyEntradas() {
    entradas = [];
  }
}
