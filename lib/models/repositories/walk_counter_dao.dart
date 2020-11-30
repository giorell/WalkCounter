import 'dart:async';

import 'package:walking_counter/models/repositories/database.dart';
import 'package:walking_counter/models/walk_counter_model.dart';

class WalkCounterDao {
  final dbProvider = DatabaseProvider.dbProvider;

  //Adds new records
  Future<void> createWalkCount(WalkCounterModel walkCounterModel) async {
    final db = await dbProvider.database;
    try {
      db.insert(walkCounterTABLE, walkCounterModel.toJson());
      print('WalkCounterDao - Successfully Saved WalkCount');
    } on Exception catch (e) {
      print(e.toString());
    }
  }

  Future<List<WalkCounterModel>> getData(
      {List<String> columns, String query}) async {
    final db = await dbProvider.database;

    List<Map<String, dynamic>> result;

    result = await db.rawQuery('SELECT * FROM $walkCounterTABLE');

    List<WalkCounterModel> todos = result.isNotEmpty
        ? result.map((item) => WalkCounterModel.fromJson(item)).toList()
        : [];
    return todos;
  }

  //Update record
  Future<void> updateTodo(WalkCounterModel todo) async {
    final db = await dbProvider.database;

    await db.update(walkCounterTABLE, todo.toJson(),
        where: "id = ?", whereArgs: [todo.id]);
  }

  //Delete records
  Future<void> deleteWalkCount(int id) async {
    final db = await dbProvider.database;

    await db.delete(walkCounterTABLE, where: 'id = ?', whereArgs: [id]);
  }

  Future deleteAllData() async {
    var result;
    final db = await dbProvider.database;
    try {
      result = await db.delete(
        walkCounterTABLE,
      );
      print('WalkCounterDao - Successfully deleted database');
    } catch (e) {
      print(e.toString());
    }

    return result;
  }
}
