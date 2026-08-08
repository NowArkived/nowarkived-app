import '../assets/models/asset.dart';

enum WarrantyReminderStatus { expiringSoon, expired }

class WarrantyReminder {
  const WarrantyReminder({
    required this.asset,
    required this.status,
    required this.daysRemaining,
  });

  final Asset asset;
  final WarrantyReminderStatus status;
  final int daysRemaining;

  String get message {
    if (status == WarrantyReminderStatus.expired) {
      final daysExpired = daysRemaining.abs();

      if (daysExpired == 0) {
        return 'Warranty expired today';
      }

      if (daysExpired == 1) {
        return 'Warranty expired 1 day ago';
      }

      return 'Warranty expired $daysExpired days ago';
    }

    if (daysRemaining == 0) {
      return 'Warranty expires today';
    }

    if (daysRemaining == 1) {
      return 'Warranty expires tomorrow';
    }

    return 'Warranty expires in $daysRemaining days';
  }
}

List<WarrantyReminder> buildWarrantyReminders(
  List<Asset> assets, {
  int reminderWindowDays = 30,
}) {
  final now = DateTime.now();

  final today = DateTime(now.year, now.month, now.day);

  final reminders = <WarrantyReminder>[];

  for (final asset in assets) {
    final warrantyExpiry = asset.warrantyExpiry;

    if (warrantyExpiry == null) {
      continue;
    }

    final expiryDate = DateTime(
      warrantyExpiry.year,
      warrantyExpiry.month,
      warrantyExpiry.day,
    );

    final daysRemaining = expiryDate.difference(today).inDays;

    if (daysRemaining < 0) {
      reminders.add(
        WarrantyReminder(
          asset: asset,
          status: WarrantyReminderStatus.expired,
          daysRemaining: daysRemaining,
        ),
      );

      continue;
    }

    if (daysRemaining <= reminderWindowDays) {
      reminders.add(
        WarrantyReminder(
          asset: asset,
          status: WarrantyReminderStatus.expiringSoon,
          daysRemaining: daysRemaining,
        ),
      );
    }
  }

  reminders.sort((a, b) => a.daysRemaining.compareTo(b.daysRemaining));

  return reminders;
}
