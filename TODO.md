# Taskline API — 60-day plan

Day 1 = 2026-11-06. Check off as you go; commit with the day reference.

## Phase 1 — Foundations (day 1–14)
- [x] D1  api-only Rails application skeleton, Postgres config (docker-compose)
- [x] D2  RuboCop + Minitest (chose minitest to stay aligned with the generated Rails 8 CI) setup, CI green
- [x] D3  Models: User, Board, BoardMembership, Column, Card (migrations + validations)
- [x] D4  JWT auth: sign up / login endpoints
- [x] D5  Boards CRUD + membership roles (owner/member)
- [x] D6  Columns CRUD + ordering
- [x] D7  Cards CRUD, move between columns
- [x] D8  Seed data
- [x] D9  Request specs for auth + boards
- [x] D10 Request specs for columns + cards
- [ ] D11 README: setup, architecture diagram, endpoints table
- [x] D12 docker-compose for Postgres (api Dockerfile pending Rails skeleton)
- [x] D13 Error handling format (consistent JSON errors)
- [ ] D14 Phase 1 retro — ROADMAP.md update

## Phase 2 — Depth (day 15–40)
- [x] D15 Action Cable: connection auth (JWT)
- [x] D16 Presence channel: who is online on a board
- [x] D17 Rooms model (board-scoped chat rooms)
- [x] D18 Messages model + broadcast to room channel
- [x] D19 Signaling channel: offer/answer/ICE relay over Action Cable
- [ ] D20 Rate limiting on messages
- [ ] D21 Model specs round
- [ ] D22 Card assignees + due dates
- [ ] D23 Card comments
- [ ] D24 Activity log (card events)
- [ ] D25 Pagination (boards index, messages)
- [ ] D26 Background job: email-style digest (Active Job + Sidekiq)
- [ ] D27 Background job specs
- [ ] D28 API versioning prep (/api/v1)
- [ ] D29 Swagger/OpenAPI docs (rswag)
- [ ] D30 CORS tightening
- [ ] D31 Security pass (brakeman)
- [ ] D32 Performance: indexes + N+1 sweep
- [ ] D33 Refactor: service objects for card moves
- [ ] D34 WebRTC signaling: TURN-less renegotiation handling
- [ ] D35 Feature flags for chat rollout
- [ ] D36 Request specs: rooms + messages
- [ ] D37 Channel specs: presence + signaling
- [ ] D38 README: WebRTC signaling flow diagram
- [ ] D39 Demo seed script
- [ ] D40 Phase 2 retro

## Phase 3 — Polish (day 41–60)
- [ ] D41 Test coverage push (>80%)
- [ ] D42 Docker compose: full stack (api + db + redis)
- [ ] D43 GitHub Actions: security + brakeman job
- [ ] D44 CHANGELOG.md
- [ ] D45 Docs: contributing guide
- [ ] D46 Performance benchmark script
- [ ] D47 Final API audit vs OpenAPI spec
- [ ] D48 Demo GIF / screencast in README
- [ ] D49 Tag v0.1 release
- [ ] D50 Cross-link taskline-web in README
- [ ] D51–D60 Buffer / stretch: attachments, card labels, search
