import 'dart:core';
import 'dart:io';
import 'dart:convert';
import 'package:args/args.dart';

ArgResults argResults;

TodoList todoList = TodoList();
List allTasks;
int lastId;
enum Days {monday, tuesday, wednesday, thursday, friday, saturday, sunday}
void main(List<String> arguments) {
  final parser = ArgParser();
  parser.addFlag('new_task', negatable: false, abbr: 'n'); //write number to create few tasks
  parser.addFlag('del_task', negatable: false, abbr: 'd');
  parser.addFlag('show_all_tasks', negatable: false, abbr: 's');

  argResults = parser.parse(arguments);
  final rest = argResults.rest;
  todoList.chooseAction(argResults, rest);
}

class TodoList {
  void chooseAction(argResults, rest) {
    if(argResults['new_task']) {
      getData();
      int taskNumber = 1;
      if(rest.isNotEmpty && int.parse(rest[0]) is int){
        taskNumber = int.parse(rest[0]);
      }
      creatingTask(taskNumber);
      
    } else if(argResults['del_task']) {
        if(rest.isNotEmpty && int.parse(rest[0]) is int) {
          delTask(int.parse(rest[0]));
        }

    } else if(argResults['show_all_tasks']) {
      showAllTasks();
    }
  }

  static void creatingTask(taskNumber) {
    stdout.writeln('Do you want to create new task?(y or n)');
    String input = stdin.readLineSync();
    switch(input.toLowerCase()) {
      case('n'):
        stdout.writeln('ok');
        break;
      case('y'):
        final newTask = isRecurring();

        Map task = newTask.createNewTask();
        saveTask(task);
        --taskNumber;

        if(taskNumber > 0) {
          creatingTask(taskNumber);
        }
        break;

      default:
        print('Print "y" or "n"');
        creatingTask(taskNumber);
        break;
    }
    saveData({'tasks': allTasks, 'lastId': lastId});
  }

  static isRecurring() {
    stdout.writeln('Does this task is recurring? (y or n)');

    switch(stdin.readLineSync().toLowerCase()) {
      case('y'):
        return RecurringTask();
      case('n'):
        return PlainTask();
      default:
        print('Print "y" or "n"');
        isRecurring();
        break;
    }
  }

  static void saveTask(task) {
    int id = ++lastId;
    task['id'] = id;
    
    allTasks = [task, ...?allTasks];
    lastId = id;
  }

  static void delTask(int id) {
    getData();
    var result = [
      for (var i in allTasks) if(i['id'] != id) i
    ];
    saveData({'tasks': result, 'lastId': lastId});
  }

  static void saveData(data) {
    final file = File('allTasks.json').openWrite(mode: FileMode.write);
    file.write(jsonEncode(data));
  }

  static void getData() {
    final dataJson = File('allTasks.json').readAsStringSync();
    Map data = jsonDecode(dataJson);
    allTasks = data['tasks'];
    lastId = data['lastId'];
  }

  static void showAllTasks() {
    getData();
    Map categories = {};
    for(Map task in allTasks) {
      categories[task['category']] = [...?categories[task['category']], task];
    }
    categories.forEach((key, value) {
      categories[key] = value.length;
    });
    print(categories);
  }
}

abstract class Task<T> {
  String name;
  String category;

  Map createNewTask();
  String chooseName();
  String chooseCategory();
  void message(T name, T category);
}

class RecurringTask implements Task {
  String name;
  String category;
  String dayOfTheWeek;

  Map createNewTask() {
    name = chooseName();
    category = chooseCategory();
    dayOfTheWeek = chooseDay();
    message(name, category);

    return {
      'name': name,
      'category': category,
      'dayOfTheWeek': dayOfTheWeek
    };
  }

  String chooseName() {
    stdout.writeln('What is the name of the task?');
    String name = stdin.readLineSync();

    if(name.length < 1) {
      print('Name must containe at list 1 symbol');
    }
    return name;
  }

  String chooseCategory() {
    stdout.writeln('What is the category of the task?');
    String category = stdin.readLineSync();
    if(category.length < 1) {
      print('Category must containe at list 1 symbol');
      chooseCategory();
    }
    return category;
  }

  String chooseDay() {
    DateTime date = DateTime.now();
    return Days.values[date.weekday - 1].toString().split('.').last;
  }
  void message(name, category) {
    print('You created plain task "$name", category "$category"');
  }
}

class PlainTask implements Task {
  String name;
  String category;

  Map createNewTask() {
    name = chooseName();
    category = chooseCategory();
    message(name, category);
    return {
      'name': name,
      'category': category,
    };
  }

  String chooseName() {
    stdout.writeln('What is the name of the task?');
    String name = stdin.readLineSync();

    if(name.length < 1) {
      stdout.writeln('Name must containe at list 1 symbol');
      chooseName();
    }
    return name;
  }

  String chooseCategory() {
    stdout.writeln('What is the category of the task?');
    String category = stdin.readLineSync();
    if(category.length < 1) {
      stdout.writeln('Category must containe at list 1 symbol');
      chooseCategory();
    }
    return category;
  }
  void message(name, category) {
    print('You created plain task "$name", category "$category"');
  }
}