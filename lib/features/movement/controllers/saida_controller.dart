import 'package:projeto_carteira/features/account/controllers/pessoa_controller.dart';
import 'package:sqflite/sqflite.dart';

import '../../../sql/db_helper.dart';
import '../daos/saida_dao.dart';
import '../../account/models/pessoa_model.dart';
import '../models/movimento_abs.dart';
import '../models/saida_model.dart';

class SaidaController {
  Future<Database?> get db =>
      DatabaseHelper
          .getInstance()
          .db;
  final SaidaDao _saidaDao = SaidaDao();
  final PessoaController _pessoaController = PessoaController();

  insertSaida(SaidaModel saida, PessoaModel pessoa) async {
    pessoa.saldo = pessoa.saldo! - saida.valor!;
    double newSaldo = pessoa.saldo!;
    await _pessoaController.updatePessoaField(saida.pessoa!, 'saldo', newSaldo.toString());
    await _saidaDao.save(saida);
  }

  deleteSaida(Movimento saida, PessoaModel pessoa) async {
    pessoa.saldo = pessoa.saldo! + saida.valor!;
    double newSaldo = pessoa.saldo!;
    await _pessoaController.updatePessoaField(saida.pessoa!, 'saldo', newSaldo.toString());
    await _saidaDao.delete(saida.codigo!, 'codigo');
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
