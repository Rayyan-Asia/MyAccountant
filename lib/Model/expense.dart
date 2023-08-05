// expense.dart

enum ExpenseCategory {
  Food,
  Transportation,
  Clothes,
  Utilities,
  Entertainment,
  Others,
}

class Expense {
  int? id; // Change to 'int?' to make it nullable
  ExpenseCategory category;
  double amount;
  String description; // New description attribute

  Expense({
    this.id,
    required this.category,
    required this.amount,
    required this.description,
  });

  Map<String, dynamic> toMap({bool excludeId = false}) {
    final map = {
      'category': category.index,
      'amount': amount,
      'description': description, // Add description to the map
    };
    if (!excludeId) {
      map['id'] = id as num;
    }
    return map;
  }

  static Expense fromMap(Map<String, dynamic> map) {
    return Expense(
      id: map['id'],
      category: ExpenseCategory.values[map['category']],
      amount: map['amount'],
      description: map['description'], // Extract description from the map
    );
  }
}
