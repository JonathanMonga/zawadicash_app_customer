// ignore_for_file: use_build_context_synchronously, no_leading_underscores_for_local_identifiers

import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:zawadicash_app/data/api/api_checker.dart';
import 'package:zawadicash_app/data/model/response/requested_money_model.dart';
import 'package:zawadicash_app/data/model/withdraw_history_model.dart';
import 'package:zawadicash_app/data/repository/requested_money_repo.dart';
import 'package:zawadicash_app/util/app_constants.dart';
import 'package:zawadicash_app/view/base/custom_snackbar.dart';

class RequestedMoneyController extends GetxController implements GetxService {
  final RequestedMoneyRepo requestedMoneyRepo;

  RequestedMoneyController({required this.requestedMoneyRepo});

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  List<RequestedMoney> _requestedMoneyList = [];
  List<RequestedMoney> _ownRequestList = [];

  List<RequestedMoney> get requestedMoneyList => _requestedMoneyList;
  List<RequestedMoney> get ownRequestList => _ownRequestList;

  List<RequestedMoney> _pendingRequestedMoneyList = [];
  List<RequestedMoney> _ownPendingRequestedMoneyList = [];

  List<RequestedMoney> get pendingRequestedMoneyList =>
      _pendingRequestedMoneyList;
  List<RequestedMoney> get ownPendingRequestedMoneyList =>
      _ownPendingRequestedMoneyList;

  List<RequestedMoney> _acceptedRequestedMoneyList = [];
  List<RequestedMoney> _ownAcceptedRequestedMoneyList = [];

  List<RequestedMoney> get acceptedRequestedMoneyList =>
      _acceptedRequestedMoneyList;
  List<RequestedMoney> get ownAcceptedRequestedMoneyList =>
      _ownAcceptedRequestedMoneyList;

  List<RequestedMoney> _deniedRequestedMoneyList = [];
  List<RequestedMoney> _ownDeniedRequestedMoneyList = [];

  List<RequestedMoney> get deniedRequestedMoneyList =>
      _deniedRequestedMoneyList;
  List<RequestedMoney> get ownDeniedRequestedMoneyList =>
      _ownDeniedRequestedMoneyList;

  WithdrawHistoryModel? _withdrawHistoryModel;
  WithdrawHistoryModel get withdrawHistoryModel => _withdrawHistoryModel!;

  List<WithdrawHistory> pendingWithdraw = [];
  List<WithdrawHistory> acceptedWithdraw = [];
  List<WithdrawHistory> deniedWithdraw = [];
  List<WithdrawHistory> allWithdraw = [];

  final int _offset = 1;
  int? _pageSize;
  List<int> _offsetList = [];
  int get offset => _offset;
  List<int> get offsetList => _offsetList;
  int get pageSize => _pageSize!;
  Future getRequestedMoneyList(int offset, {bool reload = false}) async {
    if (reload) {
      _offsetList = [];
      _requestedMoneyList = [];
      _pendingRequestedMoneyList = [];
      _acceptedRequestedMoneyList = [];
      _deniedRequestedMoneyList = [];
    }
    Response response = await requestedMoneyRepo.getRequestedMoneyList();
    if (response.body['requested_money'] != null &&
        response.body['requested_money'] != {} &&
        response.statusCode == 200) {
      debugPrint('body req : ${response.body['requested_money']}');
      _requestedMoneyList = [];
      _pendingRequestedMoneyList = [];
      _acceptedRequestedMoneyList = [];
      _deniedRequestedMoneyList = [];
      response.body['requested_money'].forEach((requested) {
        RequestedMoney req = RequestedMoney.fromJson(requested);
        if (req.type == AppConstants.APPROVED) {
          _acceptedRequestedMoneyList.add(req);
        } else if (req.type == AppConstants.PENDING) {
          _pendingRequestedMoneyList.add(req);
        } else if (req.type == AppConstants.DENIED) {
          _deniedRequestedMoneyList.add(req);
        }
        _requestedMoneyList.add(req);
      });

      _isLoading = false;
      update();
    } else {
      ApiChecker.checkApi(response);
      _isLoading = false;
      update();
    }
  }

