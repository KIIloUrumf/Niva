import 'package:flutter/material.dart';

class AdminScreen extends StatefulWidget {
  final Map<String, dynamic> userData;

  const AdminScreen({super.key, required this.userData});

  @override
  State<AdminScreen> createState() => _AdminScreenState();
}

class _AdminScreenState extends State<AdminScreen> {
  final List<Map<String, dynamic>> _allUsers = [
    {
      'id': '1',
      'name': 'Иван Иванов',
      'email': 'deputy@duma-ekb.ru',
      'role': 'deputy',
      'position': 'Депутат',
      'department': 'Комитет по бюджету',
      'permissions': ['events', 'documents', 'profile'],
      'active': true
    },
    {
      'id': '2',
      'name': 'Петр Петров',
      'email': 'staff@duma-ekb.ru',
      'role': 'staff',
      'position': 'Сотрудник аппарата',
      'department': 'Организационный отдел',
      'permissions': ['documents', 'profile'],
      'active': true
    },
    {
      'id': '3',
      'name': 'Сидорова Мария',
      'email': 'm.sidorova@duma-ekb.ru',
      'role': 'deputy',
      'position': 'Депутат',
      'department': 'Комитет по образованию',
      'permissions': ['events', 'documents', 'profile'],
      'active': true
    },
  ];

  final List<String> _availableRoles = ['admin', 'deputy', 'staff'];
  final List<String> _availablePermissions = [
    'events', 'documents', 'meetings', 'feedback', 'admin', 'all'
  ];

