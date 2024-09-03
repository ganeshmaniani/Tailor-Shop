import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:permission_handler/permission_handler.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:shimmer/shimmer.dart';
import 'package:tailor_shop/bloc/bloc.dart';
import 'package:tailor_shop/core/constants/app_color.dart';
import 'package:tailor_shop/widgets/date_tile.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../core/core.dart';
import '../../entities/booking_status_update/booking_status_update_entity.dart';
import '../../model/booking_list_model/booking_list_model.dart';
import '../../model/booking_status/booking_status_model.dart';
import '../../widgets/widgets.dart';

class ViewListScreen extends StatefulWidget {
  final NavigatorState navigatorState;
  final int? id;

  const ViewListScreen({super.key, required this.navigatorState, this.id});

  @override
  State<ViewListScreen> createState() => _ViewListScreenState();
}

class _ViewListScreenState extends State<ViewListScreen> {
  final TextEditingController searchController = TextEditingController();
  int _selectedIndex = 0;
  bool _isSearching = false;
  int _selectedStatusIdUpdate = 1;
  @override
  void initState() {
    super.initState();
    initialCallBack();
    searchController.addListener(() {
      context.read<ViewListCubit>().searchBookings(searchController.text);
    });
    selectedIndex();
  }

  initialCallBack() async {
    widget.id == 4
        ? await BlocProvider.of<ViewListCubit>(context).loadData()
        : BlocProvider.of<ViewListCubit>(context)
            .getBookingStatusByList(widget.id ?? 0);
  }

  String formatDateTime(String? date) {
    if (date == null || date.isEmpty) return '';
    try {
      final DateTime dateTime = DateTime.parse(date);
      final DateFormat formatter = DateFormat('yyyy-MM-dd hh:mm a');
      return formatter.format(dateTime);
    } catch (e) {
      return '';
    }
  }

