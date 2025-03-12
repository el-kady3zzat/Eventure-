import 'package:eventure/core/utils/theme/colors.dart';
import 'package:eventure/features/admin_Dashboard/presentation/Cubit/events/events_cubit.dart';
import 'package:eventure/features/admin_Dashboard/presentation/pages/add_event.dart';
import 'package:eventure/features/admin_Dashboard/presentation/widgets/event_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class EventsScreen extends StatelessWidget {
  const EventsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => EventsCubit()..fetchEvents(),
      child: SafeArea(
        child: Scaffold(
          backgroundColor: kMainDark,
          appBar: AppBar(
            title: Text(
              "All Events",
              style: TextStyle(
                  fontSize: 30, color: white, fontWeight: FontWeight.w900),
            ),
            centerTitle: true,
            backgroundColor: kMainDark,
            actions: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: FilledButton(
                  onPressed: () async {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => AddEvent()),
                    );
                  },
                  child: Text(
                    "Add Event",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              )
            ],
          ),
          body: LayoutBuilder(
            builder: (context, constraints) {
              int crossAxisCount = 3;

              if (constraints.maxWidth < 1200) {
                crossAxisCount = 2;
              }
              if (constraints.maxWidth < 800) {
                crossAxisCount = 1;
              }

              return Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 50, vertical: 50),
                child: BlocBuilder<EventsCubit, EventsState>(
                  builder: (context, state) {
                    if (state is EventsLoading) {
                      return const Center(child: CircularProgressIndicator());
                    } else if (state is EventsError) {
                      return Center(child: Text("Error: ${state.message}"));
                    } else if (state is EventsLoaded) {
                      return GridView.builder(
                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: crossAxisCount,
                          crossAxisSpacing: 50,
                          mainAxisSpacing: 20,
                          mainAxisExtent: 260,
                        ),
                        itemCount: state.events.length,
                        itemBuilder: (BuildContext context, int index) {
                          final event = state.events[index];
                          return WebEventCard(event: event);
                        },
                      );
                    }
                    return const Center(child: Text("No events found"));
                  },
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}
