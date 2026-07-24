import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:protopharma/core/config/app_text_styles.dart';
import 'package:protopharma/features/orders/cubit/order_cubit.dart';
import 'package:protopharma/features/orders/widgets/add_med_box.dart';
import 'package:protopharma/features/orders/widgets/current_order.dart';

class OrderView extends StatelessWidget {
  const OrderView({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => OrderCubit(),
      child: Scaffold(
        body: Row(
          children: [
            Padding(
              padding: const EdgeInsets.all(80.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Create Order', style: AppTextStyles.cairoBold),
                  SizedBox(height: 3),
                  Text(
                    'Add medication to order',
                    style: AppTextStyles.tableCell,
                  ),
                  AddMedBox(),
                ],
              ),
            ),
            Spacer(),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [CurrentOrder()],
            ),
          ],
        ),
      ),
    );
  }
}