  int selectedIndex() {
    switch (widget.id) {
      case 1:
        _selectedIndex = 0;
        _selectedStatusIdUpdate = 1;
        return _selectedIndex;
      case 2:
        _selectedIndex = 1;
        _selectedStatusIdUpdate = 2;
        return _selectedIndex;
      case 3:
        _selectedIndex = 2;
        _selectedStatusIdUpdate = 3;
        return _selectedIndex;
      case 4:
        _selectedIndex = 3;
        _selectedStatusIdUpdate = 4;
        return _selectedIndex;
    }
    return 5;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade100,
      appBar: AppBar(
        centerTitle: true,
        title: _isSearching
            ? TextField(
                controller: searchController,
                cursorColor: Colors.white,
                decoration: const InputDecoration(
                  hintText: 'Search name or mobile no...',
                  hintStyle: TextStyle(color: Colors.white54),
                  border: InputBorder.none,
                ),
                style: const TextStyle(color: Colors.white),
                autofocus: true,
              )
            : Text(_selectedIndex == 0
                ? 'Pending'
                : _selectedIndex == 1
                    ? 'Ready To Delivery'
                    : _selectedIndex == 2
                        ? 'Delivered'
                        : _selectedIndex == 3
                            ? 'View Bookings'
                            : ''),
        actions: [
          IconButton(
            onPressed: () {
              setState(() {
                if (_isSearching) {
                  searchController.clear();
                }
                _isSearching = !_isSearching;
              });
            },
            icon: Icon(_isSearching ? Icons.clear : Icons.search),
          )
        ],
        backgroundColor: AppColors.primaryColor,
        foregroundColor: Colors.white,
      ),
      body: BlocConsumer<ViewListCubit, ViewListState>(
        listener: (context, state) {
          if (state is ViewListFailure) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('Error: ${state.errorMessage}')),
            );
          }
          if (state is UpdateStatusSuccess) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                  backgroundColor: Colors.green,
                  content: Text('Status Updated Successfully..!')),
            );
          }
        },
        builder: (context, state) {
          return Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildTabs(state),
                const SizedBox(height: 16),
                if (state is ViewListDataLoaded)
                  state.bookingList.isEmpty
                      ? const Center(child: Text('No List Found here'))
                      : Expanded(
                          child: _buildContent(state),
                        ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildTabs(ViewListState state) {
    if (state is ViewListLoading) {
      return _buildShimmerTabs();
    } else if (state is ViewListDataLoaded) {
      return SizedBox(
        height: 40.0,
        child: ListView.builder(
          scrollDirection: Axis.horizontal,
          itemCount: state.bookingStatusList.length,
          itemBuilder: (context, index) {
            return _buildTab(
              state.bookingStatusList[index].name ?? "",
              index,
              state.bookingStatusList[index].id ?? 0,
            );
          },
        ),
      );
    } else if (state is ViewListFailure) {
      return Center(child: Text(state.errorMessage));
    } else {
      return const Center(child: Text('No status available'));
    }
  }

  Widget _buildShimmerTabs() {
    return SizedBox(
      height: 40.0,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: 4,
        itemBuilder: (context, index) {
          return _buildShimmerTab();
        },
      ),
    );
  }

  Widget _buildShimmerTab() {
    return Shimmer.fromColors(
      baseColor: Colors.grey[300]!,
      highlightColor: Colors.grey[100]!,
      child: Container(
        width: 100.0,
        margin: const EdgeInsets.symmetric(horizontal: 4.0),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(8.0),
        ),
      ),
    );
  }

  Widget _buildTab(String label, int index, int id) {
    final bool isSelected = _selectedIndex == index;
    return GestureDetector(
      onTap: () {
        setState(() {
          _selectedIndex = index;
          searchController.clear();
          _selectedStatusIdUpdate = id;
        });
        if (_selectedIndex == 3) {
          context.read<ViewListCubit>().loadData();
        } else {
          context.read<ViewListCubit>().getBookingStatusByList(id);
        }
      },
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
        margin: const EdgeInsets.symmetric(horizontal: 4.0),
        decoration: BoxDecoration(
          color: isSelected ? AppColors.primaryColor : Colors.white,
          borderRadius: BorderRadius.circular(8.0),
          border: Border.all(color: AppColors.primaryColor),
        ),
        child: Text(
          label,
          style: TextStyle(
            color: isSelected ? Colors.white : AppColors.primaryColor,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }

  Widget _buildContent(ViewListState state) {
    if (state is ViewListLoading) {
      return const Center(child: CircularProgressIndicator());
    } else if (state is ViewListDataLoaded) {
      return ListView.builder(
        itemCount: state.bookingList.length,
        itemBuilder: (context, index) {
          return _buildBookingContainer(
              index, state.bookingList[index], state.bookingStatusList);
        },
      );
    } else if (state is ViewListFailure) {
      return Center(child: Text('Something went wrong: ${state.errorMessage}'));
    } else {
      return const Center(child: Text('No data available'));
    }
  }

  Widget _buildBookingContainer(
      int index, BookingsList booking, List<BookingStatus> bookingStatusList) {
    return Column(
      children: [
        Container(
          width: MediaQuery.of(context).size.width,
          padding: const EdgeInsets.all(4),
          decoration: const BoxDecoration(
              color: AppColors.primaryColor,
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(12),
                topRight: Radius.circular(12),
              )),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset(
                  booking.bookingTypeName == 'Pending'
                      ? AppAssets.pendingIcon
                      : booking.bookingTypeName == 'Ready To Delivery'
                          ? AppAssets.readyToDeliveryIcon
                          : AppAssets.deliveredIcon,
                  scale: 20,
                  color: Colors.white),
              const SizedBox(width: 4),
              Text(
                booking.bookingTypeName ?? '',
                style: const TextStyle(
                    color: Colors.white,
                    fontSize: 14,
                    fontWeight: FontWeight.bold),
              ),
            ],
          ),
        ),
        Container(
          margin: const EdgeInsets.only(bottom: 8.0),
          padding: const EdgeInsets.all(16.0),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: const BorderRadius.only(
              bottomLeft: Radius.circular(12),
              bottomRight: Radius.circular(12),
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.2),
                spreadRadius: 2,
                blurRadius: 4,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                        color: Colors.grey.shade100,
                        borderRadius: BorderRadius.circular(6)),
                    child: Column(
                      children: [
                        const Text(
                          'Booking Id',
                          style: TextStyle(
                              color: Colors.black,
                              fontSize: 8,
                              fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          booking.id.toString(),
                          style: const TextStyle(
                              color: AppColors.primaryColor,
                              fontSize: 18,
                              fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                  ),
                  Column(
                    children: [
                      Row(
                        children: [
                          Text(booking.customerName ?? '',
                              style:
                                  const TextStyle(fontWeight: FontWeight.w500)),
                          const SizedBox(width: 12),
                          const Icon(Icons.person,
                              color: AppColors.primaryColor),
                        ],
                      ),
                      Row(
                        children: [
                          Text(booking.mobileNumber ?? '',
                              style:
                                  const TextStyle(fontWeight: FontWeight.w500)),
                          const SizedBox(width: 8),
                          IconButton(
                            onPressed: () {
                              if (booking.mobileNumber != null &&
                                  booking.mobileNumber!.isNotEmpty) {
                                try {
                                  _dialPhoneNumber(
                                      context, booking.mobileNumber!);
                                } catch (e) {
                                  log('Error launching phone dialer: $e');
                                }
                              } else {
                                log('Invalid phone number');
                              }
                            },
                            icon: const Icon(Icons.call,
                                color: AppColors.primaryColor),
                          )

                          // GestureDetector(
                          //   onTap: () =>
                          //       _dialPhoneNumber(booking.mobileNumber ?? ''),
                          //   child: Container(
                          //     padding: const EdgeInsets.all(4),
                          //     decoration: BoxDecoration(
                          //         color: Colors.grey.shade100,
                          //         borderRadius: BorderRadius.circular(6)),
                          //     child: const Row(
                          //       children: [
                          //         Text('Call',
                          //             style: TextStyle(
                          //                 color: Colors.black,
                          //                 fontSize: 16,
                          //                 fontWeight: FontWeight.w500)),
                          //         SizedBox(width: 4.0),
                          //         Icon(Icons.call,
                          //             color: AppColors.primaryColor),
                          //       ],
                          //     ),
                          //   ),
                          // ),
                        ],
                      ),
                      // dateContainer(
                      //     text: "Booking Date",
                      //     date: formatDateTime(booking.createdAt)),
                      // const SizedBox(height: 8.0),
                      // dateContainer(
                      //     text: "Expected\nDelivery Date",
                      //     date: formatDateTime(booking.deliveryDate)),
                      // const SizedBox(height: 8.0),
                      // booking.expectedDeliveryDate != null &&
                      //         booking.expectedDeliveryDate!.isNotEmpty &&
                      //         booking.expectedDeliveryDate !=
                      //             '0000-00-00 00:00:00'
                      //     ? dateContainer(
                      //         text: "Delivered Date",
                      //         date:
                      //             formatDateTime(booking.expectedDeliveryDate))
                      //     : const SizedBox(),
                    ],
                  ),
                ],
              ),
              DateTile(
                  isFirst: true,
                  isLast: false,
                  isPass: true,
                  address: "Booking Date ${formatDateTime(booking.createdAt)}",
                  index: ''),
              DateTile(
                  isFirst: false,
                  isLast: booking.expectedDeliveryDate != null &&
                          booking.expectedDeliveryDate!.isNotEmpty &&
                          booking.expectedDeliveryDate != '0000-00-00 00:00:00'
                      ? false
                      : true,
                  isPass: true,
                  address:
                      "Expected\nDelivery Date ${formatDateTime(booking.deliveryDate)}",
                  index: ''),
              booking.expectedDeliveryDate != null &&
                      booking.expectedDeliveryDate!.isNotEmpty &&
                      booking.expectedDeliveryDate != '0000-00-00 00:00:00'
                  ? DateTile(
                      isFirst: false,
                      isLast: true,
                      isPass: true,
                      address:
                          "Delivered Date ${formatDateTime(booking.expectedDeliveryDate)}",
                      index: '')
                  : const SizedBox(),
              const SizedBox(height: 12),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: amountContainer(
                        text: 'Total Amount', date: "₹ ${booking.totalAmount}"),
                  ),
                  const SizedBox(width: 4),
                  Expanded(
                    child: amountContainer(
                        text: 'Balance Amount',
                        date: "₹ ${booking.balanceAmount}"),
                  ),
                  const SizedBox(width: 4),
                  if (booking.deliveryAmount != null)
                    Expanded(
                      child: amountContainer(
                          text: 'Delivered Amount',
                          date: "₹ ${booking.deliveryAmount}"),
                    ),
                ],
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  Expanded(
                    child: CustomSmallButton(
                        label: 'View',
                        onTap: () {
                          widget.navigatorState.pushNamed('viewDetails',
                              arguments: {
                                'view_details_id': booking.id,
                                'booking_name': booking.bookingTypeName
                              });
                        },
                        isIcon: true,
                        icon: Icons.remove_red_eye),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: CustomSmallButton(
                        label: 'Update',
                        onTap: () async {
                          _showUpdateStatusDialog(
                              context,
                              bookingStatusList,
                              booking.id ?? 0,
                              bookingStatusList[_selectedIndex].id ?? 0,
                              booking.balanceAmount ?? '',
                              widget.id ?? 0,
                              _selectedStatusIdUpdate);
                        },
                        isIcon: true,
                        icon: Icons.upload),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: CustomSmallButton(
                        label: 'Edit',
                        onTap: () {
                          widget.navigatorState.pushNamed('addBooking',
                              arguments: {
                                'booking_id': booking.id
                              }).whenComplete(() => initialCallBack());
                        },
                        isIcon: true,
                        icon: Icons.edit),
                  ),
                  const SizedBox(width: 8),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }

  Container dateContainer({
    required String text,
    required String date,
  }) {
    return Container(
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(
          color: Colors.grey.shade100, borderRadius: BorderRadius.circular(6)),
      child: Row(
        children: [
          Text(text,
              style: const TextStyle(
                  color: AppColors.primaryColor,
                  fontSize: 9,
                  fontWeight: FontWeight.bold)),
          const SizedBox(width: 4),
          Text(date,
              style: const TextStyle(
                  color: Colors.black,
                  fontSize: 10,
                  fontWeight: FontWeight.bold))
        ],
      ),
    );
  }

  Container amountContainer({
    required String text,
    required String date,
  }) {
    return Container(
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(
          color: Colors.grey.shade100, borderRadius: BorderRadius.circular(6)),
      child: Column(
        children: [
          Text(text,
              style: const TextStyle(
                  color: AppColors.primaryColor,
                  fontSize: 9,
                  fontWeight: FontWeight.bold)),
          const SizedBox(width: 4),
          Text(date,
              style: const TextStyle(
                  color: Colors.black,
                  fontSize: 10,
                  fontWeight: FontWeight.bold))
        ],
      ),
    );
  }

  void _showUpdateStatusDialog(
      BuildContext context,
      List<BookingStatus> bookingStatusList,
      int bookingId,
      int statusId,
      String balanceAmount,
      int getStatusId,
      int statusUpdateId) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return ImagePickerState(
          bookingStatusList: bookingStatusList,
          bookingId: bookingId,
          selectedIndex: _selectedIndex,
          ststusId: statusId,
          balanceAmount: balanceAmount,
          getStatusId: getStatusId,
          statusUpdateId: statusUpdateId,
        );
      },
    );
  }

  void _dialPhoneNumber(BuildContext context, String phoneNumber) async {
    final Uri telUri = Uri(
      scheme: 'tel',
      path: phoneNumber,
    );

    if (await Permission.phone.request().isGranted) {
      if (await canLaunchUrl(telUri)) {
        await launchUrl(telUri);
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Could not launch phone number')),
        );
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Phone call permission not granted')),
      );
    }
  }
}

