class Expense{
  final String name;
  final double amount;

  Expense({
    required this.name,
    required this.amount,
  });

  Map<String, dynamic> toJson() => {
    "name": name,
    "amount": amount,
  };

  factory Expense.fromJson(Map<String, dynamic> json) {
    return Expense(
      name: json["name"],
      amount: (json["amount"] as num).toDouble(),
    );
  }
}