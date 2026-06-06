import 'dart:math';

/// Dados acumulados durante o fluxo de transferência Pix.
class TransferData {
  final String recipientName;
  final String institution;

  /// Valor formatado, ex: "1.234,56".
  String amount;
  String? message;
  String paymentMethod;

  TransferData({
    required this.recipientName,
    this.institution = 'NU PAGAMENTOS - IP',
    this.amount = '0,00',
    this.message,
    this.paymentMethod = 'Conta Nubank',
  });
}

/// Um contato para transferência.
class TransferContact {
  final String name;
  final String institution;
  final bool isCompany;

  const TransferContact(this.name, this.institution, {this.isCompany = false});

  String get initials {
    final parts = name.trim().split(' ').where((p) => p.isNotEmpty).toList();
    if (parts.isEmpty) return '?';
    if (parts.length == 1) return parts.first[0].toUpperCase();
    return (parts.first[0] + parts.last[0]).toUpperCase();
  }

  Map<String, dynamic> toJson() => {
        'name': name,
        'institution': institution,
        'isCompany': isCompany,
      };

  factory TransferContact.fromJson(Map<String, dynamic> json) =>
      TransferContact(
        json['name'] as String? ?? '',
        json['institution'] as String? ?? 'NU PAGAMENTOS - IP',
        isCompany: json['isCompany'] as bool? ?? false,
      );
}

const _firstNames = [
  'Ana', 'Bruno', 'Carla', 'Diego', 'Eduarda', 'Felipe', 'Gabriela',
  'Henrique', 'Isabela', 'João', 'Larissa', 'Marcos', 'Natália', 'Otávio',
  'Patrícia', 'Rafael', 'Sofia', 'Thiago', 'Vanessa', 'Lucas', 'Mariana',
  'Pedro', 'Beatriz', 'Gustavo', 'Camila',
];

const _lastNames = [
  'Silva', 'Santos', 'Oliveira', 'Souza', 'Pereira', 'Lima', 'Costa',
  'Ferreira', 'Almeida', 'Gomes', 'Ribeiro', 'Carvalho', 'Martins',
  'Rocha', 'Barbosa', 'Araújo', 'Nóbrega', 'Cardoso', 'Teixeira', 'Moraes',
];

const _institutions = [
  'NU PAGAMENTOS - IP',
  'BCO SANTANDER',
  'ITAÚ UNIBANCO',
  'BCO DO BRASIL',
  'BRADESCO',
  'CAIXA ECONÔMICA',
  'BCO INTER',
  'C6 BANK',
  'MERCADO PAGO',
  'PICPAY',
];

/// Gera uma lista de contatos com nomes aleatórios.
List<TransferContact> generateRandomContacts(int count, Random random) {
  final result = <TransferContact>[];
  final used = <String>{};
  while (result.length < count) {
    final first = _firstNames[random.nextInt(_firstNames.length)];
    final last = _lastNames[random.nextInt(_lastNames.length)];
    final last2 = _lastNames[random.nextInt(_lastNames.length)];
    final name = '$first $last $last2';
    if (!used.add(name)) continue;
    result.add(
      TransferContact(
        name,
        _institutions[random.nextInt(_institutions.length)],
      ),
    );
  }
  return result;
}
