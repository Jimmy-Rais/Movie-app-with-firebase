import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:multiselect/multiselect.dart';

class AddPage extends StatefulWidget {
  AddPage({Key? key}) : super(key: key);

  @override
  State<AddPage> createState() => _AddPageState();
}

class _AddPageState extends State<AddPage> {
  final nameController = TextEditingController();
  final yearController = TextEditingController();
  final posterController = TextEditingController();
  List<String> categories = [];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Add movie")),
      body: Padding(
        padding: EdgeInsets.all(20),
        child: Column(
          children: [
            ListTile(
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(4),
                    side: BorderSide(
                        color: Color.fromARGB(246, 255, 255, 255), width: 2)),
                title: Row(
                  children: [
                    Text('name: '),
                    Expanded(
                        child: TextField(
                      decoration: InputDecoration(
                        border: InputBorder.none,
                      ),
                      controller: nameController,
                    )),
                  ],
                )),
            SizedBox(height: 20),
            ListTile(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(4),
                  side: BorderSide(
                      color: Color.fromARGB(246, 255, 255, 255), width: 2)),
              title: Row(
                children: [
                  Text('Année: '),
                  Expanded(
                      child: TextField(
                    decoration: InputDecoration(
                      border: InputBorder.none,
                    ),
                    controller: yearController,
                  )),
                ],
              ),
            ),
            SizedBox(height: 20),
            ListTile(
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(4),
                    side: BorderSide(
                        color: Color.fromARGB(246, 255, 255, 255), width: 2)),
                title: Row(
                  children: [
                    Text('poster: '),
                    Expanded(
                        child: TextField(
                      decoration: InputDecoration(
                        border: InputBorder.none,
                      ),
                      controller: posterController,
                    )),
                  ],
                )),
            SizedBox(height: 20),
            DropDownMultiSelect(
              onChanged: (List<String> x) {
                setState(() {
                  categories = x;
                });
              },
              options: ['Actions', 'Science-fiction', 'Aventure', 'Comedie'],
              selectedValues: categories,
              whenEmpty: 'Categorie',
            ),
            SizedBox(height: 15),
            ElevatedButton(
                style: ElevatedButton.styleFrom(
                  minimumSize: Size.fromHeight(50),
                ),
                onPressed: () {
                  FirebaseFirestore.instance.collection('Movies').add({
                    'name': nameController.value.text,
                    'year': yearController.value.text,
                    'poster': posterController.value.text,
                    'categories': categories,
                    'likes': 0,
                  });
                  Navigator.pop(context);
                },
                child: Text('Ajouter'))
          ],
        ),
      ),
    );
  }
}
