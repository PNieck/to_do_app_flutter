class EventCategory {
  String id;

  String name;

  EventCategory({required this.name, this.id = ''}) {
    if (name.isEmpty) {
      throw ArgumentError("Event category cannot be empty");
    }
  }

  Map<String, Object> serialize() {
    return {
      "id": id,
      "name": name,
    };
  }

  EventCategory.deserialize(Map<String, dynamic> data)
      : id = data["id"],
        name = data["name"];
}
