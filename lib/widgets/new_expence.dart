import 'package:flutter/material.dart';
import 'package:expence_tracker/models/expense.dart';

class NewExpense extends StatefulWidget {
  const NewExpense({super.key, required this.onAddExpense});
  final void Function(Expense expense) onAddExpense;
  @override
  State<NewExpense> createState() => _NewEcpenseState();
}

class _NewEcpenseState extends State<NewExpense> {
  final titleController = TextEditingController();
  final amountController = TextEditingController();
  DateTime? selectedDate;
  Category selectedCategory = Category.leisure;

  void presentDatePicker() async {
    final now = DateTime.now();
    final firstDate = DateTime(now.year - 1, now.month, now.day);
    final pickedDate = await showDatePicker(
      context: context,
      initialDate: now,
      firstDate: firstDate,
      lastDate: now,
    );
    setState(() {
      selectedDate = pickedDate;
    });
  }

  void submitExpenseData() {
    final enterdAmount = double.tryParse(amountController.text);
    final amountInvalid = enterdAmount == null || enterdAmount <= 0;
    if (titleController.text.trim().isEmpty ||
        amountInvalid ||
        selectedDate == null) {
      showDialog(
          context: context,
          builder: (ctx) {
            return AlertDialog(
              title: const Text('Invalid Input'),
              content: const Text('Invalid Input'),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.pop(ctx);
                  },
                  child: const Text('Okay'),
                ),
              ],
            );
          });
      return;
    }
    widget.onAddExpense(
      Expense(
          title: titleController.text,
          amount: enterdAmount,
          date: selectedDate!,
          category: selectedCategory),
    );
    Navigator.pop(context);
  }

  @override
  void dispose() {
    titleController.dispose();
    amountController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final keyboardInset = MediaQuery.of(context).viewInsets.bottom;
    return LayoutBuilder(builder: ((ctx, constraints) {
      return SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.fromLTRB(20, 20, 20, keyboardInset + 20),
          child: Column(children: [
            TextField(
                controller: titleController,
                maxLength: 50,
                decoration: const InputDecoration(
                  label: Text('Title'),
                )),
            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: amountController,
                    keyboardType: TextInputType.number,
                    decoration: const InputDecoration(
                        prefixText: '\$ ', label: Text('Amount')),
                  ),
                ),
                const SizedBox(
                  width: 16,
                ),
                Expanded(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text(selectedDate == null
                          ? 'Selected Date'
                          : formater.format(selectedDate!)),
                      IconButton(
                          onPressed: presentDatePicker,
                          icon: const Icon(Icons.calendar_month))
                    ],
                  ),
                )
              ],
            ),
            const SizedBox(
              height: 20,
            ),
            Row(
              children: [
                DropdownButton(
                    value: selectedCategory,
                    items: Category.values.map((category) {
                      return DropdownMenuItem(
                          value: category,
                          child: Text(category.name.toUpperCase()));
                    }).toList(),
                    onChanged: (value) {
                      if (value == null) return;
                      setState(() {
                        selectedCategory = value;
                      });
                    }),
                const Spacer(),
                TextButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    child: const Text('Close')),
                ElevatedButton(
                    onPressed: submitExpenseData,
                    child: const Text('Save Expence')),
              ],
            )
          ]),
        ),
      );
    }));
  }
}
