import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import '../models/project_provider.dart';
import '../models/project.dart';
import '../widgets/scenario_image_list.dart';

class CreateProjectScreen extends StatefulWidget {
  const CreateProjectScreen({Key? key}) : super(key: key);

  @override
  _CreateProjectScreenState createState() => _CreateProjectScreenState();
}

class _CreateProjectScreenState extends State<CreateProjectScreen> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _scenarioController = TextEditingController();
  final List<ScenarioImage> _images = [];
  final _imagePicker = ImagePicker();

  Future<void> _addImage() async {
    final XFile? image = await _imagePicker.pickImage(source: ImageSource.gallery);
    if (image != null) {
      showDialog(
        context: context,
        builder: (context) {
          final titleController = TextEditingController();
          return AlertDialog(
            title: const Text('Add Image Title'),
            content: TextField(
              controller: titleController,
              decoration: const InputDecoration(
                labelText: 'Scenario Title',
              ),
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('Cancel'),
              ),
              TextButton(
                onPressed: () {
                  setState(() {
                    _images.add(
                      ScenarioImage(
                        id: DateTime.now().toString(),
                        title: titleController.text,
                        imagePath: image.path,
                      ),
                    );
                  });
                  Navigator.pop(context);
                },
                child: const Text('Add'),
              ),
            ],
          );
        },
      );
    }
  }

  void _createProject() {
    if (_formKey.currentState!.validate() && _images.isNotEmpty) {
      final project = Project(
        id: DateTime.now().toString(),
        title: _titleController.text,
        scenario: _scenarioController.text,
        images: _images,
        createdAt: DateTime.now(),
      );

      Provider.of<ProjectProvider>(context, listen: false).addProject(project);
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Create New Project'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              TextFormField(
                controller: _titleController,
                decoration: const InputDecoration(
                  labelText: 'Video Title',
                ),
                validator: (value) {
                  if (value?.isEmpty ?? true) {
                    return 'Please enter a title';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _scenarioController,
                decoration: const InputDecoration(
                  labelText: 'Scenario Description',
                ),
                maxLines: 3,
                validator: (value) {
                  if (value?.isEmpty ?? true) {
                    return 'Please enter a scenario';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 24),
              ElevatedButton.icon(
                onPressed: _addImage,
                icon: const Icon(Icons.add_photo_alternate),
                label: const Text('Add Scenario Image'),
              ),
              const SizedBox(height: 16),
              ScenarioImageList(
                images: _images,
                onDelete: (index) {
                  setState(() {
                    _images.removeAt(index);
                  });
                },
              ),
              const SizedBox(height: 24),
              ElevatedButton(
                onPressed: _createProject,
                child: const Text('Create Project'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}