import 'dart:io';
import 'dart:math';
import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:nubank_clone/constants/app_colors.dart';
import 'package:nubank_clone/constants/assets.gen.dart';
import 'package:nubank_clone/core/app_state.dart';
import 'package:nubank_clone/pages/transfer/transfer_data.dart';
import 'package:nubank_clone/utils/extensions/router_context_extension.dart';
import 'package:path_provider/path_provider.dart';
import 'package:provider/provider.dart';
import 'package:share_plus/share_plus.dart';

class ComprovanteScreen extends StatefulWidget {
  final TransferData data;
  final DateTime dateTime;
  final String transactionId;

  const ComprovanteScreen({
    required this.data,
    required this.dateTime,
    required this.transactionId,
    super.key,
  });

  @override
  State<ComprovanteScreen> createState() => _ComprovanteScreenState();
}

class _ComprovanteScreenState extends State<ComprovanteScreen> {
  final _boundaryKey = GlobalKey();
  var _sharing = false;

  static const _label = Color(0xFF1A1A1A);
  static const _value = Color(0xFF8B8B8B);
  static const _logoGray = Color(0xFF3D3D3D);
  static const _footerBg = Color(0xFFF4F4F6);

  late final String _destinoConta;
  late final String _origemConta;
  late final String _origemCpf;

  static const _months = [
    'JAN', 'FEV', 'MAR', 'ABR', 'MAI', 'JUN', //
    'JUL', 'AGO', 'SET', 'OUT', 'NOV', 'DEZ',
  ];

  @override
  void initState() {
    super.initState();
    final random = Random();
    _destinoConta = _randomAccount(random);
    _origemConta = _randomAccount(random);
    _origemCpf = '•••.${_digits(random, 3)}.${_digits(random, 3)}-••';
  }

  String _digits(Random r, int n) =>
      List.generate(n, (_) => r.nextInt(10)).join();

  String _randomAccount(Random r) => '${_digits(r, 8)}-${r.nextInt(10)}';

  String get _formattedDate {
    final d = widget.dateTime;
    String two(int n) => n.toString().padLeft(2, '0');
    return '${two(d.day)} ${_months[d.month - 1]} ${d.year} - '
        '${two(d.hour)}:${two(d.minute)}:${two(d.second)}';
  }

  Future<void> _share() async {
    if (_sharing) return;
    setState(() => _sharing = true);
    try {
      final boundary = _boundaryKey.currentContext!.findRenderObject()!
          as RenderRepaintBoundary;
      final image = await boundary.toImage(pixelRatio: 3);
      final bytes = await image.toByteData(format: ui.ImageByteFormat.png);
      final pngBytes = bytes!.buffer.asUint8List();

      final dir = await getTemporaryDirectory();
      final file = File(
        '${dir.path}/comprovante_${widget.dateTime.millisecondsSinceEpoch}.png',
      );
      await file.writeAsBytes(pngBytes);

      await SharePlus.instance.share(
        ShareParams(
          files: [XFile(file.path)],
          text: 'Comprovante de transferência Pix',
        ),
      );
    } finally {
      if (mounted) setState(() => _sharing = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final username = context.read<AppState>().username;
    final data = widget.data;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.close, color: AppColors.secondaryText),
          onPressed: () => context.pop(),
        ),
        actions: [
          IconButton(
            icon: _sharing
                ? const SizedBox(
                    height: 20,
                    width: 20,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      color: AppColors.primary,
                    ),
                  )
                : const Icon(Icons.share_outlined, color: AppColors.primary),
            onPressed: _sharing ? null : _share,
          ),
        ],
      ),
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: RepaintBoundary(
          key: _boundaryKey,
          child: ColoredBox(
            color: Colors.white,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // ----- Corpo (fundo branco) -----
                Padding(
                  padding: const EdgeInsets.fromLTRB(24, 32, 24, 24),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      ColorFiltered(
                        colorFilter: const ColorFilter.mode(
                          _logoGray,
                          BlendMode.srcIn,
                        ),
                        child: Assets.images.logo.image(height: 34),
                      ),
                      const SizedBox(height: 44),
                      const Text(
                        'Comprovante de\ntransferência',
                        style: TextStyle(
                          fontSize: 30,
                          fontWeight: FontWeight.w600,
                          color: _label,
                          height: 1.15,
                        ),
                      ),
                      const SizedBox(height: 12),
                      Text(
                        _formattedDate,
                        style: const TextStyle(color: _value, fontSize: 17),
                      ),
                      const SizedBox(height: 40),
                      _line('Valor', 'R\$ ${data.amount}'),
                      _line('Tipo de transferência', 'Pix'),
                      _line(
                        'ID da transação',
                        widget.transactionId,
                        wrap: true,
                      ),
                      if (data.message != null)
                        _line('Mensagem', data.message!, wrap: true),
                      const SizedBox(height: 12),
                      const Divider(height: 1, color: Color(0xFFEDEDED)),
                      _sectionTitle('Destino'),
                      _line('Nome', data.recipientName, wrap: true),
                      _line('Instituição', data.institution),
                      _line('Agência', '0001'),
                      _line('Conta', _destinoConta),
                      _line('Tipo de conta', 'Conta de pagamentos'),
                      _sectionTitle('Origem'),
                      _line('Nome', username, wrap: true),
                      _line('Instituição', 'NU PAGAMENTOS - IP'),
                      _line('Agência', '0001'),
                      _line('Conta', _origemConta),
                      _line('CPF', _origemCpf),
                    ],
                  ),
                ),
                // ----- Rodapé (fundo cinza claro) -----
                Container(
                  width: double.infinity,
                  color: _footerBg,
                  padding: const EdgeInsets.fromLTRB(24, 28, 24, 48),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Nu Pagamentos S.A. - Instituição de Pagamento\n'
                        'CNPJ 18.236.120/0001-58',
                        style: TextStyle(
                          color: _value,
                          fontSize: 14,
                          height: 1.5,
                        ),
                      ),
                      const SizedBox(height: 28),
                      const Text(
                        'ID da transação:',
                        style: TextStyle(
                          color: _label,
                          fontSize: 15,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        widget.transactionId,
                        style: const TextStyle(color: _value, fontSize: 15),
                      ),
                      const SizedBox(height: 28),
                      const Text(
                        'Estamos aqui para ajudar se você tiver alguma '
                        'dúvida.',
                        style: TextStyle(
                          color: _value,
                          fontSize: 14,
                          height: 1.5,
                        ),
                      ),
                      const SizedBox(height: 12),
                      const Text(
                        'Me ajuda >',
                        style: TextStyle(
                          color: AppColors.primary,
                          fontSize: 15,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(height: 28),
                      const Text(
                        'Ouvidoria: 0800 887 0463 ou demais canais em '
                        'nubank.com.br/contato#ouvidoria (Atendimento das '
                        '8h às 18h em dias úteis)',
                        style: TextStyle(
                          color: _value,
                          fontSize: 13,
                          height: 1.5,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _sectionTitle(String title) => Padding(
        padding: const EdgeInsets.only(top: 28, bottom: 8),
        child: Text(
          title,
          style: const TextStyle(
            color: _value,
            fontSize: 15,
            fontWeight: FontWeight.w600,
          ),
        ),
      );

  Widget _line(String label, String value, {bool wrap = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 15),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: const TextStyle(
              color: _label,
              fontSize: 16,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              value,
              textAlign: TextAlign.right,
              softWrap: wrap,
              overflow: wrap ? TextOverflow.visible : TextOverflow.ellipsis,
              style: const TextStyle(color: _value, fontSize: 16),
            ),
          ),
        ],
      ),
    );
  }
}
