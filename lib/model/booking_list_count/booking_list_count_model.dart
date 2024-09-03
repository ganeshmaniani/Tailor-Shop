class BookingListCount {
  bool? apiSuccess;
  int? pendingList;
  int? readytoDeliveryList;
  int? deliveredList;
  int? totalList;

  BookingListCount(
      {this.apiSuccess,
      this.pendingList,
      this.readytoDeliveryList,
      this.deliveredList,
      this.totalList});

  BookingListCount.fromJson(Map<String, dynamic> json) {
    apiSuccess = json['Api_success'];
    pendingList = json['pending_list'];
    readytoDeliveryList = json['readyto_delivery_list'];
    deliveredList = json['delivered_list'];
    totalList = json['total_list'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['Api_success'] = apiSuccess;
    data['pending_list'] = pendingList;
    data['readyto_delivery_list'] = readytoDeliveryList;
    data['delivered_list'] = deliveredList;
    data['total_list'] = totalList;
    return data;
  }
}
