import 'package:rxdart/rxdart.dart';

abstract class BaseBloC {

  List<Subject> _subjects = new List();

  void disposeSubjects() {
    _subjects ?? _subjects.forEach((subject) => subject.close());
  }

  void initSubjects(List<Subject> subjects);

  BaseBloC() {
    initSubjects(_subjects);
  }

}