// lib/domain/auth/models/sign_up_data.dart

class SignUpData {
  final String name;
  final String email;
  final String password;
  final String? phone;

  SignUpData._({
    required this.name,
    required this.email,
    required this.password,
    this.phone,
  });

  static SignUpDataBuilder builder() => SignUpDataBuilder();
}

class SignUpDataBuilder {
  String? _name;
  String? _email;
  String? _password;
  String? _phone;

  SignUpDataBuilder setName(String name) {
    _name = name;
    return this;
  }

  SignUpDataBuilder setEmail(String email) {
    _email = email;
    return this;
  }

  SignUpDataBuilder setPassword(String password) {
    _password = password;
    return this;
  }

  SignUpDataBuilder setPhone(String? phone) {
    _phone = phone;
    return this;
  }

  SignUpData build() {
    assert(_name != null && _email != null && _password != null);
    return SignUpData._(
      name: _name!,
      email: _email!,
      password: _password!,
      phone: _phone,
    );
  }
}