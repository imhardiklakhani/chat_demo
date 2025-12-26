import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/constants/app_strings.dart';
import '../../data/repository/history_repository.dart';
import 'history_state.dart';

class HistoryCubit extends Cubit<HistoryState> {
  HistoryCubit(this._repository) : super(const HistoryInitial());

  final HistoryRepository _repository;

  Future<void> loadHistory() async {
    emit(const HistoryLoading());

    try {
      final items = await _repository.fetchHistory();
      emit(HistorySuccess(items));
    } catch (_) {
      emit(const HistoryError(AppStrings.failedToLoadHistory));
    }
  }
}
