import 'package:flutter/material.dart';
import 'package:uas_f02/page/all.dart';

class NavigationDrawerWidget extends StatelessWidget {
  final padding = EdgeInsets.symmetric(horizontal: 20);
  @override
  Widget build(BuildContext context) {
    final name = 'Shioriko';
    final email = 'MifuneShioriko@nijigasaki.com';
    final urlImage =
        'https://64.media.tumblr.com/b2274200b6c46495f31c1e0a6678dc86/05ebb2b05dc70fb3-60/s640x960/a42b3a3ccd9fdf24d376508c7e223fb0db40de08.jpg';
    return SizedBox(
        width: MediaQuery.of(context).size.width *
            0.75, // 75% of screen will be occupied
        child: Drawer(
          child: Material(
            color: Color.fromRGBO(50, 75, 205, 1),
            child: ListView(
              children: <Widget>[
                buildHeader(
                  urlImage: urlImage,
                  name: name,
                  email: email,
                  onClicked: () => Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) => ProfilePage(
                      name: name,
                      email: email,
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
                        text: 'Profile',
                        icon: Icons.person,
                        onClicked: () =>
                            selectedItem(context, 0, name, email, urlImage),
                      ),
                      const SizedBox(height: 3),
                      buildMenuItem(
                        text: 'To Do List',
                        icon: Icons.check_box,
                        onClicked: () =>
                            selectedItem(context, 1, name, email, urlImage),
                      ),
                      const SizedBox(height: 3),
                      buildMenuItem(
                        text: 'Notes',
                        icon: Icons.note_add_rounded,
                        onClicked: () =>
                            selectedItem(context, 2, name, email, urlImage),
                      ),
                      const SizedBox(height: 3),
                      buildMenuItem(
                        text: 'My Schedule',
                        icon: Icons.schedule,
                        onClicked: () =>
                            selectedItem(context, 3, name, email, urlImage),
                      ),
                      const SizedBox(height: 3),
                      buildMenuItem(
                        text: 'Community Forum',
                        icon: Icons.people_alt,
                        onClicked: () =>
                            selectedItem(context, 4, name, email, urlImage),
                      ),
                      const SizedBox(height: 3),
                      buildMenuItem(
                        text: 'Anonymous Message',
                        icon: Icons.security_rounded,
                        onClicked: () =>
                            selectedItem(context, 5, name, email, urlImage),
                      ),
                      const SizedBox(height: 3),
                      buildMenuItem(
                        text: 'News',
                        icon: Icons.wifi_tethering_outlined,
                        onClicked: () =>
                            selectedItem(context, 6, name, email, urlImage),
                      ),
                      const SizedBox(height: 15),
                      Divider(color: Colors.white70),
                      const SizedBox(height: 15),
                      buildMenuItem(
                        text: 'logout',
                        icon: Icons.logout,
                        onClicked: () =>
                            selectedItem(context, 5, name, email, urlImage),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ));
  }

  Widget buildHeader({
    required String urlImage,
    required String name,
    required String email,
    required VoidCallback onClicked,
  }) =>
      InkWell(
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

  Widget buildMenuItem({
    required String text,
    required IconData icon,
    VoidCallback? onClicked,
  }) {
    final color = Colors.white;
    final hoverColor = Colors.white70;

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
          builder: (context) => NotesPage(
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
    }
  }
}
