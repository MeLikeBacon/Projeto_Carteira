import 'package:projeto_carteira/sql/entity.dart';

abstract class Movimento extends Entity {
  int? codigo;
  int? pessoa;
  DateTime? data;
  String? descricao;
  double? valor;

  int get id {
    return codigo!;
  }

  set id(int value) => codigo = value;

  Movimento(
      int this.codigo, this.pessoa, this.data, this.descricao, this.valor);
}
