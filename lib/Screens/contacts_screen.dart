import 'package:flutter/material.dart';

class ContactsScreen extends StatelessWidget {
  final Map<String, dynamic> userData;

  const ContactsScreen({super.key, required this.userData});

  final List<Map<String, dynamic>> _deputies = const [
    {
      'name': 'Иванов Иван Иванович',
      'position': 'Депутат',
      'department': 'Комитет по бюджету и налогам',
      'phone': '+7 (343) 111-11-11',
      'email': 'i.ivanov@duma-ekb.ru',
      'photo': 'ИИ',
    },
    {
      'name': 'Петров Петр Петрович',
      'position': 'Депутат',
      'department': 'Комитет по социальной политике',
      'phone': '+7 (343) 222-22-22',
      'email': 'p.petrov@duma-ekb.ru',
      'photo': 'ПП',
    },
    {
      'name': 'Сидорова Мария Ивановна',
      'position': 'Депутат',
      'department': 'Комитет по образованию',
      'phone': '+7 (343) 333-33-33',
      'email': 'm.sidorova@duma-ekb.ru',
      'photo': 'СМ',
    },
  ];

  final List<Map<String, dynamic>> _staff = const [
    {
      'name': 'Кузнецов Алексей Владимирович',
      'position': 'Секретарь',
      'department': 'Аппарат Думы',
      'phone': '+7 (343) 444-44-44',
      'email': 'a.kuznetsov@duma-ekb.ru',
      'photo': 'КА',
    },
    {
      'name': 'Николаева Елена Сергеевна',
      'position': 'Помощник депутата',
      'department': 'Организационный отдел',
      'phone': '+7 (343) 555-55-55',
      'email': 'e.nikolaeva@duma-ekb.ru',
      'photo': 'НЕ',
    },
    {
      'name': 'Волков Дмитрий Александрович',
      'position': 'Юрист',
      'department': 'Правовое управление',
      'phone': '+7 (343) 666-66-66',
      'email': 'd.volkov@duma-ekb.ru',
      'photo': 'ВД',
    },
  ];

  void _showContactDetails(BuildContext context, Map<String, dynamic> contact) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(contact['name']),
        content: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Center(
                child: CircleAvatar(
                  backgroundColor: Colors.blue[700],
                  radius: 30,
                  child: Text(
                    contact['photo'],
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 16),
              _buildContactDetail('Должность', contact['position']),
              _buildContactDetail('Отдел', contact['department']),
              _buildContactDetail('Телефон', contact['phone']),
              _buildContactDetail('Email', contact['email']),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Закрыть'),
          ),
          TextButton(
            onPressed: () {
              // Действие "Позвонить"
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('Звонок ${contact['phone']}')),
              );
              Navigator.pop(context);
            },
            child: const Text('Позвонить'),
          ),
        ],
      ),
    );
  }

  Widget _buildContactDetail(String title, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(fontSize: 12, color: Colors.grey),
          ),
          Text(
            value,
            style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Контакты'),
        backgroundColor: Colors.blue[700],
      ),
      body: DefaultTabController(
        length: 2,
        child: Column(
          children: [
            Container(
              color: Colors.blue[700],
              child: const TabBar(
                labelColor: Colors.white,
                unselectedLabelColor: Colors.white70,
                indicatorColor: Colors.white,
                tabs: [
                  Tab(text: 'Депутаты'),
                  Tab(text: 'Сотрудники'),
                ],
              ),
            ),
            Expanded(
              child: TabBarView(
                children: [
                  // Вкладка депутатов
                  ListView.builder(
                    itemCount: _deputies.length,
                    itemBuilder: (context, index) {
                      final deputy = _deputies[index];
                      return Card(
                        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                        child: ListTile(
                          leading: CircleAvatar(
                            backgroundColor: Colors.blue[700],
                            child: Text(
                              deputy['photo'],
                              style: const TextStyle(color: Colors.white),
                            ),
                          ),
                          title: Text(deputy['name']),
                          subtitle: Text(deputy['department']),
                          trailing: const Icon(Icons.phone, color: Colors.green),
                          onTap: () => _showContactDetails(context, deputy),
                        ),
                      );
                    },
                  ),

                  // Вкладка сотрудников
                  ListView.builder(
                    itemCount: _staff.length,
                    itemBuilder: (context, index) {
                      final staff = _staff[index];
                      return Card(
                        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                        child: ListTile(
                          leading: CircleAvatar(
                            backgroundColor: Colors.green[700],
                            child: Text(
                              staff['photo'],
                              style: const TextStyle(color: Colors.white),
                            ),
                          ),
                          title: Text(staff['name']),
                          subtitle: Text('${staff['position']} • ${staff['department']}'),
                          trailing: const Icon(Icons.phone, color: Colors.green),
                          onTap: () => _showContactDetails(context, staff),
                        ),
                      );
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}