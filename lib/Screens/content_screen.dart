import 'package:flutter/material.dart';

class ContentScreen extends StatefulWidget {
  final String title;
  final Map<String, dynamic> userData;

  const ContentScreen({
    super.key,
    required this.title,
    required this.userData,
  });

  @override
  State<ContentScreen> createState() => _ContentScreenState();
}

class _ContentScreenState extends State<ContentScreen> {
  // Данные о подтверждении участия в мероприятиях
  final Map<String, String> _eventConfirmations = {};

  Map<String, dynamic> _getContentData() {
    switch (widget.title) {
      case 'Документы':
        return {
          'Последние документы': [
            'Протокол заседания №45 от 15.12.2024',
            'Бюджет города на 2024 год',
            'Отчет о работе комиссии по образованию',
            'План мероприятий на январь 2025',
            'Решение о благоустройстве парков'
          ],
          'Категории': ['Законы', 'Постановления', 'Отчеты', 'Планы']
        };
      case 'Мероприятия':
        return {
          'Текущие мероприятия': [
            {
              'title': 'Заседание комитета по бюджету',
              'date': '20.12.2024 10:00',
              'location': 'Зал заседаний №1',
              'id': 'event1'
            },
            {
              'title': 'Встреча с избирателями',
              'date': '21.12.2024 14:00',
              'location': 'Центральный округ',
              'id': 'event2'
            },
            {
              'title': 'Совещание по транспортной реформе',
              'date': '22.12.2024 11:30',
              'location': 'Кабинет 305',
              'id': 'event3'
            },
            {
              'title': 'Пленарное заседание',
              'date': '23.12.2024 09:00',
              'location': 'Большой зал заседаний',
              'id': 'event4'
            },
          ]
        };
      case 'Расписание':
        return {
          'Ближайшие мероприятия': [
            '10:00 - Заседание комитета по бюджету',
            '14:00 - Встреча с избирателями',
            '16:30 - Совещание по транспортной реформе',
            '09:00 - Прием граждан (еженедельно)',
            '11:00 - Работа с документами'
          ],
          'На этой неделе': ['Понедельник: 3 мероприятия', 'Вторник: 2 мероприятия', 'Среда: 4 мероприятия']
        };
      case 'Заседания':
        return {
          'Предстоящие заседания': [
            '20.12.2024 - Пленарное заседание',
            '25.12.2024 - Комиссия по ЖКХ',
            '28.12.2024 - Итоговое заседание года'
          ],
          'Архив': ['Ноябрь 2024: 5 заседаний', 'Октябрь 2024: 4 заседания']
        };
      case 'Обращения':
        return {
          'Новые обращения': [
            'Иванов А.П. - вопрос о ремонте дорог',
            'Петрова С.И. - проблема с вывозом мусора',
            'Сидоров В.М. - предложение по благоустройству'
          ],
          'Статусы': ['На рассмотрении: 12', 'Решено: 45', 'В работе: 8']
        };
      case 'Комиссии':
        return {
          'Ваши комиссии': [
            'Комиссия по бюджету и налогам',
            'Комиссия по социальной политике',
            'Комиссия по градостроительству'
          ],
          'Ближайшие заседания': ['Комиссия по бюджету - завтра', 'Социальная политика - через 3 дня']
        };
      case 'Профиль':
        return {
          'Личная информация': [
            'ФИО: ${widget.userData['name']}',
            'Должность: ${widget.userData['position']}',
            'Роль: ${widget.userData['role'] == 'deputy' ? 'Депутат' : 'Сотрудник'}',
            'Email: deputy@duma-ekb.ru',
            'Телефон: +7 (343) 123-45-67'
          ],
          'Статистика': ['Обработано документов: 156', 'Участие в заседаниях: 89%']
        };
      default:
        return {
          'Информация': [
            'Раздел "${widget.title}" в разработке',
            'Скоро здесь появится полезный контент',
            'Для связи: support@duma-ekb.ru'
          ]
        };
    }
  }

