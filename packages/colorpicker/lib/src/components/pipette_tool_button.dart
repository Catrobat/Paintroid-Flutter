import 'package:flutter/material.dart';

class PipetteToolButton extends StatelessWidget {
  const PipetteToolButton({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 50.0,
      width: 130.0,
      padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 4.0),
      decoration: BoxDecoration(
        color: const Color.fromARGB(255, 204, 204, 204),
        borderRadius: const BorderRadius.all(Radius.circular(6.0)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.2),
            offset: const Offset(0, 1),
            blurRadius: 1.0,
          ),
        ],
      ),
      child: const Row(
        children: [
          Icon(
            Icons.auto_fix_normal,
            color: Colors.black,
          ),
          Spacer(),
          Text(
            'PIPETTE',
            style: TextStyle(
              color: Colors.black,
              letterSpacing: 1.0,
              fontWeight: FontWeight.w500,
              fontSize: 15.0,
            ),
          ),
          Spacer(),
        ],
      ),
    );
  }
}
