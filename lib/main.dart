import 'dart:collection';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:fluttertoast/fluttertoast.dart';
import 'package:flutter/material.dart';


void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Youtube',
      theme: ThemeData(
       primarySwatch: Colors.lightBlue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: MyHomePage(title: "Search",),
    );
  }
}

class MyHomePage extends StatefulWidget {
  final String title;
  MyHomePage({Key key, this.title}) : super(key: key);
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
 var body;
  String url = "https://www.googleapis.com/youtube/v3/search?key=AIzaSyBFuaFFIinWH1OgbcJfdYHum5vTazioj7M&part=snippet&maxResults=20";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title,textAlign: TextAlign.center),
        actions: <Widget>[
//          IconButton(icon: Icon(Icons.search),onPressed: () {
//            showSearch(context: context, delegate: searchbutton());
//          })
        ],
      ),
      body: _buildSuggestions()
          );
  }

 Future<dynamic> fetchAlbum({String q="hello"}) async {
   Map<String,String> headers= {"Accept" : "application/json" };
   String url = "https://www.googleapis.com/youtube/v3/search?key=AIzaSyDXaNnissZDd7d2p5j3kFMJjW6OOVl5MiA&part=snippet&maxResults=20&q="+q;
   final response = await http.get(Uri.encodeFull(url),headers : headers );

   Fluttertoast.showToast(msg: response.body.toString() );
   if (response.statusCode == 200) {
     // If the server did return a 200 OK response,
     // then parse the JSON.
     var map = json.decode(response.body);
     body = map["items"];
     setState(() {
     //  Fluttertoast.showToast(msg: body.toString() );
     });
     return body;
   }
   else {
     // If the server did not return a 200 OK response,
     // then throw an exception.
     throw Exception('Failed to load album');
   }
 }


 Widget _buildSuggestions() {
   List<String> m=["hey","how","are","you","govinda","srrihar","bvoj"];

   return new Column(
       children: <Widget>[
         TextField(textAlign: TextAlign.left,decoration: InputDecoration(hintText: "Youtube Search"),onChanged :(text)
         {
if(text.length==0)
  {
    body=null;
    setState(() {

    });
  }
else {
  body=null;
  fetchAlbum(q: text);
}  }
         ,)
         , Expanded (
   child : ListView.builder(
   padding: const EdgeInsets.all(10.0),
   itemCount: (body==null)?0:body.length,
   itemBuilder: (context, i) {
   if (i < body.length) {
   return _buildRow(body[i]);
   }
   }
   ,
   )
   ),
       ]
   );
 }


 Widget _buildRow(var j) {
   return new Card(
     child : ListTile(
       leading:ConstrainedBox(
         constraints: BoxConstraints(
           minWidth: 44,
           minHeight: 44,
           maxWidth: 64,
           maxHeight: 64,
         ),
         child: Image.network(j["snippet"]["thumbnails"]["high"]["url"]),
       ),
       title: new Text(j["snippet"]["title"]),
       subtitle: new Text(j["snippet"]["description"]),
       isThreeLine: true,
     ),
   );
 }




}


//
//class searchbutton extends SearchDelegate {
//  @override
//  List<Widget> buildActions(BuildContext context) {
//      return [
//        IconButton(icon: Icon(Icons.clear), onPressed: () {
//                    query="";
//        },)
//      ];
//  }
//
//  @override
//  Widget buildLeading(BuildContext context) {
//    // TODO: implement buildLeading
//    return IconButton(icon: AnimatedIcon(
//        icon: AnimatedIcons.menu_arrow, progress: transitionAnimation),
//      onPressed: () {
//        close(context, "");
//      },);
//  }
//
//  @override
//  Widget buildResults(BuildContext context) {
//    // TODO: implement buildResults
//    throw UnimplementedError();
//  }
//
//  @override
//  Widget buildSuggestions(BuildContext context) {
//    // TODO: implement buildSuggestions
//    List<String> m = ["hey", "how", "are", "you", "govinda", "srrihar", "bvoj"];
//    int l = query.length;
//    if (query.length > 0) {
//         return FutureBuilder(
//         future: fetchAlbum(q: query),
//         builder: (BuildContext context, AsyncSnapshot<List<Album>> snapshot) {
//           if (snapshot.hasData) {
//            List<Album> posts = snapshot.data;
//             return ListView(
//              children: posts
//                  .map(
//                    (Album post) =>
//                    ListTile(
//                      title: new Text(post.title),
//                      leading: Image.network(post.userId),
//                      subtitle: new Text(post.id,),
//                      isThreeLine: true,
//                    ),
//              )  .toList(),
//            );
//          }
//        },
//      );
//      return ListView.builder(
//        itemBuilder: (context, index) =>
//            Card(child: ListTile(
//              title: new Text(m[index].toString()), leading: ConstrainedBox(
//              constraints: BoxConstraints(
//                minWidth: 44,
//                minHeight: 44,
//                maxWidth: 64,
//                maxHeight: 64,
//              ),
//              child: FlutterLogo(size: 60.0,),
//            ),
//              subtitle: new Text("This the example here you go",),
//              isThreeLine: true,
//            ),
//            ),
//        itemCount: m.length,
//      );
//    }
//    else
//      {
//
//      }
//  }
//}
//



class Album {
  final String userId;
  final String id;
  final String title;

  Album({this.userId, this.id, this.title});

  factory Album.fromJson(Map<String, dynamic> json) {
    return Album(
      userId: json['thumbnails']['high']['url'],
      id: json['snippet']['description'],
      title: json['snippet']['title'],
    );
  }
}
//  @override
//  Widget build(BuildContext context) {
//    return MaterialApp(
//      title: 'Fetch Data Example',
//      theme: ThemeData(
//        primarySwatch: Colors.blue,
//      ),
//      home: Scaffold(
//        appBar: AppBar(
//          title: Text('Fetch Data Example'),
//        ),
//        body: Center(
//          child: FutureBuilder<Album>(
//            future: futureAlbum,
//            builder: (context, snapshot) {
//              if (snapshot.hasData) {
//                return Text(snapshot.data.title);
//              } else if (snapshot.hasError) {
//                return Text("${snapshot.error}");
//              }
//
//              // By default, show a loading spinner.
//              return CircularProgressIndicator();
//            },
//          ),
//        ),
//      ),
//    );
//  }