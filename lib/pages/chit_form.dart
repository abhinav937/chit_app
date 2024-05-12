import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class NewPage extends StatefulWidget {
  @override
  _NewPageState createState() => _NewPageState();
}

class _NewPageState extends State<NewPage> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController amountController = TextEditingController();
  final TextEditingController interestController = TextEditingController();
  final TextEditingController monthsController = TextEditingController();
  final TextEditingController dateController = TextEditingController();
  AutovalidateMode autovalidateMode = AutovalidateMode.always;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.close),
          onPressed: () {
            Navigator.pop(context); // Close button functionality
          },
        ),
        title: const Text('New Seetu details'),
        actions: [
          FilledButton(
            onPressed: () {
              setState(() {
                autovalidateMode = AutovalidateMode.always;
              });
              if (_formKey.currentState!.validate()) {
                final double totalAmount = double.parse(amountController.text);
                final double interest = double.parse(interestController.text);
                final int totalMonths = int.parse(monthsController.text);
                final DateTime startDate = DateFormat('dd-MM-yyyy').parse(dateController.text);

                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => CalculatedPage(
                      totalAmount: totalAmount,
                      interest: interest,
                      totalMonths: totalMonths,
                      startDate: startDate,
                    ),
                  ),
                );
              }
            },
            child: const Text(
              'Next',
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
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          autovalidateMode: autovalidateMode,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Seetu Name Field
              buildTextFormFieldWithIcon(
                labelText: 'Seetu name',
                prefixIcon: Icons.person,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter Seetu name';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              // Total Amount Field
              buildTextFormFieldWithIcon(
                controller: amountController,
                labelText: 'Total amount(Rs.)',
                prefixIcon: Icons.currency_rupee,
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter total amount';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              // Interest Field
              buildTextFormFieldWithIcon(
                controller: interestController,
                labelText: 'Interest(%)',
                prefixIcon: Icons.pie_chart,
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter interest';
                  }
                  final double interest = double.tryParse(value)!;
                  if (interest < 0 || interest >= 100) {
                    return 'Interest should be between 0 and 99';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              // Total Months Field
              buildTextFormFieldWithIcon(
                controller: monthsController,
                labelText: 'Total months',
                prefixIcon: Icons.calendar_today,
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter total months';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              // Start Date Field
              buildTextFormFieldWithIcon(
                controller: dateController,
                labelText: 'Select Start Date',
                prefixIcon: Icons.event,
                readOnly: true,
                onTap: () {
                  _selectDate(context);
                },
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please select a date';
                  }
                  return null;
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

Widget buildTextFormFieldWithIcon({
  TextEditingController? controller,
  String? labelText,
  IconData? prefixIcon,
  TextInputType? keyboardType,
  bool? readOnly,
  void Function()? onTap,
  String? Function(String?)? validator,
}) {
  return Row(
    children: [
      Padding(
        padding: const EdgeInsets.only(right: 8.0),
        child: prefixIcon != null ? Icon(prefixIcon) : const SizedBox(), // Check if prefixIcon is provided
      ),
      Expanded(
        child: TextFormField(
          controller: controller,
          decoration: InputDecoration(
            labelText: labelText,
            border: const OutlineInputBorder(),
            suffixIcon: labelText == 'Select Start Date'
                ? IconButton( // Use IconButton for suffix icon if it's the Start Date field
                    onPressed: onTap,
                    icon: const Icon(Icons.arrow_drop_down),
                  )
                : null, // Only show arrow drop-down for the Start Date field
          ),
          keyboardType: keyboardType,
          readOnly: readOnly ?? false,
          onTap: onTap,
          validator: validator,
        ),
      ),
    ],
  );
}


  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );
    if (picked != null && picked != DateTime.now()) {
      setState(() {
        final formattedDate = DateFormat('dd-MM-yyyy').format(picked);
        dateController.text = formattedDate;
      });
    }
  }
}

class CalculatedPage extends StatelessWidget {
  final double totalAmount;
  final double interest;
  final int totalMonths;
  final DateTime startDate;

  CalculatedPage({
    Key? key,
    required this.totalAmount,
    required this.interest,
    required this.totalMonths,
    required this.startDate,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Perform calculations
    List<Map<String, dynamic>> calculatedData = [];

    NumberFormat currencyFormat = NumberFormat.currency(locale: 'en_IN', symbol: '₹');
    DateTime installmentDate = startDate;

    for (int i = 1; i <= totalMonths; i++) {
      double result = totalAmount / (1 + (interest / 100) * ((totalMonths - i) / 12));
      calculatedData.add({
        'installmentDate': installmentDate,
        'amount': result,
      });
      // Add a month to the installment date
      installmentDate = DateTime(installmentDate.year, installmentDate.month + 1, installmentDate.day);
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Calculated Data'),
        actions: [
          FilledButton(
            onPressed: () {
              // Handle save functionality here
              // You can implement your save logic, e.g., saving data to a database
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
        itemCount: calculatedData.length * 2 - 1, // Twice as many items to account for separators
        itemBuilder: (context, index) {
          if (index.isOdd) {
            return const Divider(); // Insert Divider between each item
          }
          final calculatedIndex = index ~/ 2;
          final installment = calculatedData[calculatedIndex];
          final formattedDate = DateFormat('dd-MM-yyyy').format(installment['installmentDate']);
          final amount = currencyFormat.format(installment['amount']);
          return ListTile(
            title: Text('Month ${calculatedIndex + 1} ($formattedDate)\nAmount: $amount'),
          );
        },
      ),
    );
  }
}



// ignore: non_constant_identifier_names
Widget chit_form(BuildContext context) {
  return NewPage();
}
