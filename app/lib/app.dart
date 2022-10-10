import 'package:flutter/material.dart';

class AppContainer extends StatelessWidget {
  const AppContainer({super.key, this.child});

  final Widget? child;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(left: 20, right: 20, top: 20),
      decoration: const BoxDecoration(
        color: Color(0xffA77979),
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(20),
          topRight: Radius.circular(20),
        ),
      ),
      child: child,
    );
  }
}

class AppContainerWithFloatingButton extends StatelessWidget {
  const AppContainerWithFloatingButton(
      {super.key, this.floatingActionButton, required this.child});

  final Widget? floatingActionButton;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return AppContainer(
      child: Stack(
        children: [
          child,
          Align(
            alignment: Alignment.bottomRight,
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: floatingActionButton,
            ),
          ),
        ],
      ),
    );
  }
}
