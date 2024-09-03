class BookingStatusModel {
  List<BookingStatus>? bookingStatus;
  bool? apiSuccess;
  String? apiMessage;

  BookingStatusModel({this.bookingStatus, this.apiSuccess, this.apiMessage});

  BookingStatusModel.fromJson(Map<String, dynamic> json) {
    if (json['booking_status'] != null) {
      bookingStatus = <BookingStatus>[];
      json['booking_status'].forEach((v) {
        bookingStatus!.add(BookingStatus.fromJson(v));
      });
    }
    apiSuccess = json['Api_success'];
    apiMessage = json['Api_message'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (bookingStatus != null) {
      data['booking_status'] = bookingStatus!.map((v) => v.toJson()).toList();
    }
    data['Api_success'] = apiSuccess;
    data['Api_message'] = apiMessage;
    return data;
  }
}

class BookingStatus {
  int? id;
  String? name;

  BookingStatus({this.id, this.name});

  BookingStatus.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['name'] = name;
    return data;
  }
}
