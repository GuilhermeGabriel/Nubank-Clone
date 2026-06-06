import 'dart:math';

import 'package:flutter/material.dart';
import 'package:nubank_clone/constants/app_colors.dart';
import 'package:nubank_clone/core/app_state.dart';
import 'package:nubank_clone/pages/transfer/comprovante_screen.dart';
import 'package:nubank_clone/pages/transfer/transfer_data.dart';
import 'package:nubank_clone/utils/extensions/router_context_extension.dart';
import 'package:provider/provider.dart';

class TransferSuccessScreen extends StatefulWidget {
  final TransferData data;

  const TransferSuccessScreen({required this.data, super.key});

  @override
  State<TransferSuccessScreen> createState() => _TransferSuccessScreenState();
}

class _TransferSuccessScreenState extends State<TransferSuccessScreen> {
  late final DateTime _dateTime;
  late final String _transactionId;

  @override
  void initState() {
    super.initState();
    _dateTime = DateTime.now();
    // ID no formato EndToEndId do Pix: E + ISPB(8) + AAAAMMDDHHMM + aleatório(11).
    final d = _dateTime;
    String two(int n) => n.toString().padLeft(2, '0');
    final datePart =
        '${d.year}${two(d.month)}${two(d.day)}${two(d.hour)}${two(d.minute)}';
    final random = Random();
    const chars = 'abcdef0123456789';
    final suffix = List.generate(
      11,
      (_) => chars[random.nextInt(chars.length)],
    ).join();
    _transactionId = 'E18236120$datePart$suffix';

    // Registra a transferência no extrato.
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<AppState>().addTransaction(
            DemoTransaction(
              title: widget.data.recipientName,
              subtitle: widget.data.message ?? 'Pix',
              amount: widget.data.amount,
              isIncome: false,
              kind: 'enviado',
            ),
          );
    });
  }

  @override
  Widget build(BuildContext context) {
    final data = widget.data;
    return Scaffold(
      backgroundColor: AppColors.background(context),
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.all(16),
              child: IconButton(
                padding: EdgeInsets.zero,
                alignment: Alignment.centerLeft,
                icon: const Icon(Icons.close, color: AppColors.secondaryText),
                onPressed: () =>
                    Navigator.of(context).popUntil((r) => r.isFirst),
              ),
            ),
            Expanded(
              child: ListView(
                physics: const BouncingScrollPhysics(),
                padding: const EdgeInsets.symmetric(horizontal: 24),
                children: [
                  Container(
                    height: 90,
                    width: 90,
                    decoration: const BoxDecoration(
                      shape: BoxShape.circle,
                      color: AppColors.limit,
                    ),
                    child: const Icon(Icons.check,
                        color: Colors.white, size: 50,),
                  ),
                  const SizedBox(height: 28),
                  Text(
                    'Sua transferência foi concluída',
                    style: Theme.of(context).textTheme.headlineMedium,
                  ),
                  const SizedBox(height: 40),
                  Text(
                    'R\$ ${data.amount}',
                    style: Theme.of(context)
                        .textTheme
                        .displaySmall
                        ?.copyWith(fontSize: 40),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Para ${data.recipientName}',
                    style: Theme.of(context)
                        .textTheme
                        .titleMedium
                        ?.copyWith(color: AppColors.secondaryText),
                  ),
                  const SizedBox(height: 32),
                  const Divider(),
                  _row(context, 'Instituição', data.institution),
                  const Divider(),
                  _row(context, 'Quando', 'Agora'),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(24, 8, 24, 16),
              child: SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  onPressed: () => context.push(
                    ComprovanteScreen(
                      data: data,
                      dateTime: _dateTime,
                      transactionId: _transactionId,
                    ),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    foregroundColor: Colors.white,
                    elevation: 0,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                  ),
                  icon: const Icon(Icons.receipt_long_outlined,
                      color: Colors.white,),
                  label: const Text(
                    'Abrir comprovante',
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _row(BuildContext context, String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 14),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: Theme.of(context)
                .textTheme
                .bodyLarge
                ?.copyWith(fontWeight: FontWeight.w600),
          ),
          Flexible(
            child: Text(
              value,
              textAlign: TextAlign.right,
              style: Theme.of(context)
                  .textTheme
                  .bodyLarge
                  ?.copyWith(color: AppColors.secondaryText),
            ),
          ),
        ],
      ),
    );
  }
}
