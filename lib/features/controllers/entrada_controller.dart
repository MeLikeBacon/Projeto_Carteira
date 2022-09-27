import 'package:flutter/material.dart';
import 'package:projeto_carteira/features/DAOs/pessoa_dao.dart';
import 'package:projeto_carteira/features/models/pessoa_model.dart';
import 'package:sqflite/sqflite.dart';

import '../../sql/db_helper.dart';
import '../DAOs/entrada_dao.dart';
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

  updateEntradaField(int id, String column, String newer) {
    _entradaDao.update(id, column, newer);
  }

  // Updates both instance and database
  updateEntradaWhole(EntradaModel entrada, EntradaModel tempEntrada) {
    //Instance
    entrada
      ..descricao = tempEntrada.descricao
      ..data = tempEntrada.data
      ..valor = tempEntrada.valor;

    //Database
    _entradaDao.updateEntrada(tempEntrada);
  }
}
