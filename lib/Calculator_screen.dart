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
                    style: TextStyle(fontSize: 70, fontWeight: FontWeight.bold),
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
    // number1 operand number2
    //  234      +       5678

    if (values != Btn.dot && int.tryParse(values) == null) {
      //
      if (operand.isNotEmpty && number2.isNotEmpty) {
        // TODO calculate the equation before assigning new operand
      }
      operand = values;
    } else if (number1.isEmpty || operand.isEmpty) {
      // number1 = "1.2"
      if (values == Btn.dot && number1.contains(Btn.dot)) return;
      if (values == Btn.dot && (number1.isEmpty || number1 == Btn.dot)) {
        // number1 = "" | "0"
        values = "0.";
      }
      number1 += values;
    } else if (number2.isEmpty || operand.isNotEmpty) {
      // number1 = "1.2"
      if (values == Btn.dot && number2.contains(Btn.dot)) return;
      if (values == Btn.dot && (number2.isEmpty || number2 == Btn.dot)) {
        // number1 = "" | "0"
        values = "0.";
      }
      number1 += values;
    }

    setState(() {
      number1 += values;
      operand += values;
      number2 += values;
    });
  }

  //  ###################
  Color getBtncolor(values) {
    return [Btn.clr, Btn.pnm].contains(values)
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
