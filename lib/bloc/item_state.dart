part of 'item_bloc.dart';

sealed class ItemState extends Equatable {
  @override
  List<Object?> get props => [];
}

class ItemLoadingState extends ItemState {}

class ItemLoadedState extends ItemState {
  final List<ItemModel> items;
  final Set<String> selectedIds;
  final String? formError;

  ItemLoadedState({
    required this.items,
    this.selectedIds = const {},
    this.formError,
  });

  bool get selectionMode => selectedIds.isNotEmpty;

  ItemLoadedState copyWith({
    List<ItemModel>? items,
    Set<String>? selectedIds,
    String? formError,
  }) {
    return ItemLoadedState(
      items: items ?? this.items,
      selectedIds: selectedIds ?? this.selectedIds,
      formError: formError,
    );
  }

  @override
  List<Object?> get props => [items, selectedIds, formError];
}

class ItemErrorState extends ItemState {
  final String message;
  ItemErrorState(this.message);
  @override
  List<Object?> get props => [message];
}
