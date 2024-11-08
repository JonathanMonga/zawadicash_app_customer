import 'package:flutter/material.dart';
import 'package:get/get_utils/src/extensions/internacionalization.dart';
import 'package:zawadicash_app/util/color_resources.dart';
import 'package:zawadicash_app/util/dimensions.dart';
import 'package:zawadicash_app/util/styles.dart';
import 'package:zawadicash_app/view/screens/history/widget/transaction_view_screen.dart';

class CustomExpandableContant extends StatefulWidget {
  const CustomExpandableContant({Key? key}) : super(key: key);

  @override
  State<CustomExpandableContant> createState() =>
      _CustomExpandableContantState();
}

class _CustomExpandableContantState extends State<CustomExpandableContant> {
  final ScrollController scrollController = ScrollController();
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.background,
      ),
      height: MediaQuery.of(context).size.height * 0.7,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            flex: 0,
            child: Container(
              padding: const EdgeInsets.symmetric(
                  horizontal: Dimensions.PADDING_SIZE_LARGE),
              child: Text(
                'all_transaction'.tr,
                style: rubikMedium.copyWith(
                  fontSize: Dimensions.FONT_SIZE_LARGE,
                  color: Theme.of(context).textTheme.titleLarge!.color,
                ),
              ),
            ),
          ),
          const SizedBox(
            height: Dimensions.PADDING_SIZE_DEFAULT,
          ),
          Expanded(
            flex: 10,
            child: Container(
              color: ColorResources.getBackgroundColor(),
              child: SingleChildScrollView(
                  child: TransactionViewScreen(
                      scrollController: scrollController, isHome: true)),
            ),
          ),
        ],
      ),
    );
  }
}
