class HomeState {
  final int selectedTab;
  final bool showAppBar;

  const HomeState({
    required this.selectedTab,
    required this.showAppBar,
  });

  HomeState copyWith({
    int? selectedTab,
    bool? showAppBar,
  }) {
    return HomeState(
      selectedTab: selectedTab ?? this.selectedTab,
      showAppBar: showAppBar ?? this.showAppBar,
    );
  }
}