import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'expense_card.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'record.dart';

class Home extends StatefulWidget {

  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {

  double totalExpenses = 0;
  static const double floatingButtonsSpacing = 10;

  late Record record;
  late final SharedPreferences prefs;

  @override
  void initState() {
    super.initState();
    record = Record(id: 'loading...', label: '', expenses: [], total: 0);
    _initDate();
  }

  void _initDate() async {
    prefs = await SharedPreferences.getInstance();

    final todayId = DateFormat("MMM-dd-yyyy").format(DateTime.now());
    String? savedDateStateID = prefs.getString('savedDateStateID');

    if(savedDateStateID == null || savedDateStateID != todayId) {
      await prefs.setString('savedDateStateID', todayId);

      setState(() {
        record = Record(
          id: todayId,
          label: '',
          expenses: [],
          total: 0,
        );
      });

      await prefs.setString(todayId, jsonEncode(record.toJson()));
    } else { // if same day/date
      String? recordJson = prefs.getString(todayId);
      if(recordJson != null) {
        setState(() {
          record = Record.fromJson(jsonDecode(recordJson));
        });
      } else {
        setState(() {
          record = Record(
            id: savedDateStateID,
            label: '',
            expenses: [],
            total: 0,
          );
        });

        await prefs.setString(todayId, jsonEncode(record.toJson()));
      }
    }
  }

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
      floatingActionButton: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          FloatyButton(
            func: () {
              debugPrint("redo");
            },
            icon: Icon(Icons.keyboard_arrow_right_rounded)
          ),
          SizedBox(width: floatingButtonsSpacing),
          FloatyButton(
              func: () {
                debugPrint("undo");
              },
              icon: Icon(Icons.keyboard_arrow_left_rounded)
          ),
          SizedBox(width: floatingButtonsSpacing),
          FloatyButton(
              func: () {
                debugPrint("plus");
              },
              icon: Icon(Icons.add)
          ),
        ],
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
              // Date Label
              record.label == '' ? record.id : record.label,
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
              onPressed: () async {
                final controller = TextEditingController(
                  text: record.label == '' || record.label.isEmpty ? record.id : record.label
                );

                WidgetsBinding.instance.addPostFrameCallback((_) {
                  controller.selection = TextSelection(
                    baseOffset: 0,
                    extentOffset: controller.text.length,
                  );
                });

                String? newLabel = await showDialog<String>(
                  context: context,
                  builder: (context) {
                    return AlertDialog(
                      title: Text("Enter Record Name", textAlign: TextAlign.center),
                      content: TextField(
                        controller: controller,
                        decoration: InputDecoration(hintText: "EnterLabel"),
                        autofocus: true,
                        textAlign: TextAlign.center,
                      ),
                      actionsAlignment: MainAxisAlignment.center,
                      actionsPadding: EdgeInsets.only(bottom: 15),
                      actions: [
                        TextButton(
                          onPressed: () => Navigator.pop(context, null),
                          child: Text("Cancel"),
                        ),
                        SizedBox(width: 50),
                        TextButton(
                          onPressed: () => Navigator.pop(context, controller.text.trim()),
                          child: Text("Enter"),
                        )
                      ],
                    );
                  },
                );

                controller.dispose();

                if(newLabel != null && newLabel.isNotEmpty) {
                  setState(() {
                    record.label = newLabel;
                  });
                }

                prefs.setString(record.id, jsonEncode(record.toJson()));
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

          SizedBox(height: 12),

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
              debugPrint("added");
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

class FloatyButton extends StatelessWidget {
  final VoidCallback func;
  final Icon icon;


  const FloatyButton({
    super.key,
    required this.func,
    required this.icon
  });

  @override
  Widget build(BuildContext context) {
    return FloatingActionButton(
      onPressed: func,
      backgroundColor: Colors.blue,
      foregroundColor: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(100),
      ),
      child: icon,
    );
  }
}