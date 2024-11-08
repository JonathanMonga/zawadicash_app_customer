import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:zawadicash_app/helper/functions.dart';
import 'package:zawadicash_app/helper/price_converter.dart';
import 'package:zawadicash_app/util/color_resources.dart';
import 'package:zawadicash_app/util/dimensions.dart';
import 'package:zawadicash_app/util/images.dart';
import 'package:zawadicash_app/util/styles.dart';

class ShowAmountView extends StatelessWidget {
  const ShowAmountView(
      {Key? key, required this.amountText, required this.onTap})
      : super(key: key);
  final String amountText;
  final OnTapFunction onTap;
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding:
          const EdgeInsets.symmetric(horizontal: Dimensions.PADDING_SIZE_LARGE),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(
                vertical: Dimensions.PADDING_SIZE_DEFAULT),
            child: Text('amount_in_bdt'.tr,
                style: rubikMedium.copyWith(
                    fontSize: Dimensions.FONT_SIZE_LARGE,
                    color: ColorResources.getGreyBaseGray1())),
          ),
          Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(PriceConverter.balanceWithSymbol(balance: amountText),
                    style: rubikMedium.copyWith(
                        fontSize: Dimensions.FONT_SIZE_LARGE)),
                InkWell(
                    onTap: onTap,
                    child: Image.asset(Images.edit_icon,
                        height: Dimensions.RADIUS_SIZE_EXTRA_LARGE,
                        width: Dimensions.RADIUS_SIZE_EXTRA_LARGE))
              ])
        ],
      ),
    );
  }
}
