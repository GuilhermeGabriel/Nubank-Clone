import 'dart:math';

import 'package:flutter/material.dart';
import 'package:nubank_clone/constants/app_colors.dart';
import 'package:nubank_clone/core/app_state.dart';
import 'package:nubank_clone/pages/transfer/transfer_data.dart';
import 'package:nubank_clone/pages/transfer/transfer_value_screen.dart';
import 'package:nubank_clone/utils/extensions/router_context_extension.dart';
import 'package:provider/provider.dart';

class TransferContactScreen extends StatefulWidget {
  const TransferContactScreen({super.key});

  @override
  State<TransferContactScreen> createState() => _TransferContactScreenState();
}

class _TransferContactScreenState extends State<TransferContactScreen> {
  final _searchController = TextEditingController();

  late final List<TransferContact> _frequentContacts;
  late final List<TransferContact> _allContacts;

  @override
  void initState() {
    super.initState();
    final random = Random();
    _frequentContacts = generateRandomContacts(3, random);
    _allContacts = generateRandomContacts(7, random);
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _selectContact(TransferContact contact) {
    context.push(
      TransferValueScreen(
        data: TransferData(
          recipientName: contact.name,
          institution: contact.institution,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background(context),
      appBar: AppBar(
        backgroundColor: AppColors.background(context),
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.close, color: AppColors.secondaryText),
          onPressed: () => context.pop(),
        ),
      ),
      body: ListView(
        physics: const BouncingScrollPhysics(),
        padding: const EdgeInsets.symmetric(horizontal: 24),
        children: [
          Text(
            'Para quem você quer transferir?',
            style: Theme.of(context).textTheme.headlineMedium,
          ),
          const SizedBox(height: 28),
          Text(
            'Insira o dado de quem vai receber',
            style: Theme.of(context)
                .textTheme
                .bodyMedium
                ?.copyWith(color: AppColors.secondaryText),
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              Expanded(
                child: TextField(
                  controller: _searchController,
                  cursorColor: AppColors.primary,
                  textInputAction: TextInputAction.done,
                  onSubmitted: (value) {
                    if (value.trim().isNotEmpty) {
                      _selectContact(TransferContact(value.trim(), 'BANCO'));
                    }
                  },
                  decoration: const InputDecoration(
                    hintText: 'Nome, CPF/CNPJ ou chave Pix',
                    border: UnderlineInputBorder(),
                    focusedBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: AppColors.primary),
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              const Icon(Icons.qr_code, color: AppColors.secondaryText),
            ],
          ),
          const SizedBox(height: 32),
          Text(
            'Você sempre costuma pagar',
            style: Theme.of(context)
                .textTheme
                .bodyMedium
                ?.copyWith(color: AppColors.secondaryText),
          ),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              for (final contact in _frequentContacts)
                _frequentItem(context, contact),
            ],
          ),
          const SizedBox(height: 32),
          Text(
            'Todos os seus contatos',
            style: Theme.of(context)
                .textTheme
                .bodyMedium
                ?.copyWith(color: AppColors.secondaryText),
          ),
          const SizedBox(height: 8),
          for (final contact in context.watch<AppState>().customContacts)
            _contactTile(context, contact),
          for (final contact in _allContacts) _contactTile(context, contact),
        ],
      ),
    );
  }

  Widget _frequentItem(BuildContext context, TransferContact contact) {
    return Expanded(
      child: GestureDetector(
        onTap: () => _selectContact(contact),
        child: Column(
          children: [
            CircleAvatar(
              radius: 36,
              backgroundColor: AppColors.surface(context),
              child: Text(
                contact.initials,
                style: TextStyle(color: AppColors.content(context)),
              ),
            ),
            const SizedBox(height: 8),
            Text(
              contact.name,
              textAlign: TextAlign.center,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: Theme.of(context).textTheme.bodyMedium,
            ),
            Text(
              contact.institution,
              textAlign: TextAlign.center,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
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

  Widget _contactTile(BuildContext context, TransferContact contact) {
    return ListTile(
      contentPadding: const EdgeInsets.symmetric(vertical: 6),
      onTap: () => _selectContact(contact),
      leading: CircleAvatar(
        radius: 24,
        backgroundColor: AppColors.surface(context),
        child: Icon(
          contact.isCompany ? Icons.apartment : Icons.person_outline,
          color: AppColors.content(context),
        ),
      ),
      title: Text(
        contact.name,
        style: Theme.of(context)
            .textTheme
            .titleMedium
            ?.copyWith(color: AppColors.content(context)),
      ),
    );
  }
}
