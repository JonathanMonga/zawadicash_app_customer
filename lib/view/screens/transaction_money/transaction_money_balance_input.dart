// ignore_for_file: no_leading_underscores_for_local_identifiers

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:zawadicash_app/controller/add_money_controller.dart';
import 'package:zawadicash_app/controller/profile_screen_controller.dart';
import 'package:zawadicash_app/controller/splash_controller.dart';
import 'package:zawadicash_app/controller/transaction_controller.dart';
import 'package:zawadicash_app/data/model/purpose_models.dart';
import 'package:zawadicash_app/data/model/response/contact_model.dart';
import 'package:zawadicash_app/data/model/withdraw_model.dart';
import 'package:zawadicash_app/helper/email_checker.dart';
import 'package:zawadicash_app/helper/price_converter.dart';
import 'package:zawadicash_app/helper/transaction_type.dart';
import 'package:zawadicash_app/util/color_resources.dart';
import 'package:zawadicash_app/util/dimensions.dart';
import 'package:zawadicash_app/util/get_class_name.dart';
import 'package:zawadicash_app/util/styles.dart';
import 'package:zawadicash_app/view/base/custom_app_bar.dart';
import 'package:zawadicash_app/view/base/custom_loader.dart';
import 'package:zawadicash_app/view/base/custom_snackbar.dart';
import 'package:zawadicash_app/view/screens/transaction_money/transaction_money_confirmation.dart';
import 'package:zawadicash_app/view/screens/transaction_money/widget/field_item_view.dart';
import 'package:zawadicash_app/view/screens/transaction_money/widget/for_person_widget.dart';
import 'package:zawadicash_app/view/screens/transaction_money/widget/input_box_view.dart';
import 'package:zawadicash_app/view/screens/transaction_money/widget/purpose_widget.dart';

class TransactionMoneyBalanceInput extends StatefulWidget {
  final String? transactionType;
  final ContactModel? contactModel;
  final String? countryCode;

  const TransactionMoneyBalanceInput(
      {Key? key, this.transactionType, this.contactModel, this.countryCode})
      : super(key: key);
  @override
  State<TransactionMoneyBalanceInput> createState() =>
      _TransactionMoneyBalanceInputState();
}

