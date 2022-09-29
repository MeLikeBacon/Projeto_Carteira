import 'package:mobx/mobx.dart';
import 'package:projeto_carteira/features/DAOs/entrada_dao.dart';
import 'package:projeto_carteira/features/DAOs/saida_dao.dart';
import 'package:projeto_carteira/features/models/movimento_abs.dart';

part 'movs_store.g.dart';

// This is the class used by rest of your codebase
class MovsStore = _MovsStore with _$MovsStore;

// The store-class
abstract class _MovsStore with Store {
  final EntradaDao _entradaDao = EntradaDao();
  final SaidaDao _saidaDao = SaidaDao();

  @observable
  List<Movimento> movs = [];

  @observable
  bool movsLoaded = true;

  @action
  loadMovs({String initialDate = '', String finalDate = ''}) async {
    movsLoaded = false;

    movs.addAll(await _entradaDao.getEntradas(
        initialDate: initialDate, finalDate: finalDate));
    movs.addAll(await _saidaDao.getSaidas(
        initialDate: initialDate, finalDate: finalDate));

    movsLoaded = true;
  }

  @action
  emptyMovs() {
    movs = [];
  }
}
