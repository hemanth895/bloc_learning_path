import 'dart:convert';
import 'dart:io';

import 'package:bloc_learning_path/Strings.dart';
import 'package:bloc_learning_path/apis/login_api.dart';
import 'package:bloc_learning_path/apis/notes_api.dart';
import 'package:bloc_learning_path/bloc/actions.dart';
import 'package:bloc_learning_path/bloc/app_bloc.dart';
import 'package:bloc_learning_path/bloc/app_state.dart';
import 'package:bloc_learning_path/dialogs/generic_dialog.dart';
import 'package:bloc_learning_path/dialogs/loading_screen.dart';
import 'package:bloc_learning_path/models.dart';
import 'package:bloc_learning_path/views/iterable_list_view.dart';
import 'package:bloc_learning_path/views/login_view.dart';
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
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.grey),
        useMaterial3: true,
      ),
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatelessWidget {
  Widget build(BuildContext context) {
    // TODO: implement build
    return BlocProvider(
      create: (context) => AppBloc(
        loginApi: LoginApi(),
        notesApi: NoteApi(),
      ),
      child: Scaffold(
        appBar: AppBar(
          title: const Text(homePage),
        ),
        body: BlocConsumer<AppBloc, AppState>(
          listener: (context, state) {
            //loading screen

            if (state.isLoading) {
              LoadingScreen.instance().show(
                context: context,
                text: pleaseWait,
              );
            } else {
              LoadingScreen.instance().hide();
            }

            final loginError = state.loginError;

            
            if (loginError != null) {
              showGenericDialog(
                context: context,
                title: loginErrorDialogTitle,
                content: loginErrorDialogContent,
                optionBuilder: () => {
                  ok: true,
                },
              );
            }

            if (state.isLoading == false &&
                state.loginError == null &&
                state.loginHandle == const LoginHandle.fooBar() &&
                state.fetchedNotes == null) {
              context.read<AppBloc>().add(const LoadNotesAction());
            }
          },
          builder: (context, appstate) {
            final notes = appstate.fetchedNotes;

            if (notes == null) {
              return LoginView(
                onLoginTapped: (email, password) {
                  context.read<AppBloc>().add(
                        LoginAction(
                          email: email,
                          password: password,
                        ),
                      );
                },
              );
            } else {
              return notes.toListView();
            }
          },
        ),
      ),
    );
  }
}


// consumer is builder and listener both



