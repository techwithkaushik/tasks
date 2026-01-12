import 'package:tasks/item_model.dart';

abstract class ItemRepo {
  List<ItemModel> fetchItems();
  Future<void> addItem(ItemModel item);
  Future<void> delete(ItemModel item);
  Future<void> deleteItems(List<String> ids);
  Future<void> updateItem(ItemModel updated);
  Future<void> toggleFavorite(String id);
}
