import 'package:projeto_carteira/features/models/saida_model.dart';
import 'package:projeto_carteira/sql/base_dao.dart';

class SaidaDao extends BaseDao<SaidaModel> {
  @override
  SaidaModel fromMap(Map<String, dynamic> map) {
    return SaidaModel.fromJson(map);
  }

  @override
  String get tableName => 'saida';

  getSaidas() async {
    try {
      List<SaidaModel> saidas = await query('SELECT * FROM saida');

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
