import 'package:projeto_carteira/features/models/saida_model.dart';
import 'package:projeto_carteira/sql/base_dao.dart';

class SaidaDao extends BaseDao<SaidaModel> {
  @override
  SaidaModel fromMap(Map<String, dynamic> map) {
    return SaidaModel.fromJson(map);
  }

  @override
  String get tableName => 'saida';

  getSaidas(
      {String initialDate = '', String finalDate = '', int? personId}) async {
    List<SaidaModel> saidas = [];

    try {
      if (initialDate.isNotEmpty && finalDate.isNotEmpty) {
        saidas = await query(
            "SELECT * FROM saida WHERE (data_saida BETWEEN '$initialDate' AND '$finalDate') ${personId != null ? 'AND pessoa = $personId' : ''}");
      } else {
        saidas = await query(
            'SELECT * FROM saida ${personId != null ? 'WHERE pessoa = $personId' : ''}');
      }

      return saidas;
    } catch (e) {
      print(e);
    }
  }

  updateSaida(SaidaModel updatedSaida) async {
    try {
      await query(
          'UPDATE saida SET descricao = ?, data_saida = ?, valor = ? WHERE codigo = ?;',
          [
            updatedSaida.descricao,
            updatedSaida.data,
            updatedSaida.valor,
          ]);
      print('updated saida, id: ${updatedSaida.codigo}');
    } catch (e) {
      print(e);
    }
  }
}
