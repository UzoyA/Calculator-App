import 'dart:ffi';

import 'package:caculatorlesson/botton_values.dart';
import 'package:flutter/material.dart';

class CalculatorScreen extends StatefulWidget {
  const CalculatorScreen({super.key});

  @override
  State<CalculatorScreen> createState() => _CalculatorScreenState();
}

class _CalculatorScreenState extends State<CalculatorScreen> {
  String number1 = ""; //  . 0-9
  String operand = ""; //  + - * /
  String number2 = ""; //  . 0-9

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;
    return Scaffold(
      body: SafeArea(
        bottom: false,
        child: Column(
          children: [
            // output
            Expanded(
              child: SingleChildScrollView(
                reverse: true,
                child: Container(
                  alignment: Alignment.bottomRight,
                  padding: const EdgeInsets.all(25),
                  child: Text(
                    "$number1$operand$number2".isEmpty
                        ? "0"
                        : "$number1$operand$number2",
                    style: const TextStyle(
                        fontSize: 70, fontWeight: FontWeight.bold),
                    textAlign: TextAlign.end,
                  ),
                ),
              ),
            ),

            // buttons
            Wrap(
              children: Btn.buttonValues
                  .map(
                    (value) => SizedBox(
                      width: value == Btn.n0
                          ? screenSize.width / 2
                          : screenSize.width / 4,
                      height: screenSize.width / 4,
                      child: buildButton(value),
                    ),
                  )
                  .toList(),
            )
          ],
        ),
      ),
    );
  }

  Widget buildButton(values) {
    return Padding(
      padding: const EdgeInsets.all(7.0),
      child: Material(
        color: getBtncolor(values),
        clipBehavior: Clip.hardEdge,
        shape: OutlineInputBorder(
          borderSide: const BorderSide(
            color: Colors.white24,
          ),
          borderRadius: BorderRadius.circular(100),
        ),
        child: InkWell(
          onTap: () => onBtnTap(values),
          child: Center(
            child: Text(
              values,
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 24),
            ),
          ),
        ),
      ),
    );
  }

  // ####################
  void onBtnTap(String values) {
    if (values == Btn.clr) {
      clear();
      return;
    }

    if (values == Btn.ans) {
      toggleSign();
      return;
    }

    if (values == Btn.per) {
      convertToPercentage();
      return;
    }

    if (values == Btn.calculate) {
      calculate();
      return;
    }

    appendvalues(values);
  }

  // ###########################################
  // calculate the result
  void calculate() {
    if (number1.isEmpty || operand.isEmpty || number2.isEmpty) return;

    final double num1 = double.parse(number1);
    final double num2 = double.parse(number2);

    var result = 0.0;

    switch (operand) {
      case Btn.add:
        result = num1 + num2;
        break;
      case Btn.subtract:
        result = num1 - num2;
        break;
      case Btn.multiply:
        result = num1 * num2;
        break;
      case Btn.divide:
        result = num1 / num2;
        break;
      default:
    }

    setState(() {
      number1 = '$result';
      if (number1.endsWith('.0')) {
        number1 = number1.substring(0, number1.length - 2);
      }
      operand = '';
      number2 = '';
    });
  }

  // ###################
  // converts output to %
  void convertToPercentage() {
    // ex: 434+324
    if (number1.isNotEmpty && operand.isNotEmpty && number2.isNotEmpty) {
      // calculate before conversion
      // TODO
      //
    }

    if (operand.isNotEmpty) {
      // cannot be converted
      return;
    }
    final number = double.parse(number1);
    setState(() {
      number1 = "${(number / 100)}";
      operand = "";
      number2 = "";
    });
  }

  // ##################
  void toggleSign() {
    setState(() {
      if (operand.isEmpty && number1.isNotEmpty) {
        number1 = number1.startsWith('-') ? number1.substring(1) : '-$number1';
      } else if (number2.isNotEmpty) {
        number2 = number2.startsWith('-') ? number2.substring(1) : '-$number2';
      }
    });
  }

  // ###################
  // delete one from the end
  void clear() {
    if (number2.isNotEmpty) {
      // 12323 => 1232
      number2 = number2.substring(0, number2.length - 1);
    } else if (operand.isNotEmpty) {
      operand = "";
    } else if (number1.isNotEmpty) {
      number1 = number1.substring(0, number1.length - 1);
    }

    setState(() {});
  }

  // ########################
  // appendvalues to the end
  void appendvalues(String values) {
    // number1 operand number2
    //  234      +       5678

    // if is operand and not "."
    if (values != Btn.dot && int.tryParse(values) == null) {
      // operand pressed
      if (operand.isNotEmpty && number2.isNotEmpty) {
        // TODO calculate the equation before assigning new operand
      }
      operand = values;
      // assign values to number1 veriable
    } else if (number1.isEmpty || operand.isEmpty) {
      // check if values is "."  |  // ex: number1 = "1.2"
      if (values == Btn.dot && number1.contains(Btn.dot)) return;
      if (values == Btn.dot && (number1.isEmpty || number1 == Btn.dot)) {
        // ex: number1 = "" | "0"
        values = "0.";
      }
      number1 += values;
    }
    // assign values to number2 veriable
    else if (number2.isEmpty || operand.isNotEmpty) {
      //  check if values is "."  |  number1 = "1.2"
      if (values == Btn.dot && number2.contains(Btn.dot)) return;
      if (values == Btn.dot && (number2.isEmpty || number2 == Btn.dot)) {
        // number1 = "" | "0"
        values = "0.";
      }
      number2 += values;
    }

    setState(() {});
  }

  //  ###################
  Color getBtncolor(values) {
    return [Btn.clr, Btn.ans].contains(values)
        ? Colors.blueGrey
        : [
            Btn.per,
            Btn.multiply,
            Btn.add,
            Btn.subtract,
            Btn.divide,
            Btn.calculate,
          ].contains(values)
            ? Colors.orange
            : Colors.black;
  }
}
