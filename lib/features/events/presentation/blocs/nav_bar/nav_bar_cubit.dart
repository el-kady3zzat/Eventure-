import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter/material.dart';

part 'nav_bar_state.dart';

class NavBarCubit extends Cubit<int> {
  NavBarCubit(super.initialState);

  void changePage(int index) => emit(index);
}
