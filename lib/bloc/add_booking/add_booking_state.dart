part of 'add_booking_cubit.dart';

abstract class AddBookingState extends Equatable {
  const AddBookingState();
  @override
  List<Object> get props => [];
}

class AddBookingInitial extends AddBookingState {}

class AddBookingLoading extends AddBookingState {}

class AddBookingSuccess extends AddBookingState {}

class AddBookingFailure extends AddBookingState {
  final String errorMessage;
  const AddBookingFailure({required this.errorMessage});
  @override
  List<Object> get props => [errorMessage];
}

class ServiceTypeLoading extends AddBookingState {}

class ServiceTypeLoadedDate extends AddBookingState {
  final List<ServiceTypes> serviceTypeList;
  const ServiceTypeLoadedDate({required this.serviceTypeList});
  @override
  List<Object> get props => [serviceTypeList];
}

class ServiceTypeFailure extends AddBookingState {
  final String errorMessage;
  const ServiceTypeFailure({required this.errorMessage});
  @override
  List<Object> get props => [errorMessage];
}

class EditDataLoaded extends AddBookingState {
  final BookingDetailsModel bookingDetailsModel;
  const EditDataLoaded({required this.bookingDetailsModel});
  @override
  List<Object> get props => [bookingDetailsModel];
}
