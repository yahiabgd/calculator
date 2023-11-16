import 'package:flutter/material.dart';
import 'history.dart';

class HistoryList extends StatefulWidget {
  HistoryList(
      {super.key,
      required this.history,
      required this.myhistory,
      required this.input,
      required this.onResult});
  final onResult;
  final TextEditingController input;
  final bool history;
  final List<History> myhistory;

  @override
  State<HistoryList> createState() => _HistoryListState();
}

class _HistoryListState extends State<HistoryList> {
  @override
  Widget build(BuildContext context) {
    return Visibility(
        visible: widget.history,
        child: Container(
          width: MediaQuery.of(context).size.width * 0.74,
          height: MediaQuery.of(context).size.height * 0.6,
          color: Colors.black,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              //Text('heool'),
              Container(
                padding: const EdgeInsets.fromLTRB(10, 0, 30, 10),
                //width: MediaQuery.of(context).size.width * 0.7,
                height: MediaQuery.of(context).size.height * 0.5,
                color: Colors.black,
                child: ListView.builder(
                    itemCount: widget.myhistory.length,
                    itemBuilder: (BuildContext context, int index) {
                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          TextButton(
                            onPressed: () {
                              setState(() {
                                updateInput(widget.myhistory[index].equation);
                              });
                            },
                            style: TextButton.styleFrom(
                                visualDensity: VisualDensity.compact,
                                alignment: Alignment.centerRight),
                            child: Text(widget.myhistory[index].equation,
                                style: const TextStyle(
                                    fontSize: 18, color: Colors.white)),
                          ),
                          TextButton(
                            style: TextButton.styleFrom(
                                visualDensity: VisualDensity.compact,
                                alignment: Alignment.centerRight),
                            onPressed: () {
                              setState(() {
                                updateInput(widget.myhistory[index].answer);
                              });
                            },
                            child: Text(
                              "=${widget.myhistory[index].answer}",
                              style: const TextStyle(
                                  fontSize: 20, color: Colors.green),
                            ),
                          ),
                          //const Gap(5)
                        ],
                      );
                    }),
              ),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0XFF4d4d4d),
                    padding: const EdgeInsets.only(left: 40, right: 40),
                    shape: const RoundedRectangleBorder(
                        borderRadius: BorderRadius.all(Radius.circular(50))),
                    textStyle: const TextStyle(
                        fontSize: 18, fontWeight: FontWeight.bold)),
                onPressed: () {
                  setState(() {
                    widget.myhistory.clear();
                  });
                },
                child: const Text("Clear history"),
              )
            ],
          ),
        ));
  }

  void updateInput(String toAdd) {
    var pos = widget.input.selection.base.offset;
    // var pre = widget.input.text.substring(0, pos);
    // var suf = widget.input.text.substring(pos, widget.input.text.length);

    widget.input.text = widget.input.text.substring(0, pos) +
        toAdd +
        widget.input.text.substring(pos, widget.input.text.length);
    widget.input.selection =
        TextSelection.fromPosition(TextPosition(offset: pos + toAdd.length));
    widget.onResult();
  }
}
