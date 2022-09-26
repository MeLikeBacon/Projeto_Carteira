import 'package:projeto_carteira/features/models/movimento_abs.dart';

class SaidaModel extends Movimento {
  SaidaModel(
      {int? codigo,
      int? pessoa,
      DateTime? data_saida,
      String? descricao,
      double? valor})
      : super(codigo, pessoa, data_saida, descricao, valor);

  @override
  Map<String, dynamic> toMap() {
    return {
      'codigo': codigo,
      'pessoa': pessoa,
      'data_saida': data.toString(),
      'descricao': descricao,
      'valor': valor,
    };
  }

  @override
  String toString() {
    return 'EntradaModel{codigo: $codigo, pessoa: $pessoa, data_saida: $data, descricao: $descricao, valor: $valor}';
  }

  factory SaidaModel.fromJson(Map<String, dynamic> json) {
    return SaidaModel(
        codigo: json['codigo'],
        pessoa: json['pessoa'],
        data_saida: json['data_saida'],
        descricao: json['descricao'],
        valor: json['valor']);
  }
}
