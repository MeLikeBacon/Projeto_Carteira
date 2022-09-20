import 'package:projeto_carteira/features/models/movimento_abs.dart';

abstract class EntradaModel extends Movimento {
  int ssss;

  EntradaModel() : super(1, 2, DateTime.now(), 's', 12);
}
