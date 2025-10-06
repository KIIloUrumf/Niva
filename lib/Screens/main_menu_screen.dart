import 'package:flutter/material.dart';
import 'auth_screen.dart';
import 'content_screen.dart';
import 'contacts_screen.dart';
import 'profile_screen.dart';
import 'settings_screen.dart';
import 'admin_screen.dart';

class MainMenuScreen extends StatefulWidget {
  final Map<String, dynamic> userData;

  const MainMenuScreen({super.key, required this.userData});

  @override
  State<MainMenuScreen> createState() => _MainMenuScreenState();
}

class _MainMenuScreenState extends State<MainMenuScreen> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  // Проверка прав доступа
  bool _hasPermission(String permission) {
    return widget.userData['permissions']?.contains('all') == true ||
        widget.userData['permissions']?.contains(permission) == true;
  }

  bool _isAdmin() {
    return widget.userData['role'] == 'admin';
  }

  void _navigateToContent(String title) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ContentScreen(
          title: title,
          userData: widget.userData,
        ),
      ),
    );
  }

  void _navigateToContacts() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ContactsScreen(userData: widget.userData),
      ),
    );
  }

  void _navigateToProfile() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ProfileScreen(userData: widget.userData),
      ),
    );
  }

  void _navigateToSettings() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => SettingsScreen(userData: widget.userData),
      ),
    );
  }

  void _navigateToAdmin() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => AdminScreen(userData: widget.userData),
      ),
    );
  }

  void _logout() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Выход'),
        content: const Text('Вы уверены, что хотите выйти?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Отмена'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => const AuthScreen()),
              );
            },
            child: const Text('Выйти', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Екатеринбургская городская Дума'),
            Text(
              '${widget.userData['name']} • ${widget.userData['position']}',
              style: const TextStyle(fontSize: 12),
            ),
          ],
        ),
        backgroundColor: Colors.blue[700],
        leading: IconButton(
          icon: const Icon(Icons.menu),
          onPressed: () {
            _scaffoldKey.currentState?.openDrawer();
          },
        ),
      ),
      drawer: _buildDrawer(),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: GridView.count(
          crossAxisCount: 2,
          crossAxisSpacing: 16,
          mainAxisSpacing: 16,
          childAspectRatio: 0.9,
          children: _buildMenuCards(),
        ),
      ),
    );
  }

  List<Widget> _buildMenuCards() {
    final cards = <Widget>[];

    if (_hasPermission('documents')) {
      cards.add(_buildMenuCard(
        title: 'Документы',
        icon: Icons.folder,
        description: 'Работа с внутренними документами',
        color: Colors.blue,
        onTap: () => _navigateToContent('Документы'),
      ));
    }

    if (_hasPermission('events')) {
      cards.add(_buildMenuCard(
        title: 'Мероприятия',
        icon: Icons.event,
        description: 'Подтверждение участия в мероприятиях',
        color: Colors.green,
        onTap: () => _navigateToContent('Мероприятия'),
      ));
    }

    if (_hasPermission('events')) {
      cards.add(_buildMenuCard(
        title: 'Расписание',
        icon: Icons.calendar_today,
        description: 'График заседаний и мероприятий',
        color: Colors.orange,
        onTap: () => _navigateToContent('Расписание'),
      ));
    }

    if (_hasPermission('meetings')) {
      cards.add(_buildMenuCard(
        title: 'Заседания',
        icon: Icons.groups,
        description: 'Архив и планирование заседаний',
        color: Colors.purple,
        onTap: () => _navigateToContent('Заседания'),
      ));
    }

    if (_hasPermission('feedback')) {
      cards.add(_buildMenuCard(
        title: 'Обращения',
        icon: Icons.feedback,
        description: 'Обращения граждан',
        color: Colors.red,
        onTap: () => _navigateToContent('Обращения'),
      ));
    }

    cards.add(_buildMenuCard(
      title: 'Контакты',
      icon: Icons.contacts,
      description: 'Профили депутатов и сотрудников',
      color: Colors.teal,
      onTap: _navigateToContacts,
    ));

    // Добавляем админ-панель для администраторов
    if (_isAdmin()) {
      cards.add(_buildMenuCard(
        title: 'Администрирование',
        icon: Icons.admin_panel_settings,
        description: 'Управление пользователями и ролями',
        color: Colors.deepPurple,
        onTap: _navigateToAdmin,
      ));
    }

    return cards;
  }

  Widget _buildDrawer() {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          DrawerHeader(
            decoration: BoxDecoration(
              color: Colors.blue[700],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CircleAvatar(
                  backgroundColor: Colors.white,
                  radius: 30,
                  child: Text(
                    _getUserInitials(widget.userData['name']),
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                      color: Colors.blue,
                    ),
                  ),
                ),
                const SizedBox(height: 10),
                Text(
                  widget.userData['name'],
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  widget.userData['position'],
                  style: const TextStyle(
                    color: Colors.white70,
                    fontSize: 14,
                  ),
                ),
                if (_isAdmin()) ...[
                  const SizedBox(height: 5),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                    decoration: BoxDecoration(
                      color: Colors.orange,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: const Text(
                      'АДМИНИСТРАТОР',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 10,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ],
            ),
          ),

          // Основные пункты меню
          _buildDrawerItem(
            icon: Icons.person,
            title: 'Мой профиль',
            onTap: _navigateToProfile,
          ),
          _buildDrawerItem(
            icon: Icons.contacts,
            title: 'Контакты',
            onTap: _navigateToContacts,
          ),
          _buildDrawerItem(
            icon: Icons.settings,
            title: 'Настройки',
            onTap: _navigateToSettings,
          ),

          // Админ-панель для администраторов
          if (_isAdmin()) ...[
            const Divider(),
            _buildDrawerItem(
              icon: Icons.admin_panel_settings,
              title: 'Администрирование',
              color: Colors.deepPurple,
              onTap: _navigateToAdmin,
            ),
          ],

          const Divider(),

          // Дополнительные пункты
          _buildDrawerItem(
            icon: Icons.help,
            title: 'Помощь',
            onTap: _showHelpDialog,
          ),
          _buildDrawerItem(
            icon: Icons.info,
            title: 'О приложении',
            onTap: _showAboutDialog,
          ),

          const Divider(),

          // Выход
          _buildDrawerItem(
            icon: Icons.exit_to_app,
            title: 'Выйти',
            color: Colors.red,
            onTap: _logout,
          ),
        ],
      ),
    );
  }

  Widget _buildDrawerItem({
    required IconData icon,
    required String title,
    required VoidCallback onTap,
    Color color = Colors.black87,
  }) {
    return ListTile(
      leading: Icon(icon, color: color),
      title: Text(title, style: TextStyle(color: color)),
      onTap: onTap,
    );
  }

  Widget _buildMenuCard({
    required String title,
    required IconData icon,
    required String description,
    required Color color,
    required VoidCallback onTap,
  }) {
    return Card(
      elevation: 4,
      child: InkWell(
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon, size: 40, color: color),
              const SizedBox(height: 8),
              Text(
                title,
                style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 4),
              Text(
                description,
                style: TextStyle(fontSize: 12, color: Colors.grey[600]),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }

  String _getUserInitials(String name) {
    final parts = name.split(' ');
    if (parts.length >= 2) {
      return '${parts[0][0]}${parts[1][0]}';
    }
    return name.length >= 2 ? name.substring(0, 2) : name;
  }

  void _showHelpDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Помощь'),
        content: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text(
                'Приложение "Кабинет депутата" предназначено для работы депутатов и сотрудников Екатеринбургской городской Думы.\n',
              ),
              const Text(
                'Основные функции:',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              _buildHelpItem('• Документы - работа с внутренними документами'),
              _buildHelpItem('• Мероприятия - подтверждение участия в мероприятиях'),
              _buildHelpItem('• Расписание - график заседаний и мероприятий'),
              _buildHelpItem('• Контакты - список депутатов и сотрудников'),
              _buildHelpItem('• Профиль - личная информация и настройки'),
              const SizedBox(height: 16),
              const Text(
                'Техническая поддержка:',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              const Text('support@duma-ekb.ru\n+7 (343) 123-45-67'),
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

  Widget _buildHelpItem(String text) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2.0),
      child: Text(text, style: const TextStyle(fontSize: 14)),
    );
  }

  void _showAboutDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('О приложении'),
        content: const Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Кабинет депутата v1.0',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 8),
            Text('Екатеринбургская городская Дума'),
            SizedBox(height: 8),
            Text('Приложение для депутатской деятельности'),
            SizedBox(height: 8),
            Text('© 2024 Все права защищены'),
          ],
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
}