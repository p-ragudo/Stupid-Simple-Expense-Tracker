import 'package:flutter/material.dart';
import 'expense.dart';
import 'record.dart';

class ExpenseCard extends StatelessWidget {
  final Expense expense;
  final VoidCallback onUpdate;

  const ExpenseCard({
    super.key,
    required this.expense,
    required this.onUpdate,
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
      onPressed: onUpdate,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            "₱${expense.amount.toStringAsFixed(2)}",
            style: TextStyle(
              color: Colors.black,
              fontSize: 30,
              fontWeight: FontWeight.bold,
            ),
            textAlign: TextAlign.center,
          ),
          Text(
            expense.name,
            style: TextStyle(
              color: Colors.black,
              fontSize: 16,
              fontWeight: FontWeight.normal,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}