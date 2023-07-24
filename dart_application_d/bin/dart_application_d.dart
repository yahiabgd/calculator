import 'package:dart_application_d/dart_application_d.dart' as dart_application_d;
import 'dart:io';
void main(List<String> arguments) {
  print('Hello world: ${dart_application_d.calculate()}!');
  var age = stdin.readLineSync();
  print(age);
}
