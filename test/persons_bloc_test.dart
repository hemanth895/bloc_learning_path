import 'package:bloc_learning_path/bloc/bloc_actions.dart';
import 'package:bloc_learning_path/bloc/person.dart';
import 'package:bloc_learning_path/bloc/persons_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:bloc_test/bloc_test.dart';

const mockedPersons1 = [
  Person(
    name: 'Foo',
    age: 20,
  ),
  Person(
    name: 'Bar',
    age: 30,
  ),
];

const mockedPersons2 = [
  Person(
    name: 'Foo',
    age: 20,
  ),
  Person(
    name: 'Bar',
    age: 30,
  ),
];

Future<Iterable<Person>> mockGetPersons1(String _) =>
    Future.value(mockedPersons1);

Future<Iterable<Person>> mockGetPersons2(String _) =>
    Future.value(mockedPersons2);

void main() {
  group('Testing Bloc', () {
    // all the tests in this group need an acce sto the person_bloc object

    late PersonsBloc bloc;

    setUp(() {
      bloc = PersonsBloc();
    });

    // will be ran once for each test in the group giving the every test  a clean  slate to work with and test

    // sets up the initial requirements for this test group for each test

    // any tests we write inside of this groyup will have a access to new copy of bloc of type PersonsBloc

    blocTest<PersonsBloc, FetchResult?>(
      'Test Initial State for Person Bloc',
      build: () => bloc,
      verify: (bloc) => expect(bloc.state, null),
    );

    // fetch mockData

    blocTest(
      'Mock retriveing persons from first iterable',
      build: () => bloc,
      act: (bloc) {
        bloc.add(const LoadPersonAction(
          url: 'dummy url',
          loader: mockGetPersons1,
        ));

        bloc.add(const LoadPersonAction(
          url: 'dummy url',
          loader: mockGetPersons1,
        ));
      },
      expect: () => [
        const FetchResult(
          persons: mockedPersons1,
          isRetrievedFromCache: false,
        ),
        const FetchResult(
          persons: mockedPersons1,
          isRetrievedFromCache: true,
        ),
      ],
    );


     blocTest(
      'Mock retriveing persons from second iterable',
      build: () => bloc,
      act: (bloc) {
        bloc.add(const LoadPersonAction(
          url: 'dummy url_1',
          loader: mockGetPersons2,
        ));
        bloc.add(const LoadPersonAction(
          url: 'dummy url_1',
          loader: mockGetPersons2,
        ));
      },
      expect: () => [
        const FetchResult(
          persons: mockedPersons2,
          isRetrievedFromCache: false,
        ),
        const FetchResult(
          persons: mockedPersons2,
          isRetrievedFromCache: true,
        ),
      ],
    );


    
  });
}
