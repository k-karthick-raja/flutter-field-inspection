import 'package:equatable/equatable.dart';

enum InspectionStatus { scheduled, inProgress, completed, synced }

/// One visit by an inspector to a [Site].
class Inspection extends Equatable {
  const Inspection({
    required this.id,
    required this.siteId,
    required this.title,
    required this.status,
    required this.scheduledFor,
  });

  final String id;
  final String siteId;
  final String title;
  final InspectionStatus status;
  final DateTime scheduledFor;

  /// Completed or synced inspections are locked so the report stays stable.
  bool get isEditable =>
      status == InspectionStatus.scheduled ||
      status == InspectionStatus.inProgress;

  Inspection copyWith({String? title, InspectionStatus? status}) {
    return Inspection(
      id: id,
      siteId: siteId,
      title: title ?? this.title,
      status: status ?? this.status,
      scheduledFor: scheduledFor,
    );
  }

  @override
  List<Object?> get props => [id, siteId, title, status, scheduledFor];
}
