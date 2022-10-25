import 'package:brasil_fields/brasil_fields.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class MyFormField extends StatefulWidget {
  MyFormField({Key? key, required this.labelText, required this.control, required this.errorText}) : super(key: key);

  String labelText;
  TextEditingController control;
  String? errorText;

  @override
  State<MyFormField> createState() => _MyFormFieldState();
}

class _MyFormFieldState extends State<MyFormField> {
  bool visible = false;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 15),
      child: TextFormField(
        obscureText: widget.labelText == 'Senha' || widget.labelText == 'Confirme sua senha' ? !visible : false,
        keyboardType: widget.labelText == 'Mínimo' ? TextInputType.number : null,
        inputFormatters:
            widget.labelText == 'Mínimo' ? [FilteringTextInputFormatter.digitsOnly, CentavosInputFormatter()] : null,
        controller: widget.control,
        //style: TextStyle(fontSize: textSize),
        decoration: InputDecoration(
          errorText: widget.errorText,
          border: const OutlineInputBorder(),
          labelText: widget.labelText,
          suffixIcon: widget.labelText == 'Senha' || widget.labelText == 'Confirme sua senha'
              ? IconButton(
                  onPressed: (() {
                    setState(() {
                      visible = !visible;
                    });
                  }),
                  icon: Icon(
                    visible ? Icons.visibility : Icons.visibility_off,
                    //size: iconSize,
                  ),
                )
              : IconButton(
                  onPressed: widget.control.clear,
                  icon: const Icon(Icons.cancel_outlined),
                ),
        ),
      ),
    );
  }
}
