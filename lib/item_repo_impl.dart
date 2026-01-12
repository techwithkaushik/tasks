import 'package:tasks/item_model.dart';
import 'package:tasks/item_repo.dart';

class ItemRepoImpl extends ItemRepo {
  final List<ItemModel> _itemList = [];

  @override
  List<ItemModel> fetchItems() {
    return List<ItemModel>.from(_itemList);
  }

  @override
  Future<void> addItem(ItemModel item) async {
    _itemList.add(item);
  }

  @override
  Future<void> delete(ItemModel item) async {
    _itemList.removeWhere((e) => e.id == item.id);
  }

  @override
  Future<void> deleteItems(List<String> ids) async {
    _itemList.removeWhere((e) => ids.contains(e.id));
  }

  @override
  Future<void> updateItem(ItemModel updated) async {
    final index = _itemList.indexWhere((e) => e.id == updated.id);
    if (index != -1) {
      _itemList[index] = updated;
    }
  }

  @override
  Future<void> toggleFavorite(String id) async {
    final index = _itemList.indexWhere((e) => e.id == id);
    if (index != -1) {
      final item = _itemList[index];
      _itemList[index] = item.copyWith(isFavorite: !item.isFavorite);
    }
  }
}
