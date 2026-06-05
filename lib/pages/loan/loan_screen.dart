import 'package:flutter/material.dart';
import 'package:nubank_clone/constants/app_colors.dart';
import 'package:nubank_clone/constants/nu_icons.dart';
import 'package:nubank_clone/core/app_state.dart';
import 'package:nubank_clone/utils/extensions/router_context_extension.dart';
import 'package:nubank_clone/widgets/nu_outlined_button.dart';
import 'package:provider/provider.dart';

class LoanScreen extends StatelessWidget {
  const LoanScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final state = Provider.of<AppState>(context);
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(
            NuIcons.nuds_ic_chevron_left,
            color: AppColors.secondaryText,
          ),
          onPressed: () => context.pop(),
        ),
        actions: [
          IconButton(
            icon: const Icon(
              Icons.help_outline,
              color: AppColors.secondaryText,
            ),
            onPressed: () {},
          ),
        ],
      ),
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 25),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 30),
                  Text(
                    'O valor disponível no momento é de R\$ ${state.loan}',
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                  const SizedBox(height: 15),
                  Text(
                    'Este valor pode mudar diariamente devido à nossa análise de crédito.',
                    style: Theme.of(context)
                        .textTheme
                        .titleSmall
                        ?.copyWith(height: 1.3),
                  ),
                  const SizedBox(height: 20),
                  Text(
                    'Entenda como funciona >',
                    style: Theme.of(context)
                        .textTheme
                        .bodyMedium
                        ?.copyWith(color: AppColors.primary),
                  ),
                  const SizedBox(height: 45),
                  const NuOutlinedButton('Novo empréstimo'),
                  const SizedBox(height: 20),
                ],
              ),
            ),
            Container(height: 1, color: AppColors.line),
            const SizedBox(height: 30),
            Center(
              child: Text(
                'Você não possui nenhum empréstimo ativo.',
                style: Theme.of(context).textTheme.titleSmall,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
