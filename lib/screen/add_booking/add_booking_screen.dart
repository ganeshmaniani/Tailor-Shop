import 'dart:async';
import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:shimmer/shimmer.dart';
import 'package:tailor_shop/bloc/add_booking/add_booking_cubit.dart';
import 'package:tailor_shop/core/constants/app_color.dart';
import 'package:tailor_shop/entities/add_booking/add_booking_entity.dart';

import '../../core/core.dart';
import '../../model/service_type/service_type_model.dart';
import '../../widgets/widgets.dart';

class AddBookingScreen extends StatefulWidget {
  final NavigatorState navigatorState;
  final int? bookingId;

  const AddBookingScreen(
      {super.key, required this.navigatorState, this.bookingId});

  @override
  State<AddBookingScreen> createState() => _AddBookingScreenState();
}

class _AddBookingScreenState extends State<AddBookingScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController nameController = TextEditingController();
  final TextEditingController ageController = TextEditingController();
  final TextEditingController mobileNumberController = TextEditingController();
  final TextEditingController alternateMobileNumberController =
      TextEditingController();
  final TextEditingController measurementController = TextEditingController();
  final TextEditingController totalAmountController = TextEditingController();
  final TextEditingController advanceAmountController = TextEditingController();
  final TextEditingController balanceAmountController = TextEditingController();
  final TextEditingController addressController = TextEditingController();
  final TextEditingController commentController = TextEditingController();

  final TextEditingController _dateController = TextEditingController();
  final TextEditingController _timeController = TextEditingController();
  final TextEditingController deliveryDateController = TextEditingController();
  String _selectedGender = 'Male';
  final List<File> _images = [];
  final ImagePicker _picker = ImagePicker();

  String? _selectedServiceTypeName;
  int? _selectedServiceTypeId;
  int? bookingType;

  @override
  void initState() {
    super.initState();
    initialCallback();
    totalAmountController.addListener(_updateBalanceAmount);
    advanceAmountController.addListener(_updateBalanceAmount);
  }

  initialCallback() async {
    BlocProvider.of<AddBookingCubit>(context).getServiceType();
    if (widget.bookingId != null) {
      BlocProvider.of<AddBookingCubit>(context)
          .getBookingEditDetails(widget.bookingId ?? 0);
    }
  }

  @override
  void dispose() {
    nameController.dispose();
    ageController.dispose();
    mobileNumberController.dispose();
    alternateMobileNumberController.dispose();
    measurementController.dispose();
    totalAmountController.dispose();
    advanceAmountController.dispose();
    balanceAmountController.dispose();
    addressController.dispose();
    deliveryDateController.dispose();
    super.dispose();
  }

  void _updateBalanceAmount() {
    final double totalAmount =
        double.tryParse(totalAmountController.text) ?? 0.0;
    final double advanceAmount =
        double.tryParse(advanceAmountController.text) ?? 0.0;

    final double balanceAmount = totalAmount - advanceAmount;
    balanceAmountController.text = balanceAmount.toStringAsFixed(2);
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

  String formatDate(String? date) {
    if (date == null || date.isEmpty) return '';
    try {
      final DateTime dateTime = DateTime.parse(date);
      final DateFormat formatter = DateFormat('dd/MM/yyyy');
      return formatter.format(dateTime);
    } catch (e) {
      return 'Invalid Date';
    }
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
      builder: (BuildContext context, Widget? child) {
        return Theme(
          data: ThemeData.light().copyWith(
              primaryColor: AppColors.primaryColor,
              hintColor: AppColors.primaryColor,
              colorScheme: const ColorScheme.light(
                  primary: AppColors.primaryColor,
                  onPrimary: Colors.white,
                  surface: Colors.white,
                  onSurface: Colors.black),
              dialogBackgroundColor: Colors.white),
          child: child!,
        );
      },
    );

    if (picked != null && picked != DateTime.now()) {
      setState(() {
        _dateController.text = DateFormat('dd/MM/yyyy').format(picked);
      });
    }
  }

  Future<void> _selectTime(BuildContext context) async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
      initialEntryMode: TimePickerEntryMode.dial,
      builder: (BuildContext context, Widget? child) {
        return Theme(
          data: ThemeData.light().copyWith(
              primaryColor: AppColors.primaryColor,
              colorScheme: const ColorScheme.light(
                  primary: AppColors.primaryColor,
                  onPrimary: Colors.white,
                  surface: Colors.white,
                  onSurface: Colors.black)),
          child: MediaQuery(
            data: MediaQuery.of(context).copyWith(alwaysUse24HourFormat: false),
            child: child!,
          ),
        );
      },
    );

    if (picked != null && picked != TimeOfDay.now()) {
      setState(() {
        final localizations = MaterialLocalizations.of(context);
        final formattedTime =
            localizations.formatTimeOfDay(picked, alwaysUse24HourFormat: false);
        _timeController.text = formattedTime;
        log(_timeController.text);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade100,
      bottomSheet: Container(
        height: 50,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: BlocBuilder<AddBookingCubit, AddBookingState>(
          builder: (context, state) {
            if (state is AddBookingLoading) {
              return const CustomLoading();
            }
            return CustomButton(
              onTap: widget.bookingId != null
                  ? () async {
                      if (_formKey.currentState!.validate() &&
                          _timeController.text.isNotEmpty &&
                          _dateController.text.isNotEmpty &&
                          _selectedGender.isNotEmpty &&
                          _selectedServiceTypeId != null) {
                        if (_images.isEmpty) {
                          ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                  content:
                                      Text('Please select at least one image'),
                                  backgroundColor: Colors.red));
                          return;
                        }
                        final String dateText = _dateController.text;
                        final DateTime date =
                            DateFormat('yyyy-MM-dd').parse(dateText);

                        final String timeText = _timeController.text;
                        final DateTime time =
                            DateFormat('HH:mm').parse(timeText);

                        // Combine Date and Time
                        final DateTime combinedDateTime = DateTime(
                          date.year,
                          date.month,
                          date.day,
                          time.hour,
                          time.minute,
                        );

                        final DateTime createAt = DateTime.now();
                        List<String> base64Images = [];
                        for (File image in _images) {
                          String base64Image =
                              base64.encode(image.readAsBytesSync());
                          base64Images.add(base64Image);
                        }

                        final AddBookingEntity addBookingEntity =
                            AddBookingEntity(
                                customerName: nameController.text,
                                mobileNumber: mobileNumberController.text,
                                alternateMobileNumber:
                                    alternateMobileNumberController.text,
                                age: ageController.text,
                                measurements: measurementController.text,
                                gender: _selectedGender,
                                serviceTypeId: _selectedServiceTypeId ?? 0,
                                totalAmount: double.tryParse(
                                        totalAmountController.text) ??
                                    0.0,
                                advanceAmount: double.tryParse(
                                        advanceAmountController.text) ??
                                    0.0,
                                balanceAmount: double.tryParse(
                                        balanceAmountController.text) ??
                                    0.0,
                                deliveryDate: combinedDateTime,
                                address: addressController.text,
                                createAt: createAt,
                                images: base64Images,
                                comments: commentController.text);

                        BlocProvider.of<AddBookingCubit>(context).updateBooking(
                            addBookingEntity,
                            widget.bookingId ?? 0,
                            bookingType ?? 0);
                      }
                    }
                  : () async {
                      if (_formKey.currentState!.validate() &&
                          _dateController.text.isNotEmpty &&
                          _timeController.text.isNotEmpty &&
                          _selectedGender.isNotEmpty &&
                          _selectedServiceTypeId != null) {
                        if (_images.isEmpty) {
                          ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                  content:
                                      Text('Please select at least one image'),
                                  backgroundColor: Colors.red));
                          return;
                        }

                        final String dateText = _dateController.text;
                        final DateTime date =
                            DateFormat('dd/MM/yyyy').parse(dateText);
                        final String timeText = _timeController.text;
                        final DateFormat timeFormat = DateFormat('h:mm a');
                        final DateTime time = timeFormat.parse(timeText);
                        final String formattedTime =
                            DateFormat('HH:mm').format(time);
                        final DateTime combinedDateTime = DateTime(
                          date.year,
                          date.month,
                          date.day,
                          int.parse(formattedTime.split(':')[0]),
                          int.parse(formattedTime.split(':')[1]),
                        );
                        final DateTime createAt = DateTime.now();
                        List<String> base64Images = [];
                        for (File image in _images) {
                          String base64Image =
                              base64.encode(image.readAsBytesSync());
                          base64Images.add(base64Image);
                        }

                        final AddBookingEntity addBookingEntity =
                            AddBookingEntity(
                                customerName: nameController.text,
                                mobileNumber: mobileNumberController.text,
                                alternateMobileNumber:
                                    alternateMobileNumberController.text,
                                age: ageController.text,
                                measurements: measurementController.text,
                                gender: _selectedGender,
                                serviceTypeId: _selectedServiceTypeId ?? 0,
                                totalAmount: double.tryParse(
                                        totalAmountController.text) ??
                                    0.0,
                                advanceAmount: double.tryParse(
                                        advanceAmountController.text) ??
                                    0.0,
                                balanceAmount: double.tryParse(
                                        balanceAmountController.text) ??
                                    0.0,
                                deliveryDate: combinedDateTime,
                                address: addressController.text,
                                createAt: createAt,
                                images: base64Images,
                                comments: commentController.text);

                        BlocProvider.of<AddBookingCubit>(context)
                            .bookingSubmit(addBookingEntity);
                      }
                    },
              text: widget.bookingId != null ? 'Update' : 'Done',
            );
          },
        ),
      ),
      appBar: AppBar(
          title: widget.bookingId != null
              ? const Text('Edit Booking')
              : const Text('Add Booking'),
          backgroundColor: AppColors.primaryColor,
          foregroundColor: Colors.white),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: BlocConsumer<AddBookingCubit, AddBookingState>(
          listener: (context, state) {
            if (state is EditDataLoaded) {
              final bookings = state.bookingDetailsModel.bookings!;
              nameController.text = bookings.customerName ?? '';
              ageController.text = bookings.age ?? '';
              mobileNumberController.text = bookings.mobileNumber ?? '';
              alternateMobileNumberController.text =
                  bookings.alternateMobileNumber ?? '';
              totalAmountController.text = (bookings.totalAmount != null)
                  ? double.parse(bookings.totalAmount!).toStringAsFixed(0)
                  : '0';
              advanceAmountController.text = (bookings.advanceAmount != null)
                  ? double.parse(bookings.advanceAmount!).toStringAsFixed(0)
                  : '0';
              balanceAmountController.text = (bookings.balanceAmount != null)
                  ? double.parse(bookings.balanceAmount!).toStringAsFixed(0)
                  : '0';
              _selectedGender = bookings.gender ?? '';
              _selectedServiceTypeName = bookings.serviceTypeName ?? "";
              _selectedServiceTypeId = bookings.serviceTypeId ?? 0;
              if (bookings.deliveryDate != null &&
                  bookings.deliveryDate!.isNotEmpty) {
                DateTime dateTime = DateTime.parse(bookings.deliveryDate!);
                _dateController.text =
                    DateFormat('yyyy-MM-dd').format(dateTime);
                _timeController.text = DateFormat('h:mm a').format(dateTime);
              } else {
                _dateController.text = '';
                _timeController.text = '';
              }
              measurementController.text = bookings.measurements ?? "";
              addressController.text = bookings.address ?? "";
              bookingType = bookings.bookingType ?? 0;
              commentController.text = bookings.comments ?? '';
            }
            if (state is AddBookingSuccess) {
              widget.bookingId != null
                  ? ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                      backgroundColor: Colors.green,
                      content: Text('Booking updated successfully!')))
                  : ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                      backgroundColor: Colors.green,
                      content: Text('Booking submitted successfully!')));
              Navigator.of(context).pop();
            } else if (state is AddBookingFailure) {
              widget.bookingId != null
                  ? ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                      backgroundColor: Colors.red,
                      content: Text('Booking updated failed!')))
                  : ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                      backgroundColor: Colors.red,
                      content: Text('Failed to submit booking')));
            }
          },
          builder: (context, state) {
            return Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  buildText(text: 'Name'),
                  CustomTextField(
                    hintText: 'Enter name',
                    controller: nameController,
                    keyboardType: TextInputType.text,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Name is required';
                      }

                      return null;
                    },
                  ),
                  const SizedBox(height: 12),
                  buildText(text: 'Age'),
                  CustomTextField(
                    hintText: 'Enter age',
                    controller: ageController,
                    keyboardType: TextInputType.number,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Age is required';
                      }
                      final int? age = int.tryParse(value);
                      if (age == null) {
                        return 'Please enter a valid number';
                      } else if (age < 0 || age > 110) {
                        return 'Age must be between 0 and 110';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 12),
                  buildText(text: 'Mobile Number'),
                  CustomTextField(
                    hintText: 'Enter mobile number',
                    controller: mobileNumberController,
                    keyboardType: TextInputType.phone,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Mobile Number is required';
                      }
                      final int? mobileNo = int.tryParse(value);
                      if (mobileNo == null) {
                        return 'Please enter a valid number';
                      }
                      if (value.length < 10 || value.length > 15) {
                        return 'Mobile Number must be between 10 and 15 digits';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 12),
                  buildText(text: 'Alternate Mobile Number'),
                  CustomTextField(
                    hintText: 'Enter alternate mobile number',
                    controller: alternateMobileNumberController,
                    keyboardType: TextInputType.phone,
                    validator: (value) {
                      return null;
                    },
                  ),
                  const SizedBox(height: 12),
                  buildText(text: 'Gender'),
                  _buildGenderSelection(),
                  const SizedBox(height: 12),
                  buildText(text: 'Service Type'),
                  const SizedBox(height: 8),
                  state is ServiceTypeLoading
                      ? _buildServiceTypeDropdownShimmer()
                      : state is ServiceTypeLoadedDate
                          ? _buildServiceTypeDropdown(
                              serviceTypeList: state.serviceTypeList)
                          : const SizedBox(),
                  const SizedBox(height: 12),
                  buildText(text: 'Total Amount'),
                  CustomTextField(
                      hintText: 'Enter total amount',
                      controller: totalAmountController,
                      keyboardType: TextInputType.number,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Total Amount is required';
                        }
                        return null;
                      }),
                  const SizedBox(height: 12),
                  buildText(text: 'Advance Amount'),
                  CustomTextField(
                    hintText: 'Enter advance amount',
                    controller: advanceAmountController,
                    keyboardType: TextInputType.number,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please give a amount as 0.';
                      }
                      final double? advanceAmount = double.tryParse(value);
                      final double totalAmount =
                          double.tryParse(totalAmountController.text) ?? 0.0;
                      if (advanceAmount == null) {
                        return 'Please enter a valid amount';
                      } else if (advanceAmount > totalAmount) {
                        return 'Advance Amount cannot be more than Total Amount';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 12),
                  buildText(text: 'Balance Amount'),
                  CustomTextField(
                      hintText: 'Balance amount',
                      controller: balanceAmountController,
                      keyboardType: TextInputType.number,
                      readOnly: true),
                  const SizedBox(height: 12),
                  buildText(text: 'Expected Delivery Date'),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      Expanded(
                          child: TextFormField(
                        readOnly: true,
                        controller: _dateController,
                        onTap: () => _selectDate(context),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Date is required';
                          }
                          return null;
                        },
                        decoration: const InputDecoration(
                            hintText: 'Select Date',
                            fillColor: Colors.white,
                            filled: true,
                            border: OutlineInputBorder(),
                            focusedBorder: OutlineInputBorder(),
                            contentPadding: EdgeInsets.symmetric(
                                vertical: 8.0, horizontal: 12.0)),
                      )),
                      const SizedBox(width: 8),
                      Expanded(
                          child: TextFormField(
                        controller: _timeController,
                        readOnly: true,
                        onTap: () => _selectTime(context),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Time is required';
                          }
                          return null;
                        },
                        cursorColor: AppColors.primaryColor,
                        decoration: const InputDecoration(
                            fillColor: Colors.white,
                            filled: true,
                            hintText: 'Select Time',
                            border: OutlineInputBorder(),
                            focusedBorder: OutlineInputBorder(),
                            contentPadding: EdgeInsets.symmetric(
                                vertical: 8.0, horizontal: 12.0)),
                      ))
                    ],
                  ),
                  const SizedBox(height: 12),
                  buildText(text: 'Measurement'),
                  const SizedBox(height: 8),
                  _buildTextArea(
                    controller: measurementController,
                    maxLines: 5,
                    hintText: 'Enter measurements',
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Measurement is required';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 12),
                  buildText(text: 'Address'),
                  const SizedBox(height: 8),
                  _buildTextArea(
                      controller: addressController,
                      maxLines: 3,
                      hintText: 'Enter address',
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Address is required';
                        }
                        return null;
                      }),
                  const SizedBox(height: 12),
                  buildText(text: 'Comments'),
                  const SizedBox(height: 8),
                  _buildTextArea(
                    controller: commentController,
                    maxLines: 3,
                    hintText: 'Enter comments',
                    validator: (value) {
                      return null;
                    },
                  ),
                  const SizedBox(height: 12),
                  _buildImagePicker(),
                  const SizedBox(height: 12),
                  _images.isEmpty
                      ? const Center(
                          child: Text('Please select at least one image',
                              style: TextStyle(color: Colors.red),
                              textAlign: TextAlign.center),
                        )
                      : _buildImagePreview(),
                  const SizedBox(height: 80),
                ],
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildGenderSelection() {
    return Row(
      children: [
        Expanded(
          child: ListTile(
            title: const Text('Male'),
            leading: Radio<String>(
              activeColor: AppColors.primaryColor,
              value: 'Male',
              groupValue: _selectedGender,
              onChanged: (String? value) {
                setState(() {
                  _selectedGender = value!;
                });
              },
            ),
          ),
        ),
        Expanded(
          child: ListTile(
            title: const Text('Female'),
            leading: Radio<String>(
              activeColor: AppColors.primaryColor,
              value: 'Female',
              groupValue: _selectedGender,
              onChanged: (String? value) {
                setState(() {
                  _selectedGender = value!;
                });
              },
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildServiceTypeDropdown(
      {required List<ServiceTypes> serviceTypeList}) {
    return DropdownButtonFormField<ServiceTypes>(
      value: _selectedServiceTypeName != null
          ? serviceTypeList.firstWhere(
              (type) => type.serviceName == _selectedServiceTypeName)
          : null,
      hint: const Text('Select service type'),
      items: serviceTypeList.map((ServiceTypes type) {
        return DropdownMenuItem<ServiceTypes>(
          value: type,
          child: Text(type.serviceName!),
        );
      }).toList(),
      onChanged: (ServiceTypes? newValue) {
        setState(() {
          _selectedServiceTypeName = newValue?.serviceName;
          _selectedServiceTypeId = newValue?.id;
        });
      },
      decoration: InputDecoration(
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8.0),
          borderSide: BorderSide(color: Colors.grey.shade400, width: 2.0),
        ),
        contentPadding:
            const EdgeInsets.symmetric(vertical: 8.0, horizontal: 12.0),
      ),
    );
  }

  Widget _buildServiceTypeDropdownShimmer() {
    return Shimmer.fromColors(
      baseColor: Colors.grey[300]!,
      highlightColor: Colors.grey[100]!,
      child: Container(
        width: double.infinity,
        height: 60.0,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(8.0),
        ),
      ),
    );
  }

  Widget _buildTextArea(
      {required TextEditingController controller,
      required int maxLines,
      required String hintText,
      required String? Function(String?)? validator}) {
    return TextFormField(
      controller: controller,
      maxLines: maxLines,
      cursorColor: AppColors.primaryColor,
      validator: validator,
      decoration: InputDecoration(
        hintText: hintText,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8.0),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8.0),
          borderSide:
              const BorderSide(color: AppColors.primaryColor, width: 2.0),
        ),
        contentPadding:
            const EdgeInsets.symmetric(vertical: 8.0, horizontal: 12.0),
      ),
    );
  }

  Widget _buildImagePicker() {
    return CustomSmallButton(onTap: _pickImageFromCamera, label: 'Pick Images');
  }

  Future<void> _pickImageFromCamera() async {
    try {
      final XFile? pickedFile =
          await _picker.pickImage(source: ImageSource.camera);
      if (pickedFile != null) {
        CroppedFile? croppedFile = await cropImage(sourcePath: pickedFile.path);
        if (croppedFile != null) {
          setState(() {
            _images.add(File(croppedFile.path));
          });
        }
      }
    } catch (e) {
      log('Error picking image from camera: $e');
    }
  }

  Future<CroppedFile?> cropImage({required String sourcePath}) async {
    return await ImageCropper().cropImage(
      sourcePath: sourcePath,
      maxWidth: 512,
      maxHeight: 512,
      aspectRatio: const CropAspectRatio(ratioX: 1.0, ratioY: 1.0),
      compressFormat: ImageCompressFormat.jpg,
      compressQuality: 90,
      uiSettings: [
        AndroidUiSettings(
          toolbarTitle: 'Crop Image',
          toolbarColor: Colors.deepPurple,
          toolbarWidgetColor: Colors.white,
          activeControlsWidgetColor: Colors.deepPurple,
          initAspectRatio: CropAspectRatioPreset.square,
          lockAspectRatio: true,
        ),
        IOSUiSettings(
          title: 'Crop Image',
        ),
      ],
    );
  }

  Widget _buildImagePreview() {
    return SizedBox(
      height: 100,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: _images.length,
        itemBuilder: (context, index) {
          return Stack(
            children: [
              Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 4.0),
                  child: ClipRRect(
                      borderRadius: BorderRadius.circular(8.0),
                      child: Container(
                          width: 150,
                          height: 150,
                          decoration: BoxDecoration(
                              image: DecorationImage(
                                  image: FileImage(_images[index]),
                                  fit: BoxFit.cover))))),
              IconButton(
                  onPressed: () {
                    setState(() {
                      _images.removeAt(index);
                    });
                  },
                  icon: const Icon(Icons.delete, color: Colors.red)),
            ],
          );
        },
      ),
    );
  }

  Text buildText({required String text}) {
    return Text(
      text,
      style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w500),
    );
  }
}
