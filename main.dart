import 'package:firebase/add_movie.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'add_movie.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData.dark(),
      title: "Movies",
      home: const Homepage(),
    );
  }
}

class Homepage extends StatelessWidget {
  const Homepage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Center(child: Text("Firebase")),
        leading: IconButton(
            onPressed: () {
              Navigator.of(context).push(MaterialPageRoute(
                builder: (BuildContext context) {
                  return AddPage();
                },
                fullscreenDialog: true,
              ));
            },
            icon: Icon(Icons.add)),
      ),
      body: Movies(),
    );
  }
}

class Movies extends StatefulWidget {
  Movies({Key? key}) : super(key: key);

  @override
  State<Movies> createState() => _MoviesState();
}

class _MoviesState extends State<Movies> {
  final Stream<QuerySnapshot> _moviesStream =
      FirebaseFirestore.instance.collection('Movies').snapshots();
  void addLike(String docID, int likes) {
    var newLikes = likes + 1;
    try {
      FirebaseFirestore.instance.collection('Movies').doc(docID).update({
        'likes': newLikes,
      }).then((value) => print('données à jour'));
    } catch (e) {
      print(e.toString());
    }
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
        stream: _moviesStream,
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.hasError) {
            return Text('Something went wrong');
          }

          if (snapshot.connectionState == ConnectionState.waiting) {
            return Text("Loading");
          }

          return ListView(
            children: snapshot.data!.docs.map((DocumentSnapshot document) {
              Map<String, dynamic> movie =
                  document.data()! as Map<String, dynamic>;
              return Padding(
                padding: EdgeInsets.all(10),
                child: Row(
                  children: [
                    SizedBox(width: 100, child: Image.network(movie['poster'])),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 8),
                      child: Column(
                        children: [
                          Text(
                            movie['name'],
                            style: TextStyle(
                                fontSize: 25, fontWeight: FontWeight.w900),
                          ),
                          Text("Année de production "),
                          Text(movie['year'].toString()),
                          Row(
                            children: [
                              for (final categorie in movie['categories'])
                                Padding(
                                  padding: EdgeInsets.only(right: 5),
                                  child: Chip(
                                    label: Text(categorie),
                                    backgroundColor: Colors.blue,
                                  ),
                                ),
                            ],
                          ),
                          Row(
                            children: [
                              Container(
                                  padding: EdgeInsets.only(right: 140),
                                  child: Row(
                                    children: [
                                      IconButton(
                                          onPressed: () {
                                            addLike(
                                                document.id, movie['likes']);
                                          },
                                          icon: Icon(Icons.favorite)),
                                      SizedBox(width: 1),
                                      Text(
                                        movie['likes'].toString(),
                                      ),
                                    ],
                                  ))
                            ],
                          )
                        ],
                      ),
                    ),
                  ],
                ),
              );
            }).toList(),
          );
        });
  }
}
