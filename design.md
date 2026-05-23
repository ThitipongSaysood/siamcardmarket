# Design System — CARD ZONE (The Ultimate TCG Marketplace)

เอกสารนี้กำหนดแนวทาง UI/UX ของเว็บไซต์ขายซองการ์ด + เปิด Live + ประมูลการ์ด
อ้างอิงดีไซน์จากภาพตัวอย่าง NFT Marketplace (โทนมืด ม่วง-น้ำเงิน) ผสมกับ
เอกลักษณ์ TCG (สีทอง/โฮโลแกรม) จาก PDF "The Ultimate TCG Ecosystem".

---

## 1. Design Direction

| หลักการ | รายละเอียด |
|---------|-----------|
| **Mood** | Cinematic dark navy, premium, futuristic — อ้างอิงภาพ TCG ตั้งต้น |
| **Inspiration** | แดชบอร์ด TCG จอ navy เข้ม + แสงโค้งสีฟ้า-ขาว + ปุ่มทอง |
| **Accent** | ทอง/โฮโลแกรม (การ์ดหายาก) + ฟ้า-cyan (แสง, CTA รอง) |
| **Style** | Glassmorphism — frosted glass, ขอบเรืองแสง, gloss highlight |
| **Layout** | Mobile-first, 100% responsive, การ์ดเป็น grid |
| **Personality** | เชื่อถือได้ (Trust) · สะดวก (Convenience) · ผูกพัน (Engagement) |

---

## 2. Color Tokens

กำหนดเป็น CSS Custom Properties ใน `assets/css/style.css` (`:root`)

### Background — deep cinematic navy
| Token | HEX | การใช้งาน |
|-------|-----|-----------|
| `--bg-900` | `#060912` | พื้นหลังหลักของหน้า |
| `--bg-800` | `#0B111F` | section รอง / drawer / footer |
| `--bg-700` | `#111A2D` | พื้นฐานการ์ด |
| `--bg-600` | `#1A2438` | input / panel ทึบ |

### Brand / Accent — steel-blue + gold
| Token | HEX | การใช้งาน |
|-------|-----|-----------|
| `--primary` | `#4F74E8` | น้ำเงินเหล็กหลัก — ปุ่ม, ลิงก์ |
| `--primary-bright` | `#7FA0FF` | น้ำเงินสว่าง — hover, eyebrow |
| `--secondary` | `#3FC6E8` | cyan — แสง, accent รอง |
| `--gold` | `#E9CC86` | ทอง — ราคา, CTA หลัก (ปุ่ม Bidding), tier |
| `--grad-gold` | `linear-gradient(120deg,#F4E0A6,#E9CC86,#C9A861)` | ปุ่มทองหลัก |
| `--holo` | `linear-gradient(135deg,#E9CC86,#7FA0FF,#3FC6E8)` | โฮโล — heading + การ์ด Rare |

### Glass tokens
| Token | ค่า |
|-------|-----|
| `--glass-bg` | `rgba(120,160,220,.06)` — กระจกฟ้าจาง |
| `--glass-border` | `rgba(150,185,235,.16)` |
| `--glass-blur` | `blur(18px) saturate(150%)` |

### State
| Token | HEX | การใช้งาน |
|-------|-----|-----------|
| `--success` | `#34D399` | สำเร็จ / Available |
| `--warning` | `#FBBF24` | รอดำเนินการ |
| `--danger` | `#F87171` | ผิดพลาด / Sold |
| `--live` | `#FF4D6D` | จุดสถานะ Live |

### Text
| Token | HEX |
|-------|-----|
| `--text-100` | `#F4F3FF` (หัวข้อ) |
| `--text-300` | `#B8B5D8` (เนื้อความ) |
| `--text-500` | `#6E6B92` (รอง / caption) |
| `--border` | `rgba(255,255,255,.08)` |

---

## 3. Typography

- **Font**: `Noto Sans Thai` (เนื้อหาไทย) + `Sora` / `Inter` (อังกฤษ + ตัวเลข) — โหลดผ่าน Google Fonts
- ภาษาไทย+อังกฤษผสมในหน้าเดียวกัน (heading อังกฤษ, เนื้อหาไทย)

| Scale | ขนาด (desktop) | ขนาด (mobile) | น้ำหนัก |
|-------|-----|-----|-----|
| `h1` / hero | 48px | 30px | 800 |
| `h2` / section | 32px | 24px | 700 |
| `h3` / card title | 20px | 18px | 600 |
| `body` | 16px | 15px | 400 |
| `caption` | 13px | 12px | 400 |
| ราคา (price) | 22px | 18px | 700 / `--gold` |

---

## 4. Spacing & Radius

- **Spacing scale**: 4 / 8 / 12 / 16 / 24 / 32 / 48 / 64 px
- **Radius**: `--r-sm` 8px · `--r-md` 14px · `--r-lg` 20px · `--r-pill` 999px
- **Container**: max-width `1240px`, padding ข้าง 16px (mobile) / 24px (desktop)

