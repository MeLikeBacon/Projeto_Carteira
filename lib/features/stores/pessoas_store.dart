import 'package:mobx/mobx.dart';
import 'package:projeto_carteira/features/DAOs/pessoa_dao.dart';

import '../models/pessoa_model.dart';

// Include generated file
part 'pessoas_store.g.dart';

// This is the class used by rest of your codebase
class PessoasStore = _PessoasStore with _$PessoasStore;

// The store-class
abstract class _PessoasStore with Store {
  final PessoaDao _pessoaDao = PessoaDao();

  @observable
  PessoaModel currentUser = PessoaModel();

  @observable
  List<PessoaModel> pessoas = [];

  @observable
  bool pessoaLoaded = true;

  @action
  void changeUser(PessoaModel newUser) {
    currentUser = newUser;
  }

  @action
  logout() {
    currentUser = PessoaModel();
  }

  @action
  loadPessoas() async {
    pessoaLoaded = false;
    pessoas = await _pessoaDao.getPessoas();
    pessoaLoaded = true;
  }

  @action
  emptyPessoas() {
    pessoas = [];
  }
}
