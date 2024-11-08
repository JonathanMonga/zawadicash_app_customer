import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:zawadicash_app/controller/splash_controller.dart';
import 'package:zawadicash_app/controller/websitelink_controller.dart';
import 'package:zawadicash_app/helper/custom_launch_url.dart';
import 'package:zawadicash_app/util/color_resources.dart';
import 'package:zawadicash_app/util/dimensions.dart';
import 'package:zawadicash_app/util/get_class_name.dart';
import 'package:zawadicash_app/util/images.dart';
import 'package:zawadicash_app/util/styles.dart';
import 'package:zawadicash_app/view/base/custom_image.dart';
import 'package:zawadicash_app/view/base/custom_ink_well.dart';

class LinkedWebsite extends StatelessWidget {
  const LinkedWebsite({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<WebsiteLinkController>(
        init: Get.find<WebsiteLinkController>(tag: getClassName<WebsiteLinkController>()),
        tag: getClassName<WebsiteLinkController>(),
        builder: (websiteLinkController) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(
                horizontal: Dimensions.PADDING_SIZE_LARGE),
            child: Text(
              'linked_website'.tr,
              style: rubikRegular.copyWith(
                fontSize: Dimensions.FONT_SIZE_LARGE,
                color: Theme.of(context).textTheme.titleLarge!.color,
              ),
            ),
          ),
          Container(
            height: 86,
            width: double.infinity,
            margin: const EdgeInsets.only(top: Dimensions.PADDING_SIZE_SMALL),
            decoration: BoxDecoration(
              color: Theme.of(context).cardColor,
              boxShadow: [
                BoxShadow(
                  color: ColorResources.containerShedow.withOpacity(0.05),
                  blurRadius: 20,
                  offset: const Offset(0, 3),
                )
              ],
            ),
            child: ListView.builder(
              itemCount: websiteLinkController.websiteList.length,
              scrollDirection: Axis.horizontal,
              itemBuilder: (context, index) {
                return CustomInkWell(
                  onTap: () => CustomLaunchUrl.launchURL(
                      url: websiteLinkController.websiteList[index].url),
                  radius: Dimensions.RADIUS_SIZE_EXTRA_SMALL,
                  highlightColor:
                      Theme.of(context).primaryColor.withOpacity(0.1),
                  child: Container(
                    width: 100,
                    padding: const EdgeInsets.symmetric(
                        vertical: Dimensions.PADDING_SIZE_DEFAULT),
                    child: Column(
                      children: [
                        SizedBox(
                          width: 50,
                          height: 30,
                          child: CustomImage(
                            image:
                                "${Get.find<SplashController>(tag: getClassName<SplashController>()).configModel.baseUrls!.linkedWebsiteImageUrl}/${websiteLinkController.websiteList[index].image}",
                            placeholder: Images.web_link_place_holder,
                            fit: BoxFit.fitWidth,
                          ),
                        ),
                        const Spacer(),
                        Text(
                          websiteLinkController.websiteList[index].name!,
                          style: rubikRegular.copyWith(
                            fontSize: Dimensions.FONT_SIZE_SMALL,
                            color: ColorResources.getWebsiteTextColor(),
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
          const SizedBox(
            height: Dimensions.PADDING_SIZE_SMALL,
          ),
        ],
      );
    });
  }
}
