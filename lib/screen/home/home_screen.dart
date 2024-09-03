import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:shimmer/shimmer.dart';
import 'package:tailor_shop/bloc/bloc.dart';
import 'package:tailor_shop/core/constants/app_color.dart';
import 'package:tailor_shop/core/core.dart';
import 'package:tailor_shop/widgets/button.dart';

class HomeScreen extends StatefulWidget {
  final NavigatorState navigatorState;
  const HomeScreen({super.key, required this.navigatorState});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  void initState() {
    super.initState();
    initialCallBack();
  }

  initialCallBack() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    int? userId = prefs.getInt('user_id');
    if (userId != null) {
      BlocProvider.of<HomeCubit>(context).getUserDetail(userId);
      BlocProvider.of<ViewListCubit>(context).loadData();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade100,
      bottomSheet: Container(
        height: 50,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: CustomButton(
            text: 'Add Booking',
            onTap: () {
              widget.navigatorState
                  .pushNamed('addBooking')
                  .whenComplete(() => initialCallBack());
            }),
      ),
      body: BlocConsumer<HomeCubit, HomeState>(
        listener: (context, state) {},
        builder: (context, state) {
          if (state is HomeLoading) {
            return _buildShimmerEffect();
          } else if (state is HomeLoadedData) {
            final user = state.user;
            final bookingCount = state.bookingListCount;
            return SingleChildScrollView(
              child: Column(
                children: [
                  Container(
                    width: MediaQuery.of(context).size.width,
                    padding: const EdgeInsets.only(
                        left: 16.0, top: 40, bottom: 16, right: 16),
                    decoration: const BoxDecoration(
                      color: AppColors.primaryColor,
                      borderRadius: BorderRadius.only(
                        bottomLeft: Radius.circular(20.0),
                        bottomRight: Radius.circular(20.0),
                      ),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          user.shopName ?? '',
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Column(
                          children: [
                            // Text(
                            //   'Name: ${user.firstName}',
                            //   style: const TextStyle(
                            //     color: Colors.white,
                            //     fontSize: 20,
                            //     fontWeight: FontWeight.bold,
                            //   ),
                            // ),
                            // const SizedBox(height: 8.0),
                            // Text(
                            //   'Email: ${user.email}',
                            //   style: const TextStyle(
                            //     color: Colors.white,
                            //     fontSize: 18,
                            //   ),
                            // ),
                            // const SizedBox(height: 8.0),
                            // Text(
                            //   'Mobile No: ${user.mobileNumber}',
                            //   style: const TextStyle(
                            //     color: Colors.white,
                            //     fontSize: 18,
                            //   ),
                            // ),

                            user.profileImage == null
                                ? const CircleAvatar(
                                    radius: 30,
                                    backgroundImage:
                                        AssetImage(AppAssets.profileIcon),
                                  )
                                : CircleAvatar(
                                    radius: 30,
                                    backgroundImage: NetworkImage(
                                        '${AppUrl.baseImageUrl}/profile_uploads/${user.profileImage}'),
                                  ),
                            const SizedBox(height: 16),
                            GestureDetector(
                              onTap: () async {
                                SharedPreferences prefs =
                                    await SharedPreferences.getInstance();
                                var remove = prefs.remove('user_id');
                                remove.whenComplete(() {
                                  widget.navigatorState.pushNamedAndRemoveUntil(
                                      'login', (route) => false);
                                });
                              },
                              child: Container(
                                alignment: Alignment.center,
                                padding: const EdgeInsets.all(6),
                                decoration: BoxDecoration(
                                    color: AppColors.primaryColor,
                                    borderRadius: BorderRadius.circular(12)),
                                child: const Icon(Icons.logout,
                                    color: Colors.white),
                              ),
                            ),
                          ],
                        )
                      ],
                    ),
                  ),
                  const SizedBox(height: 20),
                  ListView.separated(
                    shrinkWrap: true,
                    padding: const EdgeInsets.all(16.0),
                    itemCount: 4,
                    separatorBuilder: (context, index) =>
                        const SizedBox(height: 16.0),
                    itemBuilder: (context, index) {
                      switch (index) {
                        case 0:
                          return _buildListItem(
                              title: 'Pending',
                              image: AppAssets.pendingIcon,
                              count: bookingCount.pendingList.toString(),
                              onTap: () {
                                widget.navigatorState.pushNamed('viewList',
                                    arguments: {
                                      'view_list_id': 1
                                    }).whenComplete(() => initialCallBack());
                              });
                        case 1:
                          return _buildListItem(
                              title: 'Ready To Delivery',
                              image: AppAssets.readyToDeliveryIcon,
                              count:
                                  bookingCount.readytoDeliveryList.toString(),
                              onTap: () {
                                widget.navigatorState.pushNamed('viewList',
                                    arguments: {
                                      'view_list_id': 2
                                    }).whenComplete(() => initialCallBack());
                              });
                        case 2:
                          return _buildListItem(
                              title: 'Delivered',
                              image: AppAssets.deliveredIcon,
                              count: bookingCount.deliveredList.toString(),
                              onTap: () {
                                widget.navigatorState.pushNamed('viewList',
                                    arguments: {
                                      'view_list_id': 3
                                    }).whenComplete(() => initialCallBack());
                              });
                        case 3:
                          return _buildListItem(
                            title: 'View Bookings',
                            image: AppAssets.viewIcon,
                            onTap: () {
                              widget.navigatorState.pushNamed('viewList',
                                  arguments: {
                                    'view_list_id': 4
                                  }).whenComplete(() => initialCallBack());
                            },
                            count: bookingCount.totalList.toString(),
                          );
                        default:
                          return Container();
                      }
                    },
                  ),
                ],
              ),
            );
          } else if (state is HomeFailure) {
            return Center(
              child: Text(state.errorMessage),
            );
          } else {
            return Container(); // Handle other states if necessary
          }
        },
      ),
    );
  }

  Widget _buildListItem({
    required String title,
    required String image,
    VoidCallback? onTap,
    required String count,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 120,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12.0),
          boxShadow: const [
            BoxShadow(
                color: Colors.black12, blurRadius: 6.0, offset: Offset(0, 3))
          ],
        ),
        alignment: Alignment.center,
        child: Row(
          children: [
            Container(
              height: 70,
              width: 70,
              padding: const EdgeInsets.all(4),
              decoration: BoxDecoration(
                  color: const Color(0xFF36b626).withOpacity(0.7),
                  borderRadius: BorderRadius.circular(12.0)),
              alignment: Alignment.center,
              child: Image.asset(image, color: Colors.white, scale: 12),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(title,
                      style: const TextStyle(
                          color: Colors.black,
                          fontSize: 16,
                          fontWeight: FontWeight.bold)),
                  const SizedBox(height: 8),
                ],
              ),
            ),
            Container(
              height: 70,
              width: 70,
              padding: const EdgeInsets.all(4),
              decoration: BoxDecoration(
                  color: const Color(0xFF36b626).withOpacity(0.7),
                  borderRadius: BorderRadius.circular(12.0)),
              alignment: Alignment.center,
              child: Text(count,
                  style: const TextStyle(
                      color: Colors.white,
                      fontSize: 26,
                      fontWeight: FontWeight.bold)),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildShimmerEffect() {
    return Column(
      children: [
        Shimmer.fromColors(
          baseColor: Colors.grey[300]!,
          highlightColor: Colors.grey[100]!,
          child: Container(
            width: MediaQuery.of(context).size.width,
            padding: const EdgeInsets.only(
                left: 16.0, top: 40, bottom: 16, right: 16),
            decoration: const BoxDecoration(
              color: Colors.grey,
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(20.0),
                bottomRight: Radius.circular(20.0),
              ),
            ),
            child: const Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Name: Loading...',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 20),
        Expanded(
          child: Shimmer.fromColors(
            baseColor: Colors.grey[300]!,
            highlightColor: Colors.grey[100]!,
            child: ListView.separated(
              shrinkWrap: true,
              padding: const EdgeInsets.all(16.0),
              itemCount: 4, // Number of shimmer items to display
              separatorBuilder: (context, index) =>
                  const SizedBox(height: 16.0),
              itemBuilder: (context, index) {
                return Container(
                  height:
                      100, // Adjust the height based on your actual list item height
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12.0),
                  ),
                );
              },
            ),
          ),
        ),
      ],
    );
  }
}
