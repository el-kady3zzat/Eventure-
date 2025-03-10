import 'package:flutter_bloc/flutter_bloc.dart';

part 'scroll_event.dart';
part 'scroll_state.dart';

class ScrollBloc extends Bloc<ScrollEvent, ScrollState> {
  ScrollBloc() : super(ScrollState(0.0)) {
    on<ScrollUpdated>((event, emit) {
      double newOpacity = (event.scrollOffset / 300).clamp(0.0, 1.0);
      emit(ScrollState(newOpacity));
    });
  }
}
