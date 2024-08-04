import 'package:flutter/material.dart';

TextStyle getCustomTextStyle(BuildContext context) {
  return Theme.of(context).textTheme.bodyMedium?.copyWith(color: Theme.of(context).colorScheme.onSurface) ?? TextStyle();
}