---

## 5. Responsive Breakpoints

| ชื่อ | ขนาด | คอลัมน์ grid การ์ด |
|------|------|------|
| Mobile | `< 640px` | 2 |
| Tablet | `640–1024px` | 3 |
| Desktop | `> 1024px` | 4–5 |

- Navbar: desktop เป็นแถบเต็ม, mobile เป็น hamburger + drawer
- Bottom Tab Bar แสดงเฉพาะ mobile (Home / Auction / Live / Collection / Profile)

---

## 6. Components

### Card (สินค้า / การ์ด)
- พื้น `--bg-700`, radius `--r-md`, border `--border`
- `.card-img` aspect 4:5, `overflow:hidden` — รูปการ์ดจริงวางด้วย `<img>`
  (`position:absolute; inset:0; object-fit:cover`) badge มุมซ้อนบน (`z-index:2`)
- ใต้รูป: ชื่อการ์ด + ราคา ทอง + ปุ่ม
- hover: ยกขึ้น `translateY(-4px)` + เงาม่วง glow

### Button
| ชนิด | สไตล์ |
|------|------|
| `.btn-primary` | gradient ม่วง→น้ำเงิน, ตัวอักษรขาว |
| `.btn-gold` | gradient ทอง, ตัวอักษรเข้ม — ใช้กับ "ซื้อเลย/ประมูล" |
| `.btn-ghost` | โปร่ง, border ม่วง |
| `.btn-line` | เขียว LINE `#06C755` |

### Badge / Pill
- `Live` (แดงเต้น), `Rare/SR/SAR` (ทอง), สถานะ order (success/warning)

### Glass Panel
- `background: rgba(255,255,255,.04)` + `backdrop-filter: blur(12px)` + border บาง

### Status Tracker (stepper)
- **แนวตั้ง** (`.tracker`) — ใช้ในหน้า Tracking, PSA · วงกลมไอคอน + เส้นเชื่อมแนวดิ่ง
- **แนวนอน** (`.htrack`) — ใช้แสดง Serial lifecycle · 4 ขั้นเรียงเต็มความกว้าง
  (`flex:1`, ไม่มี scroll), เส้นเชื่อมระหว่างวงกลม — ขั้นที่ผ่านแล้วเป็นสีน้ำเงิน,
  ขั้นปัจจุบันขอบทอง + glow
- สถานะ: Available → Reserved → Sold → Queue Live → Opened → Delivered

---

## 7. รายการหน้า (14 หน้า Front-end)

| # | ไฟล์ | หน้า |
|---|------|------|
| 1 | `index.html` | Home — Live banner, หมวดเกม, Booster ล่าสุด, Auction Hot |
| 2 | `login.html` | Login — LINE / Facebook / Email |
| 3 | `products.html` | แสดงสินค้า (Booster Pack) + filter |
| 4 | `product-detail.html` | รายละเอียดสินค้า + Serial example |
| 5 | `cart.html` | ตะกร้าสินค้า |
| 6 | `checkout.html` | ชำระเงิน — PromptPay QR / Wallet |
| 7 | `live-queue.html` | Live Opening Queue |
| 8 | `auction-list.html` | รายการประมูล |
| 9 | `auction-detail.html` | รายละเอียดประมูล + bid history |
| 10 | `profile.html` | โปรไฟล์ / เมนูสมาชิก + Wallet + Tier |
| 11 | `my-orders.html` | คำสั่งซื้อของฉัน |
| 12 | `my-collection.html` | คลังการ์ดของฉัน (Portfolio) |
| 13 | `psa-submission.html` | ส่งการ์ดเกรด PSA |
| 14 | `tracking.html` | ติดตามพัสดุ |

---

## 8. โครงสร้างไฟล์

```
TCG/
├── design.md
├── database.md
├── index.html ... tracking.html      (14 หน้า)
└── assets/
    ├── css/style.css                 (design tokens + components)
    ├── js/main.js                    (navbar, drawer, tabs, mock data)
    └── images/                       (รูปการ์ดจริง — One Piece / Pokémon)
```

## 9. Iconography & Imagery
- ไอคอน: inline SVG (เบา ปรับสีตาม token ได้)
- รูปการ์ด: ใช้ไฟล์ภาพจริงใน `assets/images/` (การ์ด One Piece + Pokémon)
  ตั้งชื่อแบบ `[เกม]-[ตัวละคร]-[เซ็ต].webp` เช่น `op-luffy-op13.webp`,
  `pkm-pikachu-ex-gold.webp` — วางผ่าน `<img>` ใน `.card-img`
- เอฟเฟกต์โฮโล: gradient เคลื่อนไหวบน heading และขอบการ์ด Rare
