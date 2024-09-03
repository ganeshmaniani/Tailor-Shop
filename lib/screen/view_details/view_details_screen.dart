import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:shimmer/shimmer.dart';
import 'package:tailor_shop/bloc/view_details/view_details_cubit.dart';
import 'package:tailor_shop/core/constants/app_color.dart';
import 'package:tailor_shop/core/constants/app_url.dart';

class ViewDetails extends StatefulWidget {
  final NavigatorState navigatorState;
  final int id;
  final String bookingName;
  const ViewDetails(
      {super.key,
      required this.navigatorState,
      required this.id,
      required this.bookingName});

  @override
  State<ViewDetails> createState() => _ViewDetailsState();
}

class _ViewDetailsState extends State<ViewDetails> {
  @override
  void initState() {
    super.initState();
    initialCallBack();
  }

  initialCallBack() async {
    BlocProvider.of<ViewDeailsCubit>(context).getBookingDetails(widget.id);
  }

  String formatDateTime(String? date) {
    if (date == null || date.isEmpty) return 'N/A';
    try {
      final DateTime dateTime = DateTime.parse(date);
      final DateFormat formatter = DateFormat('yyyy-MM-dd hh:mm a');
      return formatter.format(dateTime);
    } catch (e) {
      return 'Invalid date';
    }
  }

  List<String> _parseBookingImages(String? bookingImages) {
    if (bookingImages == null || bookingImages.isEmpty) return [];
    try {
      final List<dynamic> jsonList = jsonDecode(bookingImages);
      return jsonList.cast<String>();
    } catch (e) {
      return [];
    }
  }

