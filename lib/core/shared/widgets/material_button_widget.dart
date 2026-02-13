import 'package:flutter/material.dart';

enum _ButtonStyleType { guardar, eliminar }

class MaterialButtonWidget extends StatelessWidget {
  final VoidCallback onPressed;
  final String texto;

  const MaterialButtonWidget({
    super.key,
    required this.onPressed,
    required this.texto,
  });

  _ButtonStyleType get _styleType {
    if (texto.toLowerCase() == 'eliminar') return _ButtonStyleType.eliminar;
    return _ButtonStyleType.guardar;
  }

  @override
  Widget build(BuildContext context) {
    final isEliminar = _styleType == _ButtonStyleType.eliminar;
    return MaterialButton(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
        side: isEliminar
            ? const BorderSide(color: Colors.black)
            : BorderSide.none,
      ),
      color: isEliminar ? null : Colors.black,
      onPressed: onPressed,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        child: Center(
          child: Text(
            texto,
            style: TextStyle(
              color: isEliminar ? Colors.black : Colors.white,
              fontSize: 20,
            ),
            textAlign: TextAlign.center,
          ),
        ),
      ),
    );
  }
}
