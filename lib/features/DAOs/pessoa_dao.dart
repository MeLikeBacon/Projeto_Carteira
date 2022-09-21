import 'package:projeto_carteira/features/models/pessoa_model.dart';
import 'package:projeto_carteira/sql/base_dao.dart';

class PessoaDao extends BaseDao<PessoaModel> {
  @override
  PessoaModel fromMap(Map<String, dynamic> map) {
    return PessoaModel.fromJson(map);
  }

  @override
  String get tableName => 'pessoas';

  getPessoas() async {
    try {
      List<PessoaModel> pessoas = await query('SELECT * FROM pessoas');

      return pessoas;
    } catch (e) {
      print(e);
    }
  }
}
