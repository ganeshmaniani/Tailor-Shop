class BookingDetailsModel {
  Bookings? bookings;
  bool? apiSuccess;
  String? apiMessage;

  BookingDetailsModel({this.bookings, this.apiSuccess, this.apiMessage});

  BookingDetailsModel.fromJson(Map<String, dynamic> json) {
    bookings =
        json['bookings'] != null ? Bookings.fromJson(json['bookings']) : null;
    apiSuccess = json['Api_success'];
    apiMessage = json['Api_message'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (bookings != null) {
      data['bookings'] = bookings!.toJson();
    }
    data['Api_success'] = apiSuccess;
    data['Api_message'] = apiMessage;
    return data;
  }
}

class Bookings {
  int? id;
  String? customerName;
  int? serviceTypeId;
  String? serviceTypeName;
  int? bookingType;
  String? bookingTypeName;
  String? mobileNumber;
  String? alternateMobileNumber;
  String? age;
  String? gender;
  String? measurements;
  String? deliveryDate;
  String? address;
  String? comments;
  String? statusUpdateComment;
  String? totalAmount;
  String? advanceAmount;
  String? balanceAmount;
  String? deliveryAmount;
  String? expectedDeliveryDate;
  String? bookingImages;
  String? createdBy;
  String? createdAt;
  String? updatedBy;
  String? updatedAt;

  Bookings(
      {this.id,
      this.customerName,
      this.serviceTypeId,
      this.serviceTypeName,
      this.bookingType,
      this.bookingTypeName,
      this.mobileNumber,
      this.alternateMobileNumber,
      this.age,
      this.gender,
      this.measurements,
      this.deliveryDate,
      this.address,
      this.comments,
      this.statusUpdateComment,
      this.totalAmount,
      this.advanceAmount,
      this.balanceAmount,
      this.deliveryAmount,
      this.expectedDeliveryDate,
      this.bookingImages,
      this.createdBy,
      this.createdAt,
      this.updatedBy,
      this.updatedAt});

  Bookings.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    customerName = json['customer_name'];
    serviceTypeId = json['service_type_id'];
    serviceTypeName = json['service_type_name'];
    bookingType = json['booking_type'];
    bookingTypeName = json['booking_type_name'];
    mobileNumber = json['mobile_number'];
    alternateMobileNumber = json['alternate_mobile_number'];
    age = json['age'];
    gender = json['gender'];
    measurements = json['measurements'];
    deliveryDate = json['delivery_date'];
    address = json['address'];
    comments = json['comments'];
    statusUpdateComment = json['status_update_comment'];
    totalAmount = json['total_amount'];
    advanceAmount = json['advance_amount'];
    balanceAmount = json['balance_amount'];
    deliveryAmount = json['delivery_amount'];
    expectedDeliveryDate = json['expected_delivery_date'];
    bookingImages = json['booking_images'];
    createdBy = json['created_by'];
    createdAt = json['created_at'];
    updatedBy = json['updated_by'];
    updatedAt = json['updated_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['customer_name'] = customerName;
    data['service_type_id'] = serviceTypeId;
    data['service_type_name'] = serviceTypeName;
    data['booking_type'] = bookingType;
    data['booking_type_name'] = bookingTypeName;
    data['mobile_number'] = mobileNumber;
    data['alternate_mobile_number'] = alternateMobileNumber;
    data['age'] = age;
    data['gender'] = gender;
    data['measurements'] = measurements;
    data['delivery_date'] = deliveryDate;
    data['address'] = address;
    data['comments'] = comments;
    data['status_update_comment'] = statusUpdateComment;
    data['total_amount'] = totalAmount;
    data['advance_amount'] = advanceAmount;
    data['balance_amount'] = balanceAmount;
    data['delivery_amount'] = deliveryAmount;
    data['expected_delivery_date'] = expectedDeliveryDate;
    data['booking_images'] = bookingImages;
    data['created_by'] = createdBy;
    data['created_at'] = createdAt;
    data['updated_by'] = updatedBy;
    data['updated_at'] = updatedAt;
    return data;
  }
}
