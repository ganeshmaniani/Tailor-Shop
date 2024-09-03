import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'bloc/bloc.dart';
import 'bloc/view_details/view_details_cubit.dart';
import 'core/core.dart';
import 'repository/repository.dart';
import 'package:flutter/services.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations(
      [DeviceOrientation.portraitUp, DeviceOrientation.portraitDown]);
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    final authRepository = AuthRepository();
    final homeRepository = HomeRepository();
    final addBookingRepository = AddBookingRepository();
    final viewListRepository = ViewListRepository();
    final viewDetailsRepository = ViewDetailsRepository();

    return MultiRepositoryProvider(
      providers: [
        RepositoryProvider<AuthRepository>(create: (context) => authRepository),
        RepositoryProvider<HomeRepository>(create: (context) => homeRepository),
        RepositoryProvider<AddBookingRepository>(
            create: (context) => addBookingRepository),
        RepositoryProvider<ViewListRepository>(
            create: (context) => viewListRepository),
        RepositoryProvider<ViewDetailsRepository>(
            create: (context) => viewDetailsRepository),
      ],
      child: MultiBlocProvider(
        providers: [
          BlocProvider<AuthCubit>(
              create: (context) => AuthCubit(authRepository: authRepository)),
          BlocProvider<HomeCubit>(
              create: (context) => HomeCubit(homeRepository: homeRepository)),
          BlocProvider<AddBookingCubit>(
              create: (context) => AddBookingCubit(
                  addBookingRepository: addBookingRepository,
                  viewDetailsRepository: viewDetailsRepository)),
          BlocProvider<ViewListCubit>(
              create: (context) => ViewListCubit(
                  viewListRepository: viewListRepository,
                  homeRepository: homeRepository)),
          BlocProvider<ViewDeailsCubit>(
              create: (context) => ViewDeailsCubit(
                  viewDetailsRepository: viewDetailsRepository)),
        ],
        child: MaterialApp(
          debugShowCheckedModeBanner: false,
          theme: ThemeData(
            fontFamily: 'Poppins',
            colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
            useMaterial3: true,
          ),
          home: const TailorShop(), // Replace with your initial screen
        ),
      ),
    );
  }
}
