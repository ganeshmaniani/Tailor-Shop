import 'package:equatable/equatable.dart';

class AddBookingEntity extends Equatable {
  final String customerName;
  final String mobileNumber;
  final String alternateMobileNumber;
  final String age;
  final String measurements;
  final String gender;
  final int serviceTypeId;
  final double totalAmount;
  final double advanceAmount;
  final double balanceAmount;
  final DateTime deliveryDate;
  final String address;
  final String comments;
  final DateTime createAt;
  final List<String> images;

  const AddBookingEntity({
    required this.customerName,
    required this.mobileNumber,
    required this.alternateMobileNumber,
    required this.age,
    required this.measurements,
    required this.gender,
    required this.serviceTypeId,
    required this.totalAmount,
    required this.advanceAmount,
    required this.balanceAmount,
    required this.deliveryDate,
    required this.address,
    required this.comments,
    required this.createAt,
    required this.images,
  });
  @override
  List<Object?> get props => [
        customerName,
        mobileNumber,
        alternateMobileNumber,
        age,
        measurements,
        gender,
        serviceTypeId,
        totalAmount,
        advanceAmount,
        balanceAmount,
        deliveryDate,
        address,
        comments,
        createAt,
        images
      ];
}
