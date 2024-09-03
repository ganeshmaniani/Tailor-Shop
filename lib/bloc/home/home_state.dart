part of 'home_cubit.dart';

sealed class HomeState extends Equatable {
  const HomeState();
  @override
  List<Object> get props => [];
}

class HomeInitial extends HomeState {}

class HomeLoading extends HomeState {}

class HomeLoadedData extends HomeState {
  final User user;
  final BookingListCount bookingListCount;
  const HomeLoadedData({required this.user,required this.bookingListCount});
  @override
  List<Object> get props => [user,bookingListCount];
}

class HomeFailure extends HomeState {
  final String errorMessage;
  const HomeFailure({required this.errorMessage});
  @override
  List<Object> get props => [errorMessage];
}
