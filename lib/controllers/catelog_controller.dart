import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:mvc_pattern/mvc_pattern.dart';
import 'package:spotmies_partner/apiCalls/apiCalling.dart';
import 'package:spotmies_partner/apiCalls/apiUrl.dart';
import 'package:spotmies_partner/home/drawer%20and%20appBar/catalog_list.dart';
import 'package:spotmies_partner/utilities/snackbar.dart';
import 'package:spotmies_partner/utilities/uploadFilesToCloud.dart';

class CatelogController extends ControllerMVC {
  File? catelogPic;
  String? imageLink;
  GlobalKey<FormState> catformkey = GlobalKey<FormState>();
  String? netcatelogPic;
  bool loader = false;
  TextEditingController catNameControl = TextEditingController();
  TextEditingController catPriceControl = TextEditingController();
  TextEditingController catDescControl = TextEditingController();
  Future<void> catelogImage() async {
    try {
      final image = await ImagePicker().pickImage(
        source: ImageSource.gallery,
        imageQuality: 20,
        preferredCameraDevice: CameraDevice.front,
      );
      final profilepicTemp = File(image!.path);
      catelogPic = profilepicTemp;
      setState(() {});
      // WidgetsBinding.instance!.addPostFrameCallback((_) => setState(() {}));
    } on PlatformException catch (e) {
      log(e.toString());
    }
  }

  Future<void> uploadimage() async {
    if (catelogPic == null) return;
    // var postImageRef = FirebaseStorage.instance.ref().child('ProfilePic');
    // UploadTask uploadTask = postImageRef
    //     .child(DateTime.now().toString() + ".jpg")
    //     .putFile(catelogPic!);
    // log(uploadTask.toString());
    // var imageUrl = await (await uploadTask).ref.getDownloadURL();
    final String location =
        "partner/${FirebaseAuth.instance.currentUser?.uid}/store";
    String imageUrl =
        await uploadFilesToCloud(catelogPic, cloudLocation: location);
    imageLink = imageUrl.toString();
    log(imageLink.toString());
  }

  fillAllForms(cat) {
    netcatelogPic = cat != null ? cat['media'][0]['url'] : "";
    catNameControl.text = cat['name'] != null ? cat['name'].toString() : "";
    catPriceControl.text = cat['price'] != null ? cat['price'].toString() : "";
    catDescControl.text =
        cat['description'] != null ? cat['description'].toString() : "";
    refresh();
  }

  addCatlogList(itemCode, job, BuildContext context) async {
    await uploadimage();
    Map<String, String?> body = {
      "name": catNameControl.text,
      "category": "$job",
      "itemCode": "$itemCode",
      "price": catPriceControl.text,
      "description": catDescControl.text,
      "pId": API.pid,
      "media.0.type": "image",
      "media.0.url": imageLink.toString().toString(),
    };

    var response = await Server().postMethod(API.catelog + API.pid!, body);

    if (response.statusCode == 200 || response.statusCode == 204) {
      log(response.statusCode.toString());
      // snackbar(context, "Service added successfully");
      return jsonDecode(response.body);
    } else {
      // snackbar(context, 'Something went wrong');
      return null;
    }
  }

  updateCat(catid, BuildContext context) async {
    if (imageLink != null) await uploadimage();
    var body = {
      "name": catNameControl.text,
      "price": catPriceControl.text,
      "description": catDescControl.text,
      if (imageLink != null) "media.0.type": "image",
      if (imageLink != null) "media.0.url": imageLink.toString().toString(),
    };

    var response = await Server().editMethod(API.updateCatelog + catid, body);
    if (response.statusCode == 200 || response.statusCode == 204) {
      log(response.statusCode.toString());
      snackbar(context, "Service updated successfully");
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
    } else {
      log(response.statusCode.toString());
    }
    partnerDetailsProvider!.setOffileLoader(false);
  }

  deleteCatelog(id) async {
    var response = await Server().deleteMethod(API.deleteCatlog + id);
    if (response.statusCode == 200 || response.statusCode == 204) {
      log(response.statusCode.toString());
      return response.statusCode;
    } else {
      log(response.statusCode.toString());
      return null;
    }
  }
}
