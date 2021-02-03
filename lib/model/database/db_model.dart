import 'dart:async';

/// Models use this mixin to easily manipulate
/// the CRUD.
/// [T] must be replace by a class (can be represented
/// as the title of a database collection).
mixin DBModel<T> {
  /// Verify if a document of this [id] exists in the
  /// database collection.
  Future<bool> exists(String id);

  /// Gets all the data stored in the database collection.
  Future<List<T>> getAll();

  /// Gets a document by an [id] stored in the database collection.
  Future<T> getById(String id);

  /// Gets multiple documents associated with the [ids].
  Future<List<T>> getMultipleByIds(List<String> ids);

  /// Creates a document with the data of the [object]
  /// parameter in the database collection.
  /// <strong>N.B.:</strong> We recommend to use
  /// random ID provided by the database.
  Future<String> create(T object);

  /// Creates a document with the data of the [object]
  /// parameter in the database collection stored with [id].
  Future<T> createWithId(String id, T object);

  /// Updates the document of [id] with the [object] in
  /// the database collection.
  Future<bool> update(String id, T object);

  /// Updates some fields for document of [id] with the
  /// [object] in the database collection.
  Future<bool> updateFields(String id, T object, List<dynamic> fieldsToUpdate,
      List<dynamic> associatedFields);

  /// Deletes the document of [id] from the database
  /// collection.
  Future<bool> delete(String id);
}
