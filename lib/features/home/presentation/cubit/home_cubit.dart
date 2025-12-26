import 'package:flutter_bloc/flutter_bloc.dart';
import 'home_state.dart';

class HomeCubit extends Cubit<HomeState> {
  HomeCubit()
      : super(const HomeState(
    selectedTab: 0,
    showAppBar: true,
  ));

  void changeTab(int index) {
    emit(
      state.copyWith(
        selectedTab: index,
        showAppBar: true,
      ),
    );
  }

  void hideAppBar() {
    if (state.showAppBar) {
      emit(state.copyWith(showAppBar: false));
    }
  }

  void showAppBar() {
    if (!state.showAppBar) {
      emit(state.copyWith(showAppBar: true));
    }
  }
}