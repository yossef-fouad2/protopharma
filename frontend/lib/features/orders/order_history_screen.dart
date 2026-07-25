import 'package:flutter/material.dart';

import 'widgets/order_history_view.dart';

/// Screen wrapper for the Order History view.
///
/// Kept thin (like [OrderView] and [HomeScreen]) so the composition and routing
/// stay obvious as the feature grows.
class OrderHistoryScreen extends StatelessWidget {
  const OrderHistoryScreen({super.key});

  @override
  Widget build(BuildContext context) => const OrderHistoryView();
}
