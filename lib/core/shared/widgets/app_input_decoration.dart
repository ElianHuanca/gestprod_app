import 'package:flutter/material.dart';

class CustomDropdownField<T> extends StatelessWidget {
  final List<T> items;
  final String? value;
  final ValueChanged<String?> onChanged;
  final String Function(T) itemLabel;
  final String Function(T) itemValue;
  final String label;
  final String hint;
  final IconData? icon;
  final bool allowNull;
  final String? nullLabel;
  final String? Function(String?)? validator;
  final void Function(String?)? onSaved;
  final Key? fieldKey;

  const CustomDropdownField({
    super.key,
    required this.items,
    required this.value,
    required this.onChanged,
    required this.itemLabel,
    required this.itemValue,
    this.label = 'Seleccione',
    this.hint = 'Seleccione',
    this.icon,
    this.allowNull = false,
    this.nullLabel,
    this.validator,
    this.onSaved,
    this.fieldKey,
  });

  @override
  Widget build(BuildContext context) {
    return DropdownButtonFormField<String?>(
      key: fieldKey ?? ValueKey(value ?? 'null'),
      initialValue: value,
      decoration: appInputDecoration(
        context,
        label: label,
        hint: hint,
        icon: icon,
      ),
      items: [
        if (allowNull)
          DropdownMenuItem<String?>(
            value: null,
            child: Text(nullLabel ?? hint),
          ),
        ...items.map(
          (item) => DropdownMenuItem<String?>(
            value: itemValue(item),
            child: Text(itemLabel(item)),
          ),
        ),
      ],
      onChanged: onChanged,
      onSaved: onSaved,
      validator: validator,
    );
  }
}

class CustomField extends StatelessWidget {
  final bool isTopField; // La idea es que tenga bordes redondeados arriba
  final bool isBottomField; // La idea es que tenga bordes redondeados abajo
  final String? label;
  final String? hint;
  final String? errorMessage;
  final bool obscureText;
  final TextInputType? keyboardType;
  final int maxLines;
  final TextCapitalization? textCapitalization;
  final String? Function(String?)? validator;
  final IconData? icon;
  final TextEditingController textEditingController;
  const CustomField({
    super.key,
    this.isTopField = false,
    this.isBottomField = false,
    this.label,
    this.hint,
    this.errorMessage,
    this.obscureText = false,
    this.keyboardType = TextInputType.text,
    this.maxLines = 1,
    this.textCapitalization,
    this.validator,
    this.icon,
    required this.textEditingController,
  });

  @override
  Widget build(BuildContext context) {
    const borderRadius = Radius.circular(15);
    return Container(
      padding: const EdgeInsets.only(bottom: 4),
      decoration: BoxDecoration(
        color: Colors.transparent,
        borderRadius: BorderRadius.only(
          topLeft: isTopField ? borderRadius : Radius.zero,
          topRight: isTopField ? borderRadius : Radius.zero,
          bottomLeft: isBottomField ? borderRadius : Radius.zero,
          bottomRight: isBottomField ? borderRadius : Radius.zero,
        ),
        boxShadow: [
          if (isBottomField)
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.06),
              blurRadius: 5,
              offset: const Offset(0, 3),
            ),
        ],
      ),
      child: TextFormField(
        controller: textEditingController,
        validator: validator,
        obscureText: obscureText,
        keyboardType: keyboardType,
        style: const TextStyle(fontSize: 15, color: Colors.black54),
        maxLines: maxLines,
        textCapitalization: textCapitalization ?? TextCapitalization.none,
        decoration: appInputDecoration(
          context,
          label: label ?? '',
          hint: hint ?? '',
          icon: icon,
          errorMessage: errorMessage ?? '',
          maxLines: maxLines,
        ),
      ),
    );
  }
}

InputDecoration appInputDecoration(
  BuildContext context, {
  required String label,
  required String hint,
  IconData? icon,
  String? errorMessage,
  int maxLines = 1,
}) {
  final theme = Theme.of(context);
  final border = OutlineInputBorder(borderRadius: BorderRadius.circular(40));
  return InputDecoration(
    prefixIcon: icon != null
        ? Icon(icon, size: 22, color: theme.colorScheme.onSurfaceVariant)
        : null,
    label: Text(label),
    hintText: hint,
    filled: true,
    fillColor: theme.colorScheme.surfaceContainerHighest.withValues(alpha: 0.4),
    border: border,
    enabledBorder: border,
    focusedBorder: border,
    errorBorder: border,
    focusedErrorBorder: border,
    floatingLabelBehavior: maxLines > 1
        ? FloatingLabelBehavior.always
        : FloatingLabelBehavior.auto,
    floatingLabelStyle: const TextStyle(
      color: Colors.black,
      fontWeight: FontWeight.bold,
      fontSize: 15,
    ),
    contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
    labelStyle: theme.textTheme.bodyLarge?.copyWith(
      color: theme.colorScheme.onSurfaceVariant,
    ),
    isDense: true,
    errorText: errorMessage,
    //focusColor: theme.colorScheme.primary,
  );
}
