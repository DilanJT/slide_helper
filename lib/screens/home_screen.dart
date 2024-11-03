import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/project_provider.dart';
import 'create_project_screen.dart';
import '../widgets/project_card.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Video Projects'),
      ),
      body: Consumer<ProjectProvider>(
        builder: (context, projectProvider, child) {
          final projects = projectProvider.projects;
          return projects.isEmpty
              ? const Center(
            child: Text('No projects yet. Create one!'),
          )
              : ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: projects.length,
            itemBuilder: (context, index) {
              return ProjectCard(project: projects[index]);
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const CreateProjectScreen(),
            ),
          );
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}