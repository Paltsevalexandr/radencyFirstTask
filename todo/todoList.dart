import 'dart:core';
import 'dart:io';
import 'dart:convert';
import 'package:args/args.dart';

ArgResults argResults;
Tasks tasks = Tasks();
Data data = Data();
TodoList todoList = TodoList();
Map allTasks;
void main(List<String> arguments) {

  final parser = ArgParser();
  parser.addFlag('add_task', negatable: false, abbr: 'a');
  parser.addFlag('del_task', negatable: false, abbr: 'd');
  parser.addFlag('all_tasks', negatable: false, abbr: 't');
  parser.addFlag('show_category', negatable: false, abbr: 'c');

  argResults = parser.parse(arguments);
  final delTaskId = argResults.rest;
  todoList.cli(argResults, delTaskId);
}

class TodoList {
  void cli(argResults, rest) {
  
    if(argResults['add_task']) {
      int taskNumber = 1;
      if(rest.length > 0 && int.parse(rest[0]) is int){
        taskNumber = int.parse(rest[0]);
      }
      tasks.createTask(taskNumber);
      
    } else if(argResults['del_task']) {
      data.delTask(int.parse(rest[0]));
      print(rest);


    } else if(argResults['all_tasks']) {
      data.getTasks();
      stdout.writeln(allTasks);

    } else if(argResults['show_category']) {
      if(rest.length > 0){
        tasks.showCategory(rest[0]);
      }
    }
  }
}

class Data {
  void saveTask(name, category) {
    int id = ++allTasks['lastId'];
    Map task = {
      "name": name,
      "category": category,
      "id": id
    };
    
    List currentCategory = allTasks[task['category']].add({"id": id, ...task});
    allTasks = {task['category']: currentCategory, "lastId": id, ...?allTasks};
    print('saveTask: $allTasks');
    saveData(allTasks);
    
  }
  void delTask(int id) {
    Map thisTask;
    getTasks();
    allTasks.forEach((key, category) {
      if(category is List) {
        for(Map task in category) {
          if(task['id'] == id) {
            thisTask = task;
          }
        }
      }
    });
    allTasks[thisTask['category']].remove(thisTask);
    saveData(allTasks);
  }
  void saveData(data) {
    print('data: $data');
    final file = File('allTasks.json').openWrite(mode: FileMode.write);
    file.write(jsonEncode(data));
  }
  void getTasks() {
    final tasks = File('allTasks.json').readAsStringSync();
    print('get:$tasks');
    allTasks = jsonDecode(tasks);
  }
}

class Tasks {
  String name = '';
  String category = '';

  void createTask(int taskNumber) {
    
    stdout.writeln('Do you want to create new task?(y or n)');
    String input = stdin.readLineSync();
  
    switch(input.toLowerCase()){
      case('n'):
        stdout.writeln('ok');
        break;
      
      case('y'):
        stdout.writeln('begin create');
        data.getTasks();
        chooseName();
        chooseCategory();
        data.saveTask(name, category);
        --taskNumber;
        print('number: $taskNumber');
        if(taskNumber > 0) {
          createTask(taskNumber);
        }
        break;

      default:
        stdout.writeln('Print "y" or "n"');
        createTask(taskNumber);
        break;
    }
  }
  void chooseName() {
    stdout.writeln('What is the name of the task?');
    String inputName = stdin.readLineSync();

    if(inputName.length < 1) {
      stdout.writeln('Name must containe at list 1 symbol');
      chooseName();
    } else {
      name = inputName;
    }
  }
  void chooseCategory() {
    stdout.writeln('What is the category of the task? 1 - Work tasks, 2 - Hobby, 3 - Homework');
    String inputCategory = stdin.readLineSync();
    
    switch(inputCategory) {
      case('1'):
        category = 'Work tasks';
        break;

      case('2'):
        category = 'Hobby';
        break;

      case('3'):
        category = 'Homework';
        break;

      default:
        stdout.writeln('Choose some category');
        chooseCategory();
        break;
    }
  }
  void showCategory(String category) {
    data.getTasks();
    bool validCategory = false;
    allTasks.forEach((key, value) {
      if(key == category) {
        validCategory = true;
      }
    });
    if(validCategory) {
      int taskNumber = allTasks[category].length;
      List thisCategory = allTasks[category];
      print('Category contain $taskNumber tasks. $thisCategory');
    } else {
      print('There is no such category');
    }
  }
}
