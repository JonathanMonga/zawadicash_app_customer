import 'package:flutter/material.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_instance/src/extension_instance.dart';
import 'package:zawadicash_app/controller/profile_screen_controller.dart';
import 'package:zawadicash_app/controller/splash_controller.dart';
import 'package:zawadicash_app/util/get_class_name.dart';

class PriceConverter {
  static String convertPrice(double price,
      {double? discount, String? discountType}) {
    if (discount != null && discountType != null) {
      if (discountType == 'amount') {
        price = price - discount;
      } else if (discountType == 'percent') {
        price = price - ((discount / 100) * price);
      }
    }
    return '${Get.find<SplashController>(tag: getClassName<SplashController>()).configModel.currencySymbol}${(price).toStringAsFixed(2).replaceAllMapped(RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (Match m) => '${m[1]},')}';
  }

  static double convertWithDiscount(BuildContext context, double price,
      double discount, String discountType) {
    if (discountType == 'amount') {
      price = price - discount;
    } else if (discountType == 'percent') {
      price = price - ((discount / 100) * price);
    }
    return price;
  }

  static double calculation(
      double amount, double discount, String type, int quantity) {
    double calculatedAmount = 0;
    if (type == 'amount') {
      calculatedAmount = discount * quantity;
    } else if (type == 'percent') {
      calculatedAmount = (discount / 100) * (amount * quantity);
    }
    return calculatedAmount;
  }

  static String percentageCalculation(BuildContext context, String price,
      String discount, String discountType) {
    return '$discount${discountType == 'percent' ? '%' : '\$'} OFF';
  }

  static double withCashOutCharge(double amount) {
    return (amount *
                Get.find<SplashController>(tag: getClassName<SplashController>())
                    .configModel
                    .cashOutChargePercent!) /
            100 +
        amount;
  }

  static double withSendMoneyCharge(double amount) {
    return amount +
        Get.find<SplashController>(tag: getClassName<SplashController>()).configModel.sendMoneyChargeFlat!;
  }

  static String availableBalance() {
    String currencySymbol =
        Get.find<SplashController>(tag: getClassName<SplashController>()).configModel.currencySymbol!;
    String currentBalance =
        Get.find<ProfileController>(tag: getClassName<ProfileController>()).userInfo!.balance!.toStringAsFixed(2);
    return Get.find<SplashController>(tag: getClassName<SplashController>()).configModel.currencyPosition == 'left'
        ? '$currencySymbol$currentBalance'
        : '$currentBalance$currencySymbol';
  }

  static String newBalanceWithDebit(
      {required double inputBalance, required double charge}) {
    debugPrint(
        'user balance = ${Get.find<ProfileController>(tag: getClassName<ProfileController>()).userInfo!.phone}');
    String currencySymbol =
        Get.find<SplashController>(tag: getClassName<SplashController>()).configModel.currencySymbol!;
    String currentBalance = (Get.find<ProfileController>(tag: getClassName<ProfileController>()).userInfo!.balance! -
            (inputBalance + charge))
        .toStringAsFixed(2);
    return Get.find<SplashController>(tag: getClassName<SplashController>()).configModel.currencyPosition == 'left'
        ? '$currencySymbol$currentBalance'
        : '$currentBalance$currencySymbol';
  }

  static String newBalanceWithCredit({required double inputBalance}) {
    String currencySymbol =
        Get.find<SplashController>(tag: getClassName<SplashController>()).configModel.currencySymbol!;
    String currentBalance =
        (Get.find<ProfileController>(tag: getClassName<ProfileController>()).userInfo!.balance! + inputBalance)
            .toStringAsFixed(2);
    return Get.find<SplashController>(tag: getClassName<SplashController>()).configModel.currencyPosition == 'left'
        ? '$currencySymbol$currentBalance'
        : '$currentBalance$currencySymbol';
  }

  static String balanceInputHint() {
    String currencySymbol =
        Get.find<SplashController>(tag: getClassName<SplashController>()).configModel.currencySymbol!;
    String balance = '0';
    return Get.find<SplashController>(tag: getClassName<SplashController>()).configModel.currencyPosition == 'left'
        ? '$currencySymbol$balance'
        : '$balance$currencySymbol';
  }

  static String balanceWithSymbol({String? balance}) {
    String currencySymbol =
        Get.find<SplashController>(tag: getClassName<SplashController>()).configModel.currencySymbol!;
    return Get.find<SplashController>(tag: getClassName<SplashController>()).configModel.currencyPosition == 'left'
        ? '$currencySymbol$balance'
        : '$balance$currencySymbol';
  }
}
