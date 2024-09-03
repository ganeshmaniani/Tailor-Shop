class ServiceTypeModel {
  List<ServiceTypes>? serviceTypes;
  bool? apiSuccess;
  String? apiMessage;

  ServiceTypeModel({this.serviceTypes, this.apiSuccess, this.apiMessage});

  ServiceTypeModel.fromJson(Map<String, dynamic> json) {
    if (json['service_types'] != null) {
      serviceTypes = <ServiceTypes>[];
      json['service_types'].forEach((v) {
        serviceTypes!.add(ServiceTypes.fromJson(v));
      });
    }
    apiSuccess = json['Api_success'];
    apiMessage = json['Api_message'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (serviceTypes != null) {
      data['service_types'] = serviceTypes!.map((v) => v.toJson()).toList();
    }
    data['Api_success'] = apiSuccess;
    data['Api_message'] = apiMessage;
    return data;
  }
}

class ServiceTypes {
  int? id;
  int? shopId;
  String? serviceName;
  String? price;
  String? description;

  ServiceTypes(
      {this.id, this.shopId, this.serviceName, this.price, this.description});

  ServiceTypes.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    shopId = json['shop_id'];
    serviceName = json['service_name'];
    price = json['price'];
    description = json['description'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = id;
    data['shop_id'] = shopId;
    data['service_name'] = serviceName;
    data['price'] = price;
    data['description'] = description;
    return data;
  }
}
