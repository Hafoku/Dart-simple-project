import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:todo_app_getx/app/data/services/storage/repository.dart';
import 'package:get_storage/get_storage.dart';
import 'package:todo_app_getx/app/core/values/colors.dart';
import 'package:get/get_utils/src/extensions/internacionalization.dart';

import '../../data/models/task.dart';

class HomeController extends GetxController {
  final formKey = GlobalKey<FormState>();
  TaskRepository taskRepository;
  HomeController({
    required this.taskRepository,
  });

  final formEditCtrl = TextEditingController();
  final tabIndex = 0.obs;
  final chipIndex = 0.obs;
  final deleting = false.obs;
  final tasks = <Task>[].obs;
  final task = Rx<Task?>(null);
  final doingTodos = <dynamic>[].obs;
  final doneTodos = <dynamic>[].obs;
  final searchController = TextEditingController();
  final searchText = ''.obs;
  final filteredTasks = <Task>[].obs;

  final _storage = GetStorage();
  final isDarkMode = false.obs;
  final isRussian = true.obs;

  @override
  void onInit() {
    super.onInit();
    tasks.assignAll(taskRepository.readTasks());
    filteredTasks.assignAll(tasks);
    
    ever(tasks, (_) {
      taskRepository.writeTasks(tasks);
      filteredTasks.assignAll(tasks.where((task) {
        return task.title.toLowerCase().contains(searchText.value.toLowerCase());
      }).toList());
    });

    ever(searchText, (_) {
      if (searchText.isEmpty) {
        filteredTasks.assignAll(tasks);
      } else {
        filteredTasks.assignAll(
          tasks.where((task) => 
            task.title.toLowerCase().contains(searchText.value.toLowerCase())
          ).toList()
        );
      }
    });

    isDarkMode.value = _storage.read('isDarkMode') ?? false;
    
    ever(isDarkMode, (bool isDark) {
      _storage.write('isDarkMode', isDark);
      Get.changeThemeMode(isDark ? ThemeMode.dark : ThemeMode.light);
    });

    isRussian.value = _storage.read('isRussian') ?? true;
    
    ever(isRussian, (bool isRu) {
      _storage.write('isRussian', isRu);
      Get.updateLocale(isRu ? const Locale('ru', 'RU') : const Locale('en', 'US'));
    });
  }

  @override
  void onClose() {
    // TODO: implement onClose
    formEditCtrl.dispose();
    searchController.dispose();
    super.onClose();
  }

  bool addTask(Task task) {
    if (tasks.contains(task)) {
      return false;
    }
    tasks.add(task);
    filteredTasks.assignAll(tasks);
    tasks.refresh();
    return true;
  }

  void deleteTask(Task task) {
    tasks.remove(task);
    filteredTasks.assignAll(tasks);
    tasks.refresh();
  }

  updateTask(Task task, String title) {
    var todos = task.todos ?? [];
    if (containTodo(todos, title)) {
      return false;
    }
    var todo = {'title': title, 'done': false};
    todos.add(todo);
    var newTask = task.copyWith(todos: todos);
    int oldIdx = tasks.indexOf(task);
    tasks[oldIdx] = newTask;
    tasks.refresh();
    return true;
  }

  bool containTodo(List todos, String title) {
    return todos.any((element) => element['title'] == title);
  }

  void changeChipIndex(int value) {
    chipIndex.value = value;
  }

  void changeDeleting(bool value) {
    deleting.value = value;
  }

  void changeTask(Task? select) {
    task.value = select;
  }

  void changeTodo(List<dynamic> select) {
    doneTodos.clear();
    doingTodos.clear();

    for (var i = 0; i < select.length; i++) {
      var todo = select[i];
      var status = todo['done'];
      if (status == true) {
        doneTodos.add(todo);
      } else {
        doingTodos.add(todo);
      }
    }
  }

  bool addTodo(String title) {
    var doingTodo = {'title': title, 'done': false};
    if (doingTodos
        .any((element) => mapEquals<String, dynamic>(doingTodo, element))) {
      return false;
    }
    var doneTodo = {'title': title, 'done': true};
    if (doneTodos
        .any((element) => mapEquals<String, dynamic>(doneTodo, element))) {
      return false;
    }
    doingTodos.add(doingTodo);
    return true;
  }

