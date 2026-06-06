import 'package:flutter/material.dart';
import 'package:flutter_masked_text2/flutter_masked_text2.dart';
import 'package:nubank_clone/constants/app_colors.dart';
import 'package:nubank_clone/core/app_state.dart';
import 'package:nubank_clone/pages/transfer/transfer_confirm_screen.dart';
import 'package:nubank_clone/pages/transfer/transfer_data.dart';
import 'package:nubank_clone/utils/extensions/router_context_extension.dart';
import 'package:provider/provider.dart';

class TransferValueScreen extends StatefulWidget {
  final TransferData data;

  const TransferValueScreen({required this.data, super.key});

  @override
  State<TransferValueScreen> createState() => _TransferValueScreenState();
}

class _TransferValueScreenState extends State<TransferValueScreen> {
  final _valueController = MoneyMaskedTextController(
    leftSymbol: r'R$ ',
  );

  String _method = 'Conta Nubank';

  @override
  void initState() {
    super.initState();
    _valueController.addListener(() => setState(() {}));
  }

  @override
  void dispose() {
    _valueController.dispose();
    super.dispose();
  }

  void _continue() {
    if (_valueController.numberValue <= 0) return;
    widget.data
      ..amount = _valueController.text.replaceAll(r'R$ ', '')
      ..paymentMethod = _method;
    context.push(TransferConfirmScreen(data: widget.data));
  }

  @override
  Widget build(BuildContext context) {
    final state = context.watch<AppState>();
    final enabled = _valueController.numberValue > 0;

    return Scaffold(
      backgroundColor: AppColors.background(context),
      appBar: AppBar(
        backgroundColor: AppColors.background(context),
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new,
              color: AppColors.secondaryText, size: 20,),
          onPressed: () => context.pop(),
        ),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Transferir para',
                style: Theme.of(context)
                    .textTheme
                    .titleMedium
                    ?.copyWith(color: AppColors.secondaryText),
              ),
              const SizedBox(height: 4),
              Text(
                widget.data.recipientName,
                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      fontSize: 22,
                      fontWeight: FontWeight.w500,
                    ),
              ),
              const SizedBox(height: 32),
              Text(
                'Valor',
                style: Theme.of(context)
                    .textTheme
                    .titleMedium
                    ?.copyWith(color: AppColors.secondaryText),
              ),
              TextField(
                controller: _valueController,
                autofocus: true,
                keyboardType: TextInputType.number,
                cursorColor: AppColors.primary,
                style: Theme.of(context).textTheme.displaySmall,
                decoration: const InputDecoration(
                  border: UnderlineInputBorder(),
                  focusedBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: AppColors.primary),
                  ),
                ),
              ),
              const SizedBox(height: 28),
              Text(
                'Pagando com',
                style: Theme.of(context)
                    .textTheme
                    .titleMedium
                    ?.copyWith(color: AppColors.secondaryText),
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  Expanded(
                    child: _payCard(
                      context,
                      icon: Icons.account_balance_wallet_outlined,
                      title: 'Conta Nubank',
                      subtitle: 'Atual: R\$ ${state.balance}\nEnvio imediato',
                      selected: _method == 'Conta Nubank',
                      onTap: () => setState(() => _method = 'Conta Nubank'),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: _payCard(
                      context,
                      icon: Icons.credit_card,
                      title: 'Cartão Nubank',
                      subtitle: 'Limite: R\$ ${state.limit}\nEnvio imediato',
                      selected: _method == 'Cartão Nubank',
                      badge: '12x com juros',
                      onTap: () => setState(() => _method = 'Cartão Nubank'),
                    ),
                  ),
                ],
              ),
              const Spacer(),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: enabled ? _continue : null,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    disabledBackgroundColor: AppColors.line,
                    foregroundColor: Colors.white,
                    elevation: 0,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                  ),
                  child: const Text(
                    'Continuar',
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 16),
            ],
          ),
        ),
      ),
    );
  }

  Widget _payCard(
    BuildContext context, {
    required IconData icon,
    required String title,
    required String subtitle,
    required bool selected,
    required VoidCallback onTap,
    String? badge,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: selected ? AppColors.primary : AppColors.line,
            width: selected ? 2 : 1,
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Icon(icon, color: AppColors.content(context)),
                if (badge != null)
                  Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 6, vertical: 2,),
                    decoration: BoxDecoration(
                      color: AppColors.primary,
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: Text(
                      badge,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 11,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
              ],
            ),
            const SizedBox(height: 28),
            Text(
              title,
              style: Theme.of(context)
                  .textTheme
                  .bodyLarge
                  ?.copyWith(fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 4),
            Text(
              subtitle,
              style: Theme.of(context)
                  .textTheme
                  .bodySmall
                  ?.copyWith(color: AppColors.secondaryText),
            ),
          ],
        ),
      ),
    );
  }
}
