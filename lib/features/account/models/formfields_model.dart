import 'dart:convert';
import 'package:flutter/material.dart';

class FormFields {
  TextEditingController nomeControl = TextEditingController();
  TextEditingController emailControl = TextEditingController();
  TextEditingController senhaControl = TextEditingController();
  TextEditingController senha2Control = TextEditingController();
  TextEditingController minimumControl = TextEditingController();
  String? typeControl;

  FormFields(this.nomeControl, this.emailControl, this.senhaControl, this.minimumControl, this.senha2Control,
      {this.typeControl});

  @override
  String toString() {
    return 'Forms::\nNome: ${nomeControl.text},\nE-Mail: ${emailControl.text},\nSenha: ${senhaControl.text},'
        '\nSenha(2): ${senha2Control.text},\nMínimo: ${minimumControl.text},\nTipo: $typeControl';
  }

  @override
  Map<String, dynamic> toMap() {
    return {
      'nomeControl': nomeControl,
      'emailControl': emailControl,
      'senhaControl': senhaControl,
      'senha2Control': senha2Control,
      'minimumControl': minimumControl,
      'typeControl': typeControl,
    };
  }

  factory FormFields.fromJson(Map<String, dynamic> json) {
    return FormFields(
        json['nomeControl'], json['emailControl'], json['senhaControl'], json['minimumControl'], json['senha2Control'],
        typeControl: json['typeControl']);
  }

  String toJson() => json.encode(toMap());

  clearAll() {
    nomeControl.clear();
    emailControl.clear();
    senhaControl.clear();
    senha2Control.clear();
    minimumControl.clear();
    typeControl = '';
  }
}
