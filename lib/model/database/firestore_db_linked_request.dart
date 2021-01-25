abstract class FirestoreDBLinkedRequest<T> {
  FirestoreDBLinkedRequest whereLinked(dynamic field,
      {dynamic isEqualTo,
      dynamic isNotEqualTo,
      dynamic isLessThan,
      dynamic isLessThanOrEqualTo,
      dynamic isGreaterThan,
      dynamic isGreaterThanOrEqualTo,
      dynamic arrayContains,
      List<dynamic> arrayContainsAny,
      List<dynamic> whereIn,
      List<dynamic> whereNotIn,
      bool isNull});

  FirestoreDBLinkedRequest limitLinked(int limit);

  FirestoreDBLinkedRequest limitToLastLinked(int limit);

  FirestoreDBLinkedRequest orderByLinked(dynamic field,
      {bool descending = false});

  Future<List<T>> executeCurrentLinkedQueryRequest();

  void cancalCurrentLinkedQueryRequest();
}
