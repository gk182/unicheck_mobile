import 'package:flutter/material.dart';

class Validator {
  Validator._();
  static final instance = Validator._();
  late BuildContext context;

  /// Init validator
  void init(BuildContext context) => this.context = context;

  /// Define regex
  static const idRegex = r"(^(\d){9}$)|(^(\d){12}$)";
  static const emailRegex =
      r"^[\w-]+@([\w-]+\.)+[\w-]{2,4}|[\w-]+\.[\w-]+@([\w-]+\.)+[\w-]{2,4}$";
  static const websiteRegex =
      r"^(http[s]?://)?(www\.)?([a-zA-Z0-9.-]+)\.([a-zA-Z]{2,})(/[a-zA-Z0-9-._~:/?#[\]@!$&\'()*+,;=]*)?$";
  static const phoneRegex =
      r"(^((\+|)84)(3|5|7|8|9)([0-9]{8})$)|(^0(3|5|7|8|9)([0-9]{8})$)";
  static const phoneTableRegex =
      r"(^((\+|)84)(3|5|7|8|9)([0-9]{8})$)|(^0(3|5|7|8|9)([0-9]{8})$)|(^02([0-9]{9})$)";
  static const passportRegex = r"^(?!^0+$)[a-zA-Z0-9]{3,20}$";
  static const bankNumberRegex = r"^[0-9]{1,30}$";

  /// Validate email format
  String validateEmail({
    required String value,
    bool? isRequired,
  }) {
    isRequired ??= false;
    if (value.isEmpty && isRequired) return "Email không được để trống";
    if (value.isNotEmpty && !RegExp(emailRegex).hasMatch(value)) {
      return "Email không đúng định dạng";
    }
    return '';
  }

  /// Validate phone format
  String validatePhone({
    required String value,
    bool? isRequired,
  }) {
    isRequired ??= false;
    if (value.isEmpty && isRequired) return "Số điện thoại không được để trống";
    if (RegExp(phoneRegex).hasMatch(value) ||
        RegExp(phoneTableRegex).hasMatch(value)) {
      return '';
    }

    return "Số điện thoại không đúng định dạng";
  }

  /// Validate id format
  String validateId({
    required String value,
    bool? isRequired,
  }) {
    isRequired ??= false;
    if (value.isEmpty && isRequired) return "CMND/CCCD không được để trống";
    if (value.isNotEmpty && !RegExp(idRegex).hasMatch(value)) {
      return "CMND/CCCD không đúng định dạng";
    }
    return '';
  }

  /// Validate issued by, default [isRequred = true]
  String validateIssuedBy(String value) {
    if (value.isEmpty) return "Nơi cấp không được để trống";
    return '';
  }

  /// Validate passport format
  String validatePassportNumber({
    required String value,
    bool? isRequired,
  }) {
    isRequired ??= false;
    if (value.isEmpty && isRequired) return "Số hộ chiếu không được để trống";

    if (value.isNotEmpty && !RegExp(passportRegex).hasMatch(value)) {
      return "Số hộ chiếu không đúng định dạng";
    }
    return '';
  }

  /// Validate position, default [isRequired = true]
  String validatePosition(String value) {
    if (value.isEmpty) return "Chức vụ không được để trống";
    return '';
  }

  /// Validate authorized number, default [isRequired = true]
  String validateAuhorizedNumber(String value) {
    if (value.isEmpty) return "Số giấy phép không được để trống";
    return '';
  }

  /// Validate beneficiary name, default [isRequired = true]
  String validateBeneficiaryName(String value) {
    if (value.isEmpty) return "Tên người thụ hưởng không được để trống";
    return '';
  }

  /// Validate bank account number
  String validateBankNumber({
    required String value,
    bool? isRequired,
  }) {
    isRequired ??= false;
    if (value.isEmpty && isRequired) return "Số tài khoản không được để trống";
    if (value.isNotEmpty && !RegExp(bankNumberRegex).hasMatch(value)) {
      return "Số tài khoản không đúng định dạng";
    }
    return '';
  }

  /// Validate full name, default [isRequired = true]
  String validateFullName({
    required String value,
    bool? isRequired,
  }) {
    isRequired ??= false;
    if (value.isEmpty && isRequired) return "Họ và tên không được để trống";
    return '';
  }

  /// Validate address, default [isRequired = true]
  String validateAddress({
    required String value,
    bool? isRequired,
  }) {
    isRequired ??= false;
    if (value.isEmpty && isRequired) return "Địa chỉ không được để trống";
    return '';
  }
}
