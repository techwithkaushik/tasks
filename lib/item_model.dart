import 'package:equatable/equatable.dart';

class ItemModel extends Equatable {
  final String id;
  final String title;
  final bool isFavorite;

  const ItemModel({
    required this.id,
    required this.title,
    this.isFavorite = false,
  });

  ItemModel copyWith({String? id, String? title, bool? isFavorite}) {
    return ItemModel(
      id: id ?? this.id,
      title: title ?? this.title,
      isFavorite: isFavorite ?? this.isFavorite,
    );
  }

  @override
  List<Object?> get props => [id, title, isFavorite];
}
