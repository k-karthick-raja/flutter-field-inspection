import 'package:equatable/equatable.dart';

/// A physical location that gets inspected, e.g. a building or a plant.
class Site extends Equatable {
  const Site({
    required this.id,
    required this.name,
    required this.address,
  });

  final String id;
  final String name;
  final String address;

  @override
  List<Object?> get props => [id, name, address];
}
