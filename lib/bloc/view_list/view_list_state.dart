part of 'view_list_cubit.dart';

abstract class ViewListState extends Equatable {
  const ViewListState();

  @override
  List<Object> get props => [];
}

class ViewListInitial extends ViewListState {}

class ViewListLoading extends ViewListState {}

class ViewListDataLoaded extends ViewListState {
  final List<BookingStatus> bookingStatusList;
  final List<BookingsList> bookingList;
  const ViewListDataLoaded({
    required this.bookingStatusList,
    required this.bookingList,
  });

  @override
  List<Object> get props => [bookingStatusList, bookingList];
}

class ViewListFailure extends ViewListState {
  final String errorMessage;
  const ViewListFailure({required this.errorMessage});

  @override
  List<Object> get props => [errorMessage];
}

class UpdateStatusLoading extends ViewListState {}

class UpdateStatusSuccess extends ViewListState {}

class UpdateStatusFailure extends ViewListState {
  final String errorMessage;
  const UpdateStatusFailure({required this.errorMessage});

  @override
  List<Object> get props => [errorMessage];
}
