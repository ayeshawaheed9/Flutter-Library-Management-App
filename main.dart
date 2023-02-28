import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:toast/toast.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final databaseReference = FirebaseDatabase.instance.reference().child("books");

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Book Database"),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => AddBookPage(),
                  ),
                );
              },
              child: Text("Add New Book"),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => ViewBooksPage(),
                  ),
                );
              },
              child: Text("View Books"),
            ),
          ],
        ),
      ),
    );
  }
}

class AddBookPage extends StatefulWidget {
  @override
  _AddBookPageState createState() => _AddBookPageState();
}

class _AddBookPageState extends State<AddBookPage> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _authorController = TextEditingController();
  final _priceController = TextEditingController();
  final _ibanController = TextEditingController();
  final _typeController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Add New Book"),
      ),
      body: Form(
        key: _formKey,
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              TextFormField(
                controller: _titleController,
                decoration: InputDecoration(
                  labelText: "Title",
                ),
                validator: (value) {
                  if (value.isEmpty) {
                    return "Please enter the title";
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _authorController,
                decoration: InputDecoration(
                  labelText: "Author Name",
                ),
                validator: (value) {
                  if (value.isEmpty) {
                    return "Please enter the author name";
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _priceController,
                decoration: InputDecoration(
                  labelText: "Price",
                ),
                validator:(value) {
                  if (value.isEmpty) {
                    return "Please enter the price";
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _ibanController,
                decoration: InputDecoration(
                  labelText: "IBAN",
                ),
                validator: (value) {
                  if (value.isEmpty) {
                    return "Please enter the IBAN";
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _typeController,
                decoration: InputDecoration(
                  labelText: "Type of Book",
                ),
                validator: (value) {
                  if (value.isEmpty) {
                    return "Please enter the type of book";
                  }
                  return null;
                },
              ),
              RaisedButton(
                onPressed: () {
                  if (_formKey.currentState.validate()) {
                    final databaseReference = FirebaseDatabase.instance.reference().child("books");
                    databaseReference.push().set({
                      "title": _titleController.text,
                      "author": _authorController.text,
                      "price": _priceController.text,
                      "iban": _ibanController.text,
                      "type": _typeController.text,
                    });
                    Toast.show("Book added successfully!", context, duration: Toast.LENGTH_SHORT, gravity: Toast.BOTTOM);
                    Navigator.pop(context);
                  }
                },
                child: Text("Add Book"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class ViewBooksPage extends StatefulWidget {
  @override
  _ViewBooksPageState createState() => _ViewBooksPageState();
}

class _ViewBooksPageState extends State<ViewBooksPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("View Books"),
      ),
      body: FutureBuilder(
        future: FirebaseDatabase.instance.reference().child("books").once(),
        builder: (context, AsyncSnapshot<DataSnapshot> snapshot) {
          if (snapshot.hasData) {
            Map<dynamic, dynamic> books = snapshot.data.value;
            List<Book> bookList = [];
            books.forEach((key, value) {
              bookList.add(
                Book(
                  key: key,
                  title: value["title"],
                  author: value["author"],
                  price: value["price"],
                  iban: value["iban"],
                  type: value["type"],
                ),
              );
            });
            return ListView.builder(
              itemCount: bookList.length,
              itemBuilder: (context, index) {
                return Card(
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Text("Title: ${bookList[index].title}"),
                        Text("Author: ${bookList[index].author}"),
                        Text("Price: ${bookList[index].price}"),
                        Text("IBAN: ${bookList[index].iban}"),
                        Text("Type: ${bookList[index].type}"),
                      ],
                    ),
                  ),
                );
              },
            );
          }
          return Center(
            child: CircularProgressIndicator(),
          );
        },
      ),
    );
  }
}
class Book {
  final String key;
  final String title;
  final String author;
  final String price;
  final String iban;
  final String type;

  Book({
    this.key,
    this.title,
    this.author,
    this.price,
    this.iban,
    this.type,
  });
}

