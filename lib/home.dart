import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'expense.dart';
import 'expense_card.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'record.dart';
import 'package:uuid/uuid.dart';

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
  final uuid = Uuid();

  static const String dateIDPrefix = "dateID_";
  static const String expenseIDPrefix = "expenseID_";

  List<Expense>? expenses;

  @override
  void initState() {
    super.initState();
    record = Record(id: 'loading...', label: '', expenses: {}, total: 0);
    _initPrefs();
  }

  void _initPrefs() async {
    prefs = await SharedPreferences.getInstance();
    _initDate();
    _initExpenses();
  }

  void _initDate() async {
    final todayId = "$dateIDPrefix${DateFormat("MMM-dd-yyyy").format(DateTime.now())}";
    String? savedDateStateID = prefs.getString('savedDateStateID');

    if(savedDateStateID == null || savedDateStateID != todayId) {
      await prefs.setString('savedDateStateID', todayId);

      setState(() {
        record = Record(
          id: todayId,
          label: '',
          expenses: {},
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
            expenses: {},
            total: 0,
          );
        });

        await prefs.setString(todayId, jsonEncode(record.toJson()));
      }
    }
  }

  void _initExpenses() async {
    final allKeys = prefs.getKeys();
    final expenseKeys = allKeys.where((key) => key.startsWith(expenseIDPrefix));

    final loadedExpenses = expenseKeys.map((key) {
      final jsonStr = prefs.getString(key);

      if(jsonStr == null) return null;

      final data = jsonDecode(jsonStr);
      return Expense.fromJson(data);
    }).whereType<Expense>().toList()
    ..sort((a, b) => a.name.compareTo(b.name));

    setState(() {
      expenses = loadedExpenses;
    });
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
              func: _addTemplate,
              icon: Icon(Icons.add)
          ),
        ],
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(width: 18),
                Text(
                  // Date Label
                  record.label == '' ? record.id.replaceFirst(dateIDPrefix, '') : record.label,
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
              "₱ ${record.total.toStringAsFixed(2)}",
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
              onPressed: () async {
                final nameController = TextEditingController();
                final amountController = TextEditingController();

                List<String>? result = await showDialog<List<String>>(
                  context: context,
                  builder: (context) {
                    return AlertDialog(
                      title: Text("Custom Amount", textAlign: TextAlign.center),
                      content: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          TextField(
                            controller: nameController,
                            decoration: InputDecoration(hintText: "Expense name"),
                            autofocus: true,
                          ),
                          SizedBox(height: 10),
                          TextField(
                            controller: amountController,
                            decoration: InputDecoration(hintText: "Amount"),
                            autofocus: true,
                          ),
                          SizedBox(height: 20),
                        ],
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
                          onPressed: () => Navigator.pop(
                            context,
                            [nameController.text.trim(), amountController.text.trim()],
                          ),
                          child: Text("Enter"),
                        )
                      ],
                    );
                  },
                );

                nameController.dispose();
                amountController.dispose();

                if(result != null && result.isNotEmpty) {
                  setState(() {
                    record.expenses[result[0]] = double.parse(result[1]);
                    record.total += double.parse(result[1]);
                    record.expenses.update(
                        result[0],
                        (value) => value + double.parse( result[1]),
                        ifAbsent: () => double.parse( result[1])
                    );
                  });
                }

                prefs.setString(record.id, jsonEncode(record.toJson()));
              },
              child: Text("ADD"),
            ),

            SizedBox(height: 81),

            expenses == null
            ? Text("No expenses yet", style: TextStyle(color: Colors.grey))
            : GridView.builder(
              shrinkWrap: true,
              physics: NeverScrollableScrollPhysics(),
              padding: EdgeInsets.symmetric(horizontal: 100),
              gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
                maxCrossAxisExtent: 150,
                mainAxisExtent: 160,
                crossAxisSpacing: 16,
                mainAxisSpacing: 16,
                childAspectRatio: 15 / 16,
              ),
              itemCount: expenses!.length,
              itemBuilder: (context, index) {
                return ExpenseCard(
                  expense: expenses![index],
                  onUpdate: () {
                    setState(() {
                      record.expenses.update(
                        expenses![index].name,
                        (value) => value + expenses![index].amount,
                        ifAbsent: () => expenses![index].amount
                      );
                      record.total += expenses![index].amount;
                    });
                    prefs.setString(record.id, jsonEncode(record.toJson()));
                  },
                );
              },
            ),

            SizedBox(height: 50),
          ],
        ),
      ),
    );
  }

  void _addTemplate() async {
    final nameController = TextEditingController();
    final amountController = TextEditingController();

    List<String>? result = await showDialog<List<String>>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text("Add Template", textAlign: TextAlign.center),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: nameController,
                decoration: InputDecoration(hintText: "Expense name"),
                autofocus: true,
              ),
              SizedBox(height: 10),
              TextField(
                controller: amountController,
                decoration: InputDecoration(hintText: "Amount"),
                autofocus: true,
              ),
              SizedBox(height: 20),
            ],
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
              onPressed: () =>
                  Navigator.pop(
                    context,
                    [nameController.text.trim(), amountController.text.trim()],
                  ),
              child: Text("Enter"),
            )
          ],
        );
      },
    );

    nameController.dispose();
    amountController.dispose();

    if (result != null && result.isNotEmpty) {
      String expenseID = "$expenseIDPrefix${uuid.v4()}";
      Expense expense = Expense(
        name: result[0],
        amount: double.parse(result[1]),
      );

      prefs.setString(expenseID, jsonEncode(expense.toJson()));

      setState(() {
        _initExpenses();
      });
    }
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