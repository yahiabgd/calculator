// ignore_for_file: public_member_api_docs, sort_constructors_first

class History {
  String equation;
  String answer;
  History({
    required this.equation,
    required this.answer,
  });

  @override
  String toString() => 'History(equation: $equation, answer: $answer)';
}
