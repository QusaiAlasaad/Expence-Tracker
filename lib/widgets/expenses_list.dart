import 'package:expence_tracker/models/expense.dart';
import 'package:expence_tracker/widgets/expenses_list/expence_items.dart';
import 'package:flutter/material.dart';

class ExpensesList extends StatelessWidget {
  const ExpensesList(
      {super.key, required this.expenses, required this.removeExpence});
  final void Function(Expense expense) removeExpence;
  final List<Expense> expenses;

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
        itemCount: expenses.length,
        itemBuilder: ((ctx, index) {
          return Dismissible(
              background: Container(
                color: Theme.of(context).colorScheme.error.withOpacity(0.7),
                margin: EdgeInsets.symmetric(
                    horizontal: Theme.of(context).cardTheme.margin!.horizontal,
                    vertical: Theme.of(context).cardTheme.margin!.vertical),
              ),
              key: ValueKey(expenses[index]),
              onDismissed: (indx) {
                removeExpence(expenses[index]);
              },
              child: ExpenceItems(expenses[index]));
        }));
  }
}