class ImagePickerState extends StatefulWidget {
  final List<BookingStatus> bookingStatusList;
  final int bookingId;
  final int ststusId;
  int selectedIndex;
  final String balanceAmount;
  final int getStatusId;
  final int statusUpdateId;
  ImagePickerState({
    super.key,
    required this.bookingStatusList,
    required this.bookingId,
    required this.selectedIndex,
    required this.ststusId,
    required this.balanceAmount,
    required this.getStatusId,
    required this.statusUpdateId,
  });

  @override
  State<ImagePickerState> createState() => _ImagePickerStateState();
}

class _ImagePickerStateState extends State<ImagePickerState> {
  final List<File> _selectedImages = [];
  final TextEditingController _statusUpdateCommentContrroler =
      TextEditingController();

  final TextEditingController deliveryAmountController =
      TextEditingController();
  int? selectedStatusId;
  String _errorMessage = '';

  Future<void> _pickImages() async {
    final ImagePicker _picker = ImagePicker();
    final XFile? image = await _picker.pickImage(source: ImageSource.camera);
    if (image != null) {
      CroppedFile? croppedFile = await cropImage(sourcePath: image.path);
      if (croppedFile != null) {
        setState(() {
          _selectedImages.add(File(croppedFile.path));
        });
      }
    }
  }

