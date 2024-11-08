import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:zawadicash_app/controller/localization_controller.dart';
import 'package:zawadicash_app/util/app_constants.dart';
import 'package:zawadicash_app/util/dimensions.dart';
import 'package:zawadicash_app/util/get_class_name.dart';
import 'package:zawadicash_app/util/styles.dart';
import 'package:zawadicash_app/view/base/custom_app_bar.dart';
import 'package:zawadicash_app/view/base/custom_logo.dart';
import 'package:zawadicash_app/view/base/custom_small_button.dart';
import 'package:zawadicash_app/view/base/custom_snackbar.dart';
import 'package:zawadicash_app/view/screens/more/widget/language_widget.dart';

class ChooseLanguageScreen extends StatelessWidget {
  const ChooseLanguageScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppbar(title: 'language'.tr),
      body:
          GetBuilder<LocalizationController>(
              init: Get.find<LocalizationController>(tag: getClassName<LocalizationController>()),
              tag: getClassName<LocalizationController>(),
              builder: (localizationController) {
        return Column(children: [
          Expanded(
              child: Center(
            child: Scrollbar(
              child: SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                padding: const EdgeInsets.all(Dimensions.PADDING_SIZE_SMALL),
                child: Center(
                    child: SizedBox(
                  width: MediaQuery.of(context).size.width,
                  child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Align(
                          alignment: Alignment.center,
                          child: CustomLogo(
                            height: 150,
                            width: 150,
                          ),
                        ),
                        const SizedBox(
                          height: Dimensions.PADDING_SIZE_OVER_LARGE,
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: Dimensions.PADDING_SIZE_EXTRA_SMALL),
                          child: Text('select_language'.tr,
                              style: rubikMedium.copyWith(
                                  color: Theme.of(context)
                                      .textTheme
                                      .titleLarge!
                                      .color,
                                  fontSize: Dimensions.FONT_SIZE_EXTRA_LARGE)),
                        ),
                        const SizedBox(
                            height: Dimensions.PADDING_SIZE_EXTRA_SMALL),
                        GridView.builder(
                          gridDelegate:
                              const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 2,
                            childAspectRatio: (1 / 1),
                          ),
                          itemCount: localizationController.languages.length,
                          physics: const NeverScrollableScrollPhysics(),
                          shrinkWrap: true,
                          itemBuilder: (context, index) => LanguageWidget(
                            languageModel:
                                localizationController.languages[index],
                            localizationController: localizationController,
                            index: index,
                          ),
                        ),
                        const SizedBox(height: Dimensions.PADDING_SIZE_LARGE),
                        Text('* ${'you_can_change_language'.tr}',
                            style: rubikRegular.copyWith(
                              fontSize: Dimensions.FONT_SIZE_SMALL,
                              color: Theme.of(context).disabledColor,
                            )),
                      ]),
                )),
              ),
            ),
          )),
          Container(
            padding: const EdgeInsets.only(
                left: Dimensions.PADDING_SIZE_DEFAULT,
                right: Dimensions.PADDING_SIZE_DEFAULT,
                bottom: Dimensions.PADDING_SIZE_EXTRA_EXTRA_LARGE),
            child: Row(
              children: [
                Expanded(
                  child: CustomSmallButton(
                    onTap: () {
                      if (localizationController.languages.isNotEmpty &&
                          localizationController.selectedIndex != -1) {
                        localizationController.setLanguage(Locale(
                          AppConstants
                              .languages[localizationController.selectedIndex]
                              .languageCode!,
                          AppConstants
                              .languages[localizationController.selectedIndex]
                              .countryCode,
                        ));
                        Get.back();
                      } else {
                        showCustomSnackBar('select_a_language'.tr,
                            isError: false);
                      }
                    },
                    backgroundColor: Theme.of(context).secondaryHeaderColor,
                    text: 'save'.tr,
                    textColor: Theme.of(context).textTheme.bodyLarge!.color!,
                  ),
                ),
              ],
            ),
          ),
        ]);
      }),
    );
  }
}