  void _editUserPermissions(int index) {
    final user = _allUsers[index];

    showDialog(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setDialogState) {
          return AlertDialog(
            title: Text('Редактирование: ${user['name']}'),
            content: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Выбор роли
                  _buildRoleSelector(user, setDialogState),
                  const SizedBox(height: 16),

                  // Выбор прав
                  _buildPermissionsSelector(user, setDialogState),
                ],
              ),
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('Отмена'),
              ),
              TextButton(
                onPressed: () {
                  _saveUserChanges(index, user);
                  Navigator.pop(context);
                },
                child: const Text('Сохранить'),
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _buildRoleSelector(Map<String, dynamic> user, StateSetter setDialogState) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('Роль:', style: TextStyle(fontWeight: FontWeight.bold)),
        const SizedBox(height: 8),
        Wrap(
          spacing: 8,
          children: _availableRoles.map((role) {
            final isSelected = user['role'] == role;
            return FilterChip(
              label: Text(_getRoleDisplayName(role)),
              selected: isSelected,
              onSelected: (selected) {
                setDialogState(() {
                  user['role'] = role;
                });
              },
            );
          }).toList(),
        ),
      ],
    );
  }

  Widget _buildPermissionsSelector(Map<String, dynamic> user, StateSetter setDialogState) {
    final permissions = List<String>.from(user['permissions'] ?? []);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('Права доступа:', style: TextStyle(fontWeight: FontWeight.bold)),
        const SizedBox(height: 8),
        Wrap(
          spacing: 8,
          runSpacing: 4,
          children: _availablePermissions.map((permission) {
            final isSelected = permissions.contains(permission);
            return FilterChip(
              label: Text(_getPermissionDisplayName(permission)),
              selected: isSelected,
              onSelected: (selected) {
                setDialogState(() {
                  if (selected) {
                    if (!permissions.contains(permission)) {
                      permissions.add(permission);
                    }
                  } else {
                    permissions.remove(permission);
                  }
                  user['permissions'] = permissions;
                });
              },
            );
          }).toList(),
        ),
      ],
    );
  }

  String _getRoleDisplayName(String role) {
    switch (role) {
      case 'admin': return 'Администратор';
      case 'deputy': return 'Депутат';
      case 'staff': return 'Сотрудник';
      default: return role;
    }
  }

  String _getPermissionDisplayName(String permission) {
    switch (permission) {
      case 'events': return 'Мероприятия';
      case 'documents': return 'Документы';
      case 'meetings': return 'Заседания';
      case 'feedback': return 'Обращения';
      case 'admin': return 'Администрирование';
      case 'all': return 'Все права';
      default: return permission;
    }
  }

  void _saveUserChanges(int index, Map<String, dynamic> updatedUser) {
    setState(() {
      _allUsers[index] = {..._allUsers[index], ...updatedUser};
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Права пользователя ${updatedUser['name']} обновлены')),
    );
  }

  void _toggleUserStatus(int index) {
    setState(() {
      _allUsers[index]['active'] = !_allUsers[index]['active'];
    });

    final status = _allUsers[index]['active'] ? 'активирован' : 'деактивирован';
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Пользователь ${_allUsers[index]['name']} $status')),
    );
  }

  void _showUserStats() {
    final activeUsers = _allUsers.where((user) => user['active'] == true).length;
    final deputies = _allUsers.where((user) => user['role'] == 'deputy').length;
    final staff = _allUsers.where((user) => user['role'] == 'staff').length;
    final admins = _allUsers.where((user) => user['role'] == 'admin').length;

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Статистика пользователей'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            _buildStatItem('Всего пользователей', _allUsers.length.toString()),
            _buildStatItem('Активных пользователей', activeUsers.toString()),
            _buildStatItem('Депутатов', deputies.toString()),
            _buildStatItem('Сотрудников', staff.toString()),
            _buildStatItem('Администраторов', admins.toString()),
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

  Widget _buildStatItem(String title, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(title),
          Text(value, style: const TextStyle(fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Администрирование'),
        backgroundColor: Colors.deepPurple,
        actions: [
          IconButton(
            icon: const Icon(Icons.analytics),
            onPressed: _showUserStats,
          ),
        ],
      ),
      body: Column(
        children: [
          // Статистика
          Card(
            margin: const EdgeInsets.all(16),
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  _buildAdminStat('Пользователи', _allUsers.length),
                  _buildAdminStat('Активные', _allUsers.where((u) => u['active'] == true).length),
                  _buildAdminStat('Депутаты', _allUsers.where((u) => u['role'] == 'deputy').length),
                ],
              ),
            ),
          ),

          // Список пользователей
          Expanded(
            child: ListView.builder(
              itemCount: _allUsers.length,
              itemBuilder: (context, index) {
                final user = _allUsers[index];
                return Card(
                  margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                  child: ListTile(
                    leading: CircleAvatar(
                      backgroundColor: user['active'] ? Colors.green : Colors.grey,
                      child: Text(
                        user['name'].toString().substring(0, 2),
                        style: const TextStyle(color: Colors.white),
                      ),
                    ),
                    title: Text(user['name']),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('${user['position']} • ${user['department']}'),
                        Text(user['email'], style: const TextStyle(fontSize: 12)),
                        const SizedBox(height: 4),
                        Wrap(
                          spacing: 4,
                          children: [
                            Chip(
                              label: Text(
                                _getRoleDisplayName(user['role']),
                                style: const TextStyle(fontSize: 10),
                              ),
                              backgroundColor: Colors.blue[50],
                            ),
                            if (user['permissions'] != null)
                              ...user['permissions'].map<Widget>((perm) => Chip(
                                label: Text(
                                  _getPermissionDisplayName(perm),
                                  style: const TextStyle(fontSize: 10),
                                ),
                                backgroundColor: Colors.green[50],
                              )).toList(),
                          ],
                        ),
                      ],
                    ),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        IconButton(
                          icon: const Icon(Icons.edit, size: 20),
                          onPressed: () => _editUserPermissions(index),
                        ),
                        IconButton(
                          icon: Icon(
                            user['active'] ? Icons.toggle_on : Icons.toggle_off,
                            color: user['active'] ? Colors.green : Colors.grey,
                            size: 30,
                          ),
                          onPressed: () => _toggleUserStatus(index),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAdminStat(String title, int count) {
    return Column(
      children: [
        Text(
          count.toString(),
          style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
        ),
        Text(title, style: const TextStyle(fontSize: 12, color: Colors.grey)),
      ],
    );
  }
}