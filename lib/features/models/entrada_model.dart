import 'package:projeto_carteira/features/models/movimento_abs.dart';

class EntradaModel extends Movimento {
  EntradaModel(
      {int? codigo,
      int? pessoa,
      int? responsavel,
      DateTime? data_entrada,
      String? descricao,
      double? valor,
      bool? mov_type = true})
      : super(codigo, pessoa, responsavel, data_entrada, descricao, valor,
            mov_type);

  @override
  Map<String, dynamic> toMap() {
    return {
      'codigo': codigo,
      'pessoa': pessoa,
      'responsavel': responsavel,
      'data_entrada': data.toString(),
      'descricao': descricao,
      'valor': valor,
      'mov_type': mov_type == true ? 1 : 0
    };
  }

  @override
  String toString() {
    return 'EntradaModel{codigo: $codigo, pessoa: $pessoa, responsavel: $responsavel, data_entrada: $data, descricao: $descricao, valor: $valor, mov_type: $mov_type}';
  }

  factory EntradaModel.fromJson(Map<String, dynamic> json) {
    return EntradaModel(
        codigo: json['codigo'],
        pessoa: json['pessoa'],
        responsavel: json['responsavel'],
        data_entrada: DateTime.parse(json['data_entrada']),
        descricao: json['descricao'],
        valor: json['valor'],
        mov_type: json['mov_type'] == 1 ? true : false);
  }
}
