import 'dart:convert';

import 'package:projeto_carteira/sql/entity.dart';

abstract class Movimento extends Entity {
  int? codigo;
  int? pessoa;
  DateTime? data;
  String? descricao;
  double? valor;
  bool? mov_type;

  Movimento(this.codigo, this.pessoa, this.data, this.descricao, this.valor,
      this.mov_type);

  @override
  Map<String, dynamic> toMap();

  @override
  String toString();

  String toJson() => json.encode(toMap());
}
