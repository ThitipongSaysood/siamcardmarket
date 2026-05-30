# Skills Playbook — TCG (CARD ZONE)

> Cross-task knowledge: วิธีใช้ skills 18 ตัวที่ติดตั้งใน `.agents/skills/` สำหรับโปรเจค TCG
> อ่านก่อนเริ่มงานใหม่เพื่อเลือก skill ที่เหมาะ — ไม่ใช่เปิด skill ตามใจ
> สถานะอ้างอิง: Scaffold v0.1 (UI mockup + Auth + DB schema, ยังไม่มี business logic)

---

## 1. รายการ Skills แยกตามหมวด

| หมวด | Skills | หน้าที่หลัก |
|------|--------|-------------|
| **🎨 Design / UI** | `frontend-design` · `web-design-guidelines` · `ui-ux-pro-max` | ออกแบบ/refine Blade view + CSS |
| **📐 Planning** | `brainstorming` · `writing-plans` · `grill-with-docs` | ก่อนเริ่ม feature ใหม่ |
| **🏗️ Execution** | `executing-plans` · `subagent-driven-development` · `dispatching-parallel-agents` | ลงมือ implement |
| **✅ Quality** | `test-driven-development` · `systematic-debugging` · `verification-before-completion` | ทุกครั้งที่เขียนโค้ด |
| **🔍 Review** | `requesting-code-review` · `receiving-code-review` · `finishing-a-development-branch` | ก่อน merge |
| **🛠️ Workflow** | `using-superpowers` · `using-git-worktrees` · `writing-skills` | จัดการ session |

---

## 2. Pipeline หลัก (จับ skill เข้ากับ phase)

```
   ┌─ Brainstorm ─┬─ Plan ─────┬─ Build ────┬─ Verify ──┬─ Review ──┬─ Ship ─┐
   │              │            │            │           │           │        │
   ▼              ▼            ▼            ▼           ▼           ▼        ▼
brainstorming  writing-plans  subagent-    TDD       requesting-  receiving- finishing-
+ grill-with-  + ui-ux-pro-   driven-dev   + verify   code-review  code-     branch
docs           max (UI)       (parallel    -before-                review
               + frontend-    tasks)       completion
               design (UI)
                              + systematic-
                              debugging
                              (เมื่อเจอ bug)
```

---

## 3. แผนใช้ตาม Roadmap จริงของ TCG

### Phase 1 — เชื่อม Controllers กับ Eloquent + Seeder (งานปัจจุบัน)

| ขั้น | Skill | จุดประสงค์ |
|-----|-------|----------|
| 1 | `brainstorming` | คุยกันก่อนว่า fetch อะไร, paginate, filter อย่างไร |
| 2 | `writing-plans` | เขียนแผนแยกตามหน้า (products → auctions → live → ...) |
| 3 | `test-driven-development` | เขียน test ก่อน PageController แต่ละ method |
| 4 | `subagent-driven-development` | กระจาย controller แต่ละหน้าให้ subagent ทำขนาน |
| 5 | `verification-before-completion` | รัน `php artisan test` ดูผลจริงก่อนบอกเสร็จ |

### Phase 2 — Auth Real (LINE / Facebook Login)

| ขั้น | Skill | หมายเหตุ |
|-----|-------|---------|
| 1 | `brainstorming` | Socialite vs custom OAuth, redirect flow |
| 2 | `grill-with-docs` | ตรวจ token storage ขัด `audit_logs` ใน database.md หรือไม่ |
| 3 | `writing-plans` | |
| 4 | `using-git-worktrees` | แยก branch isolation |
| 5 | TDD → code-review → finishing-a-development-branch | |

### Phase 3 — PromptPay QR + Webhook ยืนยันการชำระ

| ขั้น | Skill | หมายเหตุ |
|-----|-------|---------|
| 1 | `brainstorming` | flow `wallet_transactions.status` |
| 2 | `writing-plans` | bite-sized tasks: migration → service → controller → webhook → idempotency |
| 3 | `test-driven-development` | mock PromptPay webhook ก่อน |
| 4 | `systematic-debugging` | ใช้เมื่อ webhook ยิงซ้ำ / status race condition |
| 5 | `requesting-code-review` | ✋ **บังคับใช้** — โค้ดเกี่ยวกับเงิน ต้อง review |

### Phase 4 — Real-time Bidding & Live Queue (Reverb / WebSockets)

| ขั้น | Skill | หมายเหตุ |
|-----|-------|---------|
| 1 | `dispatching-parallel-agents` | bid logic + queue logic + frontend listener แยกกัน |
| 2 | `test-driven-development` | broadcast event tests |
| 3 | `systematic-debugging` | `bids.locked_txn_id` mismatch / race |

### Phase 5 — UI Refinement (เมื่อโครงทำงานแล้ว)

| ขั้น | Skill | จุดเน้น |
|-----|-------|--------|
| 1 | `ui-ux-pro-max` | review หน้า products/auctions/live ตาม priority 1-10 (accessibility, touch 44px, layout) |
| 2 | `frontend-design` | refine glassmorphism + holo accent ให้ "ไม่ generic" |
| 3 | `web-design-guidelines` | audit ความ compliant ตาม Vercel guidelines |

---

## 4. Skills ที่ใช้บ่อย "ทุกวัน"

