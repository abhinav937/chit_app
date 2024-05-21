// ignore_for_file: use_super_parameters

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class CalculatedPage extends StatelessWidget {
  final double totalAmount;
  final double interest;
  final int totalMonths;
  final DateTime startDate;

  const CalculatedPage({
    Key? key,
    required this.totalAmount,
    required this.interest,
    required this.totalMonths,
    required this.startDate,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    List<Map<String, dynamic>> calculatedData = [];
    NumberFormat currencyFormat =
        NumberFormat.currency(locale: 'en_IN', symbol: '₹');
    DateTime installmentDate = startDate;

    for (int i = 1; i <= totalMonths; i++) {
      double result =
          totalAmount / (1 + (interest / 100) * ((totalMonths - i) / 12));
      calculatedData.add({
        'installmentDate': installmentDate.toIso8601String(), // Store as ISO 8601 string
        'amount': result,
      });
      installmentDate = DateTime(
          installmentDate.year, 
          installmentDate.month + 1, 
          installmentDate.day
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Calculated Data'),
        actions: [
          FilledButton(
            onPressed: () {
              // Save button logic here
            },
            child: const Text(
              'Save',
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 16,
              ),
            ),
          ),
          const SizedBox(width: 16),
        ],
      ),
      body: ListView.builder(
        itemCount: calculatedData.length * 2 - 1,
        itemBuilder: (context, index) {
          if (index.isOdd) {
            return const Divider();
          }
          final calculatedIndex = index ~/ 2;
          final installment = calculatedData[calculatedIndex];
          final formattedDate = DateFormat('dd-MM-yyyy').format(
              DateTime.parse(installment['installmentDate']));
          final amount = currencyFormat.format(installment['amount']);
          return ListTile(
            title: Text(
              'Month ${calculatedIndex + 1} ($formattedDate)\nAmount: $amount',
            ),
          );
        },
      ),
    );
  }
}
