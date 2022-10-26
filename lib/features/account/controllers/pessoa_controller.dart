import 'package:projeto_carteira/features/account/models/pessoa_model.dart';
import 'package:projeto_carteira/sql/db_helper.dart';
import 'package:sqflite/sqflite.dart';

import '../daos/pessoa_dao.dart';

class PessoaController {
  Future<Database?> get db => DatabaseHelper.getInstance().db;
  final PessoaDao _pessoaDao = PessoaDao();

  Future<bool> insertPessoa(PessoaModel pessoa) async {
    List<PessoaModel> check = await _pessoaDao.query("SELECT * FROM pessoas WHERE email = ?;", [pessoa.email]);

    if (check.isEmpty) {
      await _pessoaDao.save(pessoa);
      return false;
    } else {
      print('${check.first} already exists.');
      return true;
    }
  }

  Future<List<PessoaModel>> logInPessoa(String email, String senha) async {
    return await _pessoaDao.query("SELECT * from pessoas WHERE email = ? AND senha = ?", [email, senha]);
  }

  Future<PessoaModel?> findPessoaByID(int id) async {
    List<PessoaModel?> ids = await _pessoaDao.getUsersByColumn('codigo', id.toString());
    return ids.first;
  }

  Future<PessoaModel?> findPessoaByEmail(String email) async {
    List<PessoaModel?> emails = await _pessoaDao.getUsersByColumn('email', email);
    return emails.first;
  }

  deletePessoa(int id) async {
    await _pessoaDao.delete(id, 'codigo');
  }

  updatePessoaField(int id, String column, String newer) {
    _pessoaDao.update(id, column, newer, 'codigo');
  }

  // Updates both instance and database
  updatePessoaWhole(PessoaModel pessoa, PessoaModel tempPessoa) {
    //Instance
    pessoa
      ..nome = tempPessoa.nome
      ..email = tempPessoa.email
      ..senha = tempPessoa.senha
      ..minimo = tempPessoa.minimo
      ..tipo = tempPessoa.tipo;
    //Database
    _pessoaDao.updateUser(pessoa);
  }
}
