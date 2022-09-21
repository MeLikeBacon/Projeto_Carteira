import 'dart:convert';

import 'package:projeto_carteira/sql/entity.dart';

abstract class Movimento extends Entity {
  int? codigo;
  int? pessoa;
  DateTime? data;
  String? descricao;
  double? valor;

  Movimento(this.codigo, this.pessoa, this.data, this.descricao, this.valor);

  @override
  Map<String, dynamic> toMap();

  @override
  String toString();

  String toJson() => json.encode(toMap());
}
