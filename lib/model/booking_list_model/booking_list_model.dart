class BookingListModel {
  bool? apiSuccess;
  List<BookingsList>? bookingsList;

  BookingListModel({this.apiSuccess, this.bookingsList});

  BookingListModel.fromJson(Map<String, dynamic> json) {
    apiSuccess = json['Api_success'];
    if (json['bookings_list'] != null) {
      bookingsList = <BookingsList>[];
      json['bookings_list'].forEach((v) {
        bookingsList!.add(BookingsList.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['Api_success'] = apiSuccess;
    if (bookingsList != null) {
      data['bookings_list'] = bookingsList!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class BookingsList {
  int? id;
  String? customerName;
  String? bookingTypeName;
  int? bookingType;
  String? mobileNumber;
  String? alternateMobileNumber;
  String? age;
  String? gender;
  String? measurements;
  String? serviceTypeId;
  String? deliveryDate;
  String? address;
  String? comments;
  String? statusUpdateComment;
  String? totalAmount;
  String? advanceAmount;
  String? balanceAmount;
  String? bookingImages;
  String? deliveryAmount;
  String? expectedDeliveryDate;
  String? createdBy;
  String? createdAt;
  String? updatedBy;
  String? updatedAt;

  BookingsList(
      {this.id,
      this.customerName,
      this.bookingTypeName,
      this.bookingType,
      this.mobileNumber,
      this.alternateMobileNumber,
      this.age,
      this.gender,
      this.measurements,
      this.serviceTypeId,
      this.deliveryDate,
      this.address,
      this.comments,
      this.statusUpdateComment,
      this.totalAmount,
      this.advanceAmount,
      this.balanceAmount,
      this.bookingImages,
      this.deliveryAmount,
      this.expectedDeliveryDate,
      this.createdBy,
      this.createdAt,
      this.updatedBy,
      this.updatedAt});

  BookingsList.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    customerName = json['customer_name'];
    bookingTypeName = json['booking_type_name'];
    bookingType = json['booking_type'];
    mobileNumber = json['mobile_number'];
    alternateMobileNumber = json['alternate_mobile_number'];
    age = json['age'];
    gender = json['gender'];
    measurements = json['measurements'];
    serviceTypeId = json['service_type_id'];
    deliveryDate = json['delivery_date'];
    address = json['address'];
    comments = json['comments'];
    statusUpdateComment = json['status_update_comment'];
    totalAmount = json['total_amount'];
    advanceAmount = json['advance_amount'];
    balanceAmount = json['balance_amount'];
    bookingImages = json['booking_images'];
    deliveryAmount = json['delivery_amount'];
    expectedDeliveryDate = json['expected_delivery_date'];
    createdBy = json['created_by'];
    createdAt = json['created_at'];
    updatedBy = json['updated_by'];
    updatedAt = json['updated_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['customer_name'] = customerName;
    data['booking_type_name'] = bookingTypeName;
    data['booking_type'] = bookingType;
    data['mobile_number'] = mobileNumber;
    data['alternate_mobile_number'] = alternateMobileNumber;
    data['age'] = age;
    data['gender'] = gender;
    data['measurements'] = measurements;
    data['service_type_id'] = serviceTypeId;
    data['delivery_amount'] = deliveryAmount;
    data['expected_delivery_date'] = expectedDeliveryDate;
    data['delivery_date'] = deliveryDate;
    data['address'] = address;
    data['comments'] = comments;
    data['status_update_comment'] = statusUpdateComment;
    data['total_amount'] = totalAmount;
    data['advance_amount'] = advanceAmount;
    data['balance_amount'] = balanceAmount;
    data['booking_images'] = bookingImages;
    data['created_by'] = createdBy;
    data['created_at'] = createdAt;
    data['updated_by'] = updatedBy;
    data['updated_at'] = updatedAt;
    return data;
  }
}
