class Nullable<T> {
  final T? value;

  /// The sole purpose of this class is for providing nullable
  /// fields in [copyWith] method. Why do we need it? Consider this class:
  ///
  /// ```dart
  /// class Cat {
  ///   final String? name;
  ///
  ///   const Cat({required this.name});
  ///
  ///   Cat copyWith({String? name}) {
  ///     return Cat(name: name ?? this.name);
  ///   }
  /// }
  /// final cat = Cat(name: "tom");             // name = "tom"
  /// final newCat = cat.copyWith(name: null);  // still "tom"
  /// ```
  ///
  /// So we change the [copyWith] method to:
  /// ```dart
  /// Cat copyWith({Nullable<String>? name}) {
  ///   return Cat(name: name != null ? name.value : this.name);
  /// }
  /// ```
  const Nullable(this.value);
}
