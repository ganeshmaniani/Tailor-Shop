import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tailor_shop/entities/add_booking/add_booking_entity.dart';

import '../../model/booking_detail/booking_detail_model.dart';
import '../../model/service_type/service_type_model.dart';
import '../../repository/repository.dart';

part 'add_booking_state.dart';

class AddBookingCubit extends Cubit<AddBookingState> {
  final AddBookingRepository addBookingRepository;
  final ViewDetailsRepository viewDetailsRepository;
  AddBookingCubit(
      {required this.addBookingRepository, required this.viewDetailsRepository})
      : super(AddBookingInitial());

  getServiceType() async {
    try {
      emit(ServiceTypeLoading());
      List<ServiceTypes>? serviceTypeList =
          await addBookingRepository.getServiceType();
      if (serviceTypeList != null) {
        emit(ServiceTypeLoadedDate(serviceTypeList: serviceTypeList));
      } else {
        emit(const ServiceTypeFailure(
            errorMessage: 'Could not load service type'));
      }
    } catch (e) {
      emit(ServiceTypeFailure(errorMessage: e.toString()));
    }
  }

  bookingSubmit(AddBookingEntity addBookingEntity) async {
    try {
      emit(AddBookingLoading());
      bool response =
          await addBookingRepository.bookingSubmit(addBookingEntity);
      if (response) {
        emit(AddBookingSuccess());
        // await getServiceType();
      } else {
        emit(const AddBookingFailure(errorMessage: 'Does Not Add'));
        // await getServiceType();
      }
    } catch (e) {
      emit(AddBookingFailure(errorMessage: e.toString()));
    }
  }

  updateBooking(AddBookingEntity addBookingEntity, int id,int bookingType) async {
    try {
      emit(AddBookingLoading());
      bool response =
          await addBookingRepository.updateBooking(addBookingEntity, id,bookingType);
      if (response) {
        emit(AddBookingSuccess());
      } else {
        emit(const AddBookingFailure(errorMessage: 'Does Not Update'));
        // await getServiceType();
      }
    } catch (e) {
      emit(AddBookingFailure(errorMessage: e.toString()));
    }
  }

  getBookingEditDetails(int id) async {
    BookingDetailsModel? bookingDetailsModel =
        await viewDetailsRepository.getBookingDetails(id);
    if (bookingDetailsModel != null) {
      emit(EditDataLoaded(bookingDetailsModel: bookingDetailsModel));
      await getServiceType();
    } else {
      emit(const AddBookingFailure(
          errorMessage: "Could not load booking detail"));
    }

    // emit(AddBookingLoading());
  }
}
