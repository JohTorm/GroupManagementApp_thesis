import 'package:flutter/material.dart';
import 'package:provider/provider.dart';


import '../mvvm/view.abs.dart';
import '../viewModel/create_group_view_model.dart';

class CreateGroup extends View<CreateGroupViewModel> {
  CreateGroup({Key? key, required CreateGroupViewModel viewModel}) : super.model(CreateGroupViewModel(), key: key);

  static const String _title = 'Sample App';
  @override
  _CreateGroupState createState() => _CreateGroupState(viewModel);

}



class _CreateGroupState extends ViewState<CreateGroup, CreateGroupViewModel> {
  _CreateGroupState(CreateGroupViewModel viewModel) : super(viewModel);
  TextEditingController nameController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  @override
  void initState() {
    super.initState();
    listenToRoutesSpecs(viewModel.routes);
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<CreateGroupViewState>(
        stream: viewModel.state,
        builder: (context, snapshot) {
          if (!snapshot.hasData) return Container();
          final state = snapshot.data!;


            return Scaffold(
              appBar: AppBar(
                title: const Text('Create group'),

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
                          'Create group',
                          style: TextStyle(fontSize: 20),
                        )),
                    Container(
                      padding: const EdgeInsets.all(10),
                      child: TextField(
                        controller: nameController,
                        decoration: const InputDecoration(
                          border: OutlineInputBorder(),
                          labelText: 'Group name',
                        ),
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.fromLTRB(10, 10, 10, 10),
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
                          child: const Text('Create group'),
                          onPressed: () {
                            print(nameController.text);
                            print(passwordController.text);
                            viewModel.createGroup(nameController.text);
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