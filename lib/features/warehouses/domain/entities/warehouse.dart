/// A stock warehouse.
///
/// The pharmacy currently operates a single (main) warehouse, resolved
/// automatically from the backend. Only [id] and [name] are needed by the app
/// today; changing the main warehouse is a planned future capability.
class Warehouse {
  const Warehouse({required this.id, required this.name});

  final String id;
  final String name;
}
