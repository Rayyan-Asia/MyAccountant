// main.dart

import 'package:flutter/material.dart';
import 'Infrastructure/DatabaseHelper.dart';
import 'Model/expense.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await DatabaseHelper().initDatabase(); // Initialize the database before running the app
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: ExpenseTracker(),
    );
  }
}

class ExpenseTracker extends StatefulWidget {
  @override
  _ExpenseTrackerState createState() => _ExpenseTrackerState();
}

class _ExpenseTrackerState extends State<ExpenseTracker> {
  final TextEditingController _amountController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  ExpenseCategory _selectedCategory = ExpenseCategory.Food;
  List<Expense> _expenses = [];

  void _addExpense() {
    double amount = double.tryParse(_amountController.text) ?? 0.0;
    String description = _descriptionController.text;
    Expense newExpense = Expense(
      category: _selectedCategory,
      amount: amount,
      description: description,
    );

    DatabaseHelper().insertExpense(newExpense).then((_) {
      setState(() {
        _expenses.add(newExpense);
        _amountController.clear();
        _descriptionController.clear();
      });
    });
  }

  @override
  void initState() {
    super.initState();
    DatabaseHelper().getExpenses().then((expenses) {
      setState(() {
        _expenses = expenses;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Expense Tracker'),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          children: [
            DropdownButton<ExpenseCategory>(
              value: _selectedCategory,
              onChanged: (newValue) {
                setState(() {
                  _selectedCategory = newValue!;
                });
              },
              items: ExpenseCategory.values.map((category) {
                return DropdownMenuItem<ExpenseCategory>(
                  value: category,
                  child: Text(category.toString().split('.').last),
                );
              }).toList(),
            ),
            TextField(
              controller: _amountController,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(labelText: 'Amount'),
            ),
            TextField(
              controller: _descriptionController,
              decoration: InputDecoration(labelText: 'Description'),
            ),
            ElevatedButton(
              onPressed: _addExpense,
              child: Text('Add Expense'),
            ),
            Expanded(
              child: ListView.builder(
                itemCount: _expenses.length,
                itemBuilder: (context, index) {
                  return ListTile(
                    title: Text(_expenses[index].category.toString().split('.').last),
                    subtitle: Text(_expenses[index].amount.toString()),
                    trailing: Text(_expenses[index].description), // Show description
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
