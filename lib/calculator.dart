import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:function_tree/function_tree.dart';

class Calculator extends StatefulWidget {
  const Calculator({super.key});

  @override
  State<Calculator> createState() => _CalculatorState();
}

class _CalculatorState extends State<Calculator> {
  final input = TextEditingController();
  String result = '0';
  int brackets = 0;
  int position = -1; // to memorise first opened bracket

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
                  // Container(
                  //   padding: const EdgeInsets.all(20),
                  //   child: Text(
                  //     input,
                  //     style: const TextStyle(
                  //         fontSize: 30, fontWeight: FontWeight.bold),
                  //   ),
                  // ),
                  Container(
                    padding: const EdgeInsets.all(20),
                    child: TextField(
                      readOnly: true,
                      showCursor: true,
                      controller: input,
                      textAlign: TextAlign.right,
                      decoration: null,
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
            textStyle: const TextStyle(
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
    var pos = input.selection.base.offset;
    if (pos == -1) {
      pos = input.text.length;
    }
    if (txt == 'AC') {
      input.clear();
      result = '0';
      brackets = 0;
      position = -1;
      return;
    }
    if (txt == 'C') {
      if (input.text.isEmpty || pos == 0) return;
      if (input.text[pos - 1] == '(') {
        brackets--;
      }
      if (input.text[pos - 1] == ')') {
        brackets++;
      }
      var pre = input.text.substring(0, pos - 1);
      var suf = input.text.substring(pos, input.text.length);
      input.text = pre + suf;
      result = getresult(input.text, brackets);
      return;
    }
    if (txt == '=') {
      result = getresult(input.text, brackets);

      input.text = result;
      brackets = 0;
      return;
    }

    if (txt == '(') {
      print(brackets);
      if (pos == 0 || input.text[pos - 1] == '(') {
        position = (pos == 0) ? 0 : position;
        brackets++;
        input.text =
            '${input.text.substring(0, pos)}(${input.text.substring(pos, input.text.length)}';
        return;
      }
      if (brackets == 0) {
        brackets++;
        int? number = int.tryParse(input.text[pos - 1]);
        position = (pos < position || position == -1) ? pos : position;
        if (number != null || input.text[pos - 1] == ')') {
          print(input.text[input.text.length - 1]);

          input.text =
              '${input.text.substring(0, pos)}*(${input.text.substring(pos, input.text.length)}';
          return;
        }
      } else {
        if (input.text[pos - 1] == '+' ||
            input.text[pos - 1] == '-' ||
            input.text[pos - 1] == '*' ||
            input.text[pos - 1] == '/') {
          brackets++;
          input.text =
              '${input.text.substring(0, pos)}(${input.text.substring(pos, input.text.length)}';
        } else {
          if (pos == input.text.length) {
            input.text += ')';
          } else {
            if (pos < position) {
              position = pos;
              brackets++;
              input.text =
                  '${input.text.substring(0, pos)}*(${input.text.substring(pos, input.text.length)}';
              return;
            } else {
              input.text =
                  '${input.text.substring(0, pos)})*${input.text.substring(pos, input.text.length)}';
            }
          }
          brackets--;
        }
        return;
      }
    }
    if (txt == '/' || txt == '*' || txt == '+' || txt == '-') {
      if (input.text[pos - 1] == '/' ||
          input.text[pos - 1] == '*' ||
          input.text[pos - 1] == '+' ||
          input.text[pos - 1] == '-') {
        input.text = input.text.substring(0, pos - 1) +
            txt +
            input.text.substring(pos, input.text.length);
      } else {
        input.text = input.text.substring(0, pos) +
            txt +
            input.text.substring(pos, input.text.length);
      }
      return;
    }
    if (pos != 0 && input.text[pos - 1] == ')') {
      input.text =
          '${input.text.substring(0, pos)}*$txt${input.text.substring(pos, input.text.length)}';
      return;
    }
    input.text = input.text.substring(0, pos) +
        txt +
        input.text.substring(pos, input.text.length);

    result = getresult(input.text, brackets);
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

  String getresult(String input, int n) {
    for (int i = 0; i < n; i++) {
      input += ')';
    }

    return (input).interpret().toString();
  }
}
