import 'package:projeto_carteira/features/models/entrada_model.dart';
import 'package:projeto_carteira/sql/base_dao.dart';

class EntradaDao extends BaseDao<EntradaModel> {
  @override
  EntradaModel fromMap(Map<String, dynamic> map) {
    return EntradaModel.fromJson(map);
  }

  @override
  String get tableName => 'entrada';

  getEntradas(
      {String initialDate = '', String finalDate = '', int? personId}) async {
    List<EntradaModel> entradas = [];

    try {
      if (initialDate.isNotEmpty && finalDate.isNotEmpty) {
        entradas = await query(
            "SELECT * FROM entrada WHERE (data_entrada BETWEEN '$initialDate' AND '$finalDate') ${personId != null ? 'AND pessoa = $personId' : ''}");
      } else {
        entradas = await query(
            'SELECT * FROM entrada ${personId != null ? 'WHERE pessoa = $personId' : ''}');
      }

      return entradas;
    } catch (e) {
      print(e);
    }
  }

  updateEntrada(EntradaModel updatedEntrada) async {
    try {
      await query(
          'UPDATE entrada SET descricao = ?, data_entrada = ?, valor = ? WHERE codigo = ?;',
          [
            updatedEntrada.descricao,
            updatedEntrada.data,
            updatedEntrada.valor,
          ]);
      print('updated entrada, id: ${updatedEntrada.codigo}');
    } catch (e) {
      print(e);
    }
  }
}
