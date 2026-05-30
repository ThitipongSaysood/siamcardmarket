# Active Task

_Last updated: 2026-05-30_

## Current goal

Phase 1 (Roadmap step 2) — เชื่อม PageController กับ Eloquent ให้ `/products`, `/auctions`, `/live`
ดึงข้อมูลจริงจาก `caed_zone` (แทน mockup)

## What just happened

- ปิด session 2026-05-30 1434 (ดู [sessions/2026-05-30-1434-auth-api-cleanup.md](sessions/2026-05-30-1434-auth-api-cleanup.md))
- REST API + Web Auth (Email/LINE/Google) ทำงานครบ + test 25/25 ผ่าน
- เคลียร์ไฟล์ unused + switch DB จาก SQLite → MariaDB `caed_zone` (import dump เรียบร้อย)

## Blockers

- **OAuth credentials ยังว่าง** ใน `.env` (LINE_CLIENT_ID, GOOGLE_CLIENT_ID, …) — ผู้ใช้ต้องไปสร้าง app ที่
  LINE Developer Console + Google Cloud Console เอง · button ทำงาน flow ทำงาน แต่ถึง provider จะ error
- **Demo users password = NULL** ใน caed_zone dump — login ผ่าน email/password ของ panya@/john@ ไม่ได้
  จนกว่าจะ set ผ่าน tinker หรือ register ใหม่

## Next step

1. (User) ตั้ง OAuth credentials → ใส่ `.env` → `php artisan config:clear` → test ปุ่ม LINE/Google
2. สร้าง Eloquent Models สำหรับตารางใน `caed_zone` (Game, Set, Shop, Product, ProductSerial, Order, OrderItem, Auction, Bid) + relationships
3. เชื่อม `PageController@products`, `productShow`, `auctions`, `auctionShow`, `live` กับ models
4. แก้ Blade views ให้รับ `$products`, `$auctions` collection จาก controller (ปัจจุบัน mockup hardcoded)

## Reminder

- ใช้ `/brainstorming` skill ก่อนเริ่ม feature ใหม่ (per `.agents/topics/skills-playbook.md`)
- ใช้ `/test-driven-development` — เขียน test ก่อน production code
- ใช้ `/verification-before-completion` — รัน `php artisan test` ก่อนบอกเสร็จ
- ถ้าจะ port models / queries ที่ใหญ่ ใช้ `/writing-plans` แล้ว `/subagent-driven-development`
