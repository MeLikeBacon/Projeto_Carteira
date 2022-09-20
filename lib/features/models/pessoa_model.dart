import 'dart:convert';

import '../../sql/entity.dart';

class PessoaModel extends Entity {
  int? codigo;
  String? nome;
  String? email;
  String? senha;
  double? minimo;
  double? saldo;

  PessoaModel(
      {this.codigo,
      this.nome,
      this.email,
      this.senha,
      this.minimo,
      this.saldo = 0});

  @override
  Map<String, dynamic> toMap() {
    return {
      'id': codigo,
      'nome': nome,
      'email': email,
      'senha': senha,
      'minimo': minimo,
      'saldo': saldo
    };
  }

  @override
  String toString() {
    return 'Usuario{user_id: $codigo, nome: $nome, email: $email, senha: $senha, saldo: $saldo, minimo: $minimo}';
  }

  PessoaModel copyWith(
      {int? id,
      String? nome,
      String? email,
      String? senha,
      double? saldo,
      double? minimo}) {
    return PessoaModel(
        codigo: id ?? this.codigo,
        nome: nome ?? this.nome,
        email: email ?? this.email,
        senha: senha ?? this.senha,
        saldo: saldo ?? this.saldo,
        minimo: minimo ?? this.minimo);
  }

  factory PessoaModel.fromJson(Map<String, dynamic> json) {
    return PessoaModel(
        codigo: json['id'],
        nome: json['nome'],
        email: json['email'],
        senha: json['senha'],
        saldo: json['saldo'],
        minimo: json['minimo']);
  }

  String toJson() => json.encode(toMap());
}
