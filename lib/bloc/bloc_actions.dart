import 'package:bloc_learning_path/bloc/person.dart';
import 'package:flutter/foundation.dart' show immutable;

const person1Url = 'http://127.0.0.1:5500/api/persons1.json';
const person2Url = 'http://127.0.0.1:5500/api/persons2.json';

typedef PersonsLoader = Future<Iterable<Person>> Function(String url);

@immutable
abstract class LoadAction {
  const LoadAction();
}

@immutable
class LoadPersonAction implements LoadAction {
  final String url;

  final PersonsLoader loader;

 const LoadPersonAction({
    required this.url,
    required this.loader,
  }) : super();
}

enum PersonUrl {
  persons1,
  persons2,
}

// extension UrlString on PersonUrl {
  // String get urlString {
    // switch (this) {
      // case PersonUrl.persons1:
        // return 
      // case PersonUrl.persons2:
        // return "http://127.0.0.1:5500/api/persons2.json";
    // }
  // }
// }
// 