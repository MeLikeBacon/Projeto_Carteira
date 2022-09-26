import 'package:mobx/mobx.dart';
import 'package:projeto_carteira/features/DAOs/saida_dao.dart';

import '../models/saida_model.dart';

part 'saida_store.g.dart';

// This is the class used by rest of your codebase
class SaidaStore = _SaidaStore with _$SaidaStore;

// The store-class
abstract class _SaidaStore with Store {
  final SaidaDao _saidaDao = SaidaDao();

  @observable
  List<SaidaModel> saidas = [];

  @action
  loadSaidas() {
    saidas = _saidaDao.getSaidas();
  }

  @action
  emptyEntradas() {
    saidas = [];
  }
}
