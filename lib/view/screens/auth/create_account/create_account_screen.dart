import 'package:phone_number/phone_number.dart';
import 'package:zawadicash_app/controller/auth_controller.dart';
import 'package:zawadicash_app/controller/create_account_controller.dart';
import 'package:zawadicash_app/controller/splash_controller.dart';
import 'package:zawadicash_app/util/color_resources.dart';
import 'package:zawadicash_app/util/dimensions.dart';
import 'package:zawadicash_app/util/get_class_name.dart';
import 'package:zawadicash_app/util/styles.dart';
import 'package:zawadicash_app/view/base/custom_app_bar.dart';
import 'package:zawadicash_app/view/base/custom_country_code_picker.dart';
import 'package:zawadicash_app/view/base/custom_logo.dart';
import 'package:zawadicash_app/view/base/custom_large_button.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:zawadicash_app/view/base/custom_snackbar.dart';

class CreateAccountScreen extends StatefulWidget {
  const CreateAccountScreen({super.key});

  @override
  State<CreateAccountScreen> createState() => _CreateAccountScreenState();
}

class _CreateAccountScreenState extends State<CreateAccountScreen> {
  final TextEditingController numberFieldController = TextEditingController();

  @override
  void initState() {
    super.initState();
    Get.find<CreateAccountController>(tag: getClassName<CreateAccountController>())
        .setInitCountryCode(Get.find<SplashController>(tag: getClassName<SplashController>()).getCountryCode());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorResources.getWhiteAndBlack(),
      appBar: CustomAppbar(title: 'login_registration'.tr),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                children: [
                  const SizedBox(
                      height: Dimensions.PADDING_SIZE_EXTRA_EXTRA_LARGE),
                  const CustomLogo(
                      height: Dimensions.BIG_LOGO, width: Dimensions.BIG_LOGO),
                  const SizedBox(height: Dimensions.PADDING_SIZE_EXTRA_LARGE),
                  Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: Dimensions.PADDING_SIZE_EXTRA_LARGE),
                    child: Text(
                      'create_account_description'.tr,
                      style: rubikRegular.copyWith(
                        color: Theme.of(context).textTheme.bodyLarge!.color,
                        fontSize: Dimensions.FONT_SIZE_LARGE,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                  const SizedBox(
                    height: Dimensions.PADDING_SIZE_EXTRA_LARGE,
                  ),
                  GetBuilder<CreateAccountController>(
                    init: Get.find<CreateAccountController>(tag: getClassName<CreateAccountController>()),
                    tag: getClassName<CreateAccountController>(),
                    builder: (controller) => Container(
                      height: 52,
                      margin: const EdgeInsets.symmetric(
                          horizontal: Dimensions.PADDING_SIZE_DEFAULT),
                      child: Center(
                        child: TextField(
                          controller: numberFieldController,
                          keyboardType: TextInputType.phone,
                          cursorColor:
                              Theme.of(context).textTheme.titleLarge!.color,
                          decoration: InputDecoration(
                            contentPadding: const EdgeInsets.only(bottom: 5),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(
                                  Dimensions.RADIUS_SIZE_SMALL),
                              borderSide: BorderSide(
                                color: Theme.of(context)
                                    .textTheme
                                    .titleLarge!
                                    .color!,
                                width: 2,
                              ),
                            ),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(
                                  Dimensions.RADIUS_SIZE_SMALL),
                              borderSide: BorderSide(
                                color: ColorResources.textFieldBorderColor,
                                width: 1,
                              ),
                            ),
                            prefixIcon: CustomCountryCodePiker(
                              onInit: (code) {},
                              initSelect: controller.countryCode,
                              onChanged: (code) =>
                                  controller.setCountryCode(code),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          GetBuilder<AuthController>(
            init: Get.find<AuthController>(tag: getClassName<AuthController>()),
            tag: getClassName<AuthController>(),
            builder: (controller) => SizedBox(
              height: 110,
              child: !controller.isLoading
                  ? CustomLargeButton(
                      backgroundColor: Theme.of(context).secondaryHeaderColor,
                      text: 'verify_umber'.tr,
                      onTap: () async {
                        String phoneNumber =
                            '${Get.find<CreateAccountController>(tag: getClassName<CreateAccountController>()).countryCode}${numberFieldController.text}';
                        try {
                          await PhoneNumberUtil().parse(phoneNumber).then(
                              (value) => Get.find<CreateAccountController>(tag: getClassName<CreateAccountController>())
                                  .sendOtpResponse(number: phoneNumber));
                        } catch (e) {
                          showCustomSnackBar(
                              'please_input_your_valid_number'.tr,
                              isError: true);
                          numberFieldController.clear();
                        }
                      },
                    )
                  : Center(
                      child: CircularProgressIndicator(
                          color: Theme.of(context).primaryColor)),
            ),
          ),
        ],
      ),
    );
  }
}
