import 'package:mobx/mobx.dart';
import 'package:projeto_carteira/features/movement/controllers/entrada_controller.dart';
import 'package:projeto_carteira/features/movement/controllers/saida_controller.dart';

import 'package:projeto_carteira/features/movement/models/movimento_abs.dart';

part 'movs_store.g.dart';

// This is the class used by rest of your codebase
class MovsStore = _MovsStore with _$MovsStore;

// The store-class
abstract class _MovsStore with Store {
  final EntradaController _entradaController = EntradaController();
  final SaidaController _saidaController = SaidaController();

  @observable
  List<Movimento> movs = [];

  @observable
  bool movsLoaded = true;

  @action
  loadMovs(int personId, {String initialDate = '', String finalDate = ''}) async {
    movsLoaded = false;

    movs = [
      ...await _entradaController.getEntradas(personId, initialDate: initialDate, finalDate: finalDate),
      ...await _saidaController.getSaidas(personId, initialDate: initialDate, finalDate: finalDate)
    ];

    movsLoaded = true;
  }

  @action
  emptyMovs() {
    movs = [];
  }

  @computed
  List<Movimento> get movsTimeline {
    var ordered = movs;
    ordered.sort(((a, b) => a.data!.compareTo(b.data!)));
    return ordered;
  }

  @computed
  List<DateTime> get movsDates {
    var list = movsTimeline.map((item) {
      //return UtilData.obterDataMMAAAA(item.data!);
      return item.data!;
    })
        //.toSet()
        .toList();

    return list;
  }

  @computed
  double get movsValuesMax {
    return movsTimeline.fold(0.0, (previousValue, element) => previousValue + (element.mov_type! ? element.valor! : 0));
  }

  @computed
  List<double> get movsValues {
    var list = movsTimeline.map((item) {
      return item.mov_type! ? item.valor! : -item.valor!;
    }).toList();

    return list;
  }

  @computed
  List<double> get movsValuesPercent {
    var list = movsValues;

    if (list.length != 1) {
      for (int i = 1; i < list.length; i++) {
        list[i] = list[i] + list[i - 1];
      }
      //print(list);
    }

    //list = list.map((e) => e / movsValuesMax).toList();

    return list;
  }
}
