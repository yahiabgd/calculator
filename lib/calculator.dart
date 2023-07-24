import 'package:flutter/material.dart';
import 'package:function_tree/function_tree.dart';

class Calculator extends StatefulWidget {
  const Calculator({super.key});

  @override
  State<Calculator> createState() => _CalculatorState();
}

class _CalculatorState extends State<Calculator> {
  String input = '';
  String result = '0';

  List<String> buttonlist = [
    'AC',
    '(',
    ')',
    '/',
    '7',
    '8',
    '9',
    '*',
    '4',
    '5',
    '6',
    '+',
    '1',
    '2',
    '3',
    '-',
    'C',
    '0',
    '.',
    '='
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          SizedBox(
            height: MediaQuery.of(context).size.height / 3.2,
            child: Container(
              alignment: Alignment.centerRight,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.end,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Container(
                    padding: const EdgeInsets.all(20),
                    child: Text(
                      input,
                      style: const TextStyle(
                          fontSize: 30, fontWeight: FontWeight.bold),
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.all(20),
                    child: Text(
                      result,
                      style: const TextStyle(
                          fontSize: 26,
                          color: Colors.black54,
                          fontWeight: FontWeight.w600),
                    ),
                  )
                ],
              ),
            ),
          ),
          const Divider(
            color: Colors.black,
          ),
          Expanded(
            child: Container(
              padding: const EdgeInsets.all(10),
              child: GridView.builder(
                itemCount: buttonlist.length,
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 4,
                    crossAxisSpacing: 10,
                    mainAxisSpacing: 10),
                itemBuilder: (BuildContext context, int index) {
                  return CustomButton(buttonlist[index]);
                },
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget CustomButton(String txt) {
    return SizedBox(
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
            backgroundColor: getbg(txt),
            textStyle: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.bold,
            )),
        onPressed: () {
          setState(() {
            buttonstat(txt);
          });
        },
        child: Text(
          txt,
          style: TextStyle(color: getcolor(txt)),
        ),
      ),
    );
  }

  void buttonstat(String txt) {
    if (txt == 'AC') {
      input = '';
      result = '0';
      return;
    }
    if (txt == 'C') {
      input = input.substring(0, input.length - 1);
      return;
    }
    if (txt == '=') {
      result = input.interpret().toString();
      input = result;
      return;
    }
    result = '0';
    input += txt;
  }

  getbg(String texte) {
    if (texte == 'AC') {
      return Colors.orange;
    }
    return Colors.black54;
  }

  getcolor(String text) {
    if (text == 'AC') {
      return Colors.white;
    }
    if (text == '(' ||
        text == ')' ||
        text == '/' ||
        text == '*' ||
        text == '+' ||
        text == '-' ||
        text == 'C') {
      return Colors.orange;
    }
    return Colors.white;
  }
}
