import 'package:flutter/material.dart';
import 'package:projeto_carteira/features/account/daos/pessoa_dao.dart';
import 'package:projeto_carteira/features/account/models/pessoa_model.dart';
import 'package:sqflite/sqflite.dart';

import '../../../sql/db_helper.dart';
import '../daos/entrada_dao.dart';
import '../models/entrada_model.dart';

class EntradaController {
  Future<Database?> get db => DatabaseHelper.getInstance().db;
  final EntradaDao _entradaDao = EntradaDao();
  final PessoaDao _pessoaDao = PessoaDao();

  insertEntrada(EntradaModel entrada, PessoaModel pessoa) async {
    pessoa.saldo = pessoa.saldo! + entrada.valor!;
    double newSaldo = pessoa.saldo!;
    await _pessoaDao.updateSaldo(entrada.pessoa!, newSaldo);
    await _entradaDao.save(entrada);
  }

  deleteEntrada(int id) async {
    await _entradaDao.delete(id, 'codigo');
  }

  deleteSingleUserEntradas(int id) async {
    await _entradaDao.delete(id, 'pessoa');
  }

  updateEntradaField(int id, String column, String newer) {
    _entradaDao.update(id, column, newer, 'codigo');
  }

  // Updates both instance and database
  updateEntradaWhole(EntradaModel entrada, EntradaModel tempEntrada) {
    //Instance
    entrada
      ..descricao = tempEntrada.descricao
      ..data = tempEntrada.data
      ..valor = tempEntrada.valor
      ..mov_type = tempEntrada.mov_type;

    //Database
    _entradaDao.updateEntrada(tempEntrada);
  }
}
