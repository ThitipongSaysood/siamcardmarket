# Session — 2026-05-30 14:50

## Goal

แยก DB ออกเป็น 2 ตัว: `siamcard` (auth/identity) + `caed_zone` (business) เพื่อ separation of concerns

## What was done

### Phase A — Infrastructure

- สร้าง DB `siamcard` (utf8mb4)
- เพิ่ม connection `caed_zone` ใน [config/database.php](../../config/database.php) (ข้างๆ `mysql`)
- แก้ [.env](../../.env) + [.env.example](../../.env.example):
  - `DB_DATABASE=siamcard` (default = mysql connection → siamcard)
  - เพิ่ม `DB_CAED_*` block สำหรับ caed_zone connection

### Phase B — Migrations split

- สร้าง folder [`database/migrations/siamcard/`](../../database/migrations/siamcard/) — auto-loaded ผ่าน [AppServiceProvider](../../app/Providers/AppServiceProvider.php) `loadMigrationsFrom()`
  - `0001_01_01_000000_create_member_table.php` — table ชื่อ `member` (ไม่ใช่ `users`!) + password_reset_tokens
  - `2026_05_23_000001_create_wallets_addresses_table.php` — wallets, wallet_transactions, addresses · FK ref `member`
  - `2026_05_30_062756_create_personal_access_tokens_table.php` — Sanctum
- ย้าย caed_zone schemas migrations ไป [`database/migrations/caed_zone/`](../../database/migrations/caed_zone/) — **reference only, ไม่ auto-load** (caed_zone DB ใช้ [caed_zone.sql](../../database/caed_zone.sql) เป็น source of truth)
- ลบ `cache_table` + `jobs_table` migrations (ไม่ใช้ — SESSION/CACHE/QUEUE = file/sync)

### Phase C — Data migration

```sql
INSERT INTO siamcard.member SELECT * FROM caed_zone.users;
INSERT INTO siamcard.wallets SELECT * FROM caed_zone.wallets;
INSERT INTO siamcard.wallet_transactions SELECT * FROM caed_zone.wallet_transactions;

-- Drop FKs ที่ ref users + drop tables
ALTER TABLE caed_zone.bids DROP FOREIGN KEY fk_bid_user;
ALTER TABLE caed_zone.orders DROP FOREIGN KEY fk_order_user;
ALTER TABLE caed_zone.product_serials DROP FOREIGN KEY fk_serial_owner;
ALTER TABLE caed_zone.shops DROP FOREIGN KEY fk_shop_owner;
DROP TABLE caed_zone.wallet_transactions, caed_zone.wallets, caed_zone.users;
DROP TABLE caed_zone.personal_access_tokens, caed_zone.migrations;
```

ย้ายสำเร็จ — 2 users (panya@, john@) + 2 wallets + 0 transactions
caed_zone เหลือ 9 business tables: games, sets, shops, products, product_serials, orders, order_items, auctions, bids

### Phase D — Code

- [User.php](../../app/Models/User.php) — เพิ่ม `protected $table = 'member';`
- สร้าง [Address.php](../../app/Models/Address.php)
- แก้ validation `unique:users,email` → `unique:member,email` ใน:
  - [Auth\AuthController](../../app/Http/Controllers/Auth/AuthController.php)
  - [Api\AuthController](../../app/Http/Controllers/Api/AuthController.php)
- แก้ assertion `assertDatabaseHas('users', ...)` → `'member'` ใน test 2 ไฟล์

### Phase E — Tests

**25 tests · 97 assertions · ทุก test ผ่าน** (เหมือนเดิมก่อน split)

### Phase F — Docs

- [database.md](../../database.md) §0 rewrite — แยก siamcard / caed_zone + planned tables ที่จะอยู่แต่ละ DB
- [.agents/CONTEXT.md](../CONTEXT.md), [README.md](../../README.md), [workflow.md](../../workflow.md) — อัพเดต DB stack
- [.env.example](../../.env.example) — multi-DB config

## State at end

- ✅ App รันได้ http://127.0.0.1:8000/login (HTTP 200) + /login/line/redirect (302 → access.line.me)
- ✅ Test 25/25 passing
- ✅ siamcard: 2 users migrated · panya@example.com (admin/gold), john@example.com (member/silver) + wallets
- ✅ caed_zone: 9 business tables clean (no user FKs)

## Next step

1. (User) ตั้ง GOOGLE_CLIENT_ID/SECRET ใน .env เพื่อเปิด Google OAuth
2. **Phase 1 ต่อ:** สร้าง Eloquent Models สำหรับ caed_zone (Game, Set, Shop, Product, ProductSerial, Order, OrderItem, Auction, Bid) + เชื่อม PageController
   - Models ต้องใช้ `protected $connection = 'caed_zone';`
   - Cross-DB relationship User ↔ Order: Laravel relationship ใช้ได้ แต่ไม่มี FK constraint enforced — ใช้ `belongsTo(User::class)` ใน Order model

## Files touched

```
M  config/database.php                     ← เพิ่ม 'caed_zone' connection
M  .env, .env.example                       ← DB_DATABASE=siamcard + DB_CAED_*
A  database/migrations/siamcard/*.php (3)
A  database/migrations/caed_zone/*.php (5)  ← ย้าย (reference only)
M  database/migrations/2026_05_23_000002-6*  ← add $connection = 'caed_zone'
D  database/migrations/0001_01_01_000001-2  ← cache/jobs ไม่ใช้
M  app/Providers/AppServiceProvider.php    ← loadMigrationsFrom siamcard
M  app/Models/User.php                     ← $table = 'member'
A  app/Models/Address.php                  ← ใหม่
M  app/Http/Controllers/Auth/AuthController.php       ← unique:member,email
M  app/Http/Controllers/Api/AuthController.php        ← unique:member,email
M  tests/Feature/Api/AuthTest.php · WebAuthTest.php  ← assertDatabaseHas('member')
M  database.md · CONTEXT.md · README.md · workflow.md
```
