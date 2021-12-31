import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:uas_f02/page/nasywa/add_news_page.dart';
import 'package:uas_f02/page/nasywa/news_model.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';


class NewsPage extends StatelessWidget {
  final String name;
  final String urlImage;
  final String email;

  NewsPage({
    Key? key,
    required this.name,
    required this.email,
    required this.urlImage,
  }) : super(key: key);

  List<News> newslst = [];

  //Future getNews() async {
  // final response = await http.get(Uri.parse('http://django-f02.herokuapp.com/note/flutter/get-news/'));
  //  newslst = json.decode(response.body)
   //     .map((data) => News.fromJson(data))
    //    .toList();
  //}

  @override
  Widget build(BuildContext context) =>
      Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.blue,
          title: Text("News"),
          centerTitle: true,
        ),
        body: ListView (
          padding: const EdgeInsets.all(20),
          children: [
            SizedBox(height: 16),
            //buildNews(),
          ],
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => AddNewsPage(name: name, email: email, urlImage: urlImage),
              ),
            );
          },
          child: Icon(Icons.add, size: 30, color: Colors.blue),
          backgroundColor: Colors.white,
        ),


      );

//  buildNews() {
 //   return Container(
  //      child: new ListView.builder(
 //           itemCount: newslst.length,
  //          itemBuilder: (BuildContext context, int index) {
   //           return Container(
   //             child: Card(
   //               child: Column(
    //                children: <Widget>[
    //                  Text("newslst[index].title", style: TextStyle(fontWeight: FontWeight.bold)),
    //                  Text("newslst[index].desc")
    //                ],
    //              ),
    //            ),
    //          );
    //        }
    //    )
    //);
  //}
}

