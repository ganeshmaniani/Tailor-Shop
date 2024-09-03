import 'package:equatable/equatable.dart';

class BookingStatusUpdateEntity extends Equatable {
  final String bookingType;
  final String bookingId;
  final String deliveryAmount;
  final String statusUpdateComments;
  final DateTime? expectedDeliveryDateTime;
  final List<String> images;
  const BookingStatusUpdateEntity(
      {required this.bookingType,
      required this.bookingId,
      required this.deliveryAmount,
      required this.statusUpdateComments,
      required this.expectedDeliveryDateTime,
      required this.images});
  @override
  List<Object?> get props => [
        bookingType,
        bookingId,
        images,
        deliveryAmount,
        statusUpdateComments,
        expectedDeliveryDateTime
      ];
}
