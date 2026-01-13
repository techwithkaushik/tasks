import 'package:isar_community/isar.dart';

part 'item_model.g.dart';

@collection
class ItemModel {
  Id id = Isar.autoIncrement;

  late String title;

  @Index()
  bool isFavorite = false;
}
