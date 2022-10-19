import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:app/viewModel/signup_view_model.dart';

import '../mvvm/view.abs.dart';

class SignupScreen extends View<SignupScreenViewModel> {
  SignupScreen({Key? key, required SignupScreenViewModel viewModel}) : super.model(SignupScreenViewModel(), key: key);

  static const String _title = 'Sample App';
  @override
  _LoginScreenState createState() => _LoginScreenState(viewModel);

}



class _LoginScreenState extends ViewState<SignupScreen, SignupScreenViewModel> {
  _LoginScreenState(SignupScreenViewModel viewModel) : super(viewModel);
  TextEditingController nameController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController emailController = TextEditingController();

  @override
  void initState() {
    super.initState();
    listenToRoutesSpecs(viewModel.routes);
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<SignupViewState>(
        stream: viewModel.state,
        builder: (context, snapshot) {
          if (!snapshot.hasData) return Container();
          final state = snapshot.data!;


            return Scaffold(
              appBar: AppBar(
                title: const Text('Signup Page'),

              ),
              body: Center(

                child: ListView(
                  children: <Widget>[
                    Container(
                        alignment: Alignment.center,
                        padding: const EdgeInsets.all(10),
                        child: const Text(
                          'My Awesome App',
                          style: TextStyle(
                              color: Colors.blue,
                              fontWeight: FontWeight.w500,
                              fontSize: 30),
                        )),
                    Container(
                        alignment: Alignment.center,
                        padding: const EdgeInsets.all(10),
                        child: const Text(
                          'Sign up',
                          style: TextStyle(fontSize: 20),
                        )),
                    Container(
                      padding: const EdgeInsets.fromLTRB(10, 10, 10, 0),
                      child: TextField(
                        obscureText: true,
                        controller: emailController,
                        decoration: const InputDecoration(
                          border: OutlineInputBorder(),
                          labelText: 'email',
                        ),
                      ),
                    ),

                    Container(
                      padding: const EdgeInsets.all(10),
                      child: TextField(
                        controller: nameController,
                        decoration: const InputDecoration(
                          border: OutlineInputBorder(),
                          labelText: 'Username',
                        ),
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.fromLTRB(10, 10, 10, 0),
                      child: TextField(
                        obscureText: true,
                        controller: passwordController,
                        decoration: const InputDecoration(
                          border: OutlineInputBorder(),
                          labelText: 'Password',
                        ),
                      ),
                    ),

                    Container(
                        height: 50,
                        padding: const EdgeInsets.fromLTRB(10, 10, 10, 0),
                        child: ElevatedButton(
                          child: const Text('Sign up'),
                          onPressed: () {
                            viewModel.signup();
                          },
                        )
                    ),

                  ],
                )
              )
                );



          }

    );
  }

}