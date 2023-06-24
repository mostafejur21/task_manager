import 'package:flutter/material.dart';
import 'package:task_manager/style.dart';
import 'package:intl/intl.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<Task> task = [];

  void addTask(Task tasks) {
    setState(() {});
    task.add(tasks);
  }

  void deleteTask(Task tasks) {
    setState(() {
      task.remove(tasks);
    });
  }

  @override
  void initState() {
    super.initState();
    _dateEditingController.text =
        _selectedDate != null ? DateFormat.yMMMd().format(_selectedDate!) : '';
  }

  DateTime? _selectedDate;
  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(1900),
      lastDate: DateTime(2100),
    );

    if (picked != null && picked != _selectedDate) {
      setState(() {
        _selectedDate = picked;
        _dateEditingController.text = DateFormat.yMMMd().format(_selectedDate!);
      });
    }
  }

  void openTaskDetails(Task task) {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) => Wrap(
        children: [
          ListTile(
            title: Text(task.title),
            subtitle: Text(task.description),
          ),
          ListTile(
            title: const Text('Deadline'),
            subtitle: Text(DateFormat('yyyy-MM-dd').format(task.date)),
          ),
          ListTile(
            leading: const Icon(Icons.delete),
            title: const Text('Delete Task'),
            onTap: () {
              deleteTask(task);
              Navigator.of(context).pop();
            },
          ),
        ],
      ),
    );
  }

  final formKey = GlobalKey<FormState>();

  final TextEditingController _titleTextController = TextEditingController();
  final TextEditingController _descriptionTextController =
      TextEditingController();
  final TextEditingController _dateEditingController = TextEditingController();

  @override
  void dispose() {
    _titleTextController.dispose();
    _descriptionTextController.dispose();
    _dateEditingController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "TaskManager",
          style: TextStyle(letterSpacing: 10),
        ),
        centerTitle: true,
      ),
      body: ListView.separated(
          itemBuilder: (context, index) {
            return Padding(
              padding: const EdgeInsets.symmetric(vertical: 10),
              child: ListTile(
                title: Text(
                  task[index].title,
                ),
                subtitle: Text(task[index].description),
                onLongPress: () => openTaskDetails(task[index]),
              ),
            );
          },
          separatorBuilder: (BuildContext context, int index) {
            return const Divider(
              height: 2,
              color: Colors.grey,
            );
          },
          itemCount: task.length),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          showDialog(
              context: context,
              builder: (BuildContext context) {
                return AlertDialog(
                  scrollable: true,
                  title: const Text("Add Task"),
                  content: Form(
                    key: formKey,
                    child: Column(
                      children: [
                        TextFormField(
                          controller: _titleTextController,
                          decoration: formInputDecoration("Title"),
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        TextFormField(
                          controller: _descriptionTextController,
                          decoration: formInputDecoration("Description"),
                          validator: (value) {
                            if (value!.isEmpty) {
                              return "Should add the description";
                            }
                            return null;
                          },
                          maxLines: 3,
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        Row(
                          children: [
                            Expanded(
                              child: TextFormField(
                                readOnly: true,
                                controller: _dateEditingController,
                                decoration: const InputDecoration(
                                  labelText: 'Deadline',
                                ),
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return 'Please enter a deadline';
                                  }
                                  return null;
                                },
                              ),
                            ),
                            IconButton(
                              onPressed: () => _selectDate(context),
                              icon: const Icon(Icons.calendar_today),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  actions: [
                    TextButton(
                      onPressed: () {
                        if (formKey.currentState!.validate()) {
                          task.add(
                            Task(
                              _titleTextController.text.trim(),
                              _descriptionTextController.text.trim(),
                              _selectedDate ?? DateTime.now(),
                            ),
                          );
                          if (mounted) {
                            setState(() {
                              _titleTextController.clear();
                              _dateEditingController.clear();
                              _descriptionTextController.clear();
                              Navigator.pop(context);
                            });
                          }
                        }
                      },
                      child: const Text("Save"),
                    ),
                  ],
                );
              });
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}

class Task {
  final String title, description;
  final DateTime date;

  Task(this.title, this.description, this.date);
}
