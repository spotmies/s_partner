import 'package:flutter/material.dart';
import 'package:spotmies_partner/reusable_widgets/text_wid.dart';

circleProgress() {
  return Scaffold(
    body: Center(
      child: CircularProgressIndicator(
        backgroundColor: Colors.indigo[100],
        color: Colors.indigo[900],
      ),
    ),
  );
}

linearProgress() {
  return Scaffold(
    body: Center(
      child: LinearProgressIndicator(
        backgroundColor: Colors.grey[100],
        color: Colors.indigo[900],
      ),
    ),
  );
}

refreshIndicator() {
  return Scaffold(
    body: Center(
        child: RefreshProgressIndicator(
            backgroundColor: Colors.grey[100],
            valueColor: AlwaysStoppedAnimation<Color>(Colors.indigo[900]!))),
  );
}

class NoDataPlaceHolder extends StatelessWidget {
  const NoDataPlaceHolder({
    Key? key,
    required double height,
    required double width,
    required String title,
  })  : _height = height,
        _width = width,
        title = title,
        super(key: key);

  final double _height;
  final double _width;
  final String title;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      physics: AlwaysScrollableScrollPhysics(),
      child: Container(
          height: _height * 0.8,
          width: _width,
          alignment: Alignment.center,
          child: TextWid(
            maxlines: 5,
            text: title,
            size: 18,
          )),
    );
  }
}
