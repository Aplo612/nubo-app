import 'package:flutter/material.dart';
import 'package:nubo/config/config.dart';
import 'package:flutter/services.dart';

class UserField extends StatelessWidget {
  const UserField({super.key,
  this.labeltext,
  this.hintText,
  this.icon,
  this.text,
  this.listinput,
  this.validador});

  final String? labeltext;
  final String? hintText;
  final IconData? icon;
  final TextInputType? text;
  final List<TextInputFormatter>? listinput;
  final String? Function(String?)? validador;

  @override
  Widget build(BuildContext context) {
    final textFieldFocusNode = FocusNode();
    final textTheme = Theme.of(context).textTheme;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          labeltext ?? '',
          style: textTheme.displayMedium?.copyWith(color: gray400),     
        ),
        const SizedBox(height: 6),
        TextFormField(
          keyboardType: text,
          inputFormatters: listinput,
          focusNode: textFieldFocusNode,
          style: textTheme.headlineMedium,
          decoration:  InputDecoration(
            floatingLabelBehavior: FloatingLabelBehavior.never, //Hides label on focus or if filledr
            hintText: hintText ,
            hintStyle: textTheme.displayMedium?.copyWith(color: gray400), 
            filled: true, // Needed for adding a fill color
            fillColor: Colors.white, 
            isDense: false,  // Reduces height a bit
            prefixIcon: Icon(icon, size: 24, color: gray400),
            suffixIcon: const Padding(
              padding: EdgeInsets.fromLTRB(0, 0, 4, 0),
            ),
          ),
            validator: validador,
        ),
      ],
    );
  }
}