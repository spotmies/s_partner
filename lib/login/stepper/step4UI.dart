import 'package:flutter/material.dart';
import 'package:spotmies_partner/controllers/stepper_controller.dart';

Widget step4UI(BuildContext context, StepperController stepperController) {
  var _hight = MediaQuery.of(context).size.height;
  // var _width = MediaQuery.of(context).size.width;
  return Column(
    children: [
      Container(
        height: _hight * 0.66,
        child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
          Text(
            'Profile _stepperController.picture',
            style: TextStyle(fontSize: 25),
          ),
          SizedBox(
            height: 10,
          ),
          Center(
            child: Container(
              padding: EdgeInsets.all(10),
              height: 220,
              width: double.infinity,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(30),
                    topRight: Radius.circular(30)),
                // border: Border.all()
              ),
              child: CircleAvatar(
                child: Center(
                  child: stepperController.profilepics == null
                      ? Icon(
                          Icons.person,
                          color: Colors.blueGrey,
                          size: 200,
                        )
                      : Container(
                          height: _hight * 0.27,
                          decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              image: DecorationImage(
                                  fit: BoxFit.fill,
                                  image: FileImage(
                                      stepperController.profilepics))),
                        ),
                ),
                radius: 30,
                backgroundColor: Colors.grey[100],
              ),
            ),
          ),
          Container(
            height: 40,
            width: double.infinity,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(30),
                  bottomRight: Radius.circular(30)),
              // border: Border.all()
            ),
            child: TextButton(
                onPressed: () {
                  stepperController.profilePic();
                },
                // icon: Icon(Icons.select_all),
                child: Text(
                  'Choose Image',
                  style: TextStyle(fontSize: 18, color: Colors.grey),
                )),
            // child: FlatButton(color:Colors.blue[700], onPressed: (){}, child: Text('Choose image')),
          ),
        ]),
      )
    ],
  );
}
