import 'package:flutter/material.dart';
import 'main_menu_screen.dart';

class AuthScreen extends StatefulWidget {
  const AuthScreen({super.key});

  @override
  State<AuthScreen> createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _isLoading = false;

  // Локальная база пользователей с ролями и правами
  final Map<String, Map<String, dynamic>> _users = {
    'admin@duma-ekb.ru': {
      'password': 'admin123',
      'name': 'Администратор Системы',
      'role': 'admin',
      'position': 'Системный администратор',
      'email': 'admin@duma-ekb.ru',
      'phone': '+7 (343) 000-00-00',
      'department': 'ИТ отдел',
      'permissions': ['all']
    },
    'deputy@duma-ekb.ru': {
      'password': '123456',
      'name': 'Иван Иванов',
      'role': 'deputy',
      'position': 'Депутат',
      'email': 'deputy@duma-ekb.ru',
      'phone': '+7 (343) 111-11-11',
      'department': 'Комитет по бюджету',
      'permissions': ['events', 'documents', 'profile', 'meetings', 'feedback']
    },
    'staff@duma-ekb.ru': {
      'password': '123456',
      'name': 'Петр Петров',
      'role': 'staff',
      'position': 'Сотрудник аппарата',
      'email': 'staff@duma-ekb.ru',
      'phone': '+7 (343) 222-22-22',
      'department': 'Организационный отдел',
      'permissions': ['documents', 'profile']
    },
  };


  Map<String, dynamic>? _authenticate(String email, String password) {
    if (_users.containsKey(email) && _users[email]!['password'] == password) {
      return _users[email];
    }
    return null;
  }

  List<String> _getTestAccounts() {
    return _users.keys.map((email) => '$email / ${_users[email]!['password']}').toList();
  }

  void _login() async {
    if (_formKey.currentState!.validate()) {
      setState(() => _isLoading = true);

      // Имитация загрузки
      await Future.delayed(const Duration(seconds: 1));

      final userData = _authenticate(
          _emailController.text,
          _passwordController.text
      );

      if (userData != null) {
        if (!mounted) return;
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => MainMenuScreen(userData: userData)),
        );
      } else {
        if (!mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Неверный email или пароль')),
        );
      }

      setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Логотип
                Icon(
                  Icons.account_balance,
                  size: 80,
                  color: Colors.blue[700],
                ),
                const SizedBox(height: 20),
                Text(
                  'Кабинет депутата',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Colors.blue[700],
                  ),
                ),
                Text(
                  'Екатеринбургская городская Дума',
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.grey[600],
                  ),
                ),
                const SizedBox(height: 40),

                // Поле email
                TextFormField(
                  controller: _emailController,
                  decoration: const InputDecoration(
                    labelText: 'Email',
                    prefixIcon: Icon(Icons.email),
                    border: OutlineInputBorder(),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Введите email';
                    }
                    if (!value.contains('@')) {
                      return 'Введите корректный email';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),

                // Поле пароля
                TextFormField(
                  controller: _passwordController,
                  obscureText: true,
                  decoration: const InputDecoration(
                    labelText: 'Пароль',
                    prefixIcon: Icon(Icons.lock),
                    border: OutlineInputBorder(),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Введите пароль';
                    }
                    if (value.length < 6) {
                      return 'Пароль должен содержать минимум 6 символов';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 24),

                // Кнопка входа
                if (_isLoading)
                  const CircularProgressIndicator()
                else
                  SizedBox(
                    width: double.infinity,
                    height: 50,
                    child: ElevatedButton(
                      onPressed: _login,
                      child: const Text(
                        'Войти',
                        style: TextStyle(fontSize: 16),
                      ),
                    ),
                  ),

                const SizedBox(height: 20),

                // Тестовые доступы
                ..._getTestAccounts().map((account) =>
                    Text(
                      account,
                      style: TextStyle(color: Colors.grey[600], fontSize: 12),
                      textAlign: TextAlign.center,
                    )
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }
}