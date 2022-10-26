import 'package:projeto_carteira/features/account/controllers/pessoa_controller.dart';
import 'package:projeto_carteira/features/account/models/pessoa_model.dart';
import 'package:projeto_carteira/features/movement/models/movimento_abs.dart';
import 'package:sqflite/sqflite.dart';

import '../../../sql/db_helper.dart';
import '../daos/entrada_dao.dart';
import '../models/entrada_model.dart';

class EntradaController {
  Future<Database?> get db => DatabaseHelper.getInstance().db;
  final EntradaDao _entradaDao = EntradaDao();
  final PessoaController _pessoaController = PessoaController();

  insertEntrada(EntradaModel entrada, PessoaModel pessoa) async {
    pessoa.saldo = pessoa.saldo! + entrada.valor!;
    double newSaldo = pessoa.saldo!;
    await _pessoaController.updatePessoaField(entrada.pessoa!, 'saldo', newSaldo.toString());
    await _entradaDao.save(entrada);
  }

  deleteEntrada(Movimento entrada, PessoaModel pessoa) async {
    pessoa.saldo = pessoa.saldo! - entrada.valor!;
    double newSaldo = pessoa.saldo!;
    await _pessoaController.updatePessoaField(entrada.pessoa!, 'saldo', newSaldo.toString());
    await _entradaDao.delete(entrada.codigo!, 'codigo');
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
