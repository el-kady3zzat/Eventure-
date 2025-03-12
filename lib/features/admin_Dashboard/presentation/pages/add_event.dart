import 'dart:convert';
import 'package:eventure/core/utils/theme/colors.dart';
import 'package:eventure/features/admin_Dashboard/presentation/Cubit/events/events_cubit.dart';
import 'package:eventure/features/admin_Dashboard/presentation/pages/events_screen.dart';
import 'package:eventure/features/admin_Dashboard/presentation/widgets/event_textfield.dart';
import 'package:eventure/features/admin_Dashboard/presentation/widgets/number_input.dart';
import 'package:eventure/features/admin_Dashboard/Logic/notifications_handler.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_picker/image_picker.dart';

class AddEvent extends StatefulWidget {
  const AddEvent({super.key});

  @override
  State<AddEvent> createState() => _AddEventState();
}

class _AddEventState extends State<AddEvent> {
  final _formKey = GlobalKey<FormState>();
  Uint8List? _webImage;
  DateTime? selectedDateTime;
  TextEditingController addressController = TextEditingController();
  TextEditingController coverController = TextEditingController();
  TextEditingController dateTimeController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();
  TextEditingController locationController = TextEditingController();
  TextEditingController priceController = TextEditingController();
  TextEditingController seatsController = TextEditingController();
  TextEditingController titleController = TextEditingController();

  Future<void> _pickDateTime(BuildContext context) async {
    FocusScope.of(context).unfocus();

    DateTime? date = await showDatePicker(
      context: context,
      firstDate: DateTime.now(),
      lastDate: DateTime(2100),
    );
    if (date != null) {
      TimeOfDay? time = await showTimePicker(
        context: context,
        initialTime: TimeOfDay.now(),
      );
      if (time != null) {
        setState(() {
          selectedDateTime = DateTime(
            date.year,
            date.month,
            date.day,
            time.hour,
            time.minute,
          );
          dateTimeController.text =
              "${date.year}-${date.month}-${date.day} ${time.format(context)}";
        });
      }
    }
  }

