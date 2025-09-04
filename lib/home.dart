import 'package:flutter/material.dart';

class Home extends StatefulWidget {

  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {

  double totalExpenses = 0;

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
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // TO DO
        },
        backgroundColor: Colors.blue,
        foregroundColor: Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(100),
        ),
        child: Icon(Icons.add),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
            SizedBox(width: 18),
            Text(
              "Date Today", // REPLACE WITH VARIABLE
              style: TextStyle(
                color: Colors.black,
                fontSize: 16,
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
            "₱ ${totalExpenses.toStringAsFixed(2)}",
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
          SizedBox(
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
            child: Text("ADD"),
          ),

          SizedBox(height: 81),

          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ExpenseCard(amount: 50, name: "Commute"),
              SizedBox(width: 28),
              ExpenseCard(amount: 100, name: "Food"),
            ],
          ),
        ],
      ),
    );
  }
}

class ExpenseCard extends StatelessWidget {
  final double amount;
  final String name;

  const ExpenseCard({
    super.key,
    required this.amount,
    required this.name,
  });

  @override
  Widget build(BuildContext context) {
    return TextButton(
      style: TextButton.styleFrom(
        fixedSize: Size(150, 160),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(5),
        ),
        side: BorderSide(
          color: Colors.black,
          width: 0.8,
        ),
      ),
      onPressed: () {
        // TO DO
      },
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            "₱$amount",
            style: TextStyle(
              color: Colors.black,
              fontSize: 30,
              fontWeight: FontWeight.bold,
            ),
          ),
          Text(
            name,
            style: TextStyle(
              color: Colors.black,
              fontSize: 16,
              fontWeight: FontWeight.normal,
            ),
          ),
        ],
      ),
    );
  }

}