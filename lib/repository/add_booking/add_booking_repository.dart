import 'dart:convert';
import 'dart:developer';

import 'package:http/http.dart' as http;
import 'package:http/http.dart';
import 'package:tailor_shop/entities/add_booking/add_booking_entity.dart';
import 'package:tailor_shop/model/service_type/service_type_model.dart';

import '../../core/core.dart';

class AddBookingRepository {
  Future<List<ServiceTypes>?> getServiceType() async {
    try {
      Response response = await http.get(Uri.parse(AppUrl.serviceTypeEndPoint));

      if (response.statusCode == 200 || response.statusCode == 201) {
        final jsonDecodeResponse = jsonDecode(response.body);
        log(jsonDecodeResponse.toString());

        if (jsonDecodeResponse['Api_success'] == true) {
          ServiceTypeModel serviceTypeModel =
              ServiceTypeModel.fromJson(jsonDecodeResponse);
          List<ServiceTypes> serviceTypeList =
              serviceTypeModel.serviceTypes ?? [];

          return serviceTypeList;
        } else {
          return null;
        }
      }
    } catch (e) {
      throw Exception(e.toString());
    }
    return null;
  }

  Future<bool> bookingSubmit(AddBookingEntity addBookingEntity) async {
    try {
      Map<String, dynamic> body = {
        'customer_name': addBookingEntity.customerName,
        'mobile_number': addBookingEntity.mobileNumber,
        'alternate_mobile_number': addBookingEntity.alternateMobileNumber,
        'age': addBookingEntity.age,
        'booking_type': 1.toString(),
        'measurements': addBookingEntity.measurements,
        'gender': addBookingEntity.gender,
        'service_type_id': addBookingEntity.serviceTypeId.toString(),
        'total_amount': addBookingEntity.totalAmount.toString(),
        'advance_amount': addBookingEntity.advanceAmount.toString(),
        'balance_amount': addBookingEntity.balanceAmount.toString(),
        'delivery_date': addBookingEntity.deliveryDate.toString(),
        'address': addBookingEntity.address,
        'created_at': addBookingEntity.createAt.toString(),
        'booking_images': addBookingEntity.images,
        'comments': addBookingEntity.comments
      };

      Response response = await http.post(
          Uri.parse(AppUrl.bookingSubmitEndPoint),
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

  Future<bool> updateBooking(
      AddBookingEntity addBookingEntity, int id, int bookingType) async {
    try {
      Map<String, dynamic> body = {
        'customer_name': addBookingEntity.customerName,
        'mobile_number': addBookingEntity.mobileNumber,
        'alternate_mobile_number': addBookingEntity.alternateMobileNumber,
        'age': addBookingEntity.age,
        'booking_type': bookingType.toString(),
        'measurements': addBookingEntity.measurements,
        'gender': addBookingEntity.gender,
        'service_type_id': addBookingEntity.serviceTypeId.toString(),
        'total_amount': addBookingEntity.totalAmount.toString(),
        'advance_amount': addBookingEntity.advanceAmount.toString(),
        'balance_amount': addBookingEntity.balanceAmount.toString(),
        'delivery_date': addBookingEntity.deliveryDate.toString(),
        'address': addBookingEntity.address,
        'updated_at': addBookingEntity.createAt.toString(),
        'booking_images': addBookingEntity.images,
        'comments': addBookingEntity.comments
      };

      Response response = await http.post(
          Uri.parse("${AppUrl.bookingSubmitUpdateEndPoint}?id=$id"),
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
        return false;
      }
    } catch (e) {
      log(e.toString());
      return false;
    }
  }
}
