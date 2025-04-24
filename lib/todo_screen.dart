import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'task_provider.dart';
import 'task_model.dart';
import 'drawer_screen.dart';

class TodoScreen extends StatefulWidget {
  const TodoScreen({super.key});

  @override
  State<TodoScreen> createState() => _TodoScreenState();
}

class _TodoScreenState extends State<TodoScreen> {
  final _taskController = TextEditingController();
  final _taskDescriptionController = TextEditingController();
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void dispose() {
    _taskController.dispose();
    _taskDescriptionController.dispose();
    super.dispose();
  }

  void _addTask() {
    final taskProvider = Provider.of<TaskProvider>(context, listen: false);
    if (_taskController.text.isNotEmpty) {
      taskProvider.addTask(
        _taskController.text,
        description: _taskDescriptionController.text.isEmpty ? null : _taskDescriptionController.text,
      );
      _taskController.clear();
      _taskDescriptionController.clear();
      Navigator.pop(context);
      
      // Show a success message
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Task added successfully!'),
          backgroundColor: Color(0xFF8875FF),
          duration: Duration(seconds: 2),
        ),
      );
    }
  }

  void _showAddTaskDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: Colors.grey[900],
        title: const Text(
          'Add New Task',
          style: TextStyle(color: Colors.white),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: _taskController,
              autofocus: true,
              decoration: const InputDecoration(
                hintText: 'Task title',
                hintStyle: TextStyle(color: Colors.grey),
                border: OutlineInputBorder(),
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Color(0xFF8875FF)),
                ),
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _taskDescriptionController,
              maxLines: 3,
              decoration: const InputDecoration(
                hintText: 'Description (optional)',
                hintStyle: TextStyle(color: Colors.grey),
                border: OutlineInputBorder(),
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Color(0xFF8875FF)),
                ),
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text(
              'Cancel',
              style: TextStyle(color: Colors.grey),
            ),
          ),
          ElevatedButton(
            onPressed: _addTask,
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF8875FF),
            ),
            child: const Text('Add Task'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        title: const Text('Daily Tasks'),
        leading: IconButton(
          icon: const Icon(Icons.menu),
          onPressed: () {
            _scaffoldKey.currentState!.openDrawer();
          },
        ),
      ),
      drawer: const DrawerScreen(),
      body: Consumer<TaskProvider>(
        builder: (context, taskProvider, child) {
          return Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: ElevatedButton.icon(
                  onPressed: _showAddTaskDialog,
                  icon: const Icon(Icons.add),
                  label: const Text('add tasks'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF8875FF),
                    minimumSize: const Size(double.infinity, 50),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                ),
              ),
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    'To do Tasks',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
              Expanded(
                child: taskProvider.tasks.isEmpty
                    ? Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Icon(
                              Icons.task_alt,
                              size: 64,
                              color: Colors.grey,
                            ),
                            const SizedBox(height: 16),
                            const Text(
                              'No tasks yet',
                              style: TextStyle(
                                fontSize: 18,
                                color: Colors.grey,
                              ),
                            ),
                            const SizedBox(height: 8),
                            TextButton(
                              onPressed: _showAddTaskDialog,
                              child: const Text('Add your first task'),
                            ),
                          ],
                        ),
                      )
                    : ListView.builder(
                        itemCount: taskProvider.tasks.length,
                        itemBuilder: (context, index) {
                          final task = taskProvider.tasks[index];
                          return TaskItem(task: task);
                        },
                      ),
              ),
            ],
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _showAddTaskDialog,
        backgroundColor: const Color(0xFF8875FF),
        child: const Icon(Icons.add),
      ),
    );
  }
}

class TaskItem extends StatelessWidget {
  final Task task;

  const TaskItem({super.key, required this.task});

  @override
  Widget build(BuildContext context) {
    return Dismissible(
      key: Key(task.id),
      background: Container(
        color: Colors.red,
        alignment: Alignment.centerRight,
        padding: const EdgeInsets.only(right: 20),
        child: const Icon(Icons.delete, color: Colors.white),
      ),
      direction: DismissDirection.endToStart,
      onDismissed: (direction) {
        Provider.of<TaskProvider>(context, listen: false).deleteTask(task.id);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('${task.title} deleted'),
            action: SnackBarAction(
              label: 'UNDO',
              onPressed: () {
                // Re-add the task if the user wants to undo
                Provider.of<TaskProvider>(context, listen: false).addTask(
                  task.title,
                  description: task.description,
                );
              },
            ),
          ),
        );
      },
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: task.isCompleted ? Colors.white : Colors.grey[900],
          borderRadius: BorderRadius.circular(8),
        ),
        child: ListTile(
          leading: Checkbox(
            value: task.isCompleted,
            activeColor: const Color(0xFF8875FF),
            shape: const CircleBorder(),
            onChanged: (value) {
              Provider.of<TaskProvider>(context, listen: false).toggleTaskStatus(task.id);
            },
          ),
          title: Text(
            task.title,
            style: TextStyle(
              color: task.isCompleted ? Colors.black : Colors.white,
              decoration: task.isCompleted ? TextDecoration.lineThrough : null,
            ),
          ),
          subtitle: task.description != null
              ? Text(
                  task.description!,
                  style: TextStyle(
                    color: task.isCompleted ? Colors.black54 : Colors.grey,
                    fontSize: 12,
                  ),
                )
              : Text(
                  'Position',
                  style: TextStyle(
                    color: task.isCompleted ? Colors.black54 : Colors.grey,
                    fontSize: 12,
                  ),
                ),
          trailing: IconButton(
            icon: const Icon(Icons.delete, color: Colors.red),
            onPressed: () {
              Provider.of<TaskProvider>(context, listen: false).deleteTask(task.id);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('${task.title} deleted'),
                  action: SnackBarAction(
                    label: 'UNDO',
                    onPressed: () {
                      // Re-add the task if the user wants to undo
                      Provider.of<TaskProvider>(context, listen: false).addTask(
                        task.title,
                        description: task.description,
                      );
                    },
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}
