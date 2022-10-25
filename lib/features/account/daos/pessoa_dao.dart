import 'package:projeto_carteira/features/account/models/pessoa_model.dart';
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

  getUserByID(int id) async {
    try {
      List<PessoaModel> pessoa = await query('SELECT * FROM $tableName WHERE codigo = $id');
      return pessoa.first;
    } catch (e) {
      print(e);
    }
  }

  updateSaldo(int pessoaId, double newSaldo) async {
    try {
      await query('UPDATE pessoas SET saldo = ? WHERE codigo = ?;', [newSaldo, pessoaId]);
    } catch (e) {
      print(e);
    }
  }

  updateUser(PessoaModel updatedPessoa) async {
    try {
      await query(
          'UPDATE pessoas SET nome = ?, email = ?, senha = ?, minimo = ?, saldo = ?, tipo = ? WHERE codigo = ?;', [
        updatedPessoa.nome,
        updatedPessoa.email,
        updatedPessoa.senha,
        updatedPessoa.minimo,
        updatedPessoa.saldo,
        updatedPessoa.tipo,
        updatedPessoa.codigo
      ]);
      print('updated user, id: ${updatedPessoa.codigo}');
    } catch (e) {
      print(e);
    }
  }
}
