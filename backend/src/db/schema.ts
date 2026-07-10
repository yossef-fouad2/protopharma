import { pgTable, serial, text, doublePrecision, integer, date, boolean, timestamp } from "drizzle-orm/pg-core";

export const drugs = pgTable("drugs", {
  id: serial("id").primaryKey(),
  commercialNameEn: text("commercial_name_en").notNull(),
  commercialNameAr: text("commercial_name_ar").default("N/A").notNull(),
  scientificName: text("scientific_name").default("N/A").notNull(),
  manufacturer: text("manufacturer").default("N/A").notNull(),
  drugClass: text("drug_class").default("N/A").notNull(),
  route: text("route").default("N/A").notNull(),
  priceEgp: doublePrecision("price_egp").notNull(),
  isActive: boolean("is_active").default(true).notNull(), // Supports soft-deletion
});

export const inventory = pgTable("inventory", {
  id: serial("id").primaryKey(),
  drugId: integer("drug_id")
    .references(() => drugs.id)
    .notNull(),
  quantity: integer("quantity").notNull().default(0),
  batchNumber: text("batch_number").default("N/A").notNull(),
  expiryDate: date("expiry_date").notNull(),
  purchasePrice: doublePrecision("purchase_price").notNull(),
  sellingPrice: doublePrecision("selling_price").notNull(),
});

export const users = pgTable("users", {
  id: serial("id").primaryKey(),
  username: text("username").notNull().unique(), // e.g., 'sarah_p'
  pin: text("pin").notNull(), // A hashed 4-digit PIN for quick login on the counter terminal
  fullName: text("full_name").notNull(),
  role: text("role").default("pharmacist").notNull(), // 'admin', 'pharmacist', 'cashier'
  isActive: boolean("is_active").default(true).notNull(), // Owner can disable a worker if they quit
});

export const sales = pgTable("sales", {
  id: serial("id").primaryKey(),
  userId: integer("user_id")
    .references(() => users.id)
    .notNull(),
  totalAmount: doublePrecision("total_amount").notNull(),
  paymentMethod: text("payment_method").default("cash").notNull(), // e.g., 'cash', 'card', 'insurance'
  createdAt: timestamp("created_at").defaultNow().notNull(),
});

export const saleItems = pgTable("sale_items", {
  id: serial("id").primaryKey(),
  saleId: integer("sale_id")
    .references(() => sales.id)
    .notNull(),
  drugId: integer("drug_id")
    .references(() => drugs.id)
    .notNull(),
  quantity: integer("quantity").notNull(),
  priceAtSale: doublePrecision("price_at_sale").notNull(), // Capture selling price at moment of sale
});

// --- Exported TypeScript Types ---
export type Drug = typeof drugs.$inferSelect;
export type NewDrug = typeof drugs.$inferInsert;

export type InventoryItem = typeof inventory.$inferSelect;
export type NewInventoryItem = typeof inventory.$inferInsert;

export type User = typeof users.$inferSelect;
export type NewUser = typeof users.$inferInsert;

export type Sale = typeof sales.$inferSelect;
export type NewSale = typeof sales.$inferInsert;

export type SaleItem = typeof saleItems.$inferSelect;
export type NewSaleItem = typeof saleItems.$inferInsert;