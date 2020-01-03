import 'package:flutter/material.dart';
import 'package:phone/screens/add_client_screen.dart';
import 'package:phone/screens/messages_screen.dart';
import 'package:phone/screens/client_card.dart';
import 'package:phone/screens/settings_screen.dart';
import 'client_card.dart';
import '../components/users.dart';

class TrainerPage extends StatefulWidget {
  final Trainer user;

  TrainerPage(this.user);

  @override
  _TrainerPageState createState() => _TrainerPageState(this.user);
}

class _TrainerPageState extends State<TrainerPage> {
  List<Widget> clients = []; // original client list
  List<Widget> tempClients = []; // filtered client list
  String searchText = '';
  Trainer user;


  _TrainerPageState(this.user);

  void createClients() {
    for(Client client in this.user.clients){

      this.clients.add(ClientCard(
          client: client,
          name: client.firstName + " " + client.lastName,
          photo: 'images/profile.png'));
    }
    tempClients.addAll(clients);
  }

  List<Widget> filterClients(String filterText){
    if(filterText == ''){
      return clients;
    }
    List<Widget> filteredClients = [];
    for(ClientCard client in this.clients){
      String clientName = client.name.toLowerCase();
      if(clientName.contains(filterText.toLowerCase())){
        filteredClients.add(client);
      }
    }
    return filteredClients;

  }

  @override
  void initState(){
    createClients();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: () {
          Navigator.push(context,
              MaterialPageRoute(builder: (context) => AddClientPage()));
          },
      ),

      appBar: AppBar(
        leading: IconButton(
          icon: Image.asset('images/profile.png'),
          onPressed: () {
            Navigator.push(context,
                MaterialPageRoute(builder: (context) => SettingsPage()));
          },
        ),
        centerTitle: true,
        title: Text(
          'Trainer',
          style: TextStyle(
            fontSize: 30.0,
          ),
        ),
        actions: <Widget>[
          IconButton(
            icon: Icon(
              Icons.near_me,
            ),
            onPressed: () {
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => MessagePage(this.user)));
            },
          ),
        ],
      ),

      body: ListView(
        children: <Widget>[
          TextField(
            decoration: InputDecoration(
              contentPadding: EdgeInsets.only(left: 10.0),
              labelText: 'Search by name',
              prefixIcon: Icon(
                Icons.search,
              ),
            ),
            onChanged: (value){
              this.searchText = value;
              setState(() {
                tempClients = filterClients(searchText);
              });
            },
          ),
          GridView.count(
            physics: NeverScrollableScrollPhysics(),
            shrinkWrap: true,
            crossAxisCount: 2,
            padding: EdgeInsets.all(10),
            children: tempClients,
          ),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            title: Text('Home'),
            icon: Icon(
              Icons.home,
            ),
          ),
          BottomNavigationBarItem(
            title: Text('Schedule'),
            icon: Icon(
              Icons.calendar_today,
            ),
          ),
        ],
      ),
    );
  }
}
