import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:paintroid/main.dart';

void main() {
  group('Bottom Navigation Bar', () {
    testWidgets('Should have four items', (tester) async {
      await tester.pumpWidget(const PocketPaintApp());
      final BottomNavigationBar navBar = tester.firstWidget(find.byType(BottomNavigationBar));
      expect(navBar.items.length, equals(4));
    });

    testWidgets('Default selection should be Brush tool', (tester) async {
      await tester.pumpWidget(const PocketPaintApp());
      final BottomNavigationBar navBar = tester.firstWidget(find.byType(BottomNavigationBar));
      final selectedItem = navBar.items[navBar.currentIndex];
      expect(selectedItem.label?.toLowerCase(), equals("brush"));
    });
  });
}