  String formatCurrency(String? amount) {
    if (amount == null || amount.isEmpty) return '₹ 0';

    try {
      final double value = double.parse(amount);
      // Convert to integer and format as currency
      return '₹ ${value.toInt()}';
    } catch (e) {
      return '₹ 0';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade100,
      appBar: AppBar(
        title: Text('${widget.bookingName} Booking Details'),
        backgroundColor: AppColors.primaryColor,
        foregroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: BlocBuilder<ViewDeailsCubit, ViewDetailState>(
          builder: (context, state) {
            if (state is ViewDetailLoading) {
              return buildShimmerEffect();
            }
            if (state is ViewDetailLoadedData) {
              final bookings = state.bookingDetailsModel.bookings!;
              final images = _parseBookingImages(bookings.bookingImages);
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  headerContainer(context, text: 'Customer Details'),
                  bodyContainer(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        textKeyValue(
                            key: 'Name', value: bookings.customerName ?? 'N/A'),
                        textKeyValue(
                            key: 'Mobile Number',
                            value: bookings.mobileNumber ?? 'N/A'),
                        if (bookings.alternateMobileNumber?.isNotEmpty ?? false)
                          textKeyValue(
                              key: 'Alternate Mobile Number',
                              value: bookings.alternateMobileNumber!),
                        textKeyValue(key: 'Age', value: bookings.age ?? 'N/A'),
                        textKeyValue(
                            key: 'Gender', value: bookings.gender ?? 'N/A'),
                        textKeyValue(
                            key: 'Address', value: bookings.address ?? 'N/A'),
                      ],
                    ),
                  ),
                  const SizedBox(height: 16),
                  headerContainer(context, text: 'Amount'),
                  bodyContainer(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        textKeyValue(
                            key: 'Total Amount',
                            value: formatCurrency(bookings.totalAmount)),
                        textKeyValue(
                            key: 'Advance Amount',
                            value: formatCurrency(bookings.advanceAmount)),
                        textKeyValue(
                            key: 'Balance Amount',
                            value: formatCurrency(bookings.balanceAmount)),
                        if (bookings.deliveryAmount != null)
                          textKeyValue(
                              key: 'Delivery Amount',
                              value: formatCurrency(
                                  bookings.deliveryAmount.toString())),
                      ],
                    ),
                  ),
                  const SizedBox(height: 16),
                  headerContainer(context, text: 'Date'),
                  bodyContainer(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        textKeyValue(
                            key: 'Booking Date',
                            value: formatDateTime(bookings.createdAt)),
                        if (bookings.deliveryDate?.isNotEmpty ?? false)
                          textKeyValue(
                              key: 'Expected Delivery Date',
                              value: formatDateTime(bookings.deliveryDate)),
                        if (bookings.expectedDeliveryDate?.isNotEmpty ?? false)
                          textKeyValue(
                              key: 'Delivered Date',
                              value: formatDateTime(
                                  bookings.expectedDeliveryDate)),
                      ],
                    ),
                  ),
                  const SizedBox(height: 16),
                  headerContainer(context, text: 'Measurements'),
                  bodyContainer(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        text(text: bookings.measurements ?? 'N/A'),
                      ],
                    ),
                  ),
                  const SizedBox(height: 16),
                  headerContainer(context, text: 'Service Type'),
                  bodyContainer(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        text(text: bookings.serviceTypeName ?? 'N/A'),
                      ],
                    ),
                  ),
                  const SizedBox(height: 16),
                  if ((bookings.comments?.isNotEmpty ?? false) ||
                      (bookings.statusUpdateComment?.isNotEmpty ?? false))
                    headerContainer(context, text: 'Comments'),
                  bodyContainer(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        if (bookings.comments?.isNotEmpty ?? false)
                          text(text: bookings.comments!),
                        if (bookings.statusUpdateComment?.isNotEmpty ?? false)
                          text(text: bookings.statusUpdateComment!),
                      ],
                    ),
                  ),
                  const SizedBox(height: 16),
                  headerContainer(context, text: 'Images'),
                  bodyContainer(
                    child: images.isNotEmpty
                        ? _buildImageList(images)
                        : const Text('No images available'),
                  ),
                ],
              );
            }
            return Container();
          },
        ),
      ),
    );
  }

  Widget _buildImageList(List<String> imageFilenames) {
    return SizedBox(
      height: 150,
      child: ListView.builder(
        shrinkWrap: true,
        scrollDirection: Axis.horizontal,
        itemCount: imageFilenames.length,
        itemBuilder: (context, index) {
          final imageFilename = imageFilenames[index];
          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 4.0),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(8.0),
              child: Container(
                width: 120,
                height: 120,
                decoration: BoxDecoration(
                  image: DecorationImage(
                    image: NetworkImage(
                        "${AppUrl.baseImageUrl}/booking_images/$imageFilename"),
                    fit: BoxFit.cover,
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Row textKeyValue({required String key, required String value}) {
    return Row(
      children: [
        Expanded(
            child: Text(
          key,
          style: const TextStyle(
              color: Colors.black, fontSize: 14, fontWeight: FontWeight.w500),
        )),
        Expanded(
            child: Text(
          value,
          textAlign: TextAlign.end,
          style: const TextStyle(
              color: Colors.black, fontSize: 14, fontWeight: FontWeight.w500),
        )),
      ],
    );
  }

  Container bodyContainer({required Widget child}) {
    return Container(
      width: MediaQuery.of(context).size.width,
      padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 12),
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(
            bottomLeft: Radius.circular(12), bottomRight: Radius.circular(12)),
      ),
      child: child,
    );
  }

  Text text({required String text}) {
    return Text(
      text,
      style: const TextStyle(
          color: Colors.black, fontSize: 14, fontWeight: FontWeight.w500),
    );
  }

  Container headerContainer(BuildContext context, {required String text}) {
    return Container(
      width: MediaQuery.of(context).size.width,
      padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 12),
      decoration: const BoxDecoration(
        color: AppColors.primaryColor,
        borderRadius: BorderRadius.only(
            topLeft: Radius.circular(12), topRight: Radius.circular(12)),
      ),
      child: Text(
        text,
        style: const TextStyle(
            color: Colors.white, fontSize: 14, fontWeight: FontWeight.w500),
      ),
    );
  }

  Widget buildShimmerEffect() {
    return Column(
      children: [
        shimmerHeader(),
        shimmerBody(height: 120),
        const SizedBox(height: 16),
        shimmerHeader(),
        shimmerBody(height: 100),
        const SizedBox(height: 16),
        shimmerHeader(),
        shimmerBody(height: 100),
      ],
    );
  }

  Widget shimmerHeader() {
    return Shimmer.fromColors(
      baseColor: Colors.grey.shade300,
      highlightColor: Colors.grey.shade100,
      child: Container(
        width: MediaQuery.of(context).size.width,
        height: 24,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
        ),
      ),
    );
  }

  Widget shimmerBody({double height = 100}) {
    return Shimmer.fromColors(
      baseColor: Colors.grey.shade300,
      highlightColor: Colors.grey.shade100,
      child: Container(
        width: MediaQuery.of(context).size.width,
        height: height,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
        ),
        margin: const EdgeInsets.only(top: 4),
      ),
    );
  }
}
