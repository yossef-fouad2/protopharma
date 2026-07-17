import 'package:drift/drift.dart';
import 'package:flutter/material.dart';
import 'package:protopharma/data/app_database.dart';

/// Seeds demo inventory batches for drugs that don't have any yet.
///
/// This is demo data: it deterministically assigns a spread of stock levels so
/// the inventory screen and dashboard alerts show a realistic mix of
/// out-of-stock, low-stock, and healthy items, plus a few expiring-soon lots.
///
/// It is safe to call on every launch — it only inserts rows for drugs that
/// currently have no inventory batch.
Future<void> seedInventory(AppDatabase db) async {
  // Count existing inventory rows; if we already have some, assume seeded.
  final existing = await db.inventoryTable.count().getSingle();
  if (existing > 0) {
    debugPrint('Inventory already seeded ($existing batches). Skipping.');
    return;
  }

  final drugs = await db.select(db.drugTable).get();
  if (drugs.isEmpty) {
    debugPrint('No drugs found — skipping inventory seeding for now.');
    return;
  }

  final now = DateTime.now();
  const chunkSize = 500;

  for (int i = 0; i < drugs.length; i += chunkSize) {
    final end = (i + chunkSize < drugs.length) ? i + chunkSize : drugs.length;
    final chunk = drugs.sublist(i, end);

    await db.batch((batch) {
      for (final drug in chunk) {
        // Deterministic pseudo-random spread based on the drug id.
        final seed = drug.id;
        final bucket = seed % 10; // 0..9

        // ~10% out of stock, ~20% low stock, ~70% healthy.
        final int quantity;
        if (bucket == 0) {
          quantity = 0; // out of stock
        } else if (bucket <= 2) {
          quantity = 1 + (seed % 9); // 1..9 -> low stock
        } else {
          quantity = 15 + (seed % 185); // 15..199 -> healthy
        }

        // A slice of items expire soon (within ~20 days) to drive alerts.
        final bool expiresSoon = bucket == 3;
        final expiry = expiresSoon
            ? now.add(Duration(days: 5 + (seed % 15))) // 5..19 days
            : now.add(Duration(days: 180 + (seed % 540))); // 6..24 months

        final sellingPrice = drug.priceEGP;
        final purchasePrice = drug.priceEGP * 0.7; // assume 30% margin

        batch.insert(
          db.inventoryTable,
          InventoryTableCompanion.insert(
            drugId: drug.id,
            quantity: Value(quantity),
            batchNumber: Value('B${drug.id.toString().padLeft(5, '0')}'),
            expiryDate: _fmtDate(expiry),
            purchasePrice: Value(purchasePrice),
            sellingPrice: Value(sellingPrice),
          ),
        );
      }
    });

    // Yield to keep the UI smooth during seeding.
    await Future.delayed(const Duration(milliseconds: 3));
  }

  final total = await db.inventoryTable.count().getSingle();
  debugPrint('Inventory seeding complete. Total batches: $total');
}

/// Formats a [DateTime] as an ISO-8601 date string (yyyy-MM-dd).
String _fmtDate(DateTime d) =>
    '${d.year.toString().padLeft(4, '0')}-'
    '${d.month.toString().padLeft(2, '0')}-'
    '${d.day.toString().padLeft(2, '0')}';
