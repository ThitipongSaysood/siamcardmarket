# Active Task

_Last updated: 2026-05-30 (after split-db session)_

## Current goal

Phase 1 (Roadmap step 2) — สร้าง Eloquent Models สำหรับ caed_zone (catalog/orders/auctions)
+ เชื่อม PageController ให้ `/products`, `/auctions`, `/live` ดึงข้อมูลจริง

## What just happened

- 14:50 ปิด session split-db — แยก DB ออกเป็น 2 ตัว: `siamcard` (auth) + `caed_zone` (business)
  ดู [sessions/2026-05-30-1450-split-db-siamcard-caed_zone.md](sessions/2026-05-30-1450-split-db-siamcard-caed_zone.md)
- siamcard มี table `member` (แทน `users`), wallets, addresses, sanctum
- caed_zone เหลือเฉพาะ business: games, sets, shops, products, product_serials, orders, order_items, auctions, bids
- 25 tests ยังผ่านครบ

## Blockers

- **LINE credentials ตั้งแล้ว** (`LINE_CLIENT_ID=2010237557`) — เหลือ GOOGLE_CLIENT_ID ยังว่าง
- **Demo users password = NULL** — login ผ่าน email/password ของ panya@/john@ ไม่ได้จนกว่าจะ set ผ่าน tinker

## Next step

1. (User) ตั้ง GOOGLE_CLIENT_ID + SECRET ใน `.env` → test ปุ่ม Google
2. สร้าง Eloquent Models สำหรับ caed_zone (Game, Set, Shop, Product, ProductSerial, Order, OrderItem, Auction, Bid)
   - ทุก model ต้องใช้ `protected $connection = 'caed_zone';`
   - Cross-DB relationship: `Order::belongsTo(User::class)` ใช้ได้ แต่ไม่มี FK constraint enforced (cross-DB)
3. เชื่อม `PageController@products`, `productShow`, `auctions`, `auctionShow`, `live` กับ models
4. แก้ Blade views ให้รับ `$products`, `$auctions` collection จาก controller (ปัจจุบัน mockup hardcoded)

## Reminder

- ใช้ `/brainstorming` skill ก่อนเริ่ม feature ใหม่ (per `.agents/topics/skills-playbook.md`)
- ใช้ `/test-driven-development` — เขียน test ก่อน production code
- ใช้ `/verification-before-completion` — รัน `php artisan test` ก่อนบอกเสร็จ
- ถ้าจะ port models / queries ที่ใหญ่ ใช้ `/writing-plans` แล้ว `/subagent-driven-development`
