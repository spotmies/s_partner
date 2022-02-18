import 'package:flutter/material.dart';
import 'package:spotmies_partner/providers/theme_provider.dart';
import 'package:spotmies_partner/reusable_widgets/text_wid.dart';

AppBar basicAppbar(BuildContext context,
    {title = "Appbar", Icon? leadingIcon}) {
  final _width = MediaQuery.of(context).size.width;
  return AppBar(
    elevation: 2,
    backgroundColor: SpotmiesTheme.onSurface,
    leading: leadingIcon,
    title: TextWid(
      text: title,
      color: SpotmiesTheme.secondaryVariant,
      size: _width * 0.045,
      weight: FontWeight.w600,
    ),
  );
}
