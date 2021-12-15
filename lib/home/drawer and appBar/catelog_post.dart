import 'package:flutter/material.dart';
import 'package:spotmies_partner/utilities/app_config.dart';

Future catelogPost(
  BuildContext context,
) {
  return showModalBottomSheet(
      context: context,
      elevation: 22,
      isScrollControlled: true,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(20),
        ),
      ),
      builder: (BuildContext context) {
        return Container(
          height: height(context) * 0.85,
          child: Column(
            children: [
              
            ],
          ),
        );
      });
}
