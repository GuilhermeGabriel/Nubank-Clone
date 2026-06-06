import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:nubank_clone/constants/mocked_values.dart';
import 'package:nubank_clone/pages/transfer/transfer_data.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Um item do extrato/atividades (compra ou dinheiro recebido).
class DemoTransaction {
  final String title;
  final String subtitle;

  /// Valor já formatado, ex: "50,00".
  final String amount;
  final bool isIncome;

  /// Tipo: null (usa isIncome), 'enviado' (transferência Pix enviada).
  final String? kind;

  const DemoTransaction({
    required this.title,
    required this.subtitle,
    required this.amount,
    required this.isIncome,
    this.kind,
  });

  IconData get icon {
    if (kind == 'enviado') return Icons.arrow_circle_up_outlined;
    return isIncome
        ? Icons.arrow_circle_down_outlined
        : Icons.shopping_cart_outlined;
  }

  String get label {
    if (kind == 'enviado') return 'Transferência enviada';
    return isIncome ? 'Transferência recebida' : 'Compra no crédito';
  }

  Map<String, dynamic> toJson() => {
        'title': title,
        'subtitle': subtitle,
        'amount': amount,
        'isIncome': isIncome,
        'kind': kind,
      };

  factory DemoTransaction.fromJson(Map<String, dynamic> json) =>
      DemoTransaction(
        title: json['title'] as String? ?? '',
        subtitle: json['subtitle'] as String? ?? '',
        amount: json['amount'] as String? ?? '',
        isIncome: json['isIncome'] as bool? ?? false,
        kind: json['kind'] as String?,
      );
}

class AppState extends ChangeNotifier {
  SharedPreferences? _prefs;

  /// Carrega os dados salvos do dispositivo. Chamar antes de usar o app.
  Future<void> load() async {
    final p = await SharedPreferences.getInstance();
    _prefs = p;

    _darkMode = p.getBool('darkMode') ?? false;
    _profileImagePath = p.getString('profileImagePath');
    username = p.getString('username') ?? MockedValues.username;
    limit = p.getString('limit') ?? MockedValues.limit;
    balance = p.getString('balance') ?? MockedValues.balance;
    saved = p.getString('saved') ?? MockedValues.saved;
    invoice = p.getString('invoice') ?? MockedValues.invoice;
    loan = p.getString('loan') ?? MockedValues.loan;
    income = p.getString('income') ?? MockedValues.income;

    final txJson = p.getString('transactions');
    if (txJson != null) {
      final decoded = jsonDecode(txJson) as List<dynamic>;
      transactions
        ..clear()
        ..addAll(
          decoded.map(
            (e) => DemoTransaction.fromJson(e as Map<String, dynamic>),
          ),
        );
    }

    final contactsJson = p.getString('customContacts');
    if (contactsJson != null) {
      final decoded = jsonDecode(contactsJson) as List<dynamic>;
      customContacts
        ..clear()
        ..addAll(
          decoded.map(
            (e) => TransferContact.fromJson(e as Map<String, dynamic>),
          ),
        );
    }

    notifyListeners();
  }

  void _save() {
    final p = _prefs;
    if (p == null) return;
    if (_profileImagePath != null) {
      p.setString('profileImagePath', _profileImagePath!);
    } else {
      p.remove('profileImagePath');
    }
    p
      ..setBool('darkMode', _darkMode)
      ..setString('username', username)
      ..setString('limit', limit)
      ..setString('balance', balance)
      ..setString('saved', saved)
      ..setString('invoice', invoice)
      ..setString('loan', loan)
      ..setString('income', income)
      ..setString(
        'transactions',
        jsonEncode(transactions.map((t) => t.toJson()).toList()),
      )
      ..setString(
        'customContacts',
        jsonEncode(customContacts.map((c) => c.toJson()).toList()),
      );
  }

  bool _viewValues = true;
  bool get viewValues => _viewValues;

  void switchView() {
    _viewValues = !_viewValues;
    notifyListeners();
  }

  bool _darkMode = false;
  bool get darkMode => _darkMode;

  void setDarkMode(bool value) {
    _darkMode = value;
    _save();
    notifyListeners();
  }

  /// Caminho da foto de perfil escolhida (null = usa o ícone padrão).
  String? _profileImagePath;
  String? get profileImagePath => _profileImagePath;

  void setProfileImagePath(String? path) {
    _profileImagePath = path;
    _save();
    notifyListeners();
  }

  // ----- Valores editáveis (começam com os mocados) -----
  String username = MockedValues.username;
  String limit = MockedValues.limit;
  String balance = MockedValues.balance;
  String saved = MockedValues.saved;
  String invoice = MockedValues.invoice;
  String loan = MockedValues.loan;
  String income = MockedValues.income;

  void updateValues({
    String? username,
    String? limit,
    String? balance,
    String? saved,
    String? invoice,
    String? loan,
    String? income,
  }) {
    if (username != null) this.username = username;
    if (limit != null) this.limit = limit;
    if (balance != null) this.balance = balance;
    if (saved != null) this.saved = saved;
    if (invoice != null) this.invoice = invoice;
    if (loan != null) this.loan = loan;
    if (income != null) this.income = income;
    _save();
    notifyListeners();
  }

  // ----- Itens do extrato -----
  final List<DemoTransaction> transactions = [];

  void addTransaction(DemoTransaction transaction) {
    transactions.insert(0, transaction);
    _save();
    notifyListeners();
  }

  void removeTransaction(int index) {
    if (index >= 0 && index < transactions.length) {
      transactions.removeAt(index);
      _save();
      notifyListeners();
    }
  }

  // ----- Contatos falsos (aparecem no fluxo de transferência) -----
  final List<TransferContact> customContacts = [];

  void addCustomContact(TransferContact contact) {
    customContacts.insert(0, contact);
    _save();
    notifyListeners();
  }

  void removeCustomContact(int index) {
    if (index >= 0 && index < customContacts.length) {
      customContacts.removeAt(index);
      _save();
      notifyListeners();
    }
  }
}
