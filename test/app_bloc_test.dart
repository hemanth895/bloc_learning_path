import 'package:bloc_learning_path/apis/login_api.dart';
import 'package:bloc_learning_path/apis/notes_api.dart';
import 'package:bloc_learning_path/bloc/actions.dart';
import 'package:bloc_learning_path/bloc/app_bloc.dart';
import 'package:bloc_learning_path/bloc/app_state.dart';
import 'package:bloc_learning_path/models.dart';
import 'package:flutter/foundation.dart' show immutable;
import 'package:flutter/material.dart';
import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';


const Iterable<Note> mockNotes = [
  Note(title: 'Note 1'),
  Note(title: 'Note 2'),
  Note(title: 'Note 3'),
];

@immutable
class DummyNotesApi implements NotesApiProtocol {

  final LoginHandle acceptedLoginHandle;
  final Iterable<Note>? notesToReturnForAcceptedLoginHandle;

  const DummyNotesApi({required this.acceptedLoginHandle,required this.notesToReturnForAcceptedLoginHandle})


  const DummyNotesApi.empty() : acceptedLoginHandle = const LoginHandle.fooBar() , notesToReturnForAcceptedLoginHandle = null;

  @override
  Future<Iterable<Note>?> getNotes({required LoginHandle loginHandle}) async{
    if(loginHandle == acceptedLoginHandle){
      return notesToReturnForAcceptedLoginHandle;
    }else{
      return null;
    }

  }
}


@immutable
class DummyLoginApi implements LoginApiProtocol{

final String acceptedEmail;
 final String acceptedPassword;
 const DummyLoginApi({required this.acceptedEmail,required this.acceptedPassword,});

 const DummyLoginApi.empty() : acceptedEmail = '' ,acceptedPassword = '';


  @override
  Future<LoginHandle?> login({required String email, required String password})async {
   if(email == acceptedEmail && password == acceptedPassword){
  return const LoginHandle.fooBar();
}else{
  return null;
}
  }

}



void main(){
  blocTest<AppBloc,AppState>('initial state of the bloc should be Appstate.empty()',
  build:() => AppBloc(
   loginApi: const DummyLoginApi.empty(),
   notesApi: const DummyNotesApi.empty(),
   ),
   verify:(appstate) => expect(
    appstate,
   const AppState.empty(),
   ),
  );


   blocTest<AppBloc,AppState>('can we log in with correct credentials?',
 build:() => AppBloc(
  loginApi: const DummyLoginApi(acceptedEmail: 'bar@baz.com',acceptedPassword: 'foo'),
  notesApi: const DummyNotesApi.empty(),
  ),
 
 
 act: (bloc) => bloc.add(const LoginAction(email: 'bar@baz.com', password: 'foo',),),
 expect: () => [
  const AppState(isLoading: true, loginError: null, loginHandle: null, fetchedNotes: null,),

    const AppState(isLoading: false, loginError: null, loginHandle: LoginHandle.fooBar(), fetchedNotes: null,),

 ],
 
 );
}
