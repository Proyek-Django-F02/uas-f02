import 'package:flutter/material.dart';
import 'package:uas_f02/page/all.dart';
import 'package:shared_preferences/shared_preferences.dart';

class NavigationDrawerWidget extends StatefulWidget {
  const NavigationDrawerWidget({Key? key}) : super(key: key);
  @override
  NavigationDrawerWidgetState createState() => NavigationDrawerWidgetState();
}

class NavigationDrawerWidgetState extends State<NavigationDrawerWidget> {
  final padding = EdgeInsets.symmetric(horizontal: 20);
  final Future<SharedPreferences> _prefs = SharedPreferences.getInstance();
  late Future<String> _email;
  late Future<String> _username;

  @override
  void initState() {
    super.initState();
    _email = _prefs.then((SharedPreferences prefs) {
      return prefs.getString('email') ?? '';
    });
    _username = _prefs.then((SharedPreferences prefs) {
      return prefs.getString('username') ?? '';
    });
  }

  Future<void> _logout() async {
    final SharedPreferences prefs = await _prefs;
    setState(() {
      _email = prefs.setString('email', "").then((bool success) {
        return "";
      });
      _username = prefs.setString('username', "").then((bool success) {
        return "";
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    final urlImage =
        'https://64.media.tumblr.com/b2274200b6c46495f31c1e0a6678dc86/05ebb2b05dc70fb3-60/s640x960/a42b3a3ccd9fdf24d376508c7e223fb0db40de08.jpg';
    return SizedBox(
      width: MediaQuery.of(context).size.width *
          0.75, // 75% of screen will be occupied
      child: FutureBuilder<List<String>>(
        future: Future.wait([_username, _email]),
        builder: (context, AsyncSnapshot<List<dynamic>> snapshot) {
          switch (snapshot.connectionState) {
            case ConnectionState.waiting:
              return const CircularProgressIndicator();
            default:
              if (snapshot.hasError) {
                return Text('Error: ${snapshot.error}');
              } else {
                bool isLoggedIn = snapshot.data?[0] != '';
                return Drawer(
                  child: Material(
                    color: Color.fromRGBO(50, 75, 205, 1),
                    child: ListView(
                      children: <Widget>[
                        buildHeader(
                          isLoggedIn: isLoggedIn,
                          urlImage: urlImage,
                          name: snapshot.data?[0],
                          email: snapshot.data?[1],
                          onClicked: () =>
                              Navigator.of(context).push(MaterialPageRoute(
                            builder: (context) => ProfilePage(
                              name: snapshot.data?[0],
                              email: snapshot.data?[1],
                              urlImage: urlImage,
                            ),
                          )),
                        ),
                        Container(
                          padding: padding,
                          child: Column(
                            children: [
                              const SizedBox(height: 10),
                              buildMenuItem(
                                isLoggedIn: isLoggedIn,
                                text: 'Profile',
                                icon: Icons.person,
                                onClicked: () => selectedItem(
                                    context,
                                    0,
                                    snapshot.data?[0],
                                    snapshot.data?[1],
                                    urlImage),
                              ),
                              const SizedBox(height: 3),
                              buildMenuItem(
                                isLoggedIn: isLoggedIn,
                                text: 'To Do List',
                                icon: Icons.check_box,
                                onClicked: () => selectedItem(
                                    context,
                                    1,
                                    snapshot.data?[0],
                                    snapshot.data?[1],
                                    urlImage),
                              ),
                              const SizedBox(height: 3),
                              buildMenuItem(
                                isLoggedIn: isLoggedIn,
                                text: 'Notes',
                                icon: Icons.note_add_rounded,
                                onClicked: () => selectedItem(
                                    context,
                                    2,
                                    snapshot.data?[0],
                                    snapshot.data?[1],
                                    urlImage),
                              ),
                              const SizedBox(height: 3),
                              buildMenuItem(
                                isLoggedIn: isLoggedIn,
                                text: 'My Schedule',
                                icon: Icons.schedule,
                                onClicked: () => selectedItem(
                                    context,
                                    3,
                                    snapshot.data?[0],
                                    snapshot.data?[1],
                                    urlImage),
                              ),
                              const SizedBox(height: 3),
                              buildMenuItem(
                                isLoggedIn: isLoggedIn,
                                text: 'Community Forum',
                                icon: Icons.people_alt,
                                onClicked: () => selectedItem(
                                    context,
                                    4,
                                    snapshot.data?[0],
                                    snapshot.data?[1],
                                    urlImage),
                              ),
                              const SizedBox(height: 3),
                              buildMenuItem(
                                isLoggedIn: isLoggedIn,
                                text: 'Anonymous Message',
                                icon: Icons.security_rounded,
                                onClicked: () => selectedItem(
                                    context,
                                    5,
                                    snapshot.data?[0],
                                    snapshot.data?[1],
                                    urlImage),
                              ),
                              const SizedBox(height: 3),
                              buildMenuItem(
                                isLoggedIn: isLoggedIn,
                                text: 'News',
                                icon: Icons.wifi_tethering_outlined,
                                onClicked: () => selectedItem(
                                    context,
                                    6,
                                    snapshot.data?[0],
                                    snapshot.data?[1],
                                    urlImage),
                              ),
                              const SizedBox(height: 15),
                              Divider(color: Colors.white70),
                              const SizedBox(height: 15),
                              buildMenuItem(
                                  isLoggedIn: isLoggedIn,
                                  text: 'Logout',
                                  icon: Icons.logout,
                                  onClicked: () {
                                    _logout();
                                    selectedItem(context, 7, snapshot.data?[0],
                                        snapshot.data?[1], urlImage);
                                  }),
                              buildMenuItem(
                                isLoggedIn: !isLoggedIn,
                                text: 'Login',
                                icon: Icons.login,
                                onClicked: () => selectedItem(
                                    context,
                                    7,
                                    snapshot.data?[0],
                                    snapshot.data?[1],
                                    urlImage),
                              ),
                              const SizedBox(height: 15),
                              buildMenuItem(
                                isLoggedIn: !isLoggedIn,
                                text: 'Register',
                                icon: Icons.app_registration_rounded,
                                onClicked: () => selectedItem(
                                    context,
                                    8,
                                    snapshot.data?[0],
                                    snapshot.data?[1],
                                    urlImage),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              }
          }
        },
      ),
    );
  }

  Widget buildHeader({
    required bool isLoggedIn,
    required String urlImage,
    required String name,
    required String email,
    required VoidCallback onClicked,
  }) {
    if (!isLoggedIn) {
      return SizedBox(
        height: 0,
      );
    }
    return InkWell(
      onTap: onClicked,
      child: Container(
        padding: padding.add(EdgeInsets.only(top: 40, bottom: 20)),
        child: Row(
          children: [
            CircleAvatar(radius: 30, backgroundImage: NetworkImage(urlImage)),
            SizedBox(width: 20),
            Flexible(
                child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  name,
                  style: TextStyle(fontSize: 20, color: Colors.white),
                ),
                const SizedBox(height: 4),
                Text(
                  email,
                  style: TextStyle(fontSize: 14, color: Colors.white),
                ),
              ],
            )),
            Container(
              padding: EdgeInsets.only(left: 30, right: 10),
              child: CircleAvatar(
                radius: 24,
                backgroundColor: Color.fromRGBO(30, 60, 168, 1),
                child: Icon(Icons.mode_edit_outline, color: Colors.white),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget buildMenuItem({
    required bool isLoggedIn,
    required String text,
    required IconData icon,
    VoidCallback? onClicked,
  }) {
    final color = Colors.white;
    final hoverColor = Colors.white70;

    if (!isLoggedIn) {
      return SizedBox(
        height: 0,
      );
    }
    return ListTile(
      leading: Icon(icon, color: color),
      title: Text(text, style: TextStyle(color: color)),
      hoverColor: hoverColor,
      onTap: onClicked,
    );
  }

  void selectedItem(BuildContext context, int index, String name, String email,
      String urlImage) {
    Navigator.of(context).pop();

    switch (index) {
      case 0:
        Navigator.of(context).push(MaterialPageRoute(
          builder: (context) => ProfilePage(
            name: name,
            email: email,
            urlImage: urlImage,
          ),
        ));
        break;
      case 1:
        Navigator.of(context).push(MaterialPageRoute(
          builder: (context) => ToDoPage(
            name: name,
            email: email,
            urlImage: urlImage,
          ),
        ));
        break;
      case 2:
        Navigator.of(context).push(MaterialPageRoute(
          builder: (context) => Notes(
            name: name,
            email: email,
            urlImage: urlImage,
          ),
        ));
        break;
      case 3:
        Navigator.of(context).push(MaterialPageRoute(
          builder: (context) => SchedulePage(
            name: name,
            email: email,
            urlImage: urlImage,
          ),
        ));
        break;
      case 4:
        Navigator.of(context).push(MaterialPageRoute(
          builder: (context) => CommunityForumPage(
            name: name,
            email: email,
            urlImage: urlImage,
          ),
        ));
        break;
      case 5:
        Navigator.of(context).push(MaterialPageRoute(
          builder: (context) => AnonymousPage(
            name: name,
            email: email,
            urlImage: urlImage,
          ),
        ));
        break;
      case 6:
        Navigator.of(context).push(MaterialPageRoute(
          builder: (context) => NewsPage(
            name: name,
            email: email,
            urlImage: urlImage,
          ),
        ));
        break;
      case 7:
        Navigator.of(context).push(MaterialPageRoute(
          builder: (context) => LoginPage(),
        ));
        break;
      case 8:
        Navigator.of(context).push(MaterialPageRoute(
          builder: (context) => RegisterPage(),
        ));
        break;
    }
  }
}