  Future<CroppedFile?> cropImage({required String sourcePath}) async {
    return await ImageCropper().cropImage(
      sourcePath: sourcePath,
      maxWidth: 512,
      maxHeight: 512,
      aspectRatio: const CropAspectRatio(ratioX: 2.0, ratioY: 2.0),
      compressFormat: ImageCompressFormat.jpg,
      compressQuality: 90,
      uiSettings: [
        AndroidUiSettings(
            toolbarTitle: 'Crop Image',
            toolbarColor: Colors.deepPurple,
            toolbarWidgetColor: Colors.white,
            activeControlsWidgetColor: Colors.deepPurple,
            initAspectRatio: CropAspectRatioPreset.original,
            lockAspectRatio: true),
        IOSUiSettings(title: 'Crop Image')
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<ViewListCubit, ViewListState>(
      listener: (context, state) {
        if (state is UpdateStatusSuccess) {
          Navigator.of(context).pop();
        }
      },
      builder: (context, state) {
        return AlertDialog(
          backgroundColor: Colors.white,
          title: Text(
              widget.ststusId == 1
                  ? 'Update your Booking To Ready to Delivery or Delivered'
                  : widget.ststusId == 2
                      ? "Update Your Booking To Delivered"
                      : widget.ststusId == 3
                          ? "Update Your Booking To Ready To Delivery"
                          : widget.ststusId == 4
                              ? 'Update Your Status'
                              : '',
              textAlign: TextAlign.center,
              style:
                  const TextStyle(fontSize: 18, fontWeight: FontWeight.w500)),
          content: SingleChildScrollView(
            child: SizedBox(
              width: double.maxFinite,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  DropdownButtonFormField<int>(
                    borderRadius: BorderRadius.circular(12),
                    isExpanded: true,
                    padding: const EdgeInsets.all(4),
                    decoration: InputDecoration(
                        labelText: 'Select Status',
                        labelStyle:
                            const TextStyle(color: AppColors.primaryColor),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8.0),
                          borderSide: BorderSide(
                              color: Colors.grey.shade400, width: 2.0),
                        ),
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8)),
                        contentPadding: const EdgeInsets.symmetric(
                            vertical: 8.0, horizontal: 12.0)),
                    items: widget.selectedIndex == 3
                        ? getDropdownMenuItemsForAllList()
                        : getDropdownMenuItems(),
                    onChanged: (int? newValue) {
                      selectedStatusId = newValue;
                      setState(() {});
                    },
                    validator: (value) =>
                        value == null ? 'Please select a status' : null,
                  ),
                  const SizedBox(height: 8),
                  selectedStatusId == 3
                      ? Row(
                          children: [
                            Expanded(
                                child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text('Balance',
                                    style: TextStyle(
                                        fontSize: 12,
                                        fontWeight: FontWeight.w400)),
                                TextFormField(
                                  readOnly: true,
                                  decoration: InputDecoration(
                                      hintText: widget.balanceAmount,
                                      fillColor: Colors.white,
                                      filled: true,
                                      border: const OutlineInputBorder(),
                                      focusedBorder: const OutlineInputBorder(),
                                      contentPadding:
                                          const EdgeInsets.symmetric(
                                              vertical: 8.0, horizontal: 12.0)),
                                )
                              ],
                            )),
                            const SizedBox(width: 8),
                            Expanded(
                                child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text('Delivery Amount',
                                    style: TextStyle(
                                        fontSize: 12,
                                        fontWeight: FontWeight.w400)),
                                TextFormField(
                                  controller: deliveryAmountController,
                                  cursorColor: AppColors.primaryColor,
                                  decoration: const InputDecoration(
                                      fillColor: Colors.white,
                                      filled: true,
                                      border: OutlineInputBorder(),
                                      focusedBorder: OutlineInputBorder(),
                                      contentPadding: EdgeInsets.symmetric(
                                          vertical: 8.0, horizontal: 12.0)),
                                )
                              ],
                            ))
                          ],
                        )
                      : const SizedBox(),
                  if (_errorMessage.isNotEmpty)
                    Text(_errorMessage,
                        textAlign: TextAlign.center,
                        style: const TextStyle(color: Colors.red)),
                  const SizedBox(height: 4),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text('Comments',
                          style: TextStyle(
                              fontSize: 12, fontWeight: FontWeight.w400)),
                      TextFormField(
                        controller: _statusUpdateCommentContrroler,
                        cursorColor: AppColors.primaryColor,
                        decoration: const InputDecoration(
                            hintText: 'Enter a comments',
                            fillColor: Colors.white,
                            filled: true,
                            border: OutlineInputBorder(),
                            focusedBorder: OutlineInputBorder(),
                            contentPadding: EdgeInsets.symmetric(
                                vertical: 8.0, horizontal: 12.0)),
                      )
                    ],
                  ),
                  const SizedBox(height: 12),
                  CustomSmallButton(label: 'Pick Images', onTap: _pickImages),
                  const SizedBox(height: 8),
                  if (_selectedImages.isEmpty)
                    const Text('Please select at least one image',
                        style: TextStyle(color: Colors.red)),
                  if (_selectedImages.isNotEmpty)
                    SizedBox(
                      height: 100,
                      child: ListView.builder(
                        shrinkWrap: true,
                        scrollDirection: Axis.horizontal,
                        itemCount: _selectedImages.length,
                        itemBuilder: (context, index) {
                          return Container(
                            width: 100,
                            height: 100,
                            padding: const EdgeInsets.all(4.0),
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(8.0),
                              child: Image.file(
                                _selectedImages[index],
                                fit: BoxFit.cover,
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                ],
              ),
            ),
          ),
          actions: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                CustomSmallButton(
                    textColor: Colors.white,
                    color: Colors.red,
                    label: 'Cancel',
                    onTap: () => Navigator.of(context).pop()),
                state is ViewListLoading
                    ? const CircularProgressIndicator()
                    : CustomSmallButton(
                        label: 'Update',
                        color: AppColors.primaryColor,
                        onTap: () {
                          if (selectedStatusId != null) {
                            final double balanceAmount =
                                double.tryParse(widget.balanceAmount) ?? 0.0;
                            final double deliveryAmount = double.tryParse(
                                    deliveryAmountController.text) ??
                                0.0;
                            if (balanceAmount < deliveryAmount) {
                              setState(() {
                                _errorMessage =
                                    'Delivery amount cannot exceed balance amount';
                              });
                              return;
                            } else {
                              setState(() {
                                _errorMessage =
                                    ''; // Clear error message if condition is not met
                              });
                            }

                            List<String> base64Images = [];

                            for (File image in _selectedImages) {
                              String base64Image =
                                  base64.encode(image.readAsBytesSync());
                              base64Images.add(base64Image);
                            }
                            DateTime? deliveryDateTime = DateTime.now();

                            final BookingStatusUpdateEntity
                                bookingStatusUpdateEntity =
                                BookingStatusUpdateEntity(
                                    bookingType: selectedStatusId.toString(),
                                    bookingId: widget.bookingId.toString(),
                                    deliveryAmount:
                                        deliveryAmountController.text.isNotEmpty
                                            ? deliveryAmountController.text
                                            : '',
                                    expectedDeliveryDateTime:
                                        selectedStatusId == 3
                                            ? deliveryDateTime
                                            : null,
                                    images: base64Images,
                                    statusUpdateComments:
                                        _statusUpdateCommentContrroler.text);

                            context.read<ViewListCubit>().bookingStatusUpdate(
                                bookingStatusUpdateEntity,
                                widget.statusUpdateId);

                            // widget.selectedIndex = selectedStatusId! - 1;
                            // setState(() {});
                          }
                        }),
              ],
            )
          ],
        );
      },
    );
  }

  List<DropdownMenuItem<int>> getDropdownMenuItemsForAllList() {
    if (widget.ststusId == 1) {
      return widget.bookingStatusList
          .where((BookingStatus status) => status.id == 2 || status.id == 3)
          .map((BookingStatus status) {
        return DropdownMenuItem<int>(
          value: status.id,
          child: Row(
            children: [
              status.id == 2
                  ? Image.asset(AppAssets.readyToDeliveryIcon, scale: 20)
                  : status.id == 3
                      ? Image.asset(AppAssets.deliveredIcon, scale: 20)
                      : const SizedBox(),
              const SizedBox(width: 8),
              Text(status.name ?? 'Unknown'),
            ],
          ),
        );
      }).toList();
    } else if (widget.ststusId == 2 || widget.getStatusId == 2) {
      return widget.bookingStatusList
          .where((BookingStatus status) => status.id == 3)
          .map((BookingStatus status) {
        return DropdownMenuItem<int>(
          value: status.id,
          child: Row(
            children: [
              Image.asset(AppAssets.deliveredIcon, scale: 20),
              const SizedBox(width: 8),
              Text(status.name ?? 'Unknown'),
            ],
          ),
        );
      }).toList();
    } else if (widget.ststusId == 3) {
      return widget.bookingStatusList
          .where((BookingStatus status) => status.id == 2)
          .map((BookingStatus status) {
        return DropdownMenuItem<int>(
          value: status.id,
          child: Row(
            children: [
              Image.asset(AppAssets.readyToDeliveryIcon, scale: 20),
              const SizedBox(width: 8),
              Text(status.name ?? 'Unknown'),
            ],
          ),
        );
      }).toList();
    } else {
      // For all other cases, show only status id 1, 2, and 3
      return widget.bookingStatusList
          .where((BookingStatus status) =>
              status.id == 1 || status.id == 2 || status.id == 3)
          .map((BookingStatus status) {
        return DropdownMenuItem<int>(
          value: status.id,
          child: Row(
            children: [
              status.id == 1
                  ? Image.asset(AppAssets.pendingIcon, scale: 20)
                  : status.id == 2
                      ? Image.asset(AppAssets.readyToDeliveryIcon, scale: 20)
                      : Image.asset(AppAssets.deliveredIcon, scale: 20),
              const SizedBox(width: 8),
              Text(status.name ?? 'Unknown'),
            ],
          ),
        );
      }).toList();
    }
  }

  List<DropdownMenuItem<int>> getDropdownMenuItems() {
    if (widget.selectedIndex == 0) {
      return widget.bookingStatusList
          .where((BookingStatus status) => status.id == 2 || status.id == 3)
          .map((BookingStatus status) {
        return DropdownMenuItem<int>(
          value: status.id,
          child: Row(
            children: [
              status.id == 2
                  ? Image.asset(AppAssets.readyToDeliveryIcon, scale: 20)
                  : status.id == 3
                      ? Image.asset(AppAssets.deliveredIcon, scale: 20)
                      : const SizedBox(),
              const SizedBox(width: 8),
              Text(status.name ?? 'Unknown'),
            ],
          ),
        );
      }).toList();
    } else if (widget.selectedIndex == 1) {
      // When getStatusId is 2, show items with status id 3
      return widget.bookingStatusList
          .where((BookingStatus status) => status.id == 3)
          .map((BookingStatus status) {
        return DropdownMenuItem<int>(
          value: status.id,
          child: Row(
            children: [
              Image.asset(AppAssets.deliveredIcon, scale: 20),
              const SizedBox(width: 8),
              Text(status.name ?? 'Unknown'),
            ],
          ),
        );
      }).toList();
    } else if (widget.selectedIndex == 2) {
      // When getStatusId is 3, show items with status id 2
      return widget.bookingStatusList
          .where((BookingStatus status) => status.id == 2)
          .map((BookingStatus status) {
        return DropdownMenuItem<int>(
          value: status.id,
          child: Row(
            children: [
              Image.asset(AppAssets.readyToDeliveryIcon, scale: 20),
              const SizedBox(width: 8),
              Text(status.name ?? 'Unknown'),
            ],
          ),
        );
      }).toList();
    } else {
      return [];
    }
  }
}
