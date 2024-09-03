import 'package:flutter/material.dart';
import 'package:tailor_shop/screen/view_details/view_details_screen.dart';

import '../../screen/screen.dart';

class TailorShop extends StatefulWidget {
  const TailorShop({super.key});

  @override
  State<TailorShop> createState() => _TailorShopState();
}

class _TailorShopState extends State<TailorShop> {
  final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();
  Route<dynamic>? onGenerateRoute(RouteSettings settings) {
    final rootNavigator = navigatorKey.currentState!;
    final arg = settings.arguments as Map<String, dynamic>? ?? {};
    // Widget widget;
    switch (settings.name) {
      case '/':
        return MaterialPageRoute(
            builder: (context) => SplashScreen(navigatorState: rootNavigator),
            settings: settings);
      case 'login':
        return MaterialPageRoute(
            builder: (context) => LoginScreen(navigatorState: rootNavigator),
            settings: settings);
      case 'home':
        return MaterialPageRoute(
            builder: (context) => HomeScreen(navigatorState: rootNavigator),
            settings: settings);

      case 'addBooking':
        return MaterialPageRoute(
            builder: (context) => AddBookingScreen(
                navigatorState: rootNavigator,
                bookingId: (arg['booking_id'] != null)
                    ? arg['booking_id'] as int
                    : null),
            settings: settings);
      case 'viewList':
        return MaterialPageRoute(
          builder: (context) => ViewListScreen(
            navigatorState: rootNavigator,
            id: arg['view_list_id'] as int,
          ),
          settings: settings,
        );
      case 'viewDetails':
        return MaterialPageRoute(
          builder: (context) => ViewDetails(
              navigatorState: rootNavigator,
              id: arg['view_details_id'],
              bookingName: arg['booking_name']),
          settings: settings,
        );
      // case 'productDetailPage':
      //   widget = ProductDetailScreen(products: arg['products'] as Products);
      //   break;
      default:
        throw Exception('Invalid Routes');
    }
    // builder(BuildContext context) => widget;
    // return MaterialPageRoute<void>(builder: builder, settings: settings);
  }

  Future<bool> _onWillPop() async {
    if (navigatorKey.currentState!.canPop()) {
      navigatorKey.currentState!.pop();
      return false;
    }
    return true;
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: _onWillPop,
      child: Navigator(
        key: navigatorKey,
        initialRoute: '/',
        onGenerateRoute: onGenerateRoute,
      ),
    );
  }
}
