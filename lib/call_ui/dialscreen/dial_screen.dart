import 'package:flutter/material.dart';
import 'package:spotmies_partner/call_ui/audioCallWithImage/constants.dart';
import 'package:spotmies_partner/call_ui/audioCallWithImage/size.config.dart';
import 'package:spotmies_partner/providers/theme_provider.dart';

import 'components/body.dart';

class DialScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    return Scaffold(
      backgroundColor: SpotmiesTheme.background,
      body: Body(),
    );
  }
}
