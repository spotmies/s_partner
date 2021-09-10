import 'package:flutter/material.dart';

snackbar(BuildContext context, description, {color: Colors.black}) {
  final snackBar = SnackBar(
    backgroundColor: color,
    content: Text(description),
    action: SnackBarAction(
      label: 'Close',
      onPressed: () {},
    ),
  );

  return ScaffoldMessenger.of(context).showSnackBar(snackBar);
}
