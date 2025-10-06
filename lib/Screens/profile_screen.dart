import 'package:flutter/material.dart';

class ProfileScreen extends StatefulWidget {
  final Map<String, dynamic> userData;

  const ProfileScreen({super.key, required this.userData});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _departmentController = TextEditingController();

  @override
  void initState() {
    super.initState();
    // Заполняем данные пользователя
    _nameController.text = widget.userData['name'];
    _phoneController.text = widget.userData['phone'] ?? '+7 (343) 123-45-67';
    _departmentController.text = widget.userData['department'] ?? 'Комитет по бюджету';
  }

  void _saveProfile() {
    setState(() {
      widget.userData['name'] = _nameController.text;
      widget.userData['phone'] = _phoneController.text;
      widget.userData['department'] = _departmentController.text;
    });

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Профиль успешно сохранен')),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Мой профиль'),
        backgroundColor: Colors.blue[700],
        actions: [
          IconButton(
            icon: const Icon(Icons.save),
            onPressed: _saveProfile,
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            // Аватар и основная информация
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  children: [
                    CircleAvatar(
                      backgroundColor: Colors.blue[700],
                      radius: 40,
                      child: Text(
                        widget.userData['name'].toString().split(' ').map((n) => n[0]).join(),
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),
                    Text(
                      widget.userData['position'],
                      style: const TextStyle(
                        fontSize: 16,
                        color: Colors.grey,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Екатеринбургская городская Дума',
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.grey[600],
                      ),
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 20),

            // Форма редактирования
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Личная информация',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 16),

                    _buildInfoField('ФИО', _nameController),
                    const SizedBox(height: 12),

                    _buildInfoField('Телефон', _phoneController),
                    const SizedBox(height: 12),

                    _buildInfoField('Отдел/Комитет', _departmentController),
                    const SizedBox(height: 12),

                    _buildReadOnlyField('Email', widget.userData['email'] ?? 'deputy@duma-ekb.ru'),
                    const SizedBox(height: 12),

                    _buildReadOnlyField('Роль', widget.userData['role'] == 'deputy' ? 'Депутат' : 'Сотрудник аппарата'),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 20),

            // Статистика
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Статистика активности',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 16),

                    _buildStatItem('Обработано документов', '156'),
                    _buildStatItem('Участие в заседаниях', '89%'),
                    _buildStatItem('Обращения граждан', '45'),
                    _buildStatItem('Рабочих дней', '234'),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoField(String label, TextEditingController controller) {
    return TextField(
      controller: controller,
      decoration: InputDecoration(
        labelText: label,
        border: const OutlineInputBorder(),
        suffixIcon: Icon(Icons.edit, color: Colors.blue[700]),
      ),
    );
  }

  Widget _buildReadOnlyField(String label, String value) {
    return TextField(
      controller: TextEditingController(text: value),
      decoration: InputDecoration(
        labelText: label,
        border: const OutlineInputBorder(),
        enabled: false,
      ),
    );
  }

  Widget _buildStatItem(String title, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(title, style: const TextStyle(fontSize: 14)),
          Text(value, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }
}