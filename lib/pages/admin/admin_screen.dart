import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:nubank_clone/constants/app_colors.dart';
import 'package:nubank_clone/core/app_state.dart';
import 'package:nubank_clone/core/notification_service.dart';
import 'package:nubank_clone/pages/transfer/transfer_data.dart';
import 'package:path_provider/path_provider.dart';
import 'package:provider/provider.dart';

/// Painel escondido de demonstração.
///
/// Permite editar todos os dados mocados do app, lançar itens no extrato
/// (compras / dinheiro recebido) e disparar notificações com o ícone do
/// Nubank. Acesse segurando a saudação "Olá, ..." na tela inicial.
class AdminScreen extends StatefulWidget {
  const AdminScreen({super.key});

  @override
  State<AdminScreen> createState() => _AdminScreenState();
}

class _AdminScreenState extends State<AdminScreen> {
  // Notificação livre
  final _notifTitle = TextEditingController();
  final _notifBody = TextEditingController();

  // Lançamento no extrato
  final _txTitle = TextEditingController();
  final _txSubtitle = TextEditingController();
  final _txAmount = TextEditingController();
  bool _txIsIncome = false;

  // Contato falso
  final _contactName = TextEditingController();
  final _contactInstitution = TextEditingController();

  // Edição dos dados do app
  late final TextEditingController _username;
  late final TextEditingController _balance;
  late final TextEditingController _saved;
  late final TextEditingController _invoice;
  late final TextEditingController _limit;
  late final TextEditingController _loan;
  late final TextEditingController _income;

  @override
  void initState() {
    super.initState();
    final state = context.read<AppState>();
    _username = TextEditingController(text: state.username);
    _balance = TextEditingController(text: state.balance);
    _saved = TextEditingController(text: state.saved);
    _invoice = TextEditingController(text: state.invoice);
    _limit = TextEditingController(text: state.limit);
    _loan = TextEditingController(text: state.loan);
    _income = TextEditingController(text: state.income);
  }

  @override
  void dispose() {
    for (final c in [
      _notifTitle,
      _notifBody,
      _txTitle,
      _txSubtitle,
      _txAmount,
      _contactName,
      _contactInstitution,
      _username,
      _balance,
      _saved,
      _invoice,
      _limit,
      _loan,
      _income,
    ]) {
      c.dispose();
    }
    super.dispose();
  }

  void _toast(String message) {
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(SnackBar(content: Text(message)));
  }

  Future<void> _sendNotification() async {
    final title = _notifTitle.text.trim();
    final body = _notifBody.text.trim();
    if (title.isEmpty && body.isEmpty) {
      _toast('Preencha o título ou a descrição');
      return;
    }
    await NotificationService.instance.show(
      title: title.isEmpty ? 'Nubank' : title,
      body: body,
    );
    _toast('Notificação enviada!');
  }

  Future<void> _addTransaction() async {
    final title = _txTitle.text.trim();
    final amount = _txAmount.text.trim();
    if (title.isEmpty || amount.isEmpty) {
      _toast('Preencha o nome e o valor');
      return;
    }
    final transaction = DemoTransaction(
      title: title,
      subtitle: _txSubtitle.text.trim(),
      amount: amount,
      isIncome: _txIsIncome,
    );
    context.read<AppState>().addTransaction(transaction);

    await NotificationService.instance.show(
      title: transaction.label,
      body: _txIsIncome
          ? 'Você recebeu R\$ $amount de $title'
          : 'Compra de R\$ $amount em $title',
    );

    _txTitle.clear();
    _txSubtitle.clear();
    _txAmount.clear();
    _toast('Item adicionado ao extrato!');
  }

  void _addContact() {
    final name = _contactName.text.trim();
    if (name.isEmpty) {
      _toast('Digite o nome do contato');
      return;
    }
    final institution = _contactInstitution.text.trim();
    context.read<AppState>().addCustomContact(
          TransferContact(
            name,
            institution.isEmpty ? 'NU PAGAMENTOS - IP' : institution,
          ),
        );
    _contactName.clear();
    _contactInstitution.clear();
    _toast('Contato adicionado!');
  }

  Future<void> _pickProfileImage() async {
    final picked = await ImagePicker().pickImage(
      source: ImageSource.gallery,
      maxWidth: 600,
      imageQuality: 85,
    );
    if (picked == null) return;

    // Copia pra uma pasta permanente do app (o cache do picker pode ser limpo).
    final dir = await getApplicationDocumentsDirectory();
    final dest =
        '${dir.path}/profile_${DateTime.now().millisecondsSinceEpoch}.jpg';
    await File(picked.path).copy(dest);

    if (!mounted) return;
    context.read<AppState>().setProfileImagePath(dest);
    _toast('Foto de perfil atualizada!');
  }

  void _saveValues() {
    context.read<AppState>().updateValues(
          username: _username.text.trim(),
          balance: _balance.text.trim(),
          saved: _saved.text.trim(),
          invoice: _invoice.text.trim(),
          limit: _limit.text.trim(),
          loan: _loan.text.trim(),
          income: _income.text.trim(),
        );
    _toast('Dados atualizados!');
  }

  @override
  Widget build(BuildContext context) {
    final state = context.watch<AppState>();
    final transactions = state.transactions;

    return Scaffold(
      backgroundColor: AppColors.background(context),
      appBar: AppBar(
        backgroundColor: AppColors.primary,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.white),
        title: const Text(
          'Painel de demonstração',
          style: TextStyle(color: Colors.white, fontSize: 18),
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(20, 20, 20, 40),
        children: [
          // ---------- Aparência ----------
          _section('Aparência'),
          SwitchListTile(
            contentPadding: EdgeInsets.zero,
            activeThumbColor: AppColors.primary,
            title: const Text('Dark mode'),
            subtitle: const Text('Ativa o tema escuro do app'),
            value: state.darkMode,
            onChanged: (value) =>
                context.read<AppState>().setDarkMode(value),
          ),

          const SizedBox(height: 24),

          // ---------- Perfil ----------
          _section('Perfil'),
          _field(
            'Nome do usuário',
            _username,
            hint: 'Ex: Guilherme',
            onChanged: (value) =>
                context.read<AppState>().updateValues(username: value),
          ),
          const SizedBox(height: 4),
          Row(
            children: [
              CircleAvatar(
                radius: 32,
                backgroundColor: AppColors.secondary,
                backgroundImage: state.profileImagePath != null
                    ? FileImage(File(state.profileImagePath!))
                    : null,
                child: state.profileImagePath == null
                    ? const Icon(Icons.person, color: Colors.white, size: 32)
                    : null,
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    OutlinedButton.icon(
                      onPressed: _pickProfileImage,
                      icon: const Icon(Icons.photo_library_outlined),
                      style: OutlinedButton.styleFrom(
                        foregroundColor: AppColors.primary,
                      ),
                      label: const Text('Escolher foto'),
                    ),
                    if (state.profileImagePath != null)
                      TextButton.icon(
                        onPressed: () =>
                            context.read<AppState>().setProfileImagePath(null),
                        icon: const Icon(
                          Icons.delete_outline,
                          color: Colors.red,
                        ),
                        label: const Text(
                          'Remover',
                          style: TextStyle(color: Colors.red),
                        ),
                      ),
                  ],
                ),
              ),
            ],
          ),

          const SizedBox(height: 24),

          // ---------- Notificação livre ----------
          _section('Enviar notificação'),
          _field('Título', _notifTitle, hint: 'Ex: Você recebeu um Pix'),
          _field('Descrição', _notifBody, hint: r'Ex: R$ 250,00 de João'),
          _primaryButton('Enviar notificação', _sendNotification),

          const SizedBox(height: 32),

          // ---------- Lançar item no extrato ----------
          _section('Lançar no extrato'),
          _field('Nome (loja / pessoa)', _txTitle, hint: 'Ex: Mercado Silva'),
          _field(
            'Descrição (opcional)',
            _txSubtitle,
            hint: 'Ex: 3x no crédito',
          ),
          _field(
            'Valor',
            _txAmount,
            hint: 'Ex: 50,00',
            keyboard: TextInputType.number,
          ),
          Row(
            children: [
              const Text('Tipo:'),
              const SizedBox(width: 12),
              ChoiceChip(
                label: const Text('Compra'),
                selected: !_txIsIncome,
                selectedColor: AppColors.primary.withValues(alpha: 0.15),
                onSelected: (_) => setState(() => _txIsIncome = false),
              ),
              const SizedBox(width: 8),
              ChoiceChip(
                label: const Text('Recebido'),
                selected: _txIsIncome,
                selectedColor: AppColors.primary.withValues(alpha: 0.15),
                onSelected: (_) => setState(() => _txIsIncome = true),
              ),
            ],
          ),
          const SizedBox(height: 12),
          _primaryButton('Adicionar item (e notificar)', _addTransaction),

          const SizedBox(height: 24),

          // ---------- Lista de itens com excluir ----------
          _section('Itens do extrato (${transactions.length})'),
          if (transactions.isEmpty)
            const Padding(
              padding: EdgeInsets.symmetric(vertical: 8),
              child: Text(
                'Nenhum item ainda. Adicione acima.',
                style: TextStyle(color: AppColors.secondaryText),
              ),
            )
          else
            for (var i = 0; i < transactions.length; i++)
              ListTile(
                contentPadding: EdgeInsets.zero,
                leading: Icon(transactions[i].icon, color: AppColors.primary),
                title: Text(transactions[i].title),
                subtitle: Text(
                  '${transactions[i].isIncome ? "Recebido" : "Compra"} • '
                  'R\$ ${transactions[i].amount}',
                ),
                trailing: IconButton(
                  icon: const Icon(Icons.delete_outline, color: Colors.red),
                  onPressed: () =>
                      context.read<AppState>().removeTransaction(i),
                ),
              ),

          const SizedBox(height: 32),

          // ---------- Contatos falsos ----------
          _section('Contatos para transferência'),
          _field('Nome do contato', _contactName, hint: 'Ex: João da Silva'),
          _field(
            'Instituição (opcional)',
            _contactInstitution,
            hint: 'Ex: NU PAGAMENTOS - IP',
          ),
          const SizedBox(height: 4),
          _primaryButton('Adicionar contato', _addContact),
          const SizedBox(height: 12),
          if (state.customContacts.isEmpty)
            const Padding(
              padding: EdgeInsets.symmetric(vertical: 8),
              child: Text(
                'Nenhum contato fixo. Os contatos do fluxo são aleatórios.',
                style: TextStyle(color: AppColors.secondaryText),
              ),
            )
          else
            for (var i = 0; i < state.customContacts.length; i++)
              ListTile(
                contentPadding: EdgeInsets.zero,
                leading: const Icon(
                  Icons.person_outline,
                  color: AppColors.primary,
                ),
                title: Text(state.customContacts[i].name),
                subtitle: Text(state.customContacts[i].institution),
                trailing: IconButton(
                  icon: const Icon(Icons.delete_outline, color: Colors.red),
                  onPressed: () =>
                      context.read<AppState>().removeCustomContact(i),
                ),
              ),

          const SizedBox(height: 32),

          // ---------- Editar dados do app ----------
          _section('Editar dados do app'),
          _field('Saldo da conta', _balance),
          _field('Dinheiro guardado', _saved),
          _field('Fatura atual', _invoice),
          _field('Limite disponível', _limit),
          _field('Empréstimo disponível', _loan),
          _field('Rendimento do mês', _income),
          const SizedBox(height: 8),
          _primaryButton('Salvar dados', _saveValues),
        ],
      ),
    );
  }

  Widget _section(String title) => Padding(
        padding: const EdgeInsets.only(bottom: 12),
        child: Text(
          title,
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w700,
            color: AppColors.primary,
          ),
        ),
      );

  Widget _field(
    String label,
    TextEditingController controller, {
    String? hint,
    TextInputType keyboard = TextInputType.text,
    ValueChanged<String>? onChanged,
  }) =>
      Padding(
        padding: const EdgeInsets.only(bottom: 14),
        child: TextField(
          controller: controller,
          keyboardType: keyboard,
          onChanged: onChanged,
          cursorColor: AppColors.primary,
          decoration: InputDecoration(
            labelText: label,
            hintText: hint,
            isDense: true,
            border: const OutlineInputBorder(),
            focusedBorder: const OutlineInputBorder(
              borderSide: BorderSide(color: AppColors.primary),
            ),
          ),
        ),
      );

  Widget _primaryButton(String label, VoidCallback onPressed) => SizedBox(
        width: double.infinity,
        child: ElevatedButton(
          onPressed: onPressed,
          style: ElevatedButton.styleFrom(
            backgroundColor: AppColors.primary,
            foregroundColor: Colors.white,
            elevation: 0,
            padding: const EdgeInsets.symmetric(vertical: 14),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(30),
            ),
          ),
          child: Text(
            label,
            style: const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      );
}
