import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:tasks/item_model.dart';
import 'package:tasks/item_repo_impl.dart';

part 'item_event.dart';
part 'item_state.dart';

class ItemBloc extends Bloc<ItemEvent, ItemState> {
  final ItemRepoImpl repo;

  ItemBloc({required this.repo}) : super(ItemLoadingState()) {
    on<LoadItemsEvent>(_onLoadItems);
    on<AddItemEvent>(_onAddItem);
    on<ToggleFavoriteEvent>(_onToggleFavorite);
    on<ToggleSelectItemEvent>(_onToggleSelect);
    on<ClearSelectionEvent>(_onClearSelection);
    on<DeleteSelectedEvent>(_onDeleteSelected);
    on<ValidateTitleEvent>(_onValidateTitleEvent);
  }

  bool _isDuplicate(String title, List<ItemModel> items) {
    return items.any((e) => e.title == title.trim());
  }

  void _onLoadItems(LoadItemsEvent event, Emitter<ItemState> emit) {
    final items = repo.fetchItems();
    emit(ItemLoadedState(items: items));
  }

  void _onAddItem(AddItemEvent event, Emitter<ItemState> emit) {
    final current = state as ItemLoadedState;
    final text = event.title.trim();

    if (text.isEmpty) {
      emit(current.copyWith(formError: "Text cannot be empty"));
      return;
    }

    if (_isDuplicate(text, current.items)) {
      emit(current.copyWith(formError: "Duplicate title"));
      return;
    }

    final newItem = ItemModel(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      title: text,
    );

    repo.addItem(newItem);

    emit(current.copyWith(items: repo.fetchItems(), formError: null));
  }

  void _onToggleFavorite(ToggleFavoriteEvent event, Emitter<ItemState> emit) {
    final current = state as ItemLoadedState;

    repo.toggleFavorite(event.id);

    emit(
      current.copyWith(items: repo.fetchItems(), formError: current.formError),
    );
  }

  void _onToggleSelect(ToggleSelectItemEvent event, Emitter<ItemState> emit) {
    final current = state as ItemLoadedState;
    final selected = Set<String>.from(current.selectedIds);

    selected.contains(event.id)
        ? selected.remove(event.id)
        : selected.add(event.id);

    emit(current.copyWith(selectedIds: selected));
  }

  void _onClearSelection(ClearSelectionEvent event, Emitter<ItemState> emit) {
    final current = state as ItemLoadedState;
    emit(current.copyWith(selectedIds: {}));
  }

  void _onDeleteSelected(DeleteSelectedEvent event, Emitter<ItemState> emit) {
    final current = state as ItemLoadedState;

    repo.deleteItems(current.selectedIds.toList());

    emit(current.copyWith(items: repo.fetchItems(), selectedIds: {}));
  }

  void _onValidateTitleEvent(
    ValidateTitleEvent event,
    Emitter<ItemState> emit,
  ) {
    final current = state as ItemLoadedState;
    final text = event.title.trim();

    if (text.isEmpty) {
      emit(current.copyWith(formError: "Text cannot be empty"));
      return;
    }

    if (_isDuplicate(text, current.items)) {
      emit(current.copyWith(formError: "Duplicate title"));
      return;
    }

    // Clear error when valid
    if (current.formError != null) {
      emit(current.copyWith(formError: null));
    }
  }
}
