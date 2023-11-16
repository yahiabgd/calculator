import 'package:flutter/material.dart';
import 'package:function_tree/function_tree.dart';
import 'package:gap/gap.dart';
import 'historyList.dart';
import 'package:test1/my_flutter_app_icons.dart';
import 'history.dart';

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
  bool enabledBackSpace = false;
  bool history = false;
  List<History> myhistory = [];

  List<String> buttonlist = [
    'C',
    '( )',
    '%',
    '÷',
    '7',
    '8',
    '9',
    '×',
    '4',
    '5',
    '6',
    '-',
    '1',
    '2',
    '3',
    '+',
    '+/-',
    '0',
    '.',
    '='
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Column(
        children: [
          SizedBox(
            height: MediaQuery.of(context).size.height / 3,
            child: Container(
              alignment: Alignment.centerRight,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Container(
                    padding: EdgeInsets.fromLTRB(
                        20, MediaQuery.of(context).size.height / 10, 20, 20),
                    child: TextField(
                      style: const TextStyle(fontSize: 40, color: Colors.white),
                      readOnly: true,
                      showCursor: true,
                      controller: input,
                      textAlign: TextAlign.right,
                      decoration: null,
                    ),
                  ),
                  Container(
                    padding: EdgeInsets.fromLTRB(
                        0, MediaQuery.of(context).size.height / 13, 20, 0),
                    child: Text(
                      result,
                      style: const TextStyle(
                          fontSize: 23,
                          color: Color(0xFF646464),
                          fontWeight: FontWeight.w600),
                    ),
                  )
                ],
              ),
            ),
          ),
          Gap(20),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Padding(
                padding: const EdgeInsets.only(right: 50),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    IconButton(
                        onPressed: () {
                          setState(() {
                            history = !history;
                          });
                        },
                        splashRadius: 23,
                        icon: Icon(
                          history
                              ? Icons.calculate_outlined
                              : Icons.history_toggle_off_rounded,
                          color: Colors.white,
                        )),
                    // IconButton(
                    //     onPressed: () {},
                    //     icon: const Icon(
                    //       Icons.history_toggle_off_rounded,
                    //       color: Colors.white,
                    //     )),
                    IconButton(
                        splashRadius: 23,
                        onPressed: () {},
                        icon: const Icon(
                          Icons.rule_folder_outlined,
                          color: Colors.white,
                        )),
                    IconButton(
                        splashRadius: 20,
                        onPressed: () {},
                        icon: const Icon(
                          Icons.calculate_outlined,
                          color: Colors.white,
                        ))
                  ],
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  IconButton(
                      splashRadius: 23,
                      onPressed: !enabledBackSpace
                          ? null
                          : () {
                              setState(() {
                                backSpace();
                              });
                            },
                      iconSize: 20,
                      icon: Icon(
                        MyFlutterApp.backspace,
                        color: enabledBackSpace
                            ? const Color(0xFF437D05)
                            : const Color.fromARGB(255, 29, 47, 10),
                      ))
                ],
              ),
            ],
          ),
          Expanded(
            child: Stack(
              children: [
                Align(
                  alignment: Alignment.topCenter,
                  child: SizedBox(
                    height: 30,
                    width: MediaQuery.of(context).size.width * 0.9,
                    child: const Divider(
                      color: Color(0xff1f1f1f),
                      thickness: 1.4,
                    ),
                  ),
                ),
                Container(
                  padding: const EdgeInsets.fromLTRB(20, 15, 20, 0),
                  child: GridView.builder(
                    itemCount: buttonlist.length,
                    physics: const NeverScrollableScrollPhysics(),
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 4,
                            crossAxisSpacing: 15,
                            mainAxisSpacing: 6.3),
                    itemBuilder: (BuildContext context, int index) {
                      return customButton(buttonlist[index]);
                    },
                  ),
                ),
                HistoryList(
                  history: history,
                  myhistory: myhistory,
                  input: input,
                  onResult: _onChangedResult,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget customButton(String txt) {
    return SizedBox(
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(50)),
            backgroundColor: getbg(txt),
            textStyle: TextStyle(
              fontSize: iconSize(txt),
              fontWeight: FontWeight.normal,
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

  double? iconSize(String txt) {
    if (txt == '+/-') return 25;
    if (txt == '( )') return 22;
    if (txt.isNotEmpty && txt.codeUnitAt(0) >= 48 && txt.codeUnitAt(0) <= 57) {
      return 28;
    }
    return 35;
  }

// logical part :

  void buttonstat(String txt) {
    var pos = input.selection.base.offset;
    if (pos == -1) {
      pos = input.text.length;
    }
    if (txt == 'C') {
      input.clear();
      result = '0';
      brackets = 0;
      position = -1;
      enabledBackSpace = false;
      return;
    }

    if (txt == '=') {
      result = getresult(input.text, brackets);
      input.text != result
          ? myhistory.add(History(equation: input.text, answer: result))
          : null;
      input.text = result;
      brackets = 0;
      return;
    }
    enabledBackSpace = true;
    if (txt == '( )') {
      print(brackets);
      print('pos = $pos');
      if (pos == 0 || input.text[pos - 1] == '(') {
        position = (pos == 0) ? 0 : position;
        brackets++;
        input.text =
            '${input.text.substring(0, pos)}(${input.text.substring(pos, input.text.length)}';
        input.selection =
            TextSelection.fromPosition(TextPosition(offset: pos + 1));
        return;
      }
      if (input.text[pos - 1] == '+' ||
          input.text[pos - 1] == '-' ||
          input.text[pos - 1] == '×' ||
          input.text[pos - 1] == '÷') {
        brackets++;
        input.text =
            '${input.text.substring(0, pos)}(${input.text.substring(pos, input.text.length)}';
        return;
      }
      if (brackets == 0) {
        print(brackets);
        int? number = int.tryParse(input.text[pos - 1]);
        position = (pos < position || position == -1) ? pos : position;
        if (number != null || input.text[pos - 1] == ')') {
          //print(input.text[input.text.length - 1]);
          brackets++;
          input.text =
              '${input.text.substring(0, pos)}×(${input.text.substring(pos, input.text.length)}';
          input.selection =
              TextSelection.fromPosition(TextPosition(offset: pos + 2));
          return;
        }
      } else {
        if (pos == input.text.length) {
          input.text += ')';
        } else {
          if (pos < position) {
            position = pos;
            brackets++;
            input.text =
                '${input.text.substring(0, pos)}×(${input.text.substring(pos, input.text.length)}';

            return;
          } else {
            input.text =
                '${input.text.substring(0, pos)})×${input.text.substring(pos, input.text.length)}';
          }
        }
        brackets--;
        return;
      }
    }
    if (txt == '÷' || txt == '×' || txt == '+' || txt == '-') {
      if (input.text[pos - 1] == '÷' ||
          input.text[pos - 1] == '×' ||
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
      input.selection =
          TextSelection.fromPosition(TextPosition(offset: pos + 1));
      return;
    }
    if (txt == '+/-') {
      return;
    }
    if (pos != 0 && input.text[pos - 1] == ')') {
      input.text =
          '${input.text.substring(0, pos)}×$txt${input.text.substring(pos, input.text.length)}';
      return;
    }
    input.text = input.text.substring(0, pos) +
        txt +
        input.text.substring(pos, input.text.length);
    input.selection = TextSelection.fromPosition(TextPosition(offset: pos + 1));
    result = getresult(input.text, brackets);
  }

  getbg(String texte) {
    if (texte == '=') {
      return const Color(0xFF437d05);
    }
    return const Color(0xFF1f1f1f);
  }

  getcolor(String text) {
    if (text == 'C') {
      return const Color(0xFFF56C7F);
    }
    if (text == '( )' ||
        text == '%' ||
        text == '÷' ||
        text == '×' ||
        text == '+' ||
        text == '-' ||
        text == 'C') {
      return const Color(0xFF437D05);
    }
    return Colors.white;
  }

  String getresult(String input, int n) {
    if (input == '') {
      enabledBackSpace = false;
      return '';
    }
    input =
        input.replaceAll('×', '*').replaceAll('÷', '/').replaceAll('%', '/100');

    input += ')' * n;
    return (input).interpret().toString().endsWith('.0')
        ? (input).interpret().toString().replaceAll('.0', '')
        : (input).interpret().toString();
  }

  backSpace() {
    var pos = input.selection.base.offset;
    //print(pos);
    if (pos == -1) {
      pos = input.text.length;
    }
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
    input.selection = TextSelection.fromPosition(TextPosition(offset: pos - 1));
    //print(input.text);
    result = getresult(input.text, brackets);
    return;
  }

  void _onChangedResult() {
    setState(() {
      result = getresult(input.text, brackets);
    });
  }
}
