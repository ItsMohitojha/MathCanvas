import 'package:freezed_annotation/freezed_annotation.dart';

part 'notebook.freezed.dart';
part 'notebook.g.dart';

/// Immutable domain model representing a math canvas notebook.
@freezed
class Notebook with _$Notebook {
  /// Creates a [Notebook] domain model.
  const factory Notebook({
    required String id,
    @Default('Untitled Notebook') String name,
    required DateTime createdAt,
    required DateTime updatedAt,
    @Default(0.0) double viewportX,
    @Default(0.0) double viewportY,
    @Default(1.0) double zoomLevel,
  }) = _Notebook;

  const Notebook._();

  /// Creates a [Notebook] from a JSON map.
  factory Notebook.fromJson(Map<String, dynamic> json) =>
      _$NotebookFromJson(json);
}
