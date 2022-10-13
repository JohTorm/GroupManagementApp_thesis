import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../mvvm/view.abs.dart';
import '../ui_components.dart';
import '../viewModel/second_view_model.dart';

class SecondPage extends View<SecondPageViewModel> {
const SecondPage({required SecondPageViewModel viewModel, Key? key})
: super.model(viewModel, key: key);

@override
_SecondPageState createState() => _SecondPageState(viewModel);
}

class _SecondPageState extends ViewState<SecondPage, SecondPageViewModel> {
  _SecondPageState(SecondPageViewModel viewModel) : super(viewModel);

  @override
  void initState() {
    super.initState();
    listenToRoutesSpecs(viewModel.routes);
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<SecondPageState>(
      stream: viewModel.state,
      builder: (context, snapshot) {
        if (!snapshot.hasData) return Container();

        final state = snapshot.data!;

        return Scaffold(
          appBar: AppBar(
            title: const Text('Second Page'),
          ),
          body: SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(32),
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      '''Hello ${state.user} ''',
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 32),

                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}