import 'package:drift/drift.dart';

/// Shared timestamp columns applied to every table, mirroring the backend
/// `timestamps` object in `backend/src/db/schema.ts`:
///
/// ```ts
/// const timestamps = {
///   createdAt: timestamp("created_at").defaultNow().notNull(),
///   updatedAt: timestamp("updated_at").defaultNow().notNull().$onUpdate(...),
///   deletedAt: timestamp("deleted_at"), // null = active, set = soft-deleted
/// };
/// ```
///
/// Mix this into a [Table] with `class Foo extends Table with TableTimestamps`.
///
/// A client-side default (`clientDefault`) is used for [createdAt]/[updatedAt]
/// instead of a SQL default so the value is filled consistently on every
/// insert, including on databases upgraded via `ALTER TABLE ADD COLUMN`
/// (SQLite disallows non-constant SQL defaults when adding columns).
mixin TableTimestamps on Table {
  /// Row creation time. Defaults to now on insert.
  DateTimeColumn get createdAt =>
      dateTime().clientDefault(() => DateTime.now())();

  /// Last update time. Defaults to now; keep in sync on updates in app code.
  DateTimeColumn get updatedAt =>
      dateTime().clientDefault(() => DateTime.now())();

  /// Soft-delete marker. `null` = active, non-null = soft-deleted.
  DateTimeColumn get deletedAt => dateTime().nullable()();
}
