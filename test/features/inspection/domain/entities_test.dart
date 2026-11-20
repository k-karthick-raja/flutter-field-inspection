import 'package:field_inspection/features/inspection/domain/entities/checklist_item.dart';
import 'package:field_inspection/features/inspection/domain/entities/inspection.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('Inspection', () {
    final inspection = Inspection(
      id: 'insp-1',
      siteId: 'site-1',
      title: 'Fire safety',
      status: InspectionStatus.scheduled,
      scheduledFor: DateTime.utc(2026, 11, 25, 9),
    );

    test('is editable until it is completed', () {
      expect(inspection.isEditable, isTrue);
      expect(
        inspection.copyWith(status: InspectionStatus.inProgress).isEditable,
        isTrue,
      );
      expect(
        inspection.copyWith(status: InspectionStatus.completed).isEditable,
        isFalse,
      );
      expect(
        inspection.copyWith(status: InspectionStatus.synced).isEditable,
        isFalse,
      );
    });

    test('copyWith keeps identity fields and compares by value', () {
      final renamed = inspection.copyWith(title: 'Fire safety (Q4)');

      expect(renamed.id, inspection.id);
      expect(renamed.scheduledFor, inspection.scheduledFor);
      expect(renamed, isNot(inspection));
      expect(renamed.copyWith(title: 'Fire safety'), inspection);
    });
  });

  group('ChecklistItem', () {
    const item = ChecklistItem(
      id: 'item-1',
      inspectionId: 'insp-1',
      label: 'Extinguishers within service date',
    );

    test('starts unanswered', () {
      expect(item.isAnswered, isFalse);
      expect(item.copyWith(answer: ChecklistAnswer.pass).isAnswered, isTrue);
    });

    test('a failed answer needs a note', () {
      final failed = item.copyWith(answer: ChecklistAnswer.fail);

      expect(failed.needsNote, isTrue);
      expect(failed.copyWith(note: '   ').needsNote, isTrue);
      expect(failed.copyWith(note: 'Two units expired').needsNote, isFalse);
      expect(item.copyWith(answer: ChecklistAnswer.pass).needsNote, isFalse);
    });
  });
}
