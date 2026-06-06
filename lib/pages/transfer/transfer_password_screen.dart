import 'package:flutter/material.dart';
import 'package:nubank_clone/constants/app_colors.dart';
import 'package:nubank_clone/pages/transfer/transfer_data.dart';
import 'package:nubank_clone/pages/transfer/transfer_loading_screen.dart';
import 'package:nubank_clone/utils/extensions/router_context_extension.dart';

class TransferPasswordScreen extends StatefulWidget {
  final TransferData data;

  const TransferPasswordScreen({required this.data, super.key});

  @override
  State<TransferPasswordScreen> createState() => _TransferPasswordScreenState();
}

class _TransferPasswordScreenState extends State<TransferPasswordScreen> {
  String _pin = '';

  void _onKey(String value) {
    if (_pin.length >= 4) return;
    setState(() => _pin += value);
    if (_pin.length == 4) {
      Future.delayed(const Duration(milliseconds: 150), () {
        if (!mounted) return;
        Navigator.of(context).pushReplacement(
          MaterialPageRoute<void>(
            builder: (_) => TransferLoadingScreen(data: widget.data),
          ),
        );
      });
    }
  }

  void _onDelete() {
    if (_pin.isEmpty) return;
    setState(() => _pin = _pin.substring(0, _pin.length - 1));
  }

  @override
  Widget build(BuildContext context) {
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
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Digite sua senha de 4 dígitos',
                    style: Theme.of(context).textTheme.headlineMedium,
                  ),
                  const SizedBox(height: 12),
                  Text(
                    'Essa é a mesma senha de 4 dígitos do seu cartão do Nubank',
                    style: Theme.of(context)
                        .textTheme
                        .titleMedium
                        ?.copyWith(color: AppColors.secondaryText),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 48),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                for (var i = 0; i < 4; i++)
                  Container(
                    margin: const EdgeInsets.symmetric(horizontal: 16),
                    height: 16,
                    width: 16,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: i < _pin.length
                          ? AppColors.content(context)
                          : AppColors.line,
                    ),
                  ),
              ],
            ),
            const Spacer(),
            _keypad(),
          ],
        ),
      ),
    );
  }

  Widget _keypad() {
    final keys = ['1', '2', '3', '4', '5', '6', '7', '8', '9', '', '0', 'del'];
    return GridView.count(
      crossAxisCount: 3,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      childAspectRatio: 1.8,
      children: keys.map((key) {
        if (key.isEmpty) return const SizedBox.shrink();
        if (key == 'del') {
          return InkWell(
            onTap: _onDelete,
            child: Icon(Icons.backspace_outlined,
                color: AppColors.content(context),),
          );
        }
        return InkWell(
          onTap: () => _onKey(key),
          child: Center(
            child: Text(
              key,
              style: TextStyle(
                fontSize: 28,
                color: AppColors.content(context),
              ),
            ),
          ),
        );
      }).toList(),
    );
  }
}
