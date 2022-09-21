import 'package:projeto_carteira/features/models/entrada_model.dart';
import 'package:projeto_carteira/sql/base_dao.dart';

class EntradaDao extends BaseDao<EntradaModel> {
  @override
  EntradaModel fromMap(Map<String, dynamic> map) {
    return EntradaModel.fromJson(map);
  }

  @override
  String get tableName => 'entrada';

  getPessoas() async {
    try {
      List<EntradaModel> entradas = await query('SELECT * FROM entrada');

      return entradas;
    } catch (e) {
      print(e);
    }
  }
}
