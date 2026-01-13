part of 'item_bloc.dart';

sealed class ItemState extends Equatable {
  @override
  List<Object?> get props => [];
}

class LoadingItemState extends ItemState {}

class LoadedItemState extends ItemState {
  final List<ItemModel> items;
  final Set<int> selectedIds;
  final String? formError;

  LoadedItemState({
    required this.items,
    this.selectedIds = const {},
    this.formError,
  });

  bool get selectionMode => selectedIds.isNotEmpty;

  LoadedItemState copyWith({
    List<ItemModel>? items,
    Set<int>? selectedIds,
    String? formError,
  }) {
    return LoadedItemState(
      items: items ?? this.items,
      selectedIds: selectedIds ?? this.selectedIds,
      formError: formError,
    );
  }

  @override
  List<Object?> get props => [items, selectedIds, formError];
}

class ErrorItemState extends ItemState {
  final String message;
  ErrorItemState(this.message);
  @override
  List<Object?> get props => [message];
}
