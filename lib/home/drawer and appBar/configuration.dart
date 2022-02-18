import 'package:flutter/material.dart';
import 'package:spotmies_partner/providers/theme_provider.dart';

Color primaryGreen = SpotmiesTheme.background;
// Color primaryGreen = Color(0xff416d6d);

List<BoxShadow> shadowList = [
  BoxShadow(color: SpotmiesTheme.shadow, blurRadius: 30, offset: Offset(0, 10))
];

List<Map> drawerItems = [
  {'icon': Icons.share, 'title': 'Invite'},
  {'icon': Icons.security, 'title': 'Privacy Policies'},
  {'icon': Icons.help, 'title': 'Help & Support'},
  {'icon': Icons.history, 'title': 'Service History'},
  {'icon': Icons.feedback, 'title': 'FeedBack'},
  {'icon': Icons.edit, 'title': 'Edit Details'},
  {'icon': Icons.category, 'title': 'Catelog'},
  {'icon': Icons.settings, 'title': 'Settings'},
  {'icon': Icons.power_settings_new, 'title': 'Sign Out'},
];
