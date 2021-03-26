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
  parser.addFlag('new_task', negatable: false, abbr: 'n');
  parser.addFlag('del_task', negatable: false, abbr: 'd');
  parser.addFlag('show_all_tasks', negatable: false, abbr: 's');
  parser.addFlag('show_category', negatable: false, abbr: 'c');

  argResults = parser.parse(arguments);
  final delTaskId = argResults.rest;
  todoList.cli(argResults, delTaskId);
}


class TodoList {
  void cli(argResults, rest) {
  
    if(argResults['new_task']) {
      data.getTasks();
      int taskNumber = 1;
      if(rest.length > 0 && int.parse(rest[0]) is int){
        taskNumber = int.parse(rest[0]);
      }
      tasks.createTask(taskNumber);
      
    } else if(argResults['del_task']) {
      data.delTask(int.parse(rest[0]));

    } else if(argResults['show_all_tasks']) {
      data.getTasks();
      allTasks.forEach((key, value) {
        if(key != 'lastId') {
          stdout.writeln(value);
        }
      });
      

    } else if(argResults['show_category']) {
      if(rest.length > 0){
        tasks.showCategory(rest[0]);
      }
    }
  }
}

class Data {
  void saveTask(name, category, [String day = null]) {
    int id = ++allTasks['lastId'];
    Map task = {
      "name": name,
      "category": category,
      "id": id
    };
    if(day != null) {
      task['day'] = day;
    }
    
    List currentCategory = allTasks[task['category']].add({"id": id, ...task});
    allTasks = {task['category']: currentCategory, "lastId": id, ...?allTasks};
    
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
    if(thisTask != null) {
      allTasks[thisTask['category']].remove(thisTask);
      saveData(allTasks);
    } else {
      print('There is no task with this Id');
    }
    
  }
  void saveData(data) {
    final file = File('allTasks.json').openWrite(mode: FileMode.write);
    file.write(jsonEncode(data));
  }
  void getTasks() {
    final tasks = File('allTasks.json').readAsStringSync();
    allTasks = jsonDecode(tasks);
  }
}

class Tasks {
  String name = '';
  String category = '';
  String day = null;

  void createTask(int taskNumber) {
    
    stdout.writeln('Do you want to create new task?(y or n)');
    String input = stdin.readLineSync();
  
    switch(input.toLowerCase()){
      case('n'):
        stdout.writeln('ok');
        break;
      
      case('y'):
        chooseName();
        chooseCategory();
        stdout.writeln('Does this task is recurring? (y or n)');
        if(stdin.readLineSync() == 'y') {
          chooseDay();
        }else {
          day = null;
        }
        data.saveTask(name, category, day);
        --taskNumber;
        
        if(taskNumber > 0) {
          createTask(taskNumber);
        }
        break;

      default:
        stdout.writeln('Print "y" or "n"');
        createTask(taskNumber);
        break;
    }
    data.saveData(allTasks);
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
        category = 'Work_tasks';
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
  void chooseDay() {
    List days = ['Sunday', 'Monday', 'Tuesday', 'Wednesday', 'Thursday', 'Friday', 'Saturday'];
    DateTime date = DateTime.now();
    day = days[date.weekday];
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
