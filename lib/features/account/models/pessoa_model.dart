import 'dart:convert';

import '../../../sql/entity.dart';

class PessoaModel extends Entity {
  int? codigo;
  String? nome;
  String? email;
  String? senha;
  double? minimo;
  double? saldo;
  String? tipo;

  PessoaModel({this.codigo, this.nome, this.email, this.senha, this.minimo, this.saldo = 0, this.tipo = 'user'});

  @override
  Map<String, dynamic> toMap() {
    return {
      'codigo': codigo,
      'nome': nome,
      'email': email,
      'senha': senha,
      'minimo': minimo,
      'saldo': saldo,
      'tipo': tipo
    };
  }

  @override
  String toString() {
    return 'PessoaModel{codigo: $codigo, nome: $nome, email: $email, senha: $senha, saldo: $saldo, minimo: $minimo, tipo: $tipo}';
  }

  PessoaModel copyWith(
      {int? codigo, String? nome, String? email, String? senha, double? saldo, double? minimo, String? tipo}) {
    return PessoaModel(
        codigo: codigo ?? this.codigo,
        nome: nome ?? this.nome,
        email: email ?? this.email,
        senha: senha ?? this.senha,
        saldo: saldo ?? this.saldo,
        minimo: minimo ?? this.minimo,
        tipo: tipo ?? this.tipo);
  }

  factory PessoaModel.fromJson(Map<String, dynamic> json) {
    return PessoaModel(
        codigo: json['codigo'],
        nome: json['nome'],
        email: json['email'],
        senha: json['senha'],
        saldo: json['saldo'],
        minimo: json['minimo'],
        tipo: json['tipo']);
  }

  String toJson() => json.encode(toMap());
}
