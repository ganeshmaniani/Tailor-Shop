import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tailor_shop/model/booking_detail/booking_detail_model.dart';

import '../../repository/view_details/view_details_repository.dart';

part 'view_details_state.dart';

class ViewDeailsCubit extends Cubit<ViewDetailState> {
  final ViewDetailsRepository viewDetailsRepository;
  ViewDeailsCubit({required this.viewDetailsRepository})
      : super(ViewDetailInitial());
  getBookingDetails(int id) async {
    emit(ViewDetailLoading());
    BookingDetailsModel? bookingDetailsModel =
        await viewDetailsRepository.getBookingDetails(id);
    if (bookingDetailsModel != null) {
      emit(ViewDetailLoadedData(bookingDetailsModel: bookingDetailsModel));
    } else {
      emit(const ViewDetailFailure(errorMessage: "Could not load user"));
    }
  }
}
