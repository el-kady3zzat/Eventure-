import 'package:equatable/equatable.dart';

abstract class Failure extends Equatable {
  final String message;
  const Failure(this.message);

  @override
  List<Object?> get props => [message];
}

class EventFailure extends Failure {
  const EventFailure([super.message = 'Failed Loading Events']);
}
