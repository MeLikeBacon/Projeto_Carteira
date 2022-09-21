import 'package:projeto_carteira/features/models/movimento_abs.dart';

class SaidaModel extends Movimento {
  SaidaModel(
      {int? codigo,
      int? pessoa,
      DateTime? data_saida,
      String? desc,
      double? valor})
      : super(codigo, pessoa, data_saida, desc, valor);

  @override
  Map<String, dynamic> toMap() {
    return {
      'codigo': codigo,
      'pessoa': pessoa,
      'data_saida': data.toString(),
      'desc': descricao,
      'valor': valor,
    };
  }

  @override
  String toString() {
    return 'EntradaModel{codigo: $codigo, pessoa: $pessoa, data_saida: $data, desc: $descricao, valor: $valor}';
  }

  factory SaidaModel.fromJson(Map<String, dynamic> json) {
    return SaidaModel(
        codigo: json['codigo'],
        pessoa: json['pessoa'],
        data_saida: json['data_saida'],
        desc: json['desc'],
        valor: json['valor']);
  }
}
