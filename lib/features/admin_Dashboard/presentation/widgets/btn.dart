import 'package:eventure/core/utils/theme/colors.dart';
import 'package:eventure/features/admin_Dashboard/model/firestore_event_model.dart';
import 'package:eventure/features/admin_Dashboard/presentation/pages/edit_event.dart';
import 'package:flutter/material.dart';

class Btn extends StatelessWidget {
  final FSEvent event;
  const Btn({super.key, required this.event});

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      style: ButtonStyle(
        backgroundColor: WidgetStatePropertyAll(kButton),
      ),
      onPressed: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => EditEvent(
              event: event,
            ),
          ),
        );
      },
      child: const Text(
        'Edit',
        style: TextStyle(
          color: Colors.black,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}
