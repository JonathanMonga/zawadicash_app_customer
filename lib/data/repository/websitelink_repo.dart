import 'package:get/get_connect/http/src/response/response.dart';
import 'package:zawadicash_app/data/api/api_client.dart';
import 'package:zawadicash_app/util/app_constants.dart';

class WebsiteLinkRepo{
  final ApiClient apiClient;

  WebsiteLinkRepo({required this.apiClient});

  Future<Response> getWebsiteListApi() async {
    return await apiClient.getData(AppConstants.CUSTOMER_LINKED_WEBSITE);
  }
}