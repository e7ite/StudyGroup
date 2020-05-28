class Course {
  final String name;
  final String description;
  final String startTime;
  final String endTime;
  final String days;

  Course(
      {this.name, this.description, this.startTime, this.endTime, this.days});

  factory Course.fromMap(Map map) {
    return Course(
      name: map['name'] ?? '',
      description: map['description'] ?? '',
      startTime: map['startTime'] ?? '',
      endTime: map['endTime'] ?? '',
      days: map['days'] ?? '',
    );
  }
}
