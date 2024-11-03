class Project {
  final String id;
  final String title;
  final String scenario;
  final List<ScenarioImage> images;
  final DateTime createdAt;

  Project({
    required this.id,
    required this.title,
    required this.scenario,
    required this.images,
    required this.createdAt,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'scenario': scenario,
      'images': images.map((image) => image.toJson()).toList(),
      'createdAt': createdAt.toIso8601String(),
    };
  }

  factory Project.fromJson(Map<String, dynamic> json) {
    return Project(
      id: json['id'],
      title: json['title'],
      scenario: json['scenario'],
      images: (json['images'] as List)
          .map((image) => ScenarioImage.fromJson(image))
          .toList(),
      createdAt: DateTime.parse(json['createdAt']),
    );
  }
}

class ScenarioImage {
  final String id;
  final String title;
  final String imagePath;

  ScenarioImage({
    required this.id,
    required this.title,
    required this.imagePath,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'imagePath': imagePath,
    };
  }

  factory ScenarioImage.fromJson(Map<String, dynamic> json) {
    return ScenarioImage(
      id: json['id'],
      title: json['title'],
      imagePath: json['imagePath'],
    );
  }
}