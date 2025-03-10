part of 'scroll_bloc.dart';

abstract class ScrollEvent {}

class ScrollUpdated extends ScrollEvent {
  final double scrollOffset;
  ScrollUpdated(this.scrollOffset);
}
