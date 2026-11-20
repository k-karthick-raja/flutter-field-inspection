import 'package:equatable/equatable.dart';

enum ChecklistAnswer { unanswered, pass, fail, notApplicable }

/// A single question on an inspection checklist.
class ChecklistItem extends Equatable {
  const ChecklistItem({
    required this.id,
    required this.inspectionId,
    required this.label,
    this.isRequired = true,
    this.answer = ChecklistAnswer.unanswered,
    this.note,
  });

  final String id;
  final String inspectionId;
  final String label;
  final bool isRequired;
  final ChecklistAnswer answer;
  final String? note;

  bool get isAnswered => answer != ChecklistAnswer.unanswered;

  /// A failed item must carry a note explaining what was found.
  bool get needsNote =>
      answer == ChecklistAnswer.fail && (note == null || note!.trim().isEmpty);

  ChecklistItem copyWith({ChecklistAnswer? answer, String? note}) {
    return ChecklistItem(
      id: id,
      inspectionId: inspectionId,
      label: label,
      isRequired: isRequired,
      answer: answer ?? this.answer,
      note: note ?? this.note,
    );
  }

  @override
  List<Object?> get props =>
      [id, inspectionId, label, isRequired, answer, note];
}
