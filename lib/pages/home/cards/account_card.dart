import 'package:flutter/material.dart';
import 'package:nubank_clone/constants/app_colors.dart';
import 'package:nubank_clone/core/app_state.dart';
import 'package:nubank_clone/pages/account/account_screen.dart';
import 'package:nubank_clone/pages/home/widgets/main_card.dart';
import 'package:nubank_clone/utils/extensions/router_context_extension.dart';
import 'package:provider/provider.dart';

class AccountCard extends StatelessWidget {
  const AccountCard({super.key});

  @override
  Widget build(BuildContext context) {
    final state = Provider.of<AppState>(context);
    final viewValues = state.viewValues;

    return MainCard(
      'Conta',
      [
        if (!viewValues)
          Container(
            color: AppColors.unview,
            height: 29,
            width: double.infinity,
          )
        else
          Text(
            'R\$ ${state.balance}',
            style: Theme.of(context).textTheme.headlineSmall,
          ),
      ],
      hideDivider: true,
      onTap: () => context.push(
        const AccountScreen(),
      ),
    );
  }
}