class _TransactionMoneyBalanceInputState
    extends State<TransactionMoneyBalanceInput> {
  static final TextEditingController _inputAmountController =
      TextEditingController();
  String? _selectedMethodId;
  List<MethodField>? _fieldList;
  List<MethodField>? _gridFieldList;
  Map<String, TextEditingController> _textControllers = {};
  Map<String, TextEditingController> _gridTextController = {};
  final FocusNode _inputAmountFocusNode = FocusNode();

  void setFocus() {
    _inputAmountFocusNode.requestFocus();
    Get.back();
  }

  @override
  void initState() {
    super.initState();
    if (widget.transactionType == TransactionType.WITHDRAW_REQUEST) {
      Get.find<TransactionMoneyController>(tag: getClassName<TransactionMoneyController>()).getWithdrawMethods();
    }
  }

  @override
  Widget build(BuildContext context) {
    final ProfileController profileController = Get.find<ProfileController>(tag: getClassName<ProfileController>());
    final SplashController splashController = Get.find<SplashController>(tag: getClassName<SplashController>());
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
          appBar: CustomAppbar(title: widget.transactionType!.tr),
          body: GetBuilder<TransactionMoneyController>(
              init: Get.find<TransactionMoneyController>(tag: getClassName<TransactionMoneyController>()),
              tag: getClassName<TransactionMoneyController>(),
              builder: (transactionMoneyController) {
            if (widget.transactionType == TransactionType.WITHDRAW_REQUEST &&
                transactionMoneyController.withdrawModel == null) {
              return CustomLoader(color: Theme.of(context).primaryColor);
            }
            return SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (widget.transactionType != TransactionType.ADD_MONEY &&
                      widget.transactionType !=
                          TransactionType.WITHDRAW_REQUEST)
                    ForPersonWidget(contactModel: widget.contactModel!),
                  if (widget.transactionType ==
                      TransactionType.WITHDRAW_REQUEST)
                    Padding(
                      padding: const EdgeInsets.symmetric(
                        vertical: Dimensions.PADDING_SIZE_DEFAULT,
                        horizontal: Dimensions.PADDING_SIZE_SMALL,
                      ),
                      child: Column(
                        children: [
                          Container(
                            height: context.height * 0.05,
                            padding: const EdgeInsets.symmetric(
                                horizontal: Dimensions.PADDING_SIZE_DEFAULT),
                            decoration: BoxDecoration(
                              color: Theme.of(context).cardColor,
                              borderRadius: BorderRadius.circular(
                                  Dimensions.RADIUS_SIZE_SMALL),
                              border: Border.all(
                                  color: Theme.of(context)
                                      .primaryColor
                                      .withOpacity(0.4)),
                            ),
                            child: DropdownButton<String>(
                              menuMaxHeight: Get.height * 0.5,
                              hint: Text(
                                'select_a_method'.tr,
                                style: rubikRegular.copyWith(
                                    fontSize: Dimensions.FONT_SIZE_SMALL),
                              ),
                              value: _selectedMethodId,
                              items: transactionMoneyController
                                  .withdrawModel!.withdrawalMethods
                                  .map((withdraw) => DropdownMenuItem<String>(
                                        value: withdraw.id.toString(),
                                        child: Text(
                                          withdraw.methodName ?? 'no method',
                                          style: rubikRegular.copyWith(
                                              fontSize:
                                                  Dimensions.FONT_SIZE_SMALL),
                                        ),
                                      ))
                                  .toList(),
                              onChanged: (id) {
                                _selectedMethodId = id!;
                                _gridFieldList = [];
                                _fieldList = [];

                                for (var _method in transactionMoneyController
                                    .withdrawModel!.withdrawalMethods
                                    .firstWhere((method) =>
                                        method.id.toString() == id)
                                    .methodFields!) {
                                  _gridFieldList!.addIf(
                                      _method.inputName!.contains('cvv') ||
                                          _method.inputType == 'date',
                                      _method);
                                }

                                for (var _method in transactionMoneyController
                                    .withdrawModel!.withdrawalMethods
                                    .firstWhere((method) =>
                                        method.id.toString() == id)
                                    .methodFields!) {
                                  _fieldList!.addIf(
                                      !_method.inputName!.contains('cvv') &&
                                          _method.inputType != 'date',
                                      _method);
                                }

                                _textControllers = _textControllers =
                                    <String, TextEditingController>{};
                                _gridTextController = _gridTextController =
                                    <String, TextEditingController>{};

                                for (var _method in _fieldList!) {
                                  _textControllers[_method.inputName!] =
                                      TextEditingController();
                                }
                                for (var _method in _gridFieldList!) {
                                  _gridTextController[_method.inputName!] =
                                      TextEditingController();
                                }

                                transactionMoneyController.update();
                              },
                              isExpanded: true,
                              underline: const SizedBox(),
                            ),
                          ),
                          const SizedBox(
                              height: Dimensions.PADDING_SIZE_DEFAULT),
                          if (_fieldList != null && _fieldList!.isNotEmpty)
                            ListView.builder(
                              shrinkWrap: true,
                              physics: const NeverScrollableScrollPhysics(),
                              itemCount: _fieldList!.length,
                              padding: const EdgeInsets.symmetric(
                                vertical: Dimensions.PADDING_SIZE_EXTRA_SMALL,
                                horizontal: 10,
                              ),
                              itemBuilder: (context, index) => FieldItemView(
                                methodField: _fieldList![index],
                                textControllers: _textControllers,
                              ),
                            ),
                          if (_gridFieldList != null &&
                                  _gridFieldList!.isNotEmpty)
                                GridView.builder(
                                  padding: const EdgeInsets.symmetric(
                                    vertical:
                                        Dimensions.PADDING_SIZE_EXTRA_SMALL,
                                    horizontal: 10,
                                  ),
                                  shrinkWrap: true,
                                  physics: const NeverScrollableScrollPhysics(),
                                  gridDelegate:
                                      const SliverGridDelegateWithFixedCrossAxisCount(
                                    crossAxisCount: 2,
                                    childAspectRatio: 2,
                                crossAxisSpacing: 20,
                                mainAxisSpacing: 20,
                              ),
                              itemCount: _gridFieldList!.length,
                              itemBuilder: (context, index) => FieldItemView(
                                methodField: _gridFieldList![index],
                                textControllers: _gridTextController,
                              ),
                            ),
                        ],
                      ),
                    ),
                  InputBoxView(
                    inputAmountController: _inputAmountController,
                    focusNode: _inputAmountFocusNode,
                    transactionType: widget.transactionType!,
                  ),
                  if (widget.transactionType == TransactionType.CASH_OUT)
                    Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: Dimensions.PADDING_SIZE_LARGE,
                        vertical: Dimensions.PADDING_SIZE_DEFAULT,
                      ),
                      child: Row(
                        children: [
                          Text(
                            'save_future_cash_out'.tr,
                            style: rubikRegular.copyWith(
                                fontSize: Dimensions.FONT_SIZE_LARGE),
                          ),
                          const Spacer(),
                          Padding(
                            padding: EdgeInsets.zero,
                            child: CupertinoSwitch(
                              value: transactionMoneyController.isFutureSave,
                              onChanged: transactionMoneyController
                                  .cupertinoSwitchOnChange,
                            ),
                          ),
                        ],
                      ),
                    ),
                  widget.transactionType == TransactionType.SEND_MONEY &&
                          transactionMoneyController.purposeList.isNotEmpty
                      ? MediaQuery.of(context).viewInsets.bottom > 10
                          ? Container(
                              color: Colors.white.withOpacity(0.92),
                              padding: const EdgeInsets.symmetric(
                                horizontal: Dimensions.PADDING_SIZE_LARGE,
                                vertical: Dimensions.PADDING_SIZE_SMALL,
                              ),
                              child: Row(
                                children: [
                                  transactionMoneyController.purposeList.isEmpty
                                      ? Center(
                                          child: CircularProgressIndicator(
                                          color: Theme.of(context)
                                              .textTheme
                                              .titleLarge!
                                              .color,
                                        ))
                                      : const SizedBox(),
                                  const SizedBox(
                                      width: Dimensions.PADDING_SIZE_SMALL),
                                  Text('change_purpose'.tr,
                                      style: rubikRegular.copyWith(
                                        fontSize: Dimensions.FONT_SIZE_LARGE,
                                      ))
                                ],
                              ),
                            )
                          : const PurposeWidget()
                      : const SizedBox(),
                ],
              ),
            );
          }),
          floatingActionButton: GetBuilder<TransactionMoneyController>(
              init: Get.find<TransactionMoneyController>(tag: getClassName<TransactionMoneyController>()),
              tag: getClassName<TransactionMoneyController>(),
              builder: (transactionMoneyController) {
            return FloatingActionButton(
              onPressed: () {
                double amount;
                if (_inputAmountController.text.isEmpty) {
                  showCustomSnackBar('please_input_amount'.tr, isError: true);
                } else {
                  String balance = _inputAmountController.text;
                  if (balance
                      .contains(splashController.configModel.currencySymbol!)) {
                    balance = balance.replaceAll(
                        splashController.configModel.currencySymbol!, '');
                  }
                  if (balance.contains(',')) {
                    balance = balance.replaceAll(',', '');
                  }
                  if (balance.contains(' ')) {
                    balance = balance.replaceAll(' ', '');
                  }
                  amount = double.parse(balance);
                  if (amount == 0) {
                    showCustomSnackBar('transaction_amount_must_be'.tr,
                        isError: true);
                  } else {
                    bool inSufficientBalance = false;

                    final bool isCheck = widget.transactionType !=
                            TransactionType.REQUEST_MONEY &&
                        widget.transactionType != TransactionType.ADD_MONEY;

                    if (isCheck &&
                        widget.transactionType == TransactionType.SEND_MONEY) {
                      inSufficientBalance =
                          PriceConverter.withSendMoneyCharge(amount) >
                              profileController.userInfo!.balance!;
                    } else if (isCheck &&
                        widget.transactionType == TransactionType.CASH_OUT) {
                      inSufficientBalance =
                          PriceConverter.withCashOutCharge(amount) >
                              profileController.userInfo!.balance!;
                    } else if (isCheck) {
                      inSufficientBalance =
                          amount > profileController.userInfo!.balance!;
                    }

                        if (inSufficientBalance) {
                          showCustomSnackBar('insufficient_balance'.tr,
                              isError: true);
                        } else {
                          _confirmationRoute(amount);
                        }
                      }
                    }
                  },
                  backgroundColor: Theme.of(context).secondaryHeaderColor,
                  child: Icon(Icons.arrow_forward,
                      color: ColorResources.blackColor),
                );
          })),
    );
  }

  void _confirmationRoute(double amount) {
    final transactionMoneyController = Get.find<TransactionMoneyController>(tag: getClassName<TransactionMoneyController>());
    if (widget.transactionType == 'add_money') {
      Get.find<AddMoneyController>(tag: getClassName<AddMoneyController>()).addMoney(context, amount.toString());
    } else if (widget.transactionType == TransactionType.WITHDRAW_REQUEST) {
      late String message;
      WithdrawalMethod withdrawMethod = transactionMoneyController
          .withdrawModel!.withdrawalMethods
          .firstWhere((method) => _selectedMethodId == method.id.toString());

      List<MethodField> list = [];
      late String validationKey;

      for (var _method in withdrawMethod.methodFields!) {
        if (_method.inputType == 'email') {
          validationKey = _method.inputName!;
        }
        if (_method.inputType == 'date') {
          validationKey = _method.inputName!;
        }
      }

      _textControllers.forEach((key, textController) {
        list.add(MethodField(
          inputName: key,
          inputType: null,
          inputValue: textController.text,
          placeHolder: null,
        ));

        if ((validationKey == key) &&
            EmailChecker.isNotValid(textController.text)) {
          message = 'please_provide_valid_email'.tr;
        } else if ((validationKey == key) &&
            textController.text.contains('-')) {
          message = 'please_provide_valid_date'.tr;
        }

        if (textController.text.isEmpty && message.isEmpty) {
          message = 'please fill ${key.replaceAll('_', ' ')} field';
        }
      });

      _gridTextController.forEach((key, textController) {
        list.add(MethodField(
          inputName: key,
          inputType: null,
          inputValue: textController.text,
          placeHolder: null,
        ));

        if ((validationKey == key) && textController.text.contains('-')) {
          message = 'please_provide_valid_date'.tr;
        }
      });

      if (message.isNotEmpty) {
        showCustomSnackBar(message);
      } else {
        Get.to(() => TransactionMoneyConfirmation(
              inputBalance: amount,
              transactionType: TransactionType.WITHDRAW_REQUEST,
              withdrawMethod: WithdrawalMethod(
                methodFields: list,
                methodName: withdrawMethod.methodName,
                id: withdrawMethod.id,
              ),
              callBack: setFocus,
            ));
      }
    } else {
      Get.to(() => TransactionMoneyConfirmation(
            inputBalance: amount,
            transactionType: widget.transactionType!,
            purpose: transactionMoneyController.purposeList.isEmpty
                ? Purpose().title
                : transactionMoneyController
                    .purposeList[transactionMoneyController.selectedItem].title,
            contactModel: widget.contactModel!,
            callBack: setFocus,
          ));
    }
  }
}
