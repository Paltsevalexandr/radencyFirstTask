import 'dart:core';
import 'dart:io';

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