  Future<void> _pickImage() async {
    final ImagePicker picker = ImagePicker();
    final XFile? pickedFile =
        await picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      if (kIsWeb) {
        Uint8List imageBytes = await pickedFile.readAsBytes();
        setState(() {
          _webImage = imageBytes;
          coverController.text = base64Encode(imageBytes);
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => EventsCubit(),
      child: GestureDetector(
        onTap: () {
          FocusScope.of(context).unfocus();
        },
        child: Scaffold(
          backgroundColor: kMainDark,
          appBar: AppBar(
            title: Text(
              "Create New Event",
              style: TextStyle(
                  fontSize: 30, color: white, fontWeight: FontWeight.w900),
            ),
            backgroundColor: kMainDark,
            iconTheme: IconThemeData(
              color: Colors.white,
            ),
          ),
          body: Padding(
            padding:
                const EdgeInsets.symmetric(vertical: 20.0, horizontal: 200),
            child: Form(
              key: _formKey,
              child: ListView(
                children: [
                  SizedBox(
                    height: 30,
                  ),
                  Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        GestureDetector(
                          onTap: _pickImage,
                          child: Container(
                            height: 120,
                            width: 250,
                            decoration: BoxDecoration(
                              color: kMainLight,
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(color: kButton2, width: 0.2),
                              image: _webImage != null
                                  ? DecorationImage(
                                      image: MemoryImage(_webImage!),
                                      fit: BoxFit.cover,
                                    )
                                  : null,
                            ),
                            child: _webImage == null
                                ? const Center(
                                    child: Icon(Icons.image,
                                        size: 50, color: Colors.white),
                                  )
                                : null,
                          ),
                        ),
                        SizedBox(height: 20),
                        Text(
                          "Tap to pick an image",
                          style: TextStyle(color: Colors.white),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  Row(
                    children: [
                      Expanded(
                        child: CustomEventTextField(
                          hint: "Enter event title",
                          controller: titleController,
                          validator: (value) {
                            if (value == null || value.trim().isEmpty) {
                              return "Title is required";
                            }
                            return null;
                          },
                        ),
                      ),
                      SizedBox(
                        width: 10,
                      ),
                      Expanded(
                        child: CustomEventTextField(
                          hint: "Select Date & Time",
                          controller: dateTimeController,
                          icon: Icons.calendar_today,
                          readOnly: true,
                          onTap: () => _pickDateTime(context),
                          validator: (value) {
                            if (value == null || value.trim().isEmpty) {
                              return "Date and Time are required";
                            }
                            return null;
                          },
                        ),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  Row(
                    children: [
                      Expanded(
                        child: CustomEventTextField(
                            hint: "Location 'URL'",
                            controller: locationController,
                            validator: (value) {
                              if (value == null || value.trim().isEmpty) {
                                return "Location is required";
                              }
                              return null;
                            },
                            icon: Icons.location_on),
                      ),
                      SizedBox(
                        width: 10,
                      ),
                      Expanded(
                        child: CustomEventTextField(
                          hint: "Price (\$)",
                          controller: priceController,
                          keyboardType: TextInputType.number,
                          onlyDigits: true,
                          validator: (value) {
                            if (value == null || value.trim().isEmpty) {
                              return "Price is required";
                            }
                            return null;
                          },
                        ),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  Row(
                    children: [
                      Expanded(
                        child: CustomEventTextField(
                          hint: "Address",
                          controller: addressController,
                          validator: (value) {
                            if (value == null || value.trim().isEmpty) {
                              return "Address is required";
                            }
                            return null;
                          },
                        ),
                      ),
                      SizedBox(
                        width: 10,
                      ),
                      Expanded(
                        child: NumericStepperField(
                          hint: "Number of Seats",
                          controller: seatsController,
                          icon: Icons.chair,
                          validator: (value) {
                            if (value == null || value.trim().isEmpty) {
                              return "Number of seats is required";
                            }
                            return null;
                          },
                        ),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  Row(
                    children: [
                      Expanded(
                        child: CustomEventTextField(
                          hint: "Enter event details",
                          controller: descriptionController,
                          maxLines: 5,
                          validator: (value) {
                            if (value == null || value.trim().isEmpty) {
                              return "Details are required";
                            }
                            return null;
                          },
                        ),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 40,
                  ),
                  Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: SizedBox(
                      height: 50,
                      child: BlocConsumer<EventsCubit, EventsState>(
                        listener: (context, state) {
                          if (state is AddEventError) {
                            Fluttertoast.showToast(
                              msg: state.message,
                              toastLength: Toast.LENGTH_SHORT,
                              gravity: ToastGravity.BOTTOM,
                              backgroundColor: Colors.red,
                              textColor: Colors.white,
                            );
                          } else if (state is AddEventSuccess) {
                            Navigator.pushAndRemoveUntil(
                              context,
                              MaterialPageRoute(
                                builder: (context) => EventsScreen(),
                              ),
                              (route) => false,
                            );
                            Fluttertoast.showToast(
                              msg: "New Event Created Successfully",
                              toastLength: Toast.LENGTH_SHORT,
                              gravity: ToastGravity.BOTTOM,
                              backgroundColor: Colors.green,
                              textColor: Colors.white,
                            );
                          }
                        },
                        builder: (context, state) {
                          if (state is AddEventLoading) {
                            return Center(
                              child: CircularProgressIndicator(
                                color: white,
                              ),
                            );
                          }
                          return FilledButton(
                            onPressed: () async {
                              if (_formKey.currentState!.validate()) {
                                if (_webImage == null) {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                      content: Text(
                                          "Please select a cover image for the event."),
                                      backgroundColor: Colors.red,
                                    ),
                                  );
                                  return;
                                }

                                context.read<EventsCubit>().addEvent(
                                    address: addressController.text,
                                    title: titleController.text,
                                    seats: seatsController.text,
                                    selectedDateTime: selectedDateTime!,
                                    description: descriptionController.text,
                                    price: priceController.text,
                                    location: locationController.text,
                                    cover: coverController.text);
                                await NotificationService()
                                    .sendNotificationToAll();
                              }
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: kButton2,
                            ),
                            child: Text(
                              "Create Event",
                              style: TextStyle(
                                  color: white,
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold),
                            ),
                          );
                        },
                      ),
                    ),
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    addressController.dispose();
    coverController.dispose();
    dateTimeController.dispose();
    descriptionController.dispose();
    locationController.dispose();
    priceController.dispose();
    seatsController.dispose();
    super.dispose();
  }
}
