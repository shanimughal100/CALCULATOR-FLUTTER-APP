import 'package:flutter/material.dart';

void main() => runApp(const CalculatorApp());

class CalculatorApp extends StatelessWidget {
  const CalculatorApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Calculator',
      home: CalculatorScreen(),
    );
  }
}

class CalculatorScreen extends StatefulWidget {
  const CalculatorScreen({super.key});

  @override
  CalculatorScreenState createState() => CalculatorScreenState();
}

class CalculatorScreenState extends State<CalculatorScreen> {
  String _display = '';
  String _input = '';
  double _firstNumber = 0;
  String _operation = '';
  bool _isResultShown = false;

  void _onButtonPressed(String value) {
    setState(() {
      if (value == 'C') {
        _clearAll();
      } else if (value == '⌫') {
        _handleBackspace();
      } else if (value == '+' || value == '-' || value == '×' || value == '÷' || value == '%') {
        _handleOperator(value);
      } else if (value == '=') {
        _calculateResult();
      } else {
        _handleNumberInput(value);
      }
    });
  }

  void _clearAll() {
    _display = '';
    _input = '';
    _firstNumber = 0;
    _operation = '';
    _isResultShown = false;
  }

  void _handleBackspace() {
    if (_input.isNotEmpty) {
      _input = _input.substring(0, _input.length - 1);
      _display = _input;
    }
  }

  void _handleOperator(String value) {
    if (_input.isNotEmpty) {
      if (_isResultShown) {
        _firstNumber = double.parse(_input); // Set the first number after result is shown
        _isResultShown = false;  // Reset the flag
      } else {
        _firstNumber = double.parse(_input);
      }
      _operation = value;
      _input = '';  // Clear input for the next number
      _display = _operation;  // Display the operator
    }
  }

  void _handleNumberInput(String value) {
    if (_isResultShown) {
      _clearAll();
      _isResultShown = false;
    }
    _input += value;
    _display = _input;
  }

  void _calculateResult() {
    if (_operation.isNotEmpty && _input.isNotEmpty) {
      double secondNumber = double.parse(_input);
      double result = 0;

      switch (_operation) {
        case '+':
          result = _firstNumber + secondNumber;
          break;
        case '-':
          result = _firstNumber - secondNumber;
          break;
        case '×':
          result = _firstNumber * secondNumber;
          break;
        case '÷':
          result = _firstNumber / secondNumber;
          break;
        case '%':
          result = _firstNumber % secondNumber;
          break;
      }

      // Update display with result and prepare for the next operation
      _display = result.toString();
      _input = _display;
      _firstNumber = result;  // Set the result as the first number for future operations
      _operation = '';  // Clear operation after calculation
      _isResultShown = true;
    }
  }

  bool _isOperator(String value) {
    return value == '+' || value == '-' || value == '×' || value == '÷' || value == '=' || value == 'C' || value == '⌫' || value == '%';
  }

  @override
  Widget build(BuildContext context) {
    final buttons = [
      'C', '%', '÷', '⌫',
      '7', '8', '9', '×',
      '4', '5', '6', '-',
      '1', '2', '3', '+',
      '.', '0', '#', '=',
    ];

    return Scaffold(
      appBar: AppBar(
        title: const Text('Calculator',style: TextStyle(color: Colors.white)),
        backgroundColor: Colors.black,
        leading: IconButton(
          onPressed: () {},
          icon: const Icon(Icons.menu, color: Colors.white,),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.notification_add_sharp, color: Colors.white,),
            onPressed: () {
              // Add your settings navigation logic here
            },
          ),
          IconButton(
            icon: const Icon(Icons.settings, color: Colors.white),
            onPressed: () {
              // Add your settings navigation logic here
            },
          ),
        ]
      ),
      body: Column(
        children: [
          // Display Screen
          Expanded(
            flex: 1,
            child: Container(
              alignment: Alignment.centerRight,
              padding: const EdgeInsets.all(16),
              color: Colors.white,
              child: Text(
                _display,
                style: const TextStyle(
                  fontSize: 48,
                  color: Colors.black,
                ),
              ),
            ),
          ),
          // Button Grid
          Expanded(
            flex: 1,
            child: GridView.builder(
              padding: const EdgeInsets.all(4),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 4,
                mainAxisSpacing: 4,
                crossAxisSpacing: 4,
                childAspectRatio: 1.29,
              ),
              itemCount: buttons.length,
              itemBuilder: (context, index) {
                final buttonLabel = buttons[index];

                // Extend "=" button to occupy two rows
                if (buttonLabel == '=') {
                  return GridTile(
                    child: GestureDetector(
                      onTap: () => _onButtonPressed(buttonLabel),
                      child: Container(
                        decoration: BoxDecoration(
                          color: const Color.fromARGB(255, 224, 250, 248),
                          border: Border.all(
                            color: Colors.black,
                            width: 2,
                            style: BorderStyle.solid,
                          ),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: const Center(
                          child: Text(
                            '=',
                            style: TextStyle(fontSize: 28, color: Colors.black),
                          ),
                        ),
                      ),
                    ),
                  );
                }

                // Normal Buttons
                return GestureDetector(
                  onTap: () => _onButtonPressed(buttonLabel),
                  child: Container(
                    decoration: BoxDecoration(
                      color: _isOperator(buttonLabel)
                          ? Colors.black
                          : Colors.grey[300],
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Center(
                      child: Text(
                        buttonLabel,
                        style: TextStyle(
                          fontSize: 24,
                          color: _isOperator(buttonLabel)
                              ? Colors.white
                              : Colors.black,
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
