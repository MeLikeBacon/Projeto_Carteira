import 'package:flutter/material.dart';
import 'package:sqflite/sqflite.dart';

import '../../sql/db_helper.dart';
import '../DAOs/saida_dao.dart';
import '../models/saida_model.dart';

class SaidaController {
  Future<Database?> get db => DatabaseHelper.getInstance().db;
  final SaidaDao _saidaDao = SaidaDao();

  insertSaida(SaidaModel entrada) async {
    await _saidaDao.save(entrada);
  }

  deleteSaida(int id) async {
    await _saidaDao.delete(id, 'codigo');
  }

  updateSaidaField(int id, String column, String newer) {
    _saidaDao.update(id, column, newer);
  }

  // Updates both instance and database
  updateSaidaWhole(SaidaModel saida, SaidaModel tempSaida) {
    //Instance
    saida
      ..descricao = tempSaida.descricao
      ..data = tempSaida.data
      ..valor = tempSaida.valor;

    //Database
    _saidaDao.updateSaida(tempSaida);
  }
}
