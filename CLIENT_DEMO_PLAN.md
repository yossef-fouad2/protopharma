# ProtoPharma — Client Demo Plan & Frontend Evaluation

> Purpose: Prepare for the client meeting where we present the pharmacy management prototype.
> This document covers (1) what will attract the client, (2) how to run the demo, and
> (3) a concrete action plan for what to build next.

---

## Part 1 — What Will Attract Your Client (In Detail)

The client is (most likely) a pharmacy owner or manager. They care about three things:
**saving time, avoiding costly mistakes, and looking modern/professional to their own customers.**
Everything below is framed around those motivations.

### 1. Professional, Medical-Grade Visual Design
This builds instant trust. A pharmacy is a health business — the software has to *feel* safe and clinical.

- **Calming teal + indigo brand palette** (`primaryTeal #0D9488`, `secondaryIndigo #6366F1`). Teal reads as clean, medical, and trustworthy — not loud or playful.
- **Premium typography** using Google Fonts (Inter for body, Public Sans for big numbers). This is the same font style used by modern SaaS products, so it looks expensive and current, not like a default app.
- **Consistent card system** — soft shadows, rounded corners, generous spacing. Nothing feels cramped or amateur.
- **Semantic color coding** — green = good/completed, red = critical, amber = warning. The pharmacist can read a screen at a glance without reading every word.

**What to say to the client:** *"The look and feel is designed to match the professionalism your patients already expect from you."*

### 2. The Dashboard "Overview" — Your Opening Statement
This is the first screen and the one that sells the "control center" idea.

- **Three headline metric cards:** Today's Sales, Total Orders, Active Prescriptions.
- **Business-intelligence signals:** the sales card shows *"+12.5% vs yesterday"* with a green up-arrow. This tells the owner the software is watching their business for them.
- **One accented dark card** (Active Prescriptions) deliberately stands out to pull attention to the item that needs action.
- **Animated Today / Week / Month toggle** — smooth 300ms transition. A small detail that signals overall polish.

**What to say:** *"The moment you open the app in the morning, you know exactly how the business is doing and what needs your attention."*

### 3. Critical Alerts Panel — The Emotional Hook
This is the single most persuasive feature. It proves we understand pharmacy operations, not just generic software.

- **Low stock alert** — "Only 2 pens of Ozempic remaining, below safety threshold of 5."
- **Expiring medication alert** — "EpiPen lot expires in 14 days (Qty: 4)."
- **Drug interaction alert** — "Warfarin + Amiodarone — pharmacist intervention required."

Each of these maps to real money and real safety:
- Running out of a fast-moving drug = lost sales and unhappy patients.
- Expired stock = wasted money and legal/health risk.
- Missed drug interactions = patient harm and liability.

**What to say:** *"This is the part that protects you — it catches the expensive mistakes before they happen."*

### 4. Recent Activity Feed — "It Feels Alive"
A live-looking table of the latest operations with color-coded status pills:
Completed, Pending, Insurance Hold, Processed. Includes patient names and RX reference codes.

**What to say:** *"You can see everything happening across the counter in real time, even when you step away."*

### 5. Real, Working Inventory — The Credibility Proof
This is what separates us from a slideshow. It is **not a mockup** — it runs on a real local database.

- Backed by a real **Drift/SQLite database**, seeded with **real Egyptian drug data** (prices in EGP).
- **Live search** with debounce — type a drug name and results filter instantly.
- **Category filtering** via dropdown.
- **Pagination** for large data sets.
- **Bilingual** — shows both English and Arabic commercial names (critical for the Egyptian market).

**What to say:** *"This part is already functional with real Egyptian medication data — search it live right now."* (Then actually type in the search box during the demo.)

### 6. Responsive Layout + Dark Mode — The Easy Crowd-Pleasers
- Layout **adapts to screen size**: cards stack, tables and panels reflow on narrow screens. Great for tablets at the counter.
- **Full dark mode** that follows the device theme automatically.

