import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tailor_shop/model/model.dart';

import '../../repository/home/home_repository.dart';

part 'home_state.dart';

class HomeCubit extends Cubit<HomeState> {
  final HomeRepository homeRepository;
  HomeCubit({required this.homeRepository}) : super(HomeInitial());
  getUserDetail(int id) async {
    emit(HomeLoading());
    User? user = await homeRepository.getUserDetail(id);
    BookingListCount? bookingListCount = await homeRepository.getListCount();
    if (user != null && bookingListCount != null) {
      emit(HomeLoadedData(user: user, bookingListCount: bookingListCount));
    } else {
      emit(const HomeFailure(errorMessage: "Could not load user"));
    }
  }

   
}
