class Record {
  String id;
  String label;
  List<String> expenses;
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
    'expenses': expenses,
    'total': total,
  };

  factory Record.fromJson(Map<String, dynamic> json) => Record(
    id: json['id'],
    label: json['label'],
    expenses: List<String>.from(json['expenses']),
    total: json['total'],
  );
}