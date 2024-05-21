import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'calculated_page.dart';

class ChitForm extends StatefulWidget {
  @override
  _ChitFormState createState() {
    return _ChitFormState();
  }
}

class _ChitFormState extends State<ChitForm> {
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
                final double totalAmount =
                    double.tryParse(amountController.text) ?? 0.0;
                final double interest =
                    double.tryParse(interestController.text) ?? 0.0;
                final int totalMonths =
                    int.tryParse(monthsController.text) ?? 0;
                final DateTime startDate =
                    DateFormat('dd-MM-yyyy').parse(dateController.text);

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
            child: const Text('Next'),
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
              buildTextFormFieldWithIcon(
                controller: interestController,
                labelText: 'Interest(%)',
                prefixIcon: Icons.pie_chart,
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter interest';
                  }
                  final double interest = double.tryParse(value) ?? 0.0;
                  if (interest < 0 || interest >= 100) {
                    return 'Interest should be between 0 and 99';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
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
          child: prefixIcon != null ? Icon(prefixIcon) : const SizedBox(),
        ),
        Expanded(
          child: TextFormField(
            controller: controller,
            decoration: InputDecoration(
              labelText: labelText,
              border: const OutlineInputBorder(),
              suffixIcon: labelText == 'Select Start Date'
                  ? IconButton(
                      onPressed: onTap,
                      icon: const Icon(Icons.arrow_drop_down),
                    )
                  : null,
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
