abstract class HistoryState {
  const HistoryState();
}

class HistoryInitial extends HistoryState {
  const HistoryInitial();
}

class HistoryLoading extends HistoryState {
  const HistoryLoading();
}

class HistorySuccess extends HistoryState {
  final List items;

  const HistorySuccess(this.items);
}

class HistoryError extends HistoryState {
  final String message;

  const HistoryError(this.message);
}