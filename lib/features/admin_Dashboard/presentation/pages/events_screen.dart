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
          floatingActionButton: SizedBox(
            height: 70,
            width: 210,
            child: FilledButton.icon(
              onPressed: () async {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => AddEvent()),
                );
              },
              label: Text(
                "Create Event",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                ),
              ),
              icon: Icon(Icons.event_rounded),
            ),
          ),
          backgroundColor: kMainDark,
          body: Column(
            children: [
              Padding(
                padding: const EdgeInsets.only(top: 40.0),
                child: Center(
                  child: Text(
                    'All Events',
                    style: TextStyle(
                      fontSize: 25,
                      color: white,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 20),
              Expanded(
                child: LayoutBuilder(
                  builder: (context, constraints) {
                    int crossAxisCount = 3;

                    if (constraints.maxWidth < 1250) {
                      crossAxisCount = 2;
                    }
                    if (constraints.maxWidth < 850) {
                      crossAxisCount = 1;
                    }

                    return Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 16, vertical: 16),
                      child: BlocBuilder<EventsCubit, EventsState>(
                        builder: (context, state) {
                          if (state is EventsLoading) {
                            return const Center(
                                child: CircularProgressIndicator());
                          } else if (state is EventsError) {
                            return Center(
                                child: Text("Error: ${state.message}"));
                          } else if (state is EventsLoaded) {
                            return GridView.builder(
                              gridDelegate:
                                  SliverGridDelegateWithFixedCrossAxisCount(
                                crossAxisCount: crossAxisCount,
                                crossAxisSpacing: 50,
                                mainAxisSpacing: 20,
                                mainAxisExtent: 350,
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
            ],
          ),
        ),
      ),
    );
  }
}
