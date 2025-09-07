class Record {
  String id;
  String label;
  Map<String, double> expenses;
  double total;

  Record({
    required this.id,
    required this.label,
    required this.expenses,
    required this.total,
  });

  Map<String, dynamic> toJson() => {
    'id': id,
    'label': label,
    'expenses': expenses.map((key, value) => MapEntry(key, value)),
    'total': total,
  };

  factory Record.fromJson(Map<String, dynamic> json) => Record(
    id: json['id'],
    label: json['label'],
    expenses: Map<String, double>.from(json['expenses']),
    total: json['total'],
  );
}