import 'dart:convert';
import 'dart:developer';

import 'package:http/http.dart' as http;
import 'package:http/http.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tailor_shop/model/booking_status/booking_status_model.dart';

import '../../core/core.dart';
import '../../entities/booking_status_update/booking_status_update_entity.dart';
import '../../model/booking_list_model/booking_list_model.dart';

class ViewListRepository {
  Future<List<BookingStatus>?> getBookingStatus() async {
    try {
      Response response =
          await http.get(Uri.parse(AppUrl.bookingStatusEndPoint));
      log(response.body);
      if (response.statusCode == 200 || response.statusCode == 201) {
        final jsonDecodeResponse = jsonDecode(response.body);
        if (jsonDecodeResponse != null) {
          BookingStatusModel bookingStatusModel =
              BookingStatusModel.fromJson(jsonDecodeResponse);
          List<BookingStatus> bookStatusList =
              bookingStatusModel.bookingStatus ?? [];

          return bookStatusList;
        } else {
          return null;
        }
      }
    } catch (e) {
      throw Exception(e.toString());
    }
    return null;
  }

  Future<List<BookingsList>?> getBookingList() async {
    try {
      Response response = await http.get(Uri.parse(AppUrl.viewListEndPoint));
      log(response.body);
      if (response.statusCode == 200 || response.statusCode == 201) {
        final jsonDecodeResponse = jsonDecode(response.body);
        if (jsonDecodeResponse != null) {
          BookingListModel bookingListModel =
              BookingListModel.fromJson(jsonDecodeResponse);
          List<BookingsList> bookingsList = bookingListModel.bookingsList ?? [];

          return bookingsList;
        } else {
          return null;
        }
      }
    } catch (e) {
      throw Exception(e.toString());
    }
    return null;
  }

  Future<bool> bookingStatusUpdate(
      BookingStatusUpdateEntity bookingStatusUpdateEntity) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    int? userId = prefs.getInt('user_id');
    try {
      Map<String, dynamic> body = {
        'booking_type': bookingStatusUpdateEntity.bookingType,
        'id': bookingStatusUpdateEntity.bookingId,
        'booking_images': bookingStatusUpdateEntity.images,
        'delivery_amount': bookingStatusUpdateEntity.deliveryAmount,
        'expected_delivery_date':
            bookingStatusUpdateEntity.expectedDeliveryDateTime.toString(),
        'status_update_comment': bookingStatusUpdateEntity.statusUpdateComments
      };
      Response response = await http.post(
          Uri.parse("${AppUrl.bookingStatusUpdateEndPoint}?id=$userId"),
          body: jsonEncode(body),
          headers: {"Content-Type": "application/json"});
      log(response.body);
      if (response.statusCode == 200 || response.statusCode == 201) {
        final jsonDecodeResponse = jsonDecode(response.body);
        if (jsonDecodeResponse['Api_success'] == true) {
          return true;
        } else {
          return false;
        }
      } else {
        throw Exception('Invalid creaditial');
      }
    } catch (e) {
      log(e.toString());
      return false;
    }
  }

  Future<List<BookingsList>?> getBookingStatusByList(int id) async {
    try {
      Response response = await http.get(
          Uri.parse("${AppUrl.bookingListPendingEndPoint}?booking_type=$id"));
      log(response.body);
      if (response.statusCode == 200 || response.statusCode == 201) {
        final jsonDecodeResponse = jsonDecode(response.body);
        if (jsonDecodeResponse != null) {
          BookingListModel bookingListModel =
              BookingListModel.fromJson(jsonDecodeResponse);
          List<BookingsList> bookingsList = bookingListModel.bookingsList ?? [];

          return bookingsList;
        } else {
          return null;
        }
      }
    } catch (e) {
      throw Exception(e.toString());
    }
    return null;
  }
}