  void _confirmAttendance(String eventId, String status) {
    setState(() {
      _eventConfirmations[eventId] = status;
    });

    String statusText = status == 'yes' ? 'присутствую' : 'отсутствую';
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Вы подтвердили: $statusText')),
    );
  }

  Widget _buildEventCard(Map<String, dynamic> event) {
    final eventId = event['id']!;
    final currentStatus = _eventConfirmations[eventId];

    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              event['title'],
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                Icon(Icons.calendar_today, size: 16, color: Colors.grey[600]),
                const SizedBox(width: 4),
                Text(event['date'], style: TextStyle(color: Colors.grey[600])),
              ],
            ),
            const SizedBox(height: 4),
            Row(
              children: [
                Icon(Icons.location_on, size: 16, color: Colors.grey[600]),
                const SizedBox(width: 4),
                Text(event['location'], style: TextStyle(color: Colors.grey[600])),
              ],
            ),
            const SizedBox(height: 12),

            // Кнопки подтверждения участия
            if (currentStatus == null) ...[
              const Text('Подтвердите участие:', style: TextStyle(fontSize: 14)),
              const SizedBox(height: 8),
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton.icon(
                      onPressed: () => _confirmAttendance(eventId, 'yes'),
                      icon: const Icon(Icons.check, color: Colors.green),
                      label: const Text('Приду', style: TextStyle(color: Colors.green)),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: OutlinedButton.icon(
                      onPressed: () => _confirmAttendance(eventId, 'no'),
                      icon: const Icon(Icons.close, color: Colors.red),
                      label: const Text('Не приду', style: TextStyle(color: Colors.red)),
                    ),
                  ),
                ],
              ),
            ] else ...[
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: currentStatus == 'yes' ? Colors.green[50] : Colors.red[50],
                  border: Border.all(
                    color: currentStatus == 'yes' ? Colors.green : Colors.red,
                  ),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      currentStatus == 'yes' ? Icons.check : Icons.close,
                      color: currentStatus == 'yes' ? Colors.green : Colors.red,
                      size: 16,
                    ),
                    const SizedBox(width: 4),
                    Text(
                      currentStatus == 'yes' ? 'Вы присутствуете' : 'Вы отсутствуете',
                      style: TextStyle(
                        color: currentStatus == 'yes' ? Colors.green : Colors.red,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 8),
              OutlinedButton(
                onPressed: () => _confirmAttendance(eventId, ''),
                child: const Text('Изменить решение'),
              ),
            ],
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final contentData = _getContentData();

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
        backgroundColor: Colors.blue[700],
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: widget.title == 'Мероприятия'
          ? _buildEventsContent(contentData)
          : _buildDefaultContent(contentData),
    );
  }

  Widget _buildEventsContent(Map<String, dynamic> contentData) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Подтверждение участия в мероприятиях',
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Пожалуйста, подтвердите ваше участие в предстоящих мероприятиях',
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
          ...contentData.entries.map((entry) {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  entry.key,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 12),
                ...(entry.value as List).map((event) {
                  return _buildEventCard(event);
                }),
                const SizedBox(height: 20),
              ],
            );
          }),
        ],
      ),
    );
  }

  Widget _buildDefaultContent(Map<String, dynamic> contentData) {
    return ListView(
      children: [
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Добро пожаловать в раздел "${widget.title}"',
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Здесь вы можете управлять всеми данными, связанными с ${widget.title}',
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
              ...contentData.entries.map((entry) {
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      entry.key,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),
                    ...(entry.value as List).map((item) {
                      if (item is String) {
                        return Card(
                          margin: const EdgeInsets.symmetric(vertical: 4),
                          child: ListTile(
                            leading: const Icon(Icons.circle, size: 8),
                            title: Text(item),
                            onTap: () {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(content: Text('Выбрано: $item')),
                              );
                            },
                          ),
                        );
                      } else {
                        return Card(
                          margin: const EdgeInsets.symmetric(vertical: 4),
                          child: ListTile(
                            leading: const Icon(Icons.circle, size: 8),
                            title: Text(item['title']),
                            onTap: () {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(content: Text('Выбрано: ${item['title']}')),
                              );
                            },
                          ),
                        );
                      }
                    }),
                    const SizedBox(height: 20),
                  ],
                );
              }),
            ],
          ),
        ),
      ],
    );
  }
}