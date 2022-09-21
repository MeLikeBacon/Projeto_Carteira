import 'package:flutter/cupertino.dart';
import 'package:projeto_carteira/features/models/pessoa_model.dart';
import 'package:projeto_carteira/sql/db_helper.dart';
import 'package:sqflite/sqflite.dart';

import '../DAOs/pessoa_dao.dart';

class PessoaController {
  Future<Database?> get db => DatabaseHelper.getInstance().db;
  final PessoaDao _pessoaDao = PessoaDao();

  Future<bool> insertPessoa(BuildContext context, PessoaModel pessoa) async {
    List<PessoaModel> check = await _pessoaDao
        .query("SELECT * FROM pessoas WHERE email = ?;", [pessoa.email]);

    if (check.isEmpty) {
      await _pessoaDao.save(pessoa);
      return false;
    } else {
      print('$check already exists.');
      return true;
    }
  }

  Future<List<PessoaModel>> logInPessoa(String email, String senha) async {
    return await _pessoaDao.query(
        "SELECT * from pessoas WHERE email = ? AND senha = ?", [email, senha]);
  }

  deletePessoa(int id) async {
    await _pessoaDao.delete(id, 'codigo');
  }

  updatePessoaField(int id, String column, String newer) {
    _pessoaDao.update(id, column, newer);
  }

  // Updates both instance and database
  updatePessoaWhole(PessoaModel pessoa, int id, String nome, String email,
      String senha, double minimo) {
    //Instance
    pessoa
      ..codigo = id
      ..nome = nome
      ..email = email
      ..senha = senha
      ..minimo = minimo;
    //Database
    _pessoaDao.query(
        'UPDATE pessoas SET nome = ?, email = ?, senha = ?, minimo = ? WHERE id = ?;',
        [nome, email, senha, minimo, pessoa.codigo]);
  }
}
