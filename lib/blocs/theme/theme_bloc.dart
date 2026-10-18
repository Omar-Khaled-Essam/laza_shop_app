import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'theme_event.dart';
import 'theme_state.dart';

class ThemeBloc extends Bloc<ThemeEvent, ThemeState> {
  ThemeBloc() : super(const ThemeState(mode: ThemeMode.light)) {
    on<ToggleTheme>((event, emit) {
      emit(ThemeState(mode: state.isDark ? ThemeMode.light : ThemeMode.dark));
    });
  }
}
