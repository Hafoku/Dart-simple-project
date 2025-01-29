import 'package:equatable/equatable.dart';

class Task extends Equatable {
  final String title;
  final int icon;
  final String color;
  final List<dynamic>? todos;
  final DateTime? deadline;

  const Task(
      {required this.title,
      required this.icon,
      required this.color,
      this.todos,
      this.deadline});

  Task copyWith({
    String? title,
    int? icon,
    String? color,
    List<dynamic>? todos,
    DateTime? deadline,
  }) =>
      Task(
        title: title ?? this.title,
        icon: icon ?? this.icon,
        color: color ?? this.color,
        todos: todos ?? this.todos,
        deadline: deadline ?? this.deadline,
      );

  factory Task.fromJson(Map<String, dynamic> json) => Task(
        title: json['title'],
        icon: json['icon'],
        color: json['color'],
        todos: json['todos'],
        deadline: json['deadline'] != null 
            ? DateTime.parse(json['deadline']) 
            : null,
      );
  Map<String, dynamic> toJson() => {
        'title': title,
        'icon': icon,
        'color': color,
        'todos': todos,
        'deadline': deadline?.toIso8601String(),
      };

  @override
  List<Object?> get props => [title, icon, color, deadline];
}
