# Session — 2026-05-30 14:34

## Goal

ทำ REST API auth (Email/LINE/Google) + ใช้งานจริง + เคลียร์ไฟล์ที่ไม่ได้ใช้

## What was done

### Auth — REST API + Web (production-ready)

- ติดตั้ง `laravel/sanctum` + `laravel/socialite` + `socialiteproviders/line`
- สร้าง **[Api\AuthController](../../app/Http/Controllers/Api/AuthController.php)** — 7 endpoints (register/login/me/logout + social redirect/callback/token flow) คืน Sanctum Bearer token
- สร้าง **[Auth\AuthController](../../app/Http/Controllers/Auth/AuthController.php)** เวอร์ชัน web — session-based + เพิ่ม `redirectToProvider()` / `handleProviderCallback()` สำหรับ LINE/Google
- เพิ่ม **[UserResource](../../app/Http/Resources/UserResource.php)** + **[Wallet](../../app/Models/Wallet.php)**/[WalletTransaction](../../app/Models/WalletTransaction.php) models
- Auto-create wallet ตอน register/social login ผ่าน `ensureWallet()`
- เอา Facebook ออกหมด — provider enum เป็น `email/line/google`
- เพิ่ม [routes/api.php](../../routes/api.php) + web routes `/login/{provider}/redirect|callback`
- ปุ่ม login.blade.php → ใช้ `route('login.social.redirect', 'line'|'google')`
- ปุ่ม Facebook ลบ + เพิ่ม `.btn-google` style ใน [style.css](../../public/assets/css/style.css)

### Test suite — เขียน feature tests + ผ่านครบ

- [tests/Feature/Api/AuthTest.php](../../tests/Feature/Api/AuthTest.php) — 17 tests (REST API)
- [tests/Feature/Auth/WebAuthTest.php](../../tests/Feature/Auth/WebAuthTest.php) — 8 tests (Web session + OAuth)
- **25 tests · 97 assertions · ทุก test ผ่าน**

### Sanctum config quirks ที่เจอ + แก้

- `config/sanctum.php` → `'guard' => []` (ไม่ fallback web session, ใช้ pure Bearer)
- `bootstrap/app.php` → ไม่ใช้ `statefulApi()` + ไม่ prepend `EnsureFrontendRequestsAreStateful`
- ใน test ต้อง `$this->app['auth']->forgetGuards()` ระหว่าง 2 requests (RequestGuard cache user) เพื่อ assert logout จริง
- เพิ่ม `status, role, membership_tier` ใน `User.$fillable` — test ต้อง suspend account
- Register flow ต้อง `$user->refresh()` หลัง create เพื่อโหลด default values (bronze/member/active)

### Cleanup — ลบไฟล์ที่ไม่ได้ใช้

- ลบ static deploy infrastructure: `page/`, `app/Console/Commands/BuildStatic.php`, `.github/workflows/pages.yml`
- ลบ Vite/Tailwind toolchain: `package.json`, `vite.config.js`, `resources/css/`, `resources/js/`
- ลบ `resources/views/welcome.blade.php`, `.DS_Store`, `รูป/`, `database/database.sqlite`
- ลบ `database/factories/UserFactory.php` + `database/seeders/DatabaseSeeder.php`
- แก้ `app/Models/User.php` — เอา `HasFactory<UserFactory>` ออก

### DB switch — SQLite → MariaDB caed_zone

- `.env` เปลี่ยน `DB_CONNECTION=mysql`, `DB_DATABASE=caed_zone`, `APP_URL=http://127.0.0.1:8000`
- เปลี่ยน `SESSION_DRIVER=file`, `CACHE_STORE=file`, `QUEUE_CONNECTION=sync` (ไม่ใช้ database driver — เลี่ยง conflict กับ caed_zone schema)
- รัน `brew services start mysql` + `CREATE DATABASE caed_zone` + import `caed_zone.sql` (12 tables)
- Migrate เฉพาะ `personal_access_tokens` (Sanctum) — caed_zone schema ไม่มี

### Docs sync

- [database.md](../../database.md) เพิ่ม **§0 Implementation Status** — 11 tables มีจริง / 10 tables planned + schema drift (bids.locked_txn_id ขาด, sets.code VARCHAR(20), users.email nullable)
- [.agents/CONTEXT.md](../CONTEXT.md) ย้ายจาก root → `.agents/` (per user) + แก้ relative links ทั้งหมด
- [.agents/topics/skills-playbook.md](../topics/skills-playbook.md) — แผนใช้ 18 skills ที่ติดตั้ง
- [README.md](../../README.md), [design.md](../../design.md), [workflow.md](../../workflow.md), [AGENTS.md](../AGENTS.md) — ตัด references ของ Static Mockup Deploy + Facebook + Vite

## State at end

- ✅ App รันได้ที่ http://127.0.0.1:8000 — /login, /register, /products, /auctions, /live ทำงาน
- ✅ MariaDB caed_zone import แล้ว (panya@example.com gold/admin · john@example.com silver/member — password = NULL ใน dump)
- ✅ Test 25/25 passing
- ⚠️ **ยังไม่ได้ commit** — ต้องทำ session close-out

## Next step

1. **Setup OAuth credentials** (ผู้ใช้ทำเอง):
   - LINE Developer Console → สร้าง channel → callback `http://127.0.0.1:8000/login/line/callback` → ใส่ `.env`
   - Google Cloud Console → OAuth client → callback `http://127.0.0.1:8000/login/google/callback` → ใส่ `.env`
2. Set password ของ demo users ใน DB หรือ register ใหม่
3. **Phase 1 ต่อ:** เชื่อม PageController กับ Eloquent — สร้าง Models (Game, Set, Shop, Product, ProductSerial, Order, Auction, Bid) + ให้ /products, /auctions, /live ดึงข้อมูลจริงจาก caed_zone

## Files touched

```
A  .agents/CONTEXT.md
A  .agents/topics/skills-playbook.md
A  .agents/skills/  (18 skills installed via npx skills)
A  app/Http/Controllers/Api/AuthController.php
A  app/Http/Resources/UserResource.php
A  app/Models/Wallet.php · WalletTransaction.php
A  routes/api.php
A  tests/Feature/Api/AuthTest.php
A  tests/Feature/Auth/WebAuthTest.php
A  config/sanctum.php
A  database/caed_zone.sql
A  database/migrations/2026_05_30_062756_create_personal_access_tokens_table.php
A  skills-lock.json
M  app/Http/Controllers/Auth/AuthController.php
M  app/Models/User.php · app/Providers/AppServiceProvider.php
M  bootstrap/app.php · routes/web.php
M  config/services.php
M  composer.json · composer.lock
M  database.md · design.md · workflow.md · README.md
M  .agents/AGENTS.md
M  .env.example · .gitignore
M  database/migrations/0001_01_01_000000_create_users_table.php
M  resources/views/auth/login.blade.php
M  public/assets/css/style.css

D  .github/workflows/pages.yml
D  app/Console/Commands/BuildStatic.php
D  database/factories/UserFactory.php · database/seeders/DatabaseSeeder.php
D  resources/views/welcome.blade.php
D  resources/css/ · resources/js/
D  package.json · vite.config.js
D  tests/Feature/ExampleTest.php · tests/Unit/ExampleTest.php
```