**What to do:** Resize the window live, then toggle your OS dark mode mid-demo. It always gets a reaction.

---

## Part 2 — Recommended Demo Flow (5–7 minutes)

1. **Open on the Dashboard.** Let the metrics and alerts speak first. Pause on the numbers.
2. **Point to a Critical Alert.** Tell the real-world story it prevents (expired EpiPen, drug interaction). This is your emotional peak.
3. **Open Inventory.** Type a drug name in the search box to show live filtering. Use the category dropdown. Flip a page. Highlight the Arabic names and EGP prices.
4. **Resize the window** to show responsiveness (counter tablet use case).
5. **Toggle dark mode** to close on a polished note.

**Golden rule:** Demo only the Dashboard and Inventory in depth. Avoid clicking into unfinished areas unless you frame them as "coming next."

---

## Part 3 — Be Honest About These Gaps (Prototype Status)

Being upfront builds trust. Frame everything below as **"the next build phase."**

| Area | Current State |
|------|--------------|
| Orders tab | Empty placeholder ("Orders Screen" text) |
| Checkout tab | Empty placeholder ("Checkout Screen" text) |
| Dashboard numbers | Hardcoded demo data, not live |
| Critical Alerts | Hardcoded demo data, not connected to inventory |
| Action buttons (Review, Reorder, Override, View All) | Only print debug logs, no action yet |
| Authentication | No login / user roles yet |
| Inventory editing | Read-only — no add/edit/delete of medications |

**What to say:** *"The foundation is proven — the Inventory screen already runs on real data. The next phase connects the dashboard and adds the workflows on top of that same foundation."*

---

## Part 4 — Action Plan: What To Build Next

Prioritized by impact-per-effort. Phase 1 items are the pre-meeting quick wins.

### Phase 0 — Quick Wins Before the Meeting (a few hours)
- [ ] Wire the **"Review"** and **"View All"** buttons to navigate to the Inventory tab so nothing feels dead when clicked.
- [ ] Add the **ProtoPharma logo / app name** to the empty 160px space at the top of the side navigation (it currently looks unfinished).
- [ ] Double-check the app **launches cleanly** on the demo machine (run `flutter run -d windows` or your target device beforehand).
- [ ] Prepare the demo window at a **good size** and know the shortcut to toggle OS dark mode.

### Phase 1 — Make the Prototype Feel Complete (1–2 weeks)
- [ ] **Inventory CRUD** — add, edit, and delete medications (this is the most requested real feature; it makes Inventory fully usable).
- [ ] **Connect Dashboard to real data** — compute Today's Sales, Total Orders, and Active Prescriptions from the database instead of hardcoded values.
- [ ] **Connect Critical Alerts to real inventory** — generate low-stock and expiry alerts dynamically from actual stock levels and expiry dates.
- [ ] **Stock level + expiry fields** — add these columns to the drug model/table if not already present, since alerts depend on them.

### Phase 2 — Core Pharmacy Workflows (2–4 weeks)
- [ ] **Orders module** — create purchase orders to suppliers, track order status, receive stock into inventory.
- [ ] **Checkout / Point of Sale** — build the sell/dispense flow: add items to a cart, apply price, complete a sale, decrement stock.
- [ ] **Prescription handling** — link a sale to a prescription and patient reference (matches the "Active Prescriptions" and "Recent Activity" concepts already shown).

### Phase 3 — Accounts, Roles & Trust (1–2 weeks)
- [ ] **Authentication** — login screen with secure credential handling.
- [ ] **User roles** — pharmacist vs. cashier vs. owner, with appropriate permissions (e.g., only pharmacists can override interaction alerts).
- [ ] **Audit log** — record who dispensed / edited / overrode what and when (important for pharmacy compliance).

### Phase 4 — Backend Integration & Sync (ongoing)
- [ ] Connect the existing **backend** (already in the repo) to the app for multi-device sync and cloud backup.
- [ ] **Firebase/Firestore sync** is already partially wired — finish syncing inventory and sales across devices.
- [ ] **Reporting & exports** — sales reports, inventory valuation, expiry reports (PDF/CSV export).

