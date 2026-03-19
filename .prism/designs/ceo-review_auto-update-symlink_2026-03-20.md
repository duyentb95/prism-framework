# CEO Review: PRISM Auto-Update

**Date:** 2026-03-20
**Status:** DIRECTION LOCKED — Option B (Symlink MVP)

## Problem Reframe

- **Literal request:** Auto-update PRISM trong target projects
- **Job-to-be-done:** Bớt friction khi switch giữa dự án DLab — commands luôn sẵn sàng
- **Context:** Pain thật (đã gặp), nhưng thành thật: bớt friction, không tăng tốc ship

## 10-Star Version

Full `prism` CLI: update, diff, pin, rollback, selective sync, skill marketplace.
Closest pattern: dotfiles manager (stow) + Homebrew update model.

## Scoped MVP (Phase 1)

- `~/.prism/commands/` as shared source
- Per-file symlinks (preserve project custom commands)
- `~/.prism/projects.list` registry
- `./setup --update` auto-relinks all projects
- `~/.prism/version` marker

**Magic moment:** Chạy `./setup --update` MỘT LẦN → tất cả dự án có commands mới.

## Phase 2 (when 5+ projects OR need rollback)

- Version pinning per project
- `prism diff` (preview before update)
- CLI extraction
- Per-project rollback

## CEO Concern

DX improvement, not productivity gain. Monitor: nếu 6 tháng sau vẫn 2-3 dự án, evaluate xem symlink infrastructure có justified không.

## Options Evaluated

| Option | Effort | Pain solved | Decision |
|---|---|---|---|
| A) Quick fix loop | 5 phút | 80% | Rejected — band-aid, sẽ rewrite |
| B) Symlink MVP | 30 phút CC | 95% | **CHOSEN** — right foundation |
| C) Full CLI | 2-4 giờ CC | 100% | Deferred — overkill cho 1-3 projects |
