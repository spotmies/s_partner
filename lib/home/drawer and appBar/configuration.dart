import 'package:flutter/material.dart';

Color primaryGreen = Colors.white;
// Color primaryGreen = Color(0xff416d6d);

List<BoxShadow> shadowList = [
  BoxShadow(color: Colors.grey[300], blurRadius: 30, offset: Offset(0, 10))
];
List<Map> categories = [
  {'name': 'Cats', 'iconPath': 'images/cat.png'},
  {'name': 'Dogs', 'iconPath': 'images/dog.png'},
  {'name': 'Bunnies', 'iconPath': 'images/rabbit.png'},
  {'name': 'Parrots', 'iconPath': 'images/parrot.png'},
  {'name': 'Horses', 'iconPath': 'images/horse.png'}
];

List<Map> drawerItems = [
  {'icon': Icons.share, 'title': 'Invite'},
  {'icon': Icons.security, 'title': 'Privacy Policies'},
  {'icon': Icons.help, 'title': 'Help & Support'},
  {'icon': Icons.history, 'title': 'Service History'},
  {'icon': Icons.feedback, 'title': 'FeedBack'},
  {'icon': Icons.edit, 'title': 'Edit Details'},
  {'icon': Icons.settings, 'title': 'Settings'},
  {'icon': Icons.power_settings_new, 'title': 'Sign Out'},
];