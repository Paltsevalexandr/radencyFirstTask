import 'dart:core';
import 'dart:io';
import 'dart:convert';
import 'package:args/args.dart';

ArgResults argResults;
void main(List<String> arguments) {

  final parser = ArgParser();
  parser.addFlag('add_task', negatable: false, abbr: 'a');
  parser.addFlag('del_task', negatable: false, abbr: 'd');
  parser.addFlag('all_tasks', negatable: false, abbr: 't');

  argResults = parser.parse(arguments);
  final delTaskId = argResults.rest;
  cli(argResults, delTaskId);
}

void cli(argResults, rest) async {
  Tasks task = Tasks();
  try{
    if(argResults['add_task']) {
      task.createTask();
      
    } else if(argResults['del_task']) {
      todoList.delTask(int.parse(rest[0]));


    } else if(argResults['all_tasks']) {
      Map allTasks = todoList.getTasks();
      stdout.writeln(allTasks);
    }
  } catch(_) {
    await handleError();
  }
}
void handleError() {
  print('error');
}
TodoList todoList = TodoList();

class TodoList {
  Map getTasks() {
    
  }
  void saveTask() {
    
    
  }
  void delTask(int id) {
    
  }
  void saveData(data) {
    
  }
}

class Tasks {
  int id = 0;
  String name = '';
  String category = '';

  void createTask() {
    
    stdout.writeln('Do you want to create new task?(y or n)');
    String input = stdin.readLineSync();
  
    switch(input.toLowerCase()){
      case('n'):
        stdout.writeln('ok');
        break;
      
      case('y'):
        stdout.writeln('begin create');
        chooseName();
        chooseCategory();
        //todoList.saveTask();
        break;

      default:
        stdout.writeln('Print "y" or "n"');
        createTask();
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
}
