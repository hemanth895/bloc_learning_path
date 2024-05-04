import 'dart:convert';
import 'dart:io';

import 'package:bloc_learning_path/bloc/bloc_actions.dart';
import 'package:bloc_learning_path/bloc/person.dart';
import 'package:bloc_learning_path/bloc/persons_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'dart:developer' as devtools show log;

extension Log on Object {
  void log() => devtools.log(toString());
}

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: BlocProvider(
        create: (_) => PersonsBloc(),
        child: MyHomePage(),
      ),
    );
  }
}

//httpClient from dart io package for handling http requests

Future<Iterable<Person>> getPersons(String url) => HttpClient()
    .getUrl(Uri.parse(url))
    .then((req) => req.close())
    .then((res) => res.transform(utf8.decoder).join())
    .then((str) => json.decode(str) as List<dynamic>)
    .then((list) => list.map((e) => Person.fromJson(e)));

class MyHomePage extends StatelessWidget {
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      appBar: AppBar(
        title: const Text('Home Page'),
      ),
      body: Column(
        children: [
          Row(
            children: [
              TextButton(
                onPressed: () {
                  context.read<PersonsBloc>().add(LoadPersonAction(
                        url: person1Url,
                        loader: getPersons,
                      ));
                },
                child: const Text('Load json #1'),
              ),
              TextButton(
                onPressed: () {
                  context.read<PersonsBloc>().add(LoadPersonAction(
                        url: person2Url,
                        loader: getPersons,
                      ));
                },
                child: const Text('Load json #2'),
              ),
            ],
          ),
          BlocBuilder<PersonsBloc, FetchResult?>(
            buildWhen: (prevous, current) {
              return prevous?.persons != current?.persons;
            },
            builder: ((context, state) {
              final persons = state?.persons;

              if (persons == null) {
                return const SizedBox();
              }

              return ListView.builder(
                itemCount: persons.length,
                itemBuilder: (context, index) {
                  final person = persons[index]!;

                  return ListTile(
                    title: Text(person.name),
                  );
                },
              );
            }),
          )
        ],
      ),
    );
  }
}

extension Subscript<T> on Iterable<T> {
  T? operator [](int index) => length > index ? elementAt(index) : null;
}
