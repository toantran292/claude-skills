# Example: Fix Plan

This is an example output from `/remediation-plan`.

---

# Fix Plan: feat/add-payment-webhook

**Date**: 2026-03-10
**Source**: Review report

## Issues

| # | Title | Severity | Files | Status |
|---|-------|----------|-------|--------|
| 1 | SQL injection in webhook validation | Critical | webhook.controller.ts | PENDING |
| 2 | No idempotency on payment processing | Critical | payment.service.ts, migration | PENDING |
| 3 | Missing transaction boundary | Major | payment.service.ts | PENDING |
| 4 | No rate limiting on webhook | Major | webhook.controller.ts | PENDING |
| 5 | Magic string for payment status | Minor | payment.service.ts | PENDING |

## Fix Strategy

1. Fix SQL injection first (security, no dependencies)
2. Add idempotency (requires migration, then code change)
3. Add transaction boundary (depends on payment service code being stable)
4. Add rate limiting (independent, can be done in parallel)
5. Extract status enum (cleanup, lowest risk)

## Execution Steps

### Fix 1: SQL injection — Critical
- **Problem**: String interpolation in raw SQL query
- **Files**: src/payments/webhook.controller.ts
- **Steps**:
  1. Replace `prisma.$queryRawUnsafe(\`SELECT * FROM webhooks WHERE id = '${id}'\`)` with `prisma.$queryRaw\`SELECT * FROM webhooks WHERE id = ${id}\``
  2. Add input validation: verify `id` is a valid UUID before querying
- **Validation**: Unit test with SQL injection payload returns 400, not 500
- **Risk**: Low — parameterized queries are drop-in replacements

### Fix 2: Idempotency — Critical
- **Problem**: Duplicate webhook events create duplicate payments
- **Files**: src/payments/payment.service.ts, prisma/migrations/
- **Steps**:
  1. Create migration: `ALTER TABLE payments ADD CONSTRAINT uq_stripe_event_id UNIQUE (stripe_event_id)`
  2. Change `create()` to `upsert()` with `stripe_event_id` as the unique key
  3. Return existing payment record on duplicate instead of error
- **Validation**: Send same webhook event twice, verify only one payment exists
- **Risk**: Migration on large table may lock. Run during low traffic.

### Fix 3: Transaction boundary — Major
- **Problem**: Payment and ledger entry not atomic
- **Files**: src/payments/payment.service.ts
- **Steps**:
  1. Wrap payment creation + ledger entry in `prisma.$transaction()`
  2. Add error handling that rolls back both on failure
- **Validation**: Simulate ledger insert failure, verify no orphaned payment record
- **Risk**: Medium — need to verify transaction isolation level is sufficient

### Fix 4: Rate limiting — Major
- **Problem**: No rate limiting on webhook endpoint
- **Files**: src/payments/webhook.controller.ts
- **Steps**:
  1. Add `@Throttle(100, 60)` to the webhook controller
  2. Verify throttler module is configured in app.module.ts
- **Validation**: Send 101 requests in 60 seconds, verify 429 response
- **Risk**: Low — may need to tune limits based on expected Stripe volume

### Fix 5: Extract payment status enum — Minor
- **Problem**: Magic strings for payment status
- **Files**: src/payments/payment.service.ts
- **Steps**:
  1. Create `PaymentStatus` enum with `PENDING`, `COMPLETED`, `FAILED`
  2. Replace all string literals with enum values
- **Validation**: Tests still pass
- **Risk**: None

## Validation

After all fixes:
- [ ] All existing tests pass
- [ ] New tests cover SQL injection, idempotency, and transaction rollback
- [ ] Webhook endpoint handles duplicates gracefully
- [ ] Rate limiting responds with 429 when exceeded
- [ ] No magic strings remain for payment status
