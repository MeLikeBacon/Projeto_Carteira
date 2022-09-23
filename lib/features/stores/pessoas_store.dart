import 'package:mobx/mobx.dart';

import '../models/pessoa_model.dart';

// Include generated file
part 'pessoas_store.g.dart';

// This is the class used by rest of your codebase
class PessoasStore = _PessoasStore with _$PessoasStore;

// The store-class
abstract class _PessoasStore with Store {
  @observable
  PessoaModel currentUser = PessoaModel();

  @action
  void changeUser(PessoaModel newUser) {
    currentUser = newUser;
  }

  @action
  logout() {
    currentUser = PessoaModel();
  }
}
