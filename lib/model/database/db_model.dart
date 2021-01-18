/// Models use this mixin to easily manipulate
/// the CRUD.
/// [T] must be replace by a class (can be represented
/// as the title of a database collection).
mixin DBModel<T> {
  /// Verify if a document of this [id] exists in the
  /// database collection.
  bool exists(String id);

  /// Gets all the data stored in the database collection.
  List<T> getAll();

  /// Gets a document by an [id] stored in the database collection.
  T getById(String id);

  /// Creates a document with the data of the [object]
  /// parameter in the database collection.
  /// <strong>N.B.:</strong> We recommend to use
  /// random ID provided by the database.
  T create(T object);

  /// Updates the document of [id] with the [object] in
  /// the database collection.
  bool update(String id, T object);

  /// Deletes the document of [id] from the database
  /// collection.
  bool delete(String id);
}
