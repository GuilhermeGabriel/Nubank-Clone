import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:nubank_clone/constants/mocked_values.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Um item do extrato/atividades (compra ou dinheiro recebido).
class DemoTransaction {
  final String title;
  final String subtitle;

  /// Valor já formatado, ex: "50,00".
  final String amount;
  final bool isIncome;

  const DemoTransaction({
    required this.title,
    required this.subtitle,
    required this.amount,
    required this.isIncome,
  });

  IconData get icon =>
      isIncome ? Icons.arrow_circle_down_outlined : Icons.shopping_cart_outlined;

  String get label => isIncome ? 'Transferência recebida' : 'Compra no crédito';

  Map<String, dynamic> toJson() => {
        'title': title,
        'subtitle': subtitle,
        'amount': amount,
        'isIncome': isIncome,
      };

  factory DemoTransaction.fromJson(Map<String, dynamic> json) =>
      DemoTransaction(
        title: json['title'] as String? ?? '',
        subtitle: json['subtitle'] as String? ?? '',
        amount: json['amount'] as String? ?? '',
        isIncome: json['isIncome'] as bool? ?? false,
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

    notifyListeners();
  }

  void _save() {
    final p = _prefs;
    if (p == null) return;
    p.setBool('darkMode', _darkMode);
    if (_profileImagePath != null) {
      p.setString('profileImagePath', _profileImagePath!);
    } else {
      p.remove('profileImagePath');
    }
    p.setString('username', username);
    p.setString('limit', limit);
    p.setString('balance', balance);
    p.setString('saved', saved);
    p.setString('invoice', invoice);
    p.setString('loan', loan);
    p.setString('income', income);
    p.setString(
      'transactions',
      jsonEncode(transactions.map((t) => t.toJson()).toList()),
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
}
