import 'dart:async';
import 'dart:convert';
import 'dart:typed_data';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:eventure/core/utils/theme/colors.dart';
import 'package:eventure/features/admin_Dashboard/model/firestore_event_model.dart';
import 'package:eventure/features/admin_Dashboard/presentation/widgets/event_textfield.dart';
import 'package:eventure/features/admin_Dashboard/presentation/widgets/number_input.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:simple_barcode_scanner/simple_barcode_scanner.dart';

class EditEvent extends StatefulWidget {
  final FSEvent event;

  const EditEvent({super.key, required this.event});

  @override
  State<EditEvent> createState() => _EditEventState();
}

class _EditEventState extends State<EditEvent> {
  final _formKey = GlobalKey<FormState>();
  Uint8List? _webImage;
  DateTime? selectedDateTime;
  final titleController = TextEditingController();
  final dateTimeController = TextEditingController();
  final dateTimeContdescriptionControllerroller = TextEditingController();
  final descriptionController = TextEditingController();
  final locationController = TextEditingController();
  final priceController = TextEditingController();
  final seatsController = TextEditingController();
  final addressController = TextEditingController();
  String encodedImg = '';

  @override
  void initState() {
    super.initState();
    titleController.text = widget.event.title;
    selectedDateTime = widget.event.dateTime;
    dateTimeController.text =
        DateFormat('yyyy-MM-dd HH:mm').format(selectedDateTime!);
    descriptionController.text = widget.event.description;
    locationController.text = widget.event.location;
    priceController.text = widget.event.price.toString();
    seatsController.text = widget.event.seats.toString();
    addressController.text = widget.event.address;
    encodedImg = widget.event.cover;
  }

  Future<void> _pickDateTime(BuildContext context) async {
    DateTime? date = await showDatePicker(
      context: context,
      firstDate: DateTime.now(),
      lastDate: DateTime(2100),
    );
    if (date != null) {
      if (!context.mounted) return;
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
              DateFormat('yyyy-MM-dd HH:mm').format(selectedDateTime!);
        });
      }
    }
  }

  Future<void> _pickImage() async {
    final ImagePicker picker = ImagePicker();
    final XFile? pickedFile =
        await picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      Uint8List imageBytes = await pickedFile.readAsBytes();
      setState(() {
        _webImage = imageBytes;
        encodedImg = base64Encode(imageBytes);
      });
    }
  }

  Future<void> _updateEvent() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    try {
      final updatedEvent = {
        "title": titleController.text.trim(),
        "dateTime": selectedDateTime ?? widget.event.dateTime,
        "description": descriptionController.text.trim(),
        "location": locationController.text.trim(),
        "price": priceController.text.trim(),
        "seats": int.tryParse(seatsController.text) ?? widget.event.seats,
        "address": addressController.text.trim(),
        "cover":
            _webImage != null ? base64Encode(_webImage!) : widget.event.cover,
      };

      await FirebaseFirestore.instance
          .collection("events")
          .doc(widget.event.id)
          .update(updatedEvent);

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Event updated successfully!")),
      );

      Navigator.pop(context, true);
    } catch (error) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Failed to update event: $error")),
      );
    }
  }

  _scan() {
    FutureBuilder<String?>(
      future: SimpleBarcodeScanner.scanBarcode(context),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.done) {
          if (snapshot.hasData) {
            return Text('Scanned Code: ${snapshot.data}');
          } else {
            return const Text('No code scanned.');
          }
        } else {
          return const CircularProgressIndicator();
        }
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    print(widget.event.registeredUsers);
    double padding = 0;

    if (ScreenUtil().screenWidth > 1500) padding = 200;
    if (ScreenUtil().screenWidth > 1250) padding = 100;
    if (ScreenUtil().screenWidth < 1250) padding = 50;

    return Scaffold(
      backgroundColor: kMainDark,
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          await _scan();
        },
        child: Icon(Icons.barcode_reader),
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(vertical: 20.0, horizontal: padding),
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.only(top: 20.0),
              child: Row(
                children: [
                  IconButton(
                    onPressed: () => Navigator.pop(context),
                    icon: Icon(Icons.arrow_back, color: Colors.white),
                  ),
                  Expanded(
                    child: Center(
                      child: Text(
                        widget.event.title,
                        style: TextStyle(
                          fontSize: 25,
                          color: white,
                          fontWeight: FontWeight.w900,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Form(
              key: _formKey,
              child: Expanded(
                child: ScreenUtil().screenWidth > 1000
                    ? ListView(
                        children: [
                          const SizedBox(height: 40),
                          Row(
                            children: [
                              Expanded(child: _dataFields()),
                              SizedBox(width: 40),
                              Expanded(child: _imgField()),
                            ],
                          ),
                          const SizedBox(height: 40),
                          _btn(),
                          const SizedBox(height: 40),
                        ],
                      )
                    : ListView(
                        children: [
                          const SizedBox(height: 40),
                          Expanded(child: _imgField()),
                          SizedBox(height: 40),
                          Expanded(child: _dataFields()),
                          const SizedBox(height: 40),
                          _btn(),
                          const SizedBox(height: 40),
                        ],
                      ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _dataFields() {
    return Column(
      children: [
        CustomEventTextField(
          hint: "Enter event title",
          controller: titleController,
        ),
        const SizedBox(height: 20),
        CustomEventTextField(
          hint: "Select Date & Time",
          controller: dateTimeController,
          icon: Icons.calendar_today,
          readOnly: true,
          onTap: () => _pickDateTime(context),
        ),
        const SizedBox(height: 20),
        CustomEventTextField(
          hint: "Location 'URL'",
          controller: locationController,
        ),
        const SizedBox(height: 20),
        CustomEventTextField(
          hint: "Price (\$)",
          controller: priceController,
          keyboardType: TextInputType.number,
          onlyDigits: true,
        ),
        const SizedBox(height: 20),
        CustomEventTextField(
          hint: "Address",
          controller: addressController,
        ),
        const SizedBox(height: 20),
        NumericStepperField(
          hint: "Number of Seats",
          controller: seatsController,
        ),
        const SizedBox(height: 20),
        CustomEventTextField(
          hint: "Enter event details",
          controller: descriptionController,
          maxLines: 5,
        ),
      ],
    );
  }

  Widget _imgField() {
    return GestureDetector(
      onTap: _pickImage,
      child: Container(
        decoration: BoxDecoration(
          color: kMainLight,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: kButton2, width: 0.2),
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(12),
          child: Image.memory(
            base64Decode(encodedImg),
            fit: BoxFit.cover,
          ),
        ),
      ),
    );
  }

  Widget _btn() {
    return Center(
      child: SizedBox(
        height: 50,
        width: 450,
        child: FilledButton(
          onPressed: _updateEvent,
          style: ElevatedButton.styleFrom(backgroundColor: kButton2),
          child: const Text(
            "Save Changes",
            style: TextStyle(
                color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),
          ),
        ),
      ),
    );
  }

  @override
  void dispose() async {
    titleController.dispose();
    dateTimeController.dispose();
    descriptionController.dispose();
    locationController.dispose();
    priceController.dispose();
    seatsController.dispose();
    addressController.dispose();

    super.dispose();
  }
}
