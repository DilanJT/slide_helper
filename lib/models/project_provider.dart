import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import 'project.dart';

class ProjectProvider with ChangeNotifier {
  List<Project> _projects = [];
  static const String _storageKey = 'slidecraft_projects';
  final SharedPreferences _prefs;

  ProjectProvider(this._prefs) {
    _loadProjects();
  }

  List<Project> get projects => [..._projects];

  void _loadProjects() {
    final projectsJson = _prefs.getStringList(_storageKey) ?? [];
    _projects = projectsJson
        .map((json) => Project.fromJson(jsonDecode(json)))
        .toList();
    notifyListeners();
  }

  Future<void> _saveProjects() async {
    final projectsJson = _projects
        .map((project) => jsonEncode(project.toJson()))
        .toList();
    await _prefs.setStringList(_storageKey, projectsJson);
  }

  Future<void> addProject(Project project) async {
    _projects.add(project);
    await _saveProjects();
    notifyListeners();
  }

  Future<void> deleteProject(String id) async {
    _projects.removeWhere((project) => project.id == id);
    await _saveProjects();
    notifyListeners();
  }

  Project? getProjectById(String id) {
    try {
      return _projects.firstWhere((project) => project.id == id);
    } catch (e) {
      return null;
    }
  }
}