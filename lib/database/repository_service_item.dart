import 'package:Dorimarmitex/database/database_creator.dart';
import 'package:Dorimarmitex/models/item.dart';

class RepositoryServiceItem {
  static Future<List<Item>> getActivedItems() async {
    final sql = '''SELECT * FROM ${DatabaseCreator.itemTable}
    WHERE ${DatabaseCreator.oculto} = 0 ORDER BY ${DatabaseCreator.tipo}''';
    final data = await db.rawQuery(sql);
    List<Item> items = List();

    for (final node in data) {
      final item = Item.fromJson(node);
      items.add(item);
    }

    return items;
  }

  static Future<List<Item>> getAllItems() async {
    final sql = '''SELECT * FROM ${DatabaseCreator.itemTable}''';
    final data = await db.rawQuery(sql);
    List<Item> items = List();

    for (final node in data) {
      final item = Item.fromJson(node);
      items.add(item);
    }
    return items;
  }

  static Future<Item> getItem(int id) async {
    final sql = '''SELECT * FROM ${DatabaseCreator.itemTable}
    WHERE ${DatabaseCreator.id} = ?''';

    List<dynamic> params = [id];
    final data = await db.rawQuery(sql, params);

    final todo = Item.fromJson(data.first);
    return todo;
  }

  static Future<void> addItem(Item item) async {
    final sql = '''INSERT INTO ${DatabaseCreator.itemTable}
    (
      ${DatabaseCreator.nome},
      ${DatabaseCreator.tipo},
      ${DatabaseCreator.selec},
      ${DatabaseCreator.oculto}
    )
    VALUES (?,?,?,?)''';
    List<dynamic> params = [
      item.nome,
      item.tipo,
      item.selec ? 1 : 0,
      item.oculto ? 1 : 0
    ];
    final result = await db.rawInsert(sql, params);
    DatabaseCreator.databaseLog('Add item', sql, null, result, params);
  }

  static Future<void> deleteItem(Item item) async {
    final sql = '''DELETE FROM ${DatabaseCreator.itemTable}
    WHERE ${DatabaseCreator.id} = ?
    ''';

    List<dynamic> params = [item.id];
    final result = await db.rawDelete(sql, params);

    DatabaseCreator.databaseLog('Delete item', sql, null, result, params);
  }

  static Future<void> updateItem(Item item) async {
    final sql = '''UPDATE ${DatabaseCreator.itemTable}
    SET ${DatabaseCreator.nome} = ?,  
      ${DatabaseCreator.tipo} = ?,
      ${DatabaseCreator.selec} = ?,
      ${DatabaseCreator.oculto} = ?
    WHERE ${DatabaseCreator.id} = ?
    ''';

    List<dynamic> params = [
      item.nome,
      item.tipo,
      item.selec ? 1 : 0,
      item.oculto ? 1 : 0,
      item.id,
    ];
    final result = await db.rawUpdate(sql, params);

    DatabaseCreator.databaseLog('Update item', sql, null, result, params);
  }

  static Future<int> itemsCount() async {
    final data = await db
        .rawQuery('''SELECT COUNT(*) FROM ${DatabaseCreator.itemTable}''');

    int count = data[0].values.elementAt(0);
    int idForNewItem = count++;
    return idForNewItem;
  }
}
