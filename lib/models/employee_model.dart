
class Employee {
  final int? id;
  final String name;
  final String? photoPath;

  Employee({this.id, required this.name, this.photoPath});

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'photo_path': photoPath,
    };
  }

  factory Employee.fromMap(Map<String, dynamic> map) {
    return Employee(
      id: map['id'],
      name: map['name'],
      photoPath: map['photo_path'],
    );
  }
}
