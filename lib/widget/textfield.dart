import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class TextFieldWidget extends StatelessWidget {
  TextFieldWidget({
    super.key,
    required this.maxLine,
    required this.hintText,
    required this.txtController,
    required this.readOnly,
    this.keyboardType = TextInputType.text, // Ajout d'une valeur par défaut
    this.inputFormatters, // Aucune valeur par défaut pour les inputFormatters
  });

  final int maxLine;
  final bool readOnly;
  final String hintText;
  final TextEditingController txtController;
  final TextInputType keyboardType; // Ajout de la propriété keyboardType
  final List<TextInputFormatter>?
      inputFormatters; // Ajout de la propriété inputFormatters

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      decoration: BoxDecoration(
        color: Colors.grey.shade200,
        borderRadius: BorderRadius.circular(8),
      ),
      child: TextField(
        keyboardType: keyboardType, // Utilisation de la propriété keyboardType
        inputFormatters:
            inputFormatters, // Utilisation de la propriété inputFormatters
        controller: txtController,
        decoration: InputDecoration(
          enabledBorder: InputBorder.none,
          focusedBorder: InputBorder.none,
          hintText: hintText,
        ),
        readOnly: readOnly,
        maxLines: maxLine,
      ),
    );
  }
}
