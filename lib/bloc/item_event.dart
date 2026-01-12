part of 'item_bloc.dart';

sealed class ItemEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

class LoadItemsEvent extends ItemEvent {}

class AddItemEvent extends ItemEvent {
  final String title;
  AddItemEvent(this.title);
}

class ToggleFavoriteEvent extends ItemEvent {
  final String id;
  ToggleFavoriteEvent(this.id);
}

class ToggleSelectItemEvent extends ItemEvent {
  final String id;
  ToggleSelectItemEvent(this.id);
}

class ClearSelectionEvent extends ItemEvent {}

class DeleteSelectedEvent extends ItemEvent {}

class ValidateTitleEvent extends ItemEvent {
  final String title;
  ValidateTitleEvent(this.title);

  @override
  List<Object?> get props => [title];
}
