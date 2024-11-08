import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:zawadicash_app/controller/edit_profile_controller.dart';
import 'package:zawadicash_app/controller/profile_screen_controller.dart';
import 'package:zawadicash_app/util/color_resources.dart';
import 'package:zawadicash_app/util/dimensions.dart';
import 'package:zawadicash_app/util/get_class_name.dart';
import 'package:zawadicash_app/util/images.dart';
import 'package:zawadicash_app/util/styles.dart';
import 'package:zawadicash_app/view/screens/auth/other_info/widget/custom_gender_card.dart';

class GenderView extends StatelessWidget {
  final bool fromEditProfile;
  const GenderView({
    Key? key,
    this.fromEditProfile = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GetBuilder<ProfileController>(
        init: Get.find<ProfileController>(tag: getClassName<ProfileController>()),
        tag: getClassName<ProfileController>(),
        builder: (profileController) {
      return GetBuilder<EditProfileController>(
          init: Get.find<EditProfileController>(tag: getClassName<EditProfileController>()),
          tag: getClassName<EditProfileController>(),
          builder: (editProfileController) {
        String gender = fromEditProfile
            ? editProfileController.gender
            : profileController.gender;
        return Container(
          width: double.infinity,
          padding: const EdgeInsets.only(
            top: Dimensions.PADDING_SIZE_EXTRA_LARGE,
            left: Dimensions.PADDING_SIZE_LARGE,
            bottom: Dimensions.PADDING_SIZE_DEFAULT,
          ),
          decoration:
              BoxDecoration(color: Theme.of(context).cardColor, boxShadow: [
            BoxShadow(
              color: ColorResources.getShadowColor().withOpacity(0.08),
              blurRadius: 20,
              offset: const Offset(0, 3),
            )
          ]),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'select_your_gender'.tr,
                style: rubikMedium.copyWith(
                  color: Theme.of(context).textTheme.bodyLarge!.color,
                  fontSize: Dimensions.FONT_SIZE_EXTRA_LARGE,
                ),
              ),
              const SizedBox(
                height: Dimensions.PADDING_SIZE_DEFAULT,
              ),
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: [
                    CustomGenderCard(
                      icon: Images.male,
                      text: 'male'.tr,
                      color: gender == 'Male'
                          ? Theme.of(context).secondaryHeaderColor
                          : ColorResources.genderDefaultColor.withOpacity(0.5),
                      onTap: () => fromEditProfile
                          ? editProfileController.setGender('Male')
                          : profileController.setGender('Male'),
                    ),
                    const SizedBox(
                      width: Dimensions.PADDING_SIZE_SMALL,
                    ),
                    CustomGenderCard(
                      icon: Images.female,
                      text: 'female'.tr,
                      color: gender == 'Female'
                          ? Theme.of(context).secondaryHeaderColor
                          : ColorResources.genderDefaultColor.withOpacity(0.5),
                      onTap: () => fromEditProfile
                          ? editProfileController.setGender('Female')
                          : profileController.setGender('Female'),
                    ),
                    const SizedBox(
                      width: Dimensions.PADDING_SIZE_SMALL,
                    ),
                    CustomGenderCard(
                      icon: Images.other,
                      text: 'other'.tr,
                      color: gender == 'Other'
                          ? Theme.of(context).secondaryHeaderColor
                          : ColorResources.genderDefaultColor.withOpacity(0.5),
                      onTap: () => fromEditProfile
                          ? editProfileController.setGender('Other')
                          : profileController.setGender('Other'),
                    ),
                  ],
                ),
              )
            ],
          ),
        );
      });
    });
  }
}
