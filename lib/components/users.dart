import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'paperwork.dart';
import 'dart:math';

class User {
  String firstName;
  String lastName;
  String email;
  String _password;
  String phoneNum;
  List<User> messageList = [];
  ImageProvider photo = AssetImage('images/profile.png');

  User(firstName, lastName, email, password, cellNum) {
    this.firstName = firstName;
    this.lastName = lastName;
    this.email = email;
    this._password = password;
    this.phoneNum = cellNum;
  }

  bool signIn(String email, String password) {
    return (this.email == email) && (this._password == password);
  }

  void setName(String name) {
    var splitName = name.split(' ');
    this.firstName = splitName[0];
    this.lastName = splitName[1];
  }

  void setPassword(String password) {
    this._password = password;
  }

}


class Client extends User{

  List<Program> programs = [];
  Trainer trainer;
  List<Goal> goals = [];
  int sessions = 0;

  Client(String firstName, String lastName, String email, String password, String cellNum) :
        super(firstName, lastName, email, password, cellNum);

  void assignTrainer(Trainer trainer){
    this.trainer = trainer;
    this.messageList.add(trainer);

  }

  bool get status{
    return this.sessions > 0;
  }

  void addProgram(Program program){
    this.programs.add(program);
  }

  void addGoal(Goal goal){
    this.goals.add(goal);
  }

  void addSessions(int sessionsNum){
    this.sessions += sessionsNum;
  }

}


class Group extends User{
  Trainer trainer;
  List<Program> programs = [];
  List<Client> clients = [];
  List<Goal> goals = [];

  Group(String name, Trainer trainer, ) :
  super(null, null, null, null, null){
    this.messageList.add(trainer);
  }

  @override
  bool signIn(String email, String password){
    return false;
  }

  void addClient(Client client){
    this.clients.add(client);
    this.goals.addAll(client.goals);
    this.trainer = client.trainer;
  }

  void addProgram(Program program){
    this.programs.add(program);

    for(Client client in this.clients) {
      client.addProgram(program);
    }
  }
}


class Trainer extends User{
  List<Client> clients = [];

  Trainer(String firstName, String lastName, String email, String password, String cellNum) :
        super(firstName, lastName, email, password, cellNum);

  void addClient(Client client){
    this.clients.add(client);
    client.assignTrainer(this);
  }

  void addClientMessage(Client client){
    this.messageList.add(client);
  }


}

class Director extends Trainer{
  List<Trainer> trainers = [];
  List<Trainer> directors = [];

  Director(String firstName, String lastName, String email, String password, String cellNum) :
        super(firstName, lastName, email, password, cellNum);

  void addTrainer(Trainer trainer){
    this.trainers.add(trainer);
  }


  void addDirector(Director dir){
    this.directors.add(dir);
  }

}


class UserCreator{

  static String phoneNumberGenerator(){
    Random generator = Random();
    String phoneNum = '';

    for(int i = 0; i < 10; i++){
      phoneNum += generator.nextInt(10).toString();
    }

    return phoneNum;
  }

  static void registerUser(String email, String password) async {
    try {
      final _auth = FirebaseAuth.instance;
      await _auth.createUserWithEmailAndPassword(email: email, password: password);
      await _auth.signOut();
    } catch (e) {print(e);}
  }

  static List<User> create(){
    Random generator = Random();

    List<String> firstNames = ['Ahmed', 'Jotaro', 'Dio', 'Joe', 'James', 'Juan', 'Richard', 'Ahsan', 'Moaz', 'Mohammed'];
    List<String> lastNames = ['Mo', 'Kujo', 'Martinez', 'Brando', 'Joestar', 'Bob', 'Henry', 'Waheed', 'Mohammed', 'Smith'];
    List<Goal> goals = [Goal(exercise: 'Lose', load: 15, date: 'March 2020', current: 5,),
      Goal(exercise: 'Bench Press', load: 315, date: 'March 2020', current: 265,),
      Goal(exercise: 'OverHead Press', load: 225, date: 'March 2020', current: 135,),
      Goal(exercise: 'Squat', load: 405, date: 'March 2020', current: 315,),
      Goal(exercise: 'Run', load: 1, date: 'March 2020', unit: 'Mile(s)', current: 0.7,),
      Goal(exercise: 'Gain', load: 20, date: 'March 2020', current: 0,),];

    List<Client> clients = [];

    Director dir1 = Director('Hiro', 'Diver', 'dir1@app.com', 'Bebop!', UserCreator.phoneNumberGenerator());
    //registerUser(dir1.email, dir1._password);
    Director dir2 = Director('Youssef', 'Nafei', 'dir2@app.com', 'Bebop!', UserCreator.phoneNumberGenerator());
    //registerUser(dir2.email, dir2._password);

    Trainer train1 = Trainer('Taqi', 'Hamoda', 'train1@app.com', 'Bebop!', UserCreator.phoneNumberGenerator());
    //registerUser(train1.email, train1._password);
    Trainer train2 = Trainer('Samy', 'Hamoda', 'train2@app.com', 'Bebop!', UserCreator.phoneNumberGenerator());
    //registerUser(train2.email, train2._password);

    Client client = Client('Andrew', 'Petersen', 'client@app.com', 'Bebop!', '1234567890');
    //registerUser(client.email, client._password);
    client.addGoal(goals[0]);
    client.addGoal(goals[2]);
    client.addGoal(goals.elementAt(goals.length - 1));

    Program program = Program(name: 'PPL', goals: goals);

    Exercise exercise = Exercise();
    exercise.name = 'Bench Press';
    exercise.sets = '3';
    exercise.reps = '10';
    exercise.rest = '30 s';
    exercise.weight = '100 kg';

    program.addExercise(exercise);
    client.addProgram(program);

    train2.addClient(client);
    clients.add(client);

    dir1.addTrainer(train1);
    dir1.addTrainer(train2);
    dir2.addTrainer(train1);
    dir2.addTrainer(train2);
    dir1.addDirector(dir2);
    dir2.addDirector(dir1);

    for(int i = 0; i < 30; i++){
      String firstName = firstNames[generator.nextInt(firstNames.length)];
      String lastName = lastNames[generator.nextInt(lastNames.length)];
      Goal goal1 = goals[generator.nextInt(goals.length)];
      Goal goal2 = goals[generator.nextInt(goals.length)];
      Goal goal3 = goals[generator.nextInt(goals.length)];

      Client client = Client(firstName, lastName, firstName.toLowerCase() + lastName.toLowerCase() + '@app.com', 'Bebop!', UserCreator.phoneNumberGenerator());
      //registerUser(client.email, client._password);

      int number = generator.nextInt(4);

      if(number == 0){
        dir1.addClient(client);
        client.addGoal(goal1);
        client.addGoal(goal2);
        client.addGoal(goal3);
      }

      else if(number == 1){
        dir2.addClient(client);
        client.addGoal(goal1);
        client.addGoal(goal2);
        client.addGoal(goal3);
      }

      else if(number == 2){
        train1.addClient(client);
        client.addGoal(goal1);
        client.addGoal(goal2);
        client.addGoal(goal3);
      }

      else{
        train2.addClient(client);
        client.addGoal(goal1);
        client.addGoal(goal2);
        client.addGoal(goal3);
      }
    }


    List<User> users = [dir1, dir2, train1, train2];
    users.addAll(clients);

    return users;
  }

}
