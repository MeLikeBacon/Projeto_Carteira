import 'package:projeto_carteira/features/models/movimento_abs.dart';

class EntradaModel extends Movimento {
  EntradaModel(
      {int? codigo,
      int? pessoa,
      DateTime? data_entrada,
      String? descricao,
      double? valor})
      : super(codigo, pessoa, data_entrada, descricao, valor);

  @override
  Map<String, dynamic> toMap() {
    return {
      'codigo': codigo,
      'pessoa': pessoa,
      'data_entrada': data.toString(),
      'descricao': descricao,
      'valor': valor,
    };
  }

  @override
  String toString() {
    return 'EntradaModel{codigo: $codigo, pessoa: $pessoa, data_entrada: $data, descricao: $descricao, valor: $valor}';
  }

  factory EntradaModel.fromJson(Map<String, dynamic> json) {
    return EntradaModel(
        codigo: json['codigo'],
        pessoa: json['pessoa'],
        data_entrada: json['data_entrada'],
        descricao: json['descricao'],
        valor: json['valor']);
  }
}
