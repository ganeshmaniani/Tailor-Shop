import 'dart:convert';
import 'dart:developer';

import 'package:http/http.dart' as http;
import 'package:http/http.dart';
import 'package:tailor_shop/model/booking_detail/booking_detail_model.dart';

import '../../core/core.dart';

class ViewDetailsRepository {
  Future<BookingDetailsModel?> getBookingDetails(int id) async {
    try {
      Response response =
          await http.get(Uri.parse("${AppUrl.viewDetailEndPoint}?id=$id"));
      log(response.body);
      if (response.statusCode == 200 || response.statusCode == 201) {
        final jsonDecodeResponse = jsonDecode(response.body);
        if (jsonDecodeResponse != null) {
          BookingDetailsModel bookingDetailsModel =
              BookingDetailsModel.fromJson(jsonDecodeResponse);
          // Bookings? bookings = bookingDetailsModel.bookings;

          return bookingDetailsModel;
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
