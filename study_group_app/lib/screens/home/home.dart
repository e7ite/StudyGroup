import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:study_group_app/models/models.dart';
import 'package:study_group_app/screens/groups/groups.dart';
import 'package:study_group_app/services/services.dart';
import 'package:study_group_app/utilities/loading.dart';
import 'drawer.dart';

// Stateful home page class.
class HomePage extends StatefulWidget {
  HomePage({Key key}) : super(key: key);

  @override
// Creates the stateful widget HomePage
  _HomePageState createState() => _HomePageState();
}

// Inherits from HomePage above
class _HomePageState extends State<HomePage> {
  var appBarTitle = 'Home';
  int _selectedPage = 0;

  @override
  void initState() {
    super.initState();
  }

  // Main build function, generates the view
  @override
  Widget build(BuildContext context) {
    var user = Provider.of<User>(context);
    return user == null
        ? Loading()
        : StreamProvider<List<Group>>.value(
            value: GroupService(userUid: user.uid).groupData,
            child: Scaffold(
              backgroundColor: Theme.of(context).backgroundColor,
              appBar: AppBar(
                title: Text(appBarTitle),
              ),
              drawer: MainDrawer(user: user),
              body: SafeArea(
                top: false,
                child: IndexedStack(
                  index: _selectedPage,
                  children: [
                    GroupView(),
                    FindGroup(curUserId: user.uid),
                    CreateGroup()
                  ],
                ),
              ),
              bottomNavigationBar: Theme(
                data: Theme.of(context).copyWith(
                  canvasColor: Color(0xFF437c90),
                  textTheme: Theme.of(context)
                      .textTheme
                      .copyWith(headline6: TextStyle(color: Colors.white)),
                ),
                child: BottomNavigationBar(
                  selectedItemColor: Colors.black,
                  selectedFontSize: 16.0,
                  currentIndex: _selectedPage,
                  onTap: (int index) {
                    setState(() {
                      _selectedPage = index;
                      appBarTitle = allDestinations[index].title;
                    });
                  },
                  items: allDestinations.map((Destination destination) {
                    return BottomNavigationBarItem(
                        icon: Icon(destination.icon),
                        title: Text(destination.title));
                  }).toList(),
                ),
              ),
            ),
          );
  }

  @override
  void dispose() {
    super.dispose();
  }
}

// Bottom navigation bar constructors
class Destination {
  const Destination(this.title, this.icon);
  final String title;
  final IconData icon;
}

const List<Destination> allDestinations = <Destination>[
  Destination('Home', Icons.home),
  Destination('Search', Icons.search),
  Destination('Create', Icons.add)
];
