import 'package:flutter/material.dart';

class Home extends StatefulWidget {

  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        centerTitle: true,
        title: Text("Pindot-Pindot", style: TextStyle(color: Colors.white)),
        backgroundColor: Colors.blue,
        actions: [
          IconButton(
            icon: Icon(Icons.calendar_month),
            onPressed: () {
              // TO DO
            },
            color: Colors.white,
          ),
        ],
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
            SizedBox(width: 18),
            Text(
              "Date Today",
              style: TextStyle(
                color: Colors.black,
                fontSize: 18,
              ),
            ),
            IconButton(
              icon: Icon(
                Icons.edit,
                color: Colors.black,
                size: 15,
              ),
              onPressed: () {
                // TO DO
              },
            ),
          ],),

          SizedBox(height: 20),

          Text(
            "P 100.00", // REPLACE WITH A VARIABLE
            style: TextStyle(
              color: Colors.black,
              fontSize: 40,
              fontWeight: FontWeight.bold,
            ),
          ),
          Divider(
            height: 0.5,
            color: Colors.black,
            indent: 150,
            endIndent: 150,
          ),

          SizedBox(height: 60),

          Text(
            "custom amount",
            style: TextStyle(
              color: Colors.black,
              fontSize: 14,
            ),
          ),
          Container(
            height: 40,
            width: 150,
            child: TextField(
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 13
              ),
            ),
          ),

          SizedBox(height: 10),

          TextButton(
            child: Text("ADD"),
            style: TextButton.styleFrom(
              backgroundColor: Colors.blue,
              foregroundColor: Colors.white,
              padding: EdgeInsets.symmetric(vertical: 15, horizontal: 30),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(5)
              ),
            ),
            onPressed: () {

            },
          ),
        ],
      ),
    );
  }
}