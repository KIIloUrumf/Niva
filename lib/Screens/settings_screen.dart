import 'package:flutter/material.dart';

class SettingsScreen extends StatefulWidget {
  final Map<String, dynamic> userData;

  const SettingsScreen({super.key, required this.userData});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  bool _notificationsEnabled = true;
  bool _darkThemeEnabled = false;
  bool _backupEnabled = true;
  bool _biometricEnabled = false;

  final TextEditingController _currentPasswordController = TextEditingController();
  final TextEditingController _newPasswordController = TextEditingController();
  final TextEditingController _confirmPasswordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Настройки'),
        backgroundColor: Colors.blue[700],
      ),
      body: ListView(
        padding: const EdgeInsets.all(16.0),
        children: [
          // Уведомления
          _buildSettingsSection(
            title: 'Уведомления',
            children: [
              _buildSettingsSwitch(
                title: 'Push-уведомления',
                subtitle: 'Получать уведомления о событиях',
                value: _notificationsEnabled,
                onChanged: (value) {
                  setState(() {
                    _notificationsEnabled = value;
                  });
                  _showSnackbar('Уведомления ${value ? 'включены' : 'выключены'}');
                },
              ),
            ],
          ),

          const SizedBox(height: 20),

          // Внешний вид
          _buildSettingsSection(
            title: 'Внешний вид',
            children: [
              _buildSettingsSwitch(
                title: 'Темная тема',
                subtitle: 'Включить темный режим',
                value: _darkThemeEnabled,
                onChanged: (value) {
                  setState(() {
                    _darkThemeEnabled = value;
                  });
                  _showSnackbar('Темная тема ${value ? 'включена' : 'выключена'}');
                  // Здесь можно добавить логику смены темы
                },
              ),
            ],
          ),

          const SizedBox(height: 20),

          // Безопасность
          _buildSettingsSection(
            title: 'Безопасность',
            children: [
              _buildSettingsSwitch(
                title: 'Резервное копирование',
                subtitle: 'Автоматическое создание резервных копий',
                value: _backupEnabled,
                onChanged: (value) {
                  setState(() {
                    _backupEnabled = value;
                  });
                  _showSnackbar('Резервное копирование ${value ? 'включено' : 'выключено'}');
                },
              ),
              const SizedBox(height: 12),
              _buildSettingsSwitch(
                title: 'Биометрическая аутентификация',
                subtitle: 'Вход по отпечатку пальца или Face ID',
                value: _biometricEnabled,
                onChanged: (value) {
                  setState(() {
                    _biometricEnabled = value;
                  });
                  _showSnackbar('Биометрическая аутентификация ${value ? 'включена' : 'выключена'}');
                },
              ),
              const SizedBox(height: 12),
              _buildSettingsButton(
                title: 'Сменить пароль',
                subtitle: 'Изменить пароль учетной записи',
                onTap: _showChangePasswordDialog,
              ),
              const SizedBox(height: 12),
              _buildSettingsButton(
                title: 'История входов',
                subtitle: 'Просмотр истории входов в аккаунт',
                onTap: _showLoginHistory,
              ),
            ],
          ),

          const SizedBox(height: 20),

          // Конфиденциальность
          _buildSettingsSection(
            title: 'Конфиденциальность',
            children: [
              _buildSettingsButton(
                title: 'Экспорт данных',
                subtitle: 'Скачать все ваши данные',
                onTap: _exportData,
              ),
              const SizedBox(height: 12),
              _buildSettingsButton(
                title: 'Очистить кэш',
                subtitle: 'Удалить временные файлы',
                onTap: _clearCache,
              ),
            ],
          ),

          const SizedBox(height: 20),

          // О приложении
          _buildSettingsSection(
            title: 'О приложении',
            children: [
              _buildInfoItem('Версия', '1.0.0'),
              _buildInfoItem('Дата сборки', '15.12.2024'),
              _buildInfoItem('Разработчик', 'Екатеринбургская городская Дума'),
            ],
          ),

          const SizedBox(height: 30),

          // Кнопки действий
          _buildActionButton(
            text: 'Сбросить настройки',
            icon: Icons.restore,
            onTap: _resetSettings,
            color: Colors.red,
          ),
        ],
      ),
    );
  }

  Widget _buildSettingsSection({
    required String title,
    required List<Widget> children,
  }) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 12),
            ...children,
          ],
        ),
      ),
    );
  }

  Widget _buildSettingsSwitch({
    required String title,
    required String subtitle,
    required bool value,
    required ValueChanged<bool> onChanged,
  }) {
    return Row(
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(title, style: const TextStyle(fontSize: 16)),
              Text(subtitle, style: TextStyle(fontSize: 12, color: Colors.grey[600])),
            ],
          ),
        ),
        Switch(
          value: value,
          onChanged: onChanged,
          activeColor: Colors.blue[700],
        ),
      ],
    );
  }

  Widget _buildSettingsButton({
    required String title,
    required String subtitle,
    required VoidCallback onTap,
  }) {
    return ListTile(
      contentPadding: EdgeInsets.zero,
      leading: const Icon(Icons.arrow_forward_ios, size: 16, color: Colors.grey),
      title: Text(title, style: const TextStyle(fontSize: 16)),
      subtitle: Text(subtitle, style: TextStyle(fontSize: 12, color: Colors.grey[600])),
      onTap: onTap,
    );
  }

  Widget _buildInfoItem(String title, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(title, style: const TextStyle(fontSize: 14)),
          Text(value, style: const TextStyle(fontSize: 14, color: Colors.grey)),
        ],
      ),
    );
  }

  Widget _buildActionButton({
    required String text,
    required IconData icon,
    required VoidCallback onTap,
    Color color = Colors.blue,
  }) {
    return SizedBox(
      width: double.infinity,
      child: OutlinedButton.icon(
        onPressed: onTap,
        icon: Icon(icon, color: color),
        label: Text(text, style: TextStyle(color: color)),
        style: OutlinedButton.styleFrom(
          padding: const EdgeInsets.symmetric(vertical: 12),
          side: BorderSide(color: color),
        ),
      ),
    );
  }

  void _showSnackbar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        duration: const Duration(seconds: 2),
      ),
    );
  }

  void _showChangePasswordDialog() {
    showDialog(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setDialogState) {
          return AlertDialog(
            title: const Text('Смена пароля'),
            content: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextField(
                    controller: _currentPasswordController,
                    obscureText: true,
                    decoration: const InputDecoration(
                      labelText: 'Текущий пароль',
                      border: OutlineInputBorder(),
                    ),
                  ),
                  const SizedBox(height: 12),
                  TextField(
                    controller: _newPasswordController,
                    obscureText: true,
                    decoration: const InputDecoration(
                      labelText: 'Новый пароль',
                      border: OutlineInputBorder(),
                    ),
                  ),
                  const SizedBox(height: 12),
                  TextField(
                    controller: _confirmPasswordController,
                    obscureText: true,
                    decoration: const InputDecoration(
                      labelText: 'Подтвердите новый пароль',
                      border: OutlineInputBorder(),
                    ),
                  ),
                ],
              ),
            ),
            actions: [
              TextButton(
                onPressed: () {
                  _currentPasswordController.clear();
                  _newPasswordController.clear();
                  _confirmPasswordController.clear();
                  Navigator.pop(context);
                },
                child: const Text('Отмена'),
              ),
              ElevatedButton(
                onPressed: () => _changePassword(setDialogState),
                child: const Text('Сменить пароль'),
              ),
            ],
          );
        },
      ),
    );
  }

  void _changePassword(StateSetter setDialogState) {
    final currentPassword = _currentPasswordController.text;
    final newPassword = _newPasswordController.text;
    final confirmPassword = _confirmPasswordController.text;

    // Проверка текущего пароля
    if (currentPassword != widget.userData['password']) {
      _showSnackbar('Неверный текущий пароль');
      return;
    }

    // Проверка нового пароля
    if (newPassword.isEmpty) {
      _showSnackbar('Введите новый пароль');
      return;
    }

    if (newPassword.length < 6) {
      _showSnackbar('Пароль должен содержать минимум 6 символов');
      return;
    }

    if (newPassword != confirmPassword) {
      _showSnackbar('Пароли не совпадают');
      return;
    }

    // Обновление пароля
    setDialogState(() {
      widget.userData['password'] = newPassword;
    });

    // Очистка полей и закрытие диалога
    _currentPasswordController.clear();
    _newPasswordController.clear();
    _confirmPasswordController.clear();

    Navigator.pop(context);
    _showSnackbar('Пароль успешно изменен');
  }

  void _showLoginHistory() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('История входов'),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              _buildLoginHistoryItem('15.12.2024 10:30', 'Успешно', 'Android'),
              _buildLoginHistoryItem('14.12.2024 09:15', 'Успешно', 'Android'),
              _buildLoginHistoryItem('13.12.2024 14:20', 'Успешно', 'Web'),
              _buildLoginHistoryItem('12.12.2024 11:05', 'Успешно', 'Android'),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Закрыть'),
          ),
        ],
      ),
    );
  }

  Widget _buildLoginHistoryItem(String date, String status, String device) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 4),
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey[300]!),
        borderRadius: BorderRadius.circular(4),
      ),
      child: Row(
        children: [
          Icon(Icons.check_circle, color: Colors.green[700], size: 16),
          const SizedBox(width: 8),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(date, style: const TextStyle(fontSize: 12)),
                Text('$status • $device', style: TextStyle(fontSize: 10, color: Colors.grey[600])),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void _exportData() {
    _showSnackbar('Экспорт данных начат...');
    // Имитация экспорта
    Future.delayed(const Duration(seconds: 2), () {
      _showSnackbar('Данные успешно экспортированы');
    });
  }

  void _clearCache() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Очистка кэша'),
        content: const Text('Вы уверены, что хотите очистить кэш? Это освободит примерно 15.3 МБ.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Отмена'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              _showSnackbar('Кэш успешно очищен');
            },
            child: const Text('Очистить'),
          ),
        ],
      ),
    );
  }

  void _resetSettings() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Сброс настроек'),
        content: const Text('Все настройки будут сброшены к значениям по умолчанию. Продолжить?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Отмена'),
          ),
          TextButton(
            onPressed: () {
              setState(() {
                _notificationsEnabled = true;
                _darkThemeEnabled = false;
                _backupEnabled = true;
                _biometricEnabled = false;
              });
              Navigator.pop(context);
              _showSnackbar('Настройки сброшены к значениям по умолчанию');
            },
            child: const Text('Сбросить'),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _currentPasswordController.dispose();
    _newPasswordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }
}