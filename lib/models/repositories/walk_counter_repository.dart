import 'package:walking_counter/models/repositories/walk_counter_dao.dart';
import 'package:walking_counter/models/walk_counter_model.dart';

class WalkCounterRepository {
  final walkCounterDao = WalkCounterDao();

  Future<List<WalkCounterModel>> getAllData() => walkCounterDao.getData();

  Future insertWalkCount(WalkCounterModel model) {
    assert(model != null);
    walkCounterDao.createWalkCount(model);
  }

  Future deleteWalkCount(int id) => walkCounterDao.deleteWalkCount(id);

  Future deleteAllData() => walkCounterDao.deleteAllData();
}
