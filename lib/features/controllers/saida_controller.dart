import 'package:flutter/material.dart';
import 'package:sqflite/sqflite.dart';

import '../../sql/db_helper.dart';
import '../DAOs/pessoa_dao.dart';
import '../DAOs/saida_dao.dart';
import '../models/pessoa_model.dart';
import '../models/saida_model.dart';

class SaidaController {
  Future<Database?> get db => DatabaseHelper.getInstance().db;
  final SaidaDao _saidaDao = SaidaDao();
  final PessoaDao _pessoaDao = PessoaDao();

  insertSaida(SaidaModel entrada, PessoaModel pessoa) async {
    pessoa.saldo = pessoa.saldo! - entrada.valor!;
    await _pessoaDao.updateSaldo(entrada.pessoa!, pessoa.saldo!);
    await _saidaDao.save(entrada);
  }

  deleteSaida(int id) async {
    await _saidaDao.delete(id, 'codigo');
  }

  deleteSingleUserSaidas(int id) async {
    await _saidaDao.delete(id, 'pessoa');
  }

  updateSaidaField(int id, String column, String newer) {
    _saidaDao.update(id, column, newer, 'codigo');
  }

  // Updates both instance and database
  updateSaidaWhole(SaidaModel saida, SaidaModel tempSaida) {
    //Instance
    saida
      ..descricao = tempSaida.descricao
      ..data = tempSaida.data
      ..valor = tempSaida.valor
      ..mov_type = tempSaida.mov_type;

    //Database
    _saidaDao.updateSaida(tempSaida);
  }
}
