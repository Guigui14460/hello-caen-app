abstract class FirestoreDBLinkedRequest<T> {
  FirestoreDBLinkedRequest<T> whereLinked(dynamic field,
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

  FirestoreDBLinkedRequest<T> limitLinked(int limit);

  FirestoreDBLinkedRequest<T> limitToLastLinked(int limit);

  FirestoreDBLinkedRequest<T> orderByLinked(dynamic field,
      {bool descending = false});

  Future<List<T>> executeCurrentLinkedQueryRequest();

  void cancalCurrentLinkedQueryRequest();
}
