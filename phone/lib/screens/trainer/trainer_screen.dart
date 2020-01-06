import 'package:flutter/material.dart';
import 'package:phone/screens/main/messages_screen.dart';
import 'package:phone/screens/trainer/client_card.dart';
import 'package:phone/screens/main/profile_edit.dart';
import 'client_card.dart';
import 'package:phone/screens/main/dialog.dart';
import '../../components/users.dart';
import 'package:flutter/services.dart';

class TrainerPage extends StatefulWidget {
  final Trainer user;

  TrainerPage(this.user);

  @override
  _TrainerPageState createState() => _TrainerPageState(this.user);
}

class _TrainerPageState extends State<TrainerPage> {
  Trainer user;
  String search = '';

  _TrainerPageState(this.user);

  List<Widget> filterClients(String filterText) {
    if (filterText == '') {
      return this.user.myClientCards();
    }
    List<Widget> filteredClients = [];
    for (ClientCard client in this.user.myClientCards()) {
      String clientName = client.name.toLowerCase();
      if (clientName.contains(filterText.toLowerCase())) {
        filteredClients.add(client);
      }
    }
    return filteredClients;
  }

  void addClient(BuildContext context) {
    String firstName;
    String lastName;
    String email;
    String phone;

    SpecialDialog(context, 'Create a client', () {
      setState(() {
        this.user.addClient(
            Client(firstName, lastName, email, 'Bebop', phone, this.user));
      });
    }, <Widget>[
      Row(
        children: <Widget>[
          Expanded(
            child: TextField(
              decoration: InputDecoration(
                contentPadding: EdgeInsets.only(left: 10.0),
                labelText: 'First Name',
              ),
              onChanged: (value) {
                firstName = value;
              },
            ),
          ),
          Expanded(
            child: TextField(
              decoration: InputDecoration(
                contentPadding: EdgeInsets.only(left: 10.0),
                labelText: 'Last Name',
              ),
              onChanged: (value) {
                lastName = value;
              },
            ),
          ),
        ],
      ),
      TextField(
        decoration: InputDecoration(
          contentPadding: EdgeInsets.only(left: 10.0),
          labelText: 'Email',
        ),
        onChanged: (value) {
          email = value;
        },
      ),
      TextField(
        decoration: InputDecoration(
          contentPadding: EdgeInsets.only(left: 10.0),
          labelText: 'Phone Number',
        ),
        onChanged: (value) {
          phone = value;
        },
      ),
    ]);
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: _onWillPop,
      child: Scaffold(
        floatingActionButton: FloatingActionButton(
          child: Icon(Icons.add),
          onPressed: () {
            addClient(context);
          },
        ),
        appBar: AppBar(
          bottom: PreferredSize(
            preferredSize: Size(100, 50),
            child: Container(
              margin: EdgeInsets.only(top: 5.0),
              child: TextField(
                style: TextStyle(color: Colors.white),
                decoration: InputDecoration(
                  labelStyle: TextStyle(color: Colors.white),
                  contentPadding: EdgeInsets.only(left: 10.0),
                  labelText: 'Search by name',
                  prefixIcon: Icon(
                    Icons.search,
                    color: Colors.white,
                  ),
                ),
                onChanged: (value){setState(() {
                  this.search = value;
                });},
              ),
            ),
          ),
          leading: IconButton(
            icon: Image.asset('images/profile.png'),
            onPressed: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => SettingsPage(this.user)));
            },
          ),
          centerTitle: true,
          title: Text(
            'Trainer ' + this.user.firstName,
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
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => MessagePage(this.user)));
              },
            ),
          ],
        ),
        body: ListView(
          children: <Widget>[
            GridView.count(
              physics: NeverScrollableScrollPhysics(),
              shrinkWrap: true,
              crossAxisCount: 2,
              padding: EdgeInsets.all(10),
              children: this.filterClients(this.search),
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
      ),
    );
  }
}


Future<bool> _onWillPop() async {
  //await showDialog or Show add banners or whatever
  // then
  await SystemNavigator.pop(animated: true);
  return false; // return true if the route to be popped
}
