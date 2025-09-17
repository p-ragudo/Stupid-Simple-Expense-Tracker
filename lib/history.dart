import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'record.dart';

class History extends StatefulWidget {
  const History({super.key});

  @override
  State<History> createState() => _HistoryState();
}

class _HistoryState extends State<History> {
  List<Record> records = [];

  @override
  void initState() {
    super.initState();
    _loadRecords();
  }

  Future<void> _loadRecords() async {
    final prefs = await SharedPreferences.getInstance();
    final keys = prefs.getKeys();

    // Filter only records (skip templates/expenses)
    final recordKeys = keys.where((key) => key.startsWith("dateID_"));

    final loadedRecords = recordKeys.map((key) {
      final jsonStr = prefs.getString(key);
      if (jsonStr == null) return null;
      return Record.fromJson(jsonDecode(jsonStr));
    }).whereType<Record>().toList();

    // Sort newest first
    loadedRecords.sort((a, b) => b.id.compareTo(a.id));

    setState(() {
      records = loadedRecords;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        centerTitle: true,
        title: Text("History", style: TextStyle(color: Colors.white)),
        backgroundColor: Colors.blue,
        iconTheme: IconThemeData(
          color: Colors.white,
        ),
      ),
      body: ListView.separated(
        itemCount: records.length,
        separatorBuilder: (context, index) => const Padding(
          padding: EdgeInsets.only(left: 25, right: 25, top: 8), // horizontal + top
          child: Divider(
            thickness: 0.3,   // actual line thickness
            height: 20,       // vertical space (creates gap above/below)
            color: Colors.black,
          ),
        ),
        itemBuilder: (context, index) {
          final record = records[index];
          final displayLabel = record.label.isNotEmpty
              ? record.label
              : record.id.replaceFirst("dateID_", "");

          return ExpansionTile(
            tilePadding: const EdgeInsets.symmetric(horizontal: 30),
            title: Text(displayLabel),
            trailing: Text(
              "₱ ${record.total.toStringAsFixed(0)}",
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 14,
              ),
            ),
            children: record.expenses.entries.map((entry) {
              return Padding(
                padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 4),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(entry.key, style: const TextStyle(color: Colors.black54, fontWeight: FontWeight.bold)),
                    Text(
                      "₱ ${entry.value.toStringAsFixed(0)}",
                      style: const TextStyle(color: Colors.black87),
                    ),
                  ],
                ),
              );
            }).toList(),
          );
        },
      ),
    );
  }
}