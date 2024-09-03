part of 'view_details_cubit.dart';

sealed class ViewDetailState extends Equatable {
  const ViewDetailState();
  @override
  List<Object> get props => [];
}

class ViewDetailInitial extends ViewDetailState {}

class ViewDetailLoading extends ViewDetailState {}

class ViewDetailLoadedData extends ViewDetailState {
  final BookingDetailsModel bookingDetailsModel;
  const ViewDetailLoadedData({required this.bookingDetailsModel});
  @override
  List<Object> get props => [bookingDetailsModel];
}

class ViewDetailFailure extends ViewDetailState {
  final String errorMessage;
  const ViewDetailFailure({required this.errorMessage});
  @override
  List<Object> get props => [errorMessage];
}
