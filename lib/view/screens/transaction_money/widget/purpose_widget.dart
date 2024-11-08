import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_instance/src/extension_instance.dart';
import 'package:get/get_utils/src/extensions/internacionalization.dart';
import 'package:zawadicash_app/controller/localization_controller.dart';
import 'package:zawadicash_app/controller/transaction_controller.dart';
import 'package:zawadicash_app/helper/hexa_color.dart';
import 'package:zawadicash_app/util/dimensions.dart';
import 'package:zawadicash_app/util/get_class_name.dart';
import 'package:zawadicash_app/util/images.dart';
import 'package:zawadicash_app/util/styles.dart';
import 'package:zawadicash_app/view/base/custom_loader.dart';
import 'package:flutter/material.dart';
import 'package:get/get_state_manager/src/simple/get_state.dart';
import 'package:zawadicash_app/view/screens/transaction_money/widget/purpose_item.dart';

class PurposeWidget extends StatelessWidget {
  const PurposeWidget({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final localizationController = Get.find<LocalizationController>(tag: getClassName<LocalizationController>());
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(
              horizontal: Dimensions.PADDING_SIZE_LARGE,
              vertical: Dimensions.PADDING_SIZE_SMALL),
          child: Text(
            'select_your_purpose'.tr,
            style: rubikRegular.copyWith(fontSize: Dimensions.FONT_SIZE_LARGE),
          ),
        ),
        GetBuilder<TransactionMoneyController>(builder: (controller) {
          return controller.isLoading
              ? CustomLoader(color: Theme.of(context).primaryColor)
              : Container(
                  height: 150,
                  padding: localizationController.isLtr
                      ? const EdgeInsets.only(
                          left: Dimensions.PADDING_SIZE_DEFAULT)
                      : const EdgeInsets.only(
                          right: Dimensions.PADDING_SIZE_DEFAULT),
                  child: ListView.builder(
                    physics: const BouncingScrollPhysics(),
                    itemCount: controller.purposeList.length,
                    scrollDirection: Axis.horizontal,
                    itemBuilder: (context, index) {
                      return Stack(
                        children: [
                          PurposeItem(
                              onTap: () => controller.itemSelect(index: index),
                              image: controller.purposeList[index].logo,
                              title: controller.purposeList[index].title,
                              color: HexColor(
                                  controller.purposeList[index].color)),
                          Visibility(
                              visible: controller.selectedItem == index
                                  ? true
                                  : false,
                              child: Positioned(
                                  top: Dimensions.PADDING_SIZE_DEFAULT,
                                  right: Dimensions.PADDING_SIZE_DEFAULT,
                                  child: Image.asset(Images.on_select,
                                      height: 12, width: 12)))
                        ],
                      );
                    },
                  ),
                );
        })
      ],
    );
  }
}
