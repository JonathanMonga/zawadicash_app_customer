// ignore_for_file: unnecessary_null_comparison

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:zawadicash_app/controller/home_controller.dart';
import 'package:zawadicash_app/controller/profile_screen_controller.dart';
import 'package:zawadicash_app/util/dimensions.dart';
import 'package:zawadicash_app/util/get_class_name.dart';
import 'package:zawadicash_app/util/styles.dart';

class ShowName extends StatelessWidget {
  const ShowName({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        GetBuilder<ProfileController>(
          init: Get.find<ProfileController>(
              tag: getClassName<ProfileController>()),
          tag: getClassName<ProfileController>(),
          builder: (controller) => controller.userInfo != null
              ? Text(
                  '${'Hi'.tr} ${controller.userInfo!.fName} ${controller.userInfo!.lName}',
                  textAlign: TextAlign.start,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: rubikLight.copyWith(
                    fontSize: Dimensions.FONT_SIZE_DEFAULT,
                    color: Colors.white.withOpacity(0.5),
                  ),
                )
              : Text('hi_user'.tr,
                  style: rubikLight.copyWith(
                      fontSize: Dimensions.FONT_SIZE_DEFAULT,
                      color: Colors.white.withOpacity(0.5))),
        ),
        GetBuilder<HomeController>(
            init: Get.find<HomeController>(tag: getClassName<HomeController>()),
            tag: getClassName<HomeController>(),
            builder: (controller) {
              return Text(
                controller.greetingMessage(),
                style: rubikRegular.copyWith(
                  fontSize: Dimensions.FONT_SIZE_OVER_LARGE,
                  color: Colors.white,
                ),
              );
            }),
      ],
    );
  }
}