ติดเป็นนิสัย — invoke โดยอัตโนมัติ:

| Skill | Trigger |
|-------|---------|
| `brainstorming` | ก่อนเริ่ม feature ใหม่ (บังคับโดยตัวมันเอง — HARD GATE) |
| `test-driven-development` | ก่อนเขียน production code ทุกครั้ง |
| `verification-before-completion` | ก่อนบอก "เสร็จแล้ว" ทุกครั้ง |
| `systematic-debugging` | ทุกครั้งที่เจอ bug — ห้าม quick patch |
| `grill-with-docs` | อัพเดต [CONTEXT.md](../CONTEXT.md) ตอนเจอ term ใหม่ |

---

## 5. Skills ที่ "อย่าเพิ่งใช้ตอนนี้"

| Skill | เหตุผล |
|-------|-------|
| `writing-skills` | ยังไม่ต้องสร้าง skill เอง — รอเจอ pattern ซ้ำ 3+ ครั้งก่อน |
| `using-git-worktrees` | branch เดียวก็พอ ระยะแรก |
| `dispatching-parallel-agents` | ใช้เมื่องาน 3+ ตัวเป็นอิสระจริงๆ เท่านั้น (เช่น Reverb broadcast + UI + queue logic) |

---

## 6. Workflow แนะนำเริ่มงานถัดไป

**สมมุติงาน next:** "เชื่อม `PageController@products` กับ Eloquent + filter"

```
1. /brainstorming     "อยากให้ /products fetch จริง + filter เกม/เซ็ต/ราคา"
                      → คุย scope · success criteria · approach 2-3 อัน
                      → save spec: docs/superpowers/specs/YYYY-MM-DD-products-eloquent-design.md

2. /writing-plans     → bite-sized tasks (test → model query → controller → blade binding → test pass)
                      → save: docs/superpowers/plans/YYYY-MM-DD-products-eloquent.md

3. /test-driven-development
                      → RED-GREEN-REFACTOR

4. /verification-before-completion
                      → รัน php artisan test, ดู output, ไม่ใช่ "should work"

5. /requesting-code-review
                      → ก่อน commit

6. /finishing-a-development-branch
                      → merge/PR
```

---

## 7. กฎที่ skills ต่างๆ บังคับ (ที่ขัดกับ default behavior)

| Skill | Iron Law / กฎเหล็ก |
|-------|---------------------|
| `brainstorming` | **HARD-GATE** — ห้าม implement ก่อน user approve design |
| `test-driven-development` | **NO PRODUCTION CODE WITHOUT A FAILING TEST FIRST** — เขียนโค้ดก่อน test = ลบทิ้ง |
| `verification-before-completion` | **NO COMPLETION CLAIMS WITHOUT FRESH VERIFICATION EVIDENCE** — ห้าม "should pass" |
| `systematic-debugging` | **NO FIXES WITHOUT ROOT CAUSE INVESTIGATION FIRST** — ห้าม quick patch |
| `receiving-code-review` | ห้ามตอบ "You're absolutely right!" — verify ก่อน implement |

> ⚠️ **หมายเหตุ:** กฎเหล่านี้ override default system behavior แต่ user instructions ใน CLAUDE.md/AGENTS.md ชนะหมด
> ดู priority: `using-superpowers` SKILL.md

---

## 8. ตำแหน่งไฟล์ที่ skills จะสร้าง

| ประเภท | path |
|--------|------|
| Design specs | `docs/superpowers/specs/YYYY-MM-DD-<topic>-design.md` |
| Implementation plans | `docs/superpowers/plans/YYYY-MM-DD-<feature>.md` |
| Session checkpoints | `.agents/sessions/YYYY-MM-DD-HHMM-<slug>.md` |
| Cross-task notes (นี้!) | `.agents/topics/<slug>.md` |
| Skill ใหม่ที่เราเขียนเอง | `~/.claude/skills/<name>/SKILL.md` |

---

## 9. Quick Reference — เมื่อไหร่ใช้อะไร

```
เริ่ม feature ใหม่           →  brainstorming
มี spec แล้ว, ยังไม่มี plan  →  writing-plans
มี plan แล้ว, มี subagent    →  subagent-driven-development
มี plan แล้ว, แยก session    →  executing-plans
เขียนโค้ดทุกครั้ง            →  test-driven-development
เจอ bug                       →  systematic-debugging
ก่อนบอก "เสร็จ"               →  verification-before-completion
ก่อน merge                    →  requesting-code-review
รับ review feedback           →  receiving-code-review
งาน implement เสร็จหมด        →  finishing-a-development-branch
อัพเดต glossary/CONTEXT.md   →  grill-with-docs
UI ใหม่ / refine             →  frontend-design + ui-ux-pro-max
audit UI compliance           →  web-design-guidelines
3+ งานอิสระจริงๆ              →  dispatching-parallel-agents
```

---

## 10. References

- [.agents/AGENTS.md](../AGENTS.md) — กฎทั่วไปของ `.agents/`
- [CONTEXT.md](../CONTEXT.md) — ภาพรวมโปรเจค
- [workflow.md](../../workflow.md) — flow business
- [database.md](../../database.md) — schema
- [design.md](../../design.md) — UI tokens
- `.agents/skills/<name>/SKILL.md` — เนื้อหา skill แต่ละตัว
