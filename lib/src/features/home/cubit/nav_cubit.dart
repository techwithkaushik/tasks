/// Cubit for managing bottom navigation state and history
///
/// Manages:
/// - Current selected tab index (0 = Tasks, 1 = Settings, 2 = About)
/// - Navigation history for back button handling
/// - Prevents unnecessary rebuilds when selecting the same tab
library;

import 'package:flutter_bloc/flutter_bloc.dart';

/// Controls bottom navigation and maintains navigation history
///
/// State: int (current tab index)
///
/// Features:
/// - Tracks navigation history
/// - Prevents duplicate entries
/// - Handles back navigation with proper history management
class NavCubit extends Cubit<int> {
  NavCubit() : super(0);
  final List<int> _history = [0];

  void setIndex(int index) {
    if (state == index) return;
    _history.add(index);
    emit(index);
  }

  /// Returns true if handled (moved to previous tab),
  /// false if we are already at the first tab.
  bool back() {
    if (_history.length > 1) {
      _history.removeLast();
      emit(_history.last);
      return true;
    }
    return false;
  }
}
