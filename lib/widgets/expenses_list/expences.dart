import 'package:expence_tracker/widgets/chart/chart.dart';
import 'package:expence_tracker/widgets/expenses_list.dart';
import 'package:expence_tracker/widgets/new_expence.dart';
import 'package:flutter/material.dart';
import 'package:expence_tracker/models/expense.dart';

class Expenses extends StatefulWidget {
  const Expenses({super.key});

  @override
  State<StatefulWidget> createState() {
    return _ExpensesState();
  }
}

class _ExpensesState extends State<Expenses> {
  final List<Expense> _registerdExpenses = [
    Expense(
        title: 'Rent',
        amount: 110,
        date: DateTime.now(),
        category: Category.work),
    Expense(
        title: 'Food',
        amount: 250,
        date: DateTime.now(),
        category: Category.food),
    Expense(
        title: "Groceries",
        amount: 100,
        date: DateTime.now(),
        category: Category.travel)
  ];

  void addExpence(Expense expense) {
    setState(() {
      _registerdExpenses.add(expense);
    });
  }

  void removeExpence(Expense expense) {
    final index = _registerdExpenses.indexOf(expense);
    setState(
      () {
        _registerdExpenses.remove(expense);
      },
    );
    ScaffoldMessenger.of(context).clearSnackBars();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        duration: const Duration(seconds: 5),
        content: const Text('Expence deleted'),
        action: SnackBarAction(
          label: 'Undo',
          onPressed: () {
            setState(
              () {
                _registerdExpenses.insert(index, expense);
              },
            );
          },
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final height = MediaQuery.of(context).size.height;
    Widget mainContext = const Center(
      child: Text('No Expenses added!.... Start adding some'),
    );

    if (_registerdExpenses.isNotEmpty) {
      mainContext = ExpensesList(
        expenses: _registerdExpenses,
        removeExpence: removeExpence,
      );
    }
    return Scaffold(
      appBar: AppBar(
        title: const Text('Expense Tracker'),
        actions: [
          IconButton(
            onPressed: () {
              showModalBottomSheet(
                useSafeArea: true,
                isScrollControlled: true,
                context: context,
                builder: (ctx) {
                  return NewExpense(
                    onAddExpense: addExpence,
                  );
                },
              );
            },
            icon: const Icon(Icons.add),
          )
        ],
      ),
      body: height > width
          ? Column(
              children: [
                Chart(expenses: _registerdExpenses),
                Expanded(child: mainContext)
              ],
            )
          : Row(
              children: [
                Expanded(child: Chart(expenses: _registerdExpenses)),
                Expanded(child: mainContext)
              ],
            ),
    );
  }
}
