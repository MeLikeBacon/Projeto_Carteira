import 'package:projeto_carteira/features/models/movimento_abs.dart';

class SaidaModel extends Movimento {
  SaidaModel(
      {int? codigo,
      int? pessoa,
      DateTime? data_saida,
      String? descricao,
      double? valor,
      bool? mov_type = false})
      : super(codigo, pessoa, data_saida, descricao, valor, mov_type);

  @override
  Map<String, dynamic> toMap() {
    return {
      'codigo': codigo,
      'pessoa': pessoa,
      'data_saida': data.toString(),
      'descricao': descricao,
      'valor': valor,
      'mov_type': mov_type == true ? 1 : 0
    };
  }

  @override
  String toString() {
    return 'SaidaModel{codigo: $codigo, pessoa: $pessoa, data_saida: $data, descricao: $descricao, valor: $valor, mov_type: $mov_type}';
  }

  factory SaidaModel.fromJson(Map<String, dynamic> json) {
    return SaidaModel(
        codigo: json['codigo'],
        pessoa: json['pessoa'],
        data_saida: DateTime.parse(json['data_saida']),
        descricao: json['descricao'],
        valor: json['valor'],
        mov_type: json['mov_type'] == 1 ? true : false);
  }
}