  Future getOwnRequestedMoneyList(int offset, {bool reload = false}) async {
    debugPrint('own request api call');
    if (reload) {
      _offsetList = [];
      _ownRequestList = [];
      _ownPendingRequestedMoneyList = [];
      _ownAcceptedRequestedMoneyList = [];
      _ownDeniedRequestedMoneyList = [];
    }
    Response response = await requestedMoneyRepo.getOwnRequestedMoneyList();

    if (response.body['requested_money'] != null &&
        response.body['requested_money'] != {} &&
        response.statusCode == 200) {
      debugPrint('own request : ${response.body['requested_money']}');
      _ownRequestList = [];
      _ownPendingRequestedMoneyList = [];
      _ownAcceptedRequestedMoneyList = [];
      _ownDeniedRequestedMoneyList = [];
      response.body['requested_money'].forEach((requested) {
        RequestedMoney req = RequestedMoney.fromJson(requested);
        ownRequestList.add(req);
        if (req.type == AppConstants.APPROVED) {
          _ownAcceptedRequestedMoneyList.add(req);
        } else if (req.type == AppConstants.PENDING) {
          _ownPendingRequestedMoneyList.add(req);
        } else if (req.type == AppConstants.DENIED) {
          _ownDeniedRequestedMoneyList.add(req);
        }
      });
      _isLoading = false;
      update();
    } else {
      ApiChecker.checkApi(response);
      _isLoading = false;
      update();
    }
  }

  Future<void> acceptRequest(
      BuildContext context, int requestId, String pin) async {
    _isLoading = true;
    update();
    Response response =
        await requestedMoneyRepo.approveRequestedMoney(requestId, pin);
    debugPrint(response.status.toString());

    if (response.statusCode == 200) {
      getRequestedMoneyList(offset);
      Get.back();
      Navigator.pop(context);
      _isLoading = false;
    } else {
      _isLoading = false;
      ApiChecker.checkApi(response);
    }
    update();
  }

  Future<void> denyRequest(
      BuildContext context, int requestId, String pin) async {
    _isLoading = true;
    update();
    Response response =
        await requestedMoneyRepo.denyRequestedMoney(requestId, pin);
    if (response.statusCode == 200) {
      getRequestedMoneyList(offset);
      showCustomSnackBar('request_denied_successfully'.tr, isError: false);
      Get.back();
      Navigator.pop(context);
      _isLoading = false;
    } else {
      _isLoading = false;
      ApiChecker.checkApi(response);
    }
    update();
  }

  int _requestTypeIndex = 0;
  int get requestTypeIndex => _requestTypeIndex;

  void setIndex(int index, {bool isUpdate = true}) {
    _requestTypeIndex = index;
    if (isUpdate) {
      update();
    }
  }

  void showBottomLoader() {
    _isLoading = true;
    update();
  }

  Future getWithdrawHistoryList({bool reload = false}) async {
    if (reload) {
      _withdrawHistoryModel = null;
    }

    if (_withdrawHistoryModel == null) {
      Response response = await requestedMoneyRepo.getWithdrawRequest();
      debugPrint('withdraw data : ${response.body}');
      if (response.body['response_code'] == 'default_200' &&
          response.body['content'] != null) {
        pendingWithdraw = [];
        acceptedWithdraw = [];
        deniedWithdraw = [];
        allWithdraw = [];

        _withdrawHistoryModel = WithdrawHistoryModel.fromJson(response.body);
        debugPrint(
            'withdraw list : ${_withdrawHistoryModel!.withdrawHistoryList.length}');
        for (var _withdrawHistory
            in _withdrawHistoryModel!.withdrawHistoryList) {
          pendingWithdraw.addIf(
              _withdrawHistory.requestStatus == AppConstants.PENDING,
              _withdrawHistory);
          acceptedWithdraw.addIf(
              _withdrawHistory.requestStatus == AppConstants.APPROVED,
              _withdrawHistory);
          deniedWithdraw.addIf(
              _withdrawHistory.requestStatus == AppConstants.DENIED,
              _withdrawHistory);
          allWithdraw.add(_withdrawHistory);
        }
        debugPrint('${pendingWithdraw.length}');
      } else {
        ApiChecker.checkApi(response);
      }
    }
    _isLoading = false;
    update();
  }
}
