import '../../domain/models/notebook.dart';

/// Database Transfer Object for the notebooks table.
class NotebookEntity {
  final String id;
  final String name;
  final int createdAt;
  final int updatedAt;
  final double viewportX;
  final double viewportY;
  final double zoomLevel;

  /// Creates a [NotebookEntity].
  NotebookEntity({
    required this.id,
    required this.name,
    required this.createdAt,
    required this.updatedAt,
    required this.viewportX,
    required this.viewportY,
    required this.zoomLevel,
  });

  /// Converts this entity to a map for database insertion/update.
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'created_at': createdAt,
      'updated_at': updatedAt,
      'viewport_x': viewportX,
      'viewport_y': viewportY,
      'zoom_level': zoomLevel,
    };
  }

  /// Creates a [NotebookEntity] from a database row map.
  factory NotebookEntity.fromMap(Map<String, dynamic> map) {
    return NotebookEntity(
      id: map['id'] as String,
      name: map['name'] as String,
      createdAt: map['created_at'] as int,
      updatedAt: map['updated_at'] as int,
      viewportX: (map['viewport_x'] as num).toDouble(),
      viewportY: (map['viewport_y'] as num).toDouble(),
      zoomLevel: (map['zoom_level'] as num).toDouble(),
    );
  }

  /// Converts this entity to a [Notebook] domain model.
  Notebook toDomain() {
    return Notebook(
      id: id,
      name: name,
      createdAt: DateTime.fromMillisecondsSinceEpoch(createdAt),
      updatedAt: DateTime.fromMillisecondsSinceEpoch(updatedAt),
      viewportX: viewportX,
      viewportY: viewportY,
      zoomLevel: zoomLevel,
    );
  }

  /// Creates a [NotebookEntity] from a [Notebook] domain model.
  factory NotebookEntity.fromDomain(Notebook domain) {
    return NotebookEntity(
      id: domain.id,
      name: domain.name,
      createdAt: domain.createdAt.millisecondsSinceEpoch,
      updatedAt: domain.updatedAt.millisecondsSinceEpoch,
      viewportX: domain.viewportX,
      viewportY: domain.viewportY,
      zoomLevel: domain.zoomLevel,
    );
  }
}
