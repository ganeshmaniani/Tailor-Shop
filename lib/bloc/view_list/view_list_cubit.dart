import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tailor_shop/entities/booking_status_update/booking_status_update_entity.dart';

import '../../model/booking_list_model/booking_list_model.dart';
import '../../model/booking_status/booking_status_model.dart';
import '../../repository/repository.dart';

part 'view_list_state.dart';

class ViewListCubit extends Cubit<ViewListState> {
  final ViewListRepository viewListRepository;
  final HomeRepository homeRepository;
  List<BookingsList> _allBookings = [];
  List<BookingsList> _currentBookings = [];
  List<BookingsList> _filteredBookings = [];

  ViewListCubit(
      {required this.viewListRepository, required this.homeRepository})
      : super(ViewListInitial());

  Future<void> loadData() async {
    emit(ViewListLoading());

    try {
      final bookingStatusList = await viewListRepository.getBookingStatus();
      final bookingList = await viewListRepository.getBookingList();

      if (bookingStatusList != null && bookingList != null) {
        _allBookings = bookingList;
        _currentBookings = bookingList;
        _filteredBookings = bookingList;
        emit(ViewListDataLoaded(
            bookingStatusList: bookingStatusList, bookingList: bookingList));
      } else {
        emit(const ViewListFailure(errorMessage: 'No data available'));
      }
    } catch (e) {
      emit(ViewListFailure(errorMessage: e.toString()));
    }
  }

  Future<void> bookingStatusUpdate(
      BookingStatusUpdateEntity bookingStatusUpdateEntity, int id) async {
    bool response =
        await viewListRepository.bookingStatusUpdate(bookingStatusUpdateEntity);
    if (response) {
      emit(UpdateStatusSuccess());

      await loadData();
      

      if (id >= 1 && id <= 4) {
        await getBookingStatusByList(id, reload: false);
      }
    } else {
      emit(const UpdateStatusFailure(errorMessage: 'Could not update status'));
    }
  }

  getBookingStatusByList(int id, {bool reload = true}) async {
    if (reload) {
      await loadData();
    }
    if (state is ViewListDataLoaded) {
      final currentState = state as ViewListDataLoaded;
      _currentBookings =
          await viewListRepository.getBookingStatusByList(id) ?? [];

      if (id == 4) {
        _currentBookings = _allBookings;
      }
      _filteredBookings = _currentBookings;
      emit(ViewListDataLoaded(
        bookingStatusList: currentState.bookingStatusList,
        bookingList: _filteredBookings,
      ));
    }
  }

  void searchBookings(String query) {
    if (state is ViewListDataLoaded) {
      final stateData = state as ViewListDataLoaded;

      if (query.isEmpty) {
        _filteredBookings = _currentBookings;
      } else {
        _filteredBookings = _currentBookings.where((booking) {
          final nameMatch = booking.customerName
                  ?.toLowerCase()
                  .contains(query.toLowerCase()) ??
              false;
          final mobileMatch = booking.mobileNumber?.contains(query) ?? false;
          final statusMatch = booking.bookingTypeName?.contains(query) ?? false;
          return nameMatch || mobileMatch || statusMatch;
        }).toList();
      }

      emit(ViewListDataLoaded(
        bookingStatusList: stateData.bookingStatusList,
        bookingList: _filteredBookings,
      ));
    }
  }
}
