import 'package:component_library/component_library.dart';
import 'package:flutter/material.dart';

class Screen4 extends StatelessWidget {
  const Screen4({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      color: lightColorScheme.surface,
      padding: const EdgeInsets.only(top: 100, left: 20, right: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Expanded(
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 30),
              child: const Text(
                'Landscape',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 24,
                ),
                textAlign: TextAlign.start,
              ),
            ),
          ),
          Expanded(
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 30),
              child: const Text(
                'Pocket Paint also supports drawing in landscape mode to give you the best painting experience.',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 15,
                ),
                textAlign: TextAlign.start,
              ),
            ),
          ),
          const Expanded(
            flex: 6,
            child: SizedBox(
              width: double.infinity,
              child: PocketPaintIntroLandscape(),
            ),
          ),
        ],
      ),
    );
  }
}
