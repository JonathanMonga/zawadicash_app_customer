import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../../controller/camera_screen_controller.dart';

class CameraView extends StatefulWidget {
  const CameraView({super.key});

  // final bool isQrCodeScan;
  // final bool fromEditProfile;
  // CameraView({Key key, this.isQrCodeScan = false, this.fromEditProfile = false}) : super(key: key);



  @override
  _CameraViewState createState() => _CameraViewState();
}

class _CameraViewState extends State<CameraView> {


  // @override
  // void initState() {
  //   super.initState();
  //   // Get.find<CameraScreenController>(tag: getClassName<CameraScreenController>()).startLiveFeed(fromEditProfile: widget.fromEditProfile, isQrCodeScan: widget.isQrCodeScan);
  // }
  //
  // @override
  // void dispose() {
  //   Get.find<CameraScreenController>(tag: getClassName<CameraScreenController>()).stopLiveFeed();
  //   super.dispose();
  // }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<CameraScreenController>(
      builder: (cameraController) {
        if (cameraController.controller.value.isInitialized == false) {
          return const SizedBox();
        }
        final size = MediaQuery.of(context).size;
        return Container(
          color: Colors.black,
          height: size.height * 0.7,
          width: size.width,
          child: AspectRatio(
            aspectRatio: cameraController.controller.value.aspectRatio,
            child: CameraPreview(cameraController.controller),
          ),
        );
      }
    );
  }
}