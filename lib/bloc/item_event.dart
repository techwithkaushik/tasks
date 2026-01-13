part of 'item_bloc.dart';

sealed class ItemEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

class StartWatcherEvent extends ItemEvent {}

class LoadItemsEvent extends ItemEvent {}

class _ItemsUpdatedEvent extends ItemEvent {}

class AddItemEvent extends ItemEvent {
  final String title;
  AddItemEvent(this.title);
}

class ToggleFavoriteEvent extends ItemEvent {
  final int id;
  ToggleFavoriteEvent(this.id);
  @override
  List<Object?> get props => [id];
}

class ToggleSelectItemEvent extends ItemEvent {
  final int id;
  ToggleSelectItemEvent(this.id);
  @override
  List<Object?> get props => [id];
}

class ClearSelectionEvent extends ItemEvent {}

class DeleteSelectedEvent extends ItemEvent {}

class ValidateTitleEvent extends ItemEvent {
  final String title;
  ValidateTitleEvent(this.title);

  @override
  List<Object?> get props => [title];
}
