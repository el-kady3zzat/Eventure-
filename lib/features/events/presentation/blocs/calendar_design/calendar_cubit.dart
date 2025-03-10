import 'package:flutter_bloc/flutter_bloc.dart';

part 'calendar_state.dart';

class CalendarCubit extends Cubit<DateTime> {
  CalendarCubit() : super(DateTime.now());

  void selectMonth(DateTime newMonth) => emit(newMonth);
}
