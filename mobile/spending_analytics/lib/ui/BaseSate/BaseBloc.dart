import 'package:rxdart/rxdart.dart';

abstract class BaseBloC {

  List<Subject> _subjects = new List();
  BehaviorSubject<String> _toastMessageSubject = BehaviorSubject();
  Observable<String> get toastMessageStream => _toastMessageSubject.stream;

  void showMessage(String message) {
    _toastMessageSubject.sink.add(message);
  }

  void disposeSubjects() {
    _subjects ?? _subjects.forEach((subject) => subject.close());
    _toastMessageSubject.close();
  }

  void initSubjects(List<Subject> subjects);

  BaseBloC() {
    initSubjects(_subjects);
  }

}