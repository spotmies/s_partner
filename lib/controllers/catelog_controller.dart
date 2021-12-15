import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:mvc_pattern/mvc_pattern.dart';
import 'package:spotmies_partner/apiCalls/apiCalling.dart';
import 'package:spotmies_partner/apiCalls/apiUrl.dart';
import 'package:spotmies_partner/home/drawer%20and%20appBar/catalog_list.dart';
import 'package:spotmies_partner/utilities/snackbar.dart';

class CatelogController extends ControllerMVC {
  File catelogPic;
  var imageLink;
  var catformkey = GlobalKey<FormState>();
  bool loader = false;
  TextEditingController catNameControl = TextEditingController();
  TextEditingController catPriceControl = TextEditingController();
  TextEditingController catDescControl = TextEditingController();
  Future<void> catelogImage() async {
    try {
      final image = await ImagePicker().pickImage(
        source: ImageSource.camera,
        imageQuality: 20,
        preferredCameraDevice: CameraDevice.front,
      );
      final profilepicTemp = File(image.path);
      catelogPic = profilepicTemp;
      setState(() {});
      // WidgetsBinding.instance!.addPostFrameCallback((_) => setState(() {}));
    } on PlatformException catch (e) {
      log(e.toString());
    }
  }

  Future<void> uploadimage() async {
    if (catelogPic == null) return;
    var postImageRef = FirebaseStorage.instance.ref().child('ProfilePic');
    UploadTask uploadTask = postImageRef
        .child(DateTime.now().toString() + ".jpg")
        .putFile(catelogPic);
    log(uploadTask.toString());
    var imageUrl = await (await uploadTask).ref.getDownloadURL();
    imageLink = imageUrl.toString();
    log(imageLink.toString());
  }

  addCatlogList() async {
    await uploadimage();
    var body = {
      "name": catNameControl.text,
      "category": "1",
      "itemCode": "321",
      "price": catPriceControl.text,
      "description": catDescControl.text,
      "pId": API.pid,
      "media.0.type": "image",
      "media.0.url": imageLink.toString().toString(),
    };
    // log(body.toString());

    var response = await Server().postMethod(API.catelog + API.pid, body);
    if (response.statusCode == 200 || response.statusCode == 204) {
      log(response.statusCode.toString());
      return jsonDecode(response.body);
    } else {
      snackbar(context, 'Something went wrong');
      return null;
    }
  }

  updateCatListState(body, id) async {
    var response = await Server().editMethod(API.updateCatelog + id, body);
    if (response.statusCode == 200) {
      log(response.statusCode.toString());
      // Map<String, dynamic> data =
      //     jsonDecode(response.body) as Map<String, dynamic>;
      // partnerDetailsProvider.setPartnerDetailsOnly(data);
    } else {
      log(response.statusCode.toString());
      // partnerDetailsProvider.setAvailability(!pd['availability']);
    }
    partnerDetailsProvider.setOffileLoader(false);
  }
}
