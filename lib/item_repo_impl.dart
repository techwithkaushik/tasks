import 'package:isar_community/isar.dart';
import 'package:path_provider/path_provider.dart';
import 'package:tasks/item_model.dart';

class ItemRepoImpl {
  Isar? _isar;

  /// Getter returns an initialized Isar instance
  Future<Isar> get db async {
    if (_isar != null) return _isar!;

    final dir = await getApplicationDocumentsDirectory();
    _isar = await Isar.open(
      [ItemModelSchema],
      directory: dir.path,
      inspector: true,
    );

    return _isar!;
  }

  /// FETCH
  Future<List<ItemModel>> fetchItems() async {
    final isar = await db;
    return await isar.itemModels.where().findAll();
  }

  /// ADD
  Future<void> addItem(ItemModel item) async {
    final isar = await db;
    await isar.writeTxn(() async {
      await isar.itemModels.put(item);
    });
  }

  /// UPDATE
  Future<void> updateItem(ItemModel item) async {
    final isar = await db;
    await isar.writeTxn(() async {
      await isar.itemModels.put(item);
    });
  }

  /// TOGGLE FAVORITE
  Future<void> toggleFavorite(int id) async {
    final isar = await db;
    await isar.writeTxn(() async {
      final item = await isar.itemModels.get(id);
      if (item != null) {
        item.isFavorite = !item.isFavorite;
        await isar.itemModels.put(item);
      }
    });
  }

  /// DELETE ONE
  Future<void> deleteItem(int id) async {
    final isar = await db;
    await isar.writeTxn(() async {
      await isar.itemModels.delete(id);
    });
  }

  /// DELETE MANY
  Future<void> deleteItems(List<int> ids) async {
    final isar = await db;
    await isar.writeTxn(() async {
      await isar.itemModels.deleteAll(ids);
    });
  }
}