  void updateTodo() {
    var newTodos = <Map<String, dynamic>>[];
    newTodos.addAll([
      ...doingTodos,
      ...doneTodos,
    ]);
    var newTask = task.value!.copyWith(todos: newTodos);
    int oldIdx = tasks.indexOf(task.value);
    tasks[oldIdx] = newTask;
    tasks.refresh();
  }

  void doneTodo(String title) {
    var doingTodo = {'title': title, 'done': false};
    int index = doingTodos.indexWhere(
        (element) => mapEquals<String, dynamic>(doingTodo, element));
    doingTodos.removeAt(index);
    var doneTodo = {'title': title, 'done': true};
    doneTodos.add(doneTodo);
    doingTodos.refresh();
    doneTodos.refresh();
  }

  deleteDoneTodo(dynamic doneTodo) {
    int index = doneTodos
        .indexWhere((element) => mapEquals<String, dynamic>(doneTodo, element));
    doneTodos.removeAt(index);
    doneTodos.refresh();
  }

  bool isTodoEmpty(Task task) {
    return task.todos == null || task.todos!.isEmpty;
  }

  int getDoneTodo(Task task) {
    var res = 0;
    for (int i = 0; i < task.todos!.length; i++) {
      if (task.todos![i]['done'] == true) {
        res += 1;
      }
    }
    return res;
  }

  void changeTabIndex(int index) {
    tabIndex.value = index;
  }

  int getTotalTask() {
    var res = 0;
    for (var i = 0; i < tasks.length; i++) {
      if (tasks[i].todos != null) {
        res += tasks[i].todos!.length;
      }
    }
    return res;
  }

  int getTotalDoneTask() {
    int res = 0;
    for (int i = 0; i < tasks.length; i++) {
      if (tasks[i].todos != null) {
        for (int j = 0; j < tasks[i].todos!.length; j++) {
          // if (j < 0 || j >= tasks[i].todos!.length) break;
          if (tasks[i].todos![j]['done'] == true) {
            res += 1;
          }
        }
      }
    }
    return res;
  }

  void updateSearchText(String value) {
    searchText.value = value;
  }

  void toggleTheme() {
    isDarkMode.value = !isDarkMode.value;
  }

  void toggleLanguage() {
    isRussian.value = !isRussian.value;
  }

  void showSettingsDialog(BuildContext context) {
    Get.dialog(
      Obx(() {
        final isDark = isDarkMode.value;
        return AlertDialog(
          backgroundColor: isDark ? Colors.grey[800] : Colors.white,
          title: Text(
            'settings'.tr,
            style: TextStyle(
              color: isDark ? Colors.white : Colors.black,
            ),
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              SwitchListTile(
                title: Text(
                  'dark_theme'.tr,
                  style: TextStyle(
                    color: isDark ? Colors.white : Colors.black,
                  ),
                ),
                value: isDarkMode.value,
                onChanged: (bool value) {
                  toggleTheme();
                },
              ),
              const Divider(
                color: Colors.grey,
              ),
              ListTile(
                title: Text(
                  'select_language'.tr,
                  style: TextStyle(
                    color: isDark ? Colors.white : Colors.black,
                  ),
                ),
              ),
              RadioListTile<bool>(
                title: Text(
                  'Русский',
                  style: TextStyle(
                    color: isDark ? Colors.white : Colors.black,
                  ),
                ),
                activeColor: darkGreen,
                value: true,
                groupValue: isRussian.value,
                onChanged: (bool? value) {
                  if (value != null) isRussian.value = value;
                },
              ),
              RadioListTile<bool>(
                title: Text(
                  'English',
                  style: TextStyle(
                    color: isDark ? Colors.white : Colors.black,
                  ),
                ),
                activeColor: darkGreen,
                value: false,
                groupValue: isRussian.value,
                onChanged: (bool? value) {
                  if (value != null) isRussian.value = value;
                },
              ),
            ],
          ),
          actions: [
            TextButton(
              child: Text(
                'close'.tr,
                style: TextStyle(
                  color: darkGreen,
                ),
              ),
              onPressed: () => Get.back(),
            ),
          ],
        );
      }),
    );
  }
}
