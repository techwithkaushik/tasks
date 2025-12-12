import 'package:flutter_bloc/flutter_bloc.dart';

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
