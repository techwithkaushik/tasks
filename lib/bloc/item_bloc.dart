import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:tasks/item_model.dart';
import 'package:tasks/item_repo_impl.dart';

part 'item_event.dart';
part 'item_state.dart';

class ItemBloc extends Bloc<ItemEvent, ItemState> {
  final ItemRepoImpl repo;
  StreamSubscription? _isarSub;

  ItemBloc({required this.repo}) : super(LoadingItemState()) {
    on<StartWatcherEvent>(_onStartWatcher);
    on<LoadItemsEvent>(_onLoadItems);
    on<_ItemsUpdatedEvent>(_onItemsUpdated);
    on<AddItemEvent>(_onAddItem);
    on<ToggleFavoriteEvent>(_onToggleFavorite);
    on<ToggleSelectItemEvent>(_onToggleSelect);
    on<ClearSelectionEvent>(_onClearSelection);
    on<DeleteSelectedEvent>(_onDeleteSelected);
    on<ValidateTitleEvent>(_onValidateTitleEvent);
  }

  // --- Watcher Setup ---
  Future<void> _onStartWatcher(
    StartWatcherEvent event,
    Emitter<ItemState> emit,
  ) async {
    final isar = await repo.db;

    _isarSub?.cancel();
    _isarSub = isar.itemModels.watchLazy().listen((_) {
      if (state is LoadedItemState) {
        add(_ItemsUpdatedEvent());
      }
    });
  }

  Future<void> _onItemsUpdated(
    _ItemsUpdatedEvent event,
    Emitter<ItemState> emit,
  ) async {
    if (state is LoadedItemState) {
      final current = state as LoadedItemState;
      final items = await repo.fetchItems();
      final updatedIds = current.selectedIds
          .where((id) => items.any((e) => e.id == id))
          .toSet();

      emit(current.copyWith(items: items, selectedIds: updatedIds));
    }
  }

  bool _isDuplicate(String title, List<ItemModel> items) {
    return items.any((e) => e.title.trim() == title.trim());
  }

  Future<void> _onLoadItems(
    LoadItemsEvent event,
    Emitter<ItemState> emit,
  ) async {
    emit(LoadingItemState());
    final items = await repo.fetchItems();
    emit(LoadedItemState(items: items));
  }

  Future<void> _onAddItem(AddItemEvent event, Emitter<ItemState> emit) async {
    if (state is! LoadedItemState) return;
    final current = state as LoadedItemState;

    final text = event.title.trim();
    if (text.isEmpty) {
      emit(current.copyWith(formError: "Text cannot be empty"));
      return;
    }
    if (_isDuplicate(text, current.items)) {
      emit(current.copyWith(formError: "Duplicate title"));
      return;
    }

    final newItem = ItemModel()..title = text;
    await repo.addItem(newItem);

    emit(current.copyWith(formError: null));
  }

  Future<void> _onToggleFavorite(
    ToggleFavoriteEvent event,
    Emitter<ItemState> emit,
  ) async {
    if (state is! LoadedItemState) return;
    final current = state as LoadedItemState;

    await repo.toggleFavorite(event.id);

    emit(current.copyWith());
  }

  void _onToggleSelect(ToggleSelectItemEvent event, Emitter<ItemState> emit) {
    if (state is! LoadedItemState) return;
    final current = state as LoadedItemState;

    final selected = Set<int>.from(current.selectedIds);
    selected.contains(event.id)
        ? selected.remove(event.id)
        : selected.add(event.id);

    emit(current.copyWith(selectedIds: selected));
  }

  void _onClearSelection(ClearSelectionEvent event, Emitter<ItemState> emit) {
    if (state is! LoadedItemState) return;
    final current = state as LoadedItemState;
    emit(current.copyWith(selectedIds: {}));
  }

  Future<void> _onDeleteSelected(
    DeleteSelectedEvent event,
    Emitter<ItemState> emit,
  ) async {
    if (state is! LoadedItemState) return;
    final current = state as LoadedItemState;

    await repo.deleteItems(current.selectedIds.toList());

    emit(current.copyWith(selectedIds: {}));
  }

  void _onValidateTitleEvent(
    ValidateTitleEvent event,
    Emitter<ItemState> emit,
  ) {
    if (state is! LoadedItemState) return;
    final current = state as LoadedItemState;
    final text = event.title.trim();

    if (text.isEmpty) {
      emit(current.copyWith(formError: "Text cannot be empty"));
      return;
    }
    if (_isDuplicate(text, current.items)) {
      emit(current.copyWith(formError: "Duplicate title"));
      return;
    }

    if (current.formError != null) {
      emit(current.copyWith(formError: null));
    }
  }

  @override
  Future<void> close() {
    _isarSub?.cancel();
    return super.close();
  }
}