### Phase 5 — Polish & Delight (ongoing)
- [ ] Empty-state and loading skeletons for every screen.
- [ ] Confirmation dialogs and undo for destructive actions (delete medication, void sale).
- [ ] Full accessibility pass (contrast, screen-reader labels, keyboard navigation).
- [ ] Localization polish — full Arabic UI, not just drug names.

---

## Part 5 — One-Line Pitch to Close With

> *"ProtoPharma gives you a single control center for your pharmacy — it watches your stock,
> catches expensive mistakes before they happen, and already runs on real Egyptian medication data.
> What you're seeing is the proven foundation; the next phase turns it into your day-to-day operating system."*

Good question — let me lay out the full picture based on what I found in your code, then answer "where."

## What you already have

Interesting discovery: your **backend already has a proper `inventory` table** (`backend/src/db/schema.ts`), separate from `drugs`:

```
inventory: drugId → drugs.id, quantity, batchNumber, expiryDate, purchasePrice, sellingPrice
```

But your **Flutter local DB (Drift) only has `DrugTable`** — no stock, no quantity, no expiry. The `drugs` are loaded from Firestore into the local Drift DB, and the inventory screen just lists them read-only. So the frontend is missing the inventory concept entirely right now.

## Your options for adding stock/inventory locally

**Option A — Add a `quantity`/`stock` column directly to `DrugTable`** (simplest)
- One drug row = one stock number. Easy, fast to build.
- ❌ Can't track batches or expiry dates per lot — and your demo plan's headline feature ("EpiPen lot expires in 14 days", "batch number") depends on that. This paints you into a corner later.

**Option B — Add a separate `InventoryTable` in Drift that mirrors the backend** (recommended)
- Matches the backend schema you already designed: `drugId`, `quantity`, `batchNumber`, `expiryDate`, `purchasePrice`, `sellingPrice`.
- One drug can have multiple inventory batches (real pharmacies work this way).
- Enables the low-stock AND expiry alerts your demo plan promises, and syncs cleanly with the backend later.
- ✅ A drug's total stock = SUM of its inventory rows. "In stock" = has at least one batch with quantity > 0.

**Option C — Hybrid:** Option B for storage, but keep a computed/cached `totalStock` for fast filtering. Only worth it if you hit performance issues (you won't at this data size).

## Now — "where?" (where inventory / stock shows up in the UI)

I'd surface stock in **three places**:

1. **Inventory screen (your existing `inventory_screen.dart`)** — this becomes the real home of stock. Add a stock badge/column per drug row (e.g. green "In stock: 42", amber "Low: 3", red "Out of stock"). Add a filter toggle "Show only in-stock" or "Show low stock". This directly answers your "show it elsewhere the stock isn't 0" idea — it's a filter/sort on this screen.

2. **Dashboard Critical Alerts panel** — auto-generate the low-stock and expiring-soon alerts from the inventory rows (the demo plan's Phase 1 item). This is the emotional selling point.

3. **Checkout/POS later** — selling decrements the batch quantity.

## My recommendation
Go with **Option B**. Concretely:
1. Create `InventoryTable` in Drift (mirror the backend fields).
2. Bump Drift `schemaVersion` to 2 + a migration.
3. Seed stock values (either random-for-demo, or a real quantity field synced from Firestore).
4. Add repository methods: `getStockForDrug`, `getLowStockDrugs`, `getExpiringSoon`, and a joined query so inventory rows show stock.
5. Update the inventory screen with a stock badge + "in stock only" filter.
6. (Optional) wire dashboard Critical Alerts to real low-stock/expiry data.

Want me to detail the exact code changes (the Drift table, migration, repository queries, and UI badge) as a step-by-step plan? And two quick decisions from you:
- **Batches (Option B) or single stock number (Option A)?**
- **For the demo, seed random stock, or do you have real quantity data?**

Once you confirm, toggle to Act mode and I'll implement it.