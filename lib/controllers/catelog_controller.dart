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
  List<Map> netCatelogPics = [];
  List<String> uploadedImages = [];
  bool loader = false;
  bool isEditForm = false;
  bool isWarranty = false;
  TextEditingController catNameControl = TextEditingController();
  TextEditingController catPriceControl = TextEditingController();
  TextEditingController catDescControl = TextEditingController();
  TextEditingController catTAC = TextEditingController();
  TextEditingController warrantyVal = TextEditingController();
  TextEditingController warrantyDet = TextEditingController();
  TextEditingController days = TextEditingController();
  TextEditingController hours = TextEditingController();
  TextEditingController wI = TextEditingController();
  TextEditingController wNI = TextEditingController();
  TextEditingController catOfferPrice = TextEditingController();
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

  Future<void> pickCatelogImage(int index) async {
    log("index $index");
    try {
      final image = await ImagePicker().pickImage(
        source: ImageSource.gallery,
        imageQuality: 40,
        preferredCameraDevice: CameraDevice.front,
      );
      final profilepicTemp = File(image!.path);
      netCatelogPics.removeAt(index);
      netCatelogPics.insert(index, {"path": profilepicTemp, "type": "offline"});
      setState(() {});
    } on PlatformException catch (e) {
      log(e.toString());
    }
  }

  Future<bool> checkAndUploadImages(BuildContext context) async {
    final String location =
        "partner/${FirebaseAuth.instance.currentUser?.uid}/store";
    for (int i = 0; i < netCatelogPics.length; i++) {
      if (netCatelogPics[i]['type'] == "offline") {
        String imageUrl = await uploadFilesToCloud(netCatelogPics[i]['path'],
            cloudLocation: location);
        uploadedImages.add(imageUrl);
      } else if (netCatelogPics[i]['type'] == "online") {
        uploadedImages.add(netCatelogPics[i]['path']);
      }
    }
    log(uploadedImages.toString());
    if (uploadedImages.length < 1) {
      snackbar(context, "Please add atleat 1 image");
      return false;
    }
    return true;
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

  fillAllForms() {
    for (var i = 0; i < 4; i++) {
      netCatelogPics.add({
        "path":
            "https://toppng.com/uploads/preview/file-upload-image-icon-115632290507ftgixivqp.png",
        "type": "placeHolder"
      });
    }
    uploadedImages = [];
    catNameControl.text = "";
    catPriceControl.text = "";
    catDescControl.text = "";
    catOfferPrice.text = "";
    catTAC.text =
        "the amount quoted about only service fee. it does not includes material cost";
    isWarranty = true;
    warrantyDet.text = "Warranty only applicable on the issues we worked on";
    warrantyVal.text = "30";
    days.text = "";
    hours.text = "";
    wI.text = "the quoted price includes discount";
    wNI.text = "the quoted price does not includes GST";
    catelogPic = null;
  }

  resetForm() {
    netCatelogPics = [];
    uploadedImages = [];
  }

  editAllFields(cat) {
    isEditForm = true;
    netcatelogPic = cat != null ? cat['media'][0]['url'] : "";
    final List media = cat['media'] as List;
    log(media.toString());
    for (var i = 0; i < 4; i++) {
      if (i < media.length) {
        netCatelogPics.add({"path": media[i]['url'], "type": "online"});
      } else {
        netCatelogPics.add({
          "path":
              "https://toppng.com/uploads/preview/file-upload-image-icon-115632290507ftgixivqp.png",
          "type": "placeHolder"
        });
      }
    }

    // media.forEach((element) {
    //   netCatelogPics.insert(media.indexOf(element), element['url']);
    //   // netCatelogPics.add(element['url']);
    //   log(netCatelogPics.toString());
    // });
    catNameControl.text = cat['name'] != null ? cat['name'].toString() : "";
    catPriceControl.text = cat['price'] != null ? cat['price'].toString() : "";
    catDescControl.text =
        cat['description'] != null ? cat['description'].toString() : "";
    catOfferPrice.text =
        cat['offerPrice'] != null ? cat['offerPrice'].toString() : "";
    catTAC.text = cat['termsAndConditions'][0] != null
        ? cat['termsAndConditions'][0].toString()
        : "";
    isWarranty = cat['isWarranty'] != null ? cat['isWarranty'] : false;
    warrantyDet.text =
        cat['warrantyDetails'] != null ? cat['warrantyDetails'].toString() : "";
    warrantyVal.text =
        cat['warrantyDays'] != null ? cat['warrantyDays'].toString() : "";
    days.text =
        cat['daysToComplete'] != null ? cat['daysToComplete'].toString() : "";
    hours.text =
        cat['hoursToComplete'] != null ? cat['hoursToComplete'].toString() : "";
    wI.text =
        cat['whatIncluds'][0] != null ? cat['whatIncluds'][0].toString() : "";
    wNI.text = cat['whatNotIncluds'][0] != null
        ? cat['whatNotIncluds'][0].toString()
        : "";
    catelogPic = null;
    refresh();
  }

  addCatlogList(itemCode, job, BuildContext context, pD) async {
    // await uploadimage();
    var range = {
      "coordinates.0": 17.7480656,
      "coordinates.1": 83.2621366,
    };
    Map<String, String?> body = {
      "name": catNameControl.text,
      "category": "$job",
      "itemCode": "$itemCode",
      "price": catPriceControl.text,
      "description": catDescControl.text,
      "pId": API.pid,
      // "media.0.type": "image",
      // "media.0.url": imageLink.toString(),
      "isWarranty": isWarranty.toString(),
      "warrantyDays": warrantyVal.text.toString(),
      "warrantyDetails": warrantyDet.text.toString(),
      "termsAndConditions.0": catTAC.text.toString(),
      "daysToComplete": days.text.toString(),
      "hoursToComplete": hours.text.toString(),
      "whatIncluds.0": wI.text.toString(),
      "whatNotIncluds.0": wNI.text.toString(),
      "isVerified": false.toString(),
      "maxRange": 5.toString(),
      "range": range.toString(),
      "offerPrice": catOfferPrice.text.toString(),
      "pDetails": pD.toString(),
      "errorMessage": "Service under verification"
    };
    for (int i = 0; i < uploadedImages.length; i++) {
      body["media.$i.type"] = "image";
      body["media.$i.url"] = uploadedImages[i].toString();
    }
    log(body.toString());

    var response = await Server().postMethod(API.catelog + API.pid!, body);

    if (response.statusCode == 200 || response.statusCode == 204) {
      log(response.statusCode.toString());
      snackbar(context, "Service added successfully");
      return jsonDecode(response.body);
    } else {
      log(response.statusCode.toString());
      log(response.body.toString());
      snackbar(context, 'Something went wrong');
      return null;
    }
  }

  updateCat(catid, BuildContext context) async {
    // if (catelogPic != null) await uploadimage();
    log("image link");
    log(imageLink.toString());
    Map<String, String> body = {
      "name": catNameControl.text,
      "price": catPriceControl.text,
      "description": catDescControl.text,
      "isVerified": "false",
      "isWarranty": isWarranty.toString(),
      "warrantyDays": warrantyVal.text.toString(),
      "warrantyDetails": warrantyDet.text.toString(),
      "termsAndConditions.0": catTAC.text.toString(),
      "daysToComplete": days.text.toString(),
      "hoursToComplete": hours.text.toString(),
      "whatIncluds.0": wI.text.toString(),
      "whatNotIncluds.0": wNI.text.toString(),
      "offerPrice": catOfferPrice.text.toString(),
      "errorMessage": "Service under verification"

      // if (imageLink != null) "media.0.type": "image",
      // if (imageLink != null) "media.0.url": imageLink.toString().toString(),
    };
    for (int i = 0; i < uploadedImages.length; i++) {
      body["media.$i.type"] = "image";
      body["media.$i.url"] = uploadedImages[i].toString();
    }

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
