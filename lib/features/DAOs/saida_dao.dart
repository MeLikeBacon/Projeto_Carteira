import 'package:projeto_carteira/features/models/saida_model.dart';
import 'package:projeto_carteira/sql/base_dao.dart';

class SaidaDao extends BaseDao<SaidaModel> {
  @override
  SaidaModel fromMap(Map<String, dynamic> map) {
    return SaidaModel.fromJson(map);
  }

  @override
  String get tableName => 'saida';

  getPessoas() async {
    try {
      List<SaidaModel> saidas = await query('SELECT * FROM saida');

      return saidas;
    } catch (e) {
      print(e);
    }
  }
}
