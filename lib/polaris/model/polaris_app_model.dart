import 'package:equatable/equatable.dart';

/// The `PolarisAppModel` class is an abstract class that provides methods for JSON
/// serialization, equality comparison, hashing, and other common model operations.
abstract class PolarisAppModel<T> extends Equatable {
  const PolarisAppModel();
  @override
  String toString() => toJson().toString();

  @override
  bool operator ==(Object other);

  @override
  int get hashCode => props.fold(0, (hash, prop) => hash ^ prop.hashCode);

  @override
  List<Object?> get props => throw UnimplementedError();

  Map<String, dynamic> toJson();

  static T fromJson<T>(Map<String, dynamic> json) => throw UnimplementedError();

  void validate() => throw UnimplementedError();
  String toRawJson() => throw UnimplementedError();

  T copyWith();

  void initializeDefaults() => throw UnimplementedError();

  bool isNullOrEmpty(Object? value) {
    if (value == null) return true;
    if (value is String && value.isEmpty) return true;
    if (value is Iterable && value.isEmpty) return true;
    if (value is Map && value.isEmpty) return true;
    return false;
  }
}
