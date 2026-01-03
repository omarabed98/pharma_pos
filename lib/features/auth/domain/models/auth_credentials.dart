import 'package:pos_pharma_app/core/domain/models/json_response_model.dart';

enum LoginMethod {
  credentials,
  google,
  facebook,
  apple;

  const LoginMethod();
}

class AllowedTransaction {
  final int id;
  final String name;
  final bool checkStock;
  final bool trFoutaraAllowed;
  final bool discountAllowed;
  final bool discountBeforeTax;
  final bool discountPercAllowed;
  final bool discountValueAllowed;
  final bool discountBonusAllowed;
  final bool bonusAllowed;
  final double minCurrency;
  final bool cashregref;
  final int? defaultPayment;
  final bool piRefAllowed;

  AllowedTransaction({
    required this.id,
    required this.name,
    required this.checkStock,
    required this.trFoutaraAllowed,
    required this.discountAllowed,
    required this.discountBeforeTax,
    required this.discountPercAllowed,
    required this.discountValueAllowed,
    required this.discountBonusAllowed,
    required this.bonusAllowed,
    required this.minCurrency,
    required this.cashregref,
    this.defaultPayment,
    required this.piRefAllowed,
  });

  factory AllowedTransaction.fromJson(Map<String, dynamic> json) {
    final jsonHelper = JsonResponseModel.instance();

    return AllowedTransaction(
      id: jsonHelper.getIntJson(json, 'id'),
      name: jsonHelper.getStringJson(json, 'name') ?? '',
      checkStock: jsonHelper.getBoolJson(json, 'checkStock'),
      trFoutaraAllowed: jsonHelper.getBoolJson(json, 'trFoutaraAllowed'),
      discountAllowed: jsonHelper.getBoolJson(json, 'discountAllowed'),
      discountBeforeTax: jsonHelper.getBoolJson(json, 'discountBeforeTax'),
      discountPercAllowed: jsonHelper.getBoolJson(json, 'discountPercAllowed'),
      discountValueAllowed: jsonHelper.getBoolJson(
        json,
        'discountValueAllowed',
      ),
      discountBonusAllowed: jsonHelper.getBoolJson(
        json,
        'discountBonusAllowed',
      ),
      bonusAllowed: jsonHelper.getBoolJson(json, 'bonusAllowed'),
      minCurrency: jsonHelper.getDoubleJson(json, 'minCurrency'),
      cashregref: jsonHelper.getBoolJson(json, 'cashregref'),
      defaultPayment: json['defaultPayment'] != null
          ? jsonHelper.getIntJson(json, 'defaultPayment')
          : null,
      piRefAllowed: jsonHelper.getBoolJson(json, 'piRefAllowed'),
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'name': name,
    'checkStock': checkStock,
    'trFoutaraAllowed': trFoutaraAllowed,
    'discountAllowed': discountAllowed,
    'discountBeforeTax': discountBeforeTax,
    'discountPercAllowed': discountPercAllowed,
    'discountValueAllowed': discountValueAllowed,
    'discountBonusAllowed': discountBonusAllowed,
    'bonusAllowed': bonusAllowed,
    'minCurrency': minCurrency,
    'cashregref': cashregref,
    'defaultPayment': defaultPayment,
    'piRefAllowed': piRefAllowed,
  };
}

class AuthCredentials {
  final int id;
  final String name;
  final String username;
  final int roleId;
  final String roleName;
  final String phone;
  final String email;
  final String token;
  final String licenseKey;
  final String licenseIssue;
  final String licenseExpiry;
  final String companyName;
  final String? taxNumber;
  final String? activityNumber;
  final List<AllowedTransaction> allowedTransactions;
  final LoginMethod loginMethod;

  AuthCredentials({
    required this.id,
    required this.name,
    required this.username,
    required this.roleId,
    required this.roleName,
    required this.phone,
    required this.email,
    required this.token,
    required this.licenseKey,
    required this.licenseIssue,
    required this.licenseExpiry,
    required this.companyName,
    this.taxNumber,
    this.activityNumber,
    required this.allowedTransactions,
    required this.loginMethod,
  });

  // Getters for backward compatibility
  String get access => token;
  String get refresh => '';

  factory AuthCredentials.fromJson(
    Map<String, dynamic> json,
    LoginMethod loginMethod,
  ) {
    final jsonHelper = JsonResponseModel.instance();

    return AuthCredentials(
      id: jsonHelper.getIntJson(json, 'id'),
      name: jsonHelper.getStringJson(json, 'name') ?? '',
      username: jsonHelper.getStringJson(json, 'username') ?? '',
      roleId: jsonHelper.getIntJson(json, 'roleId'),
      roleName: jsonHelper.getStringJson(json, 'roleName') ?? '',
      phone: jsonHelper.getStringJson(json, 'phone') ?? '',
      email: jsonHelper.getStringJson(json, 'email') ?? '',
      token: jsonHelper.getStringJson(json, 'token') ?? '',
      licenseKey: jsonHelper.getStringJson(json, 'licenseKey') ?? '',
      licenseIssue: jsonHelper.getStringJson(json, 'licenseIssue') ?? '',
      licenseExpiry: jsonHelper.getStringJson(json, 'licenseExpiry') ?? '',
      companyName: jsonHelper.getStringJson(json, 'companyName') ?? '',
      taxNumber: jsonHelper.getStringJson(json, 'taxNumber'),
      activityNumber: jsonHelper.getStringJson(json, 'activityNumber'),
      allowedTransactions: jsonHelper.getListJson<AllowedTransaction>(
        json,
        'allowedTransactions',
        (json) => AllowedTransaction.fromJson(json),
      ),
      loginMethod: loginMethod,
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'name': name,
    'username': username,
    'roleId': roleId,
    'roleName': roleName,
    'phone': phone,
    'email': email,
    'token': token,
    'licenseKey': licenseKey,
    'licenseIssue': licenseIssue,
    'licenseExpiry': licenseExpiry,
    'companyName': companyName,
    'taxNumber': taxNumber,
    'activityNumber': activityNumber,
    'allowedTransactions': allowedTransactions.map((x) => x.toJson()).toList(),
  };

  @override
  String toString() {
    return 'AuthCredentials(id: $id, name: $name, username: $username, email: $email, token: $token)';
  }
}
