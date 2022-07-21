abstract class LocalDataSource<T> {
  Future<List<T>> getAll({String searchKeyboard});

  Future<T> getElementById({dynamic id});

  Future<void> delete(T data);

  Future<void> deleteAll();

  Future<void> createOrUpdate(T data);

  bool isExist(T data);
}
