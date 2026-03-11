# Example: Review Report

This is an example output from `/review-branch`.

---

# Review Report: feat/add-payment-webhook

**Date**: 2026-03-10
**Reviewer**: Claude Code
**Branch**: feat/add-payment-webhook vs main
**Tech Stack**: Node.js + NestJS + Prisma + PostgreSQL

## Critical Issues

### [C1] SQL injection in webhook signature validation
- **File**: src/payments/webhook.controller.ts:42
- **Problem**: Raw query uses string interpolation for the webhook ID lookup
- **Why it matters**: An attacker could inject SQL through a crafted webhook payload
- **Example scenario**: Malicious payload with `'; DROP TABLE payments; --` as event ID
- **Suggested fix**: Use Prisma's parameterized query: `prisma.$queryRaw\`SELECT * FROM webhooks WHERE id = ${webhookId}\``

### [C2] No idempotency check on payment processing
- **File**: src/payments/payment.service.ts:78
- **Problem**: Processing a webhook event twice will create duplicate payment records
- **Why it matters**: Stripe sends retries. Without idempotency, customers get charged twice.
- **Example scenario**: Network timeout causes Stripe to retry; both requests succeed
- **Suggested fix**: Add unique constraint on `stripe_event_id` and wrap in upsert

## Major Issues

### [M1] Missing transaction boundary on payment + ledger update
- **File**: src/payments/payment.service.ts:85-102
- **Problem**: Payment record and ledger entry are created in separate queries
- **Why it matters**: If ledger insert fails, payment exists without a ledger entry
- **Suggested fix**: Wrap both operations in `prisma.$transaction()`

### [M2] No rate limiting on webhook endpoint
- **File**: src/payments/webhook.controller.ts:15
- **Problem**: Webhook endpoint has no rate limiting
- **Why it matters**: Denial of service via rapid webhook calls
- **Suggested fix**: Add `@Throttle(100, 60)` decorator from `@nestjs/throttler`

## Minor Issues

### [m1] Magic string for payment status
- **File**: src/payments/payment.service.ts:92
- **Issue**: `status: 'completed'` is a magic string used in 3 places
- **Suggestion**: Extract to `PaymentStatus.COMPLETED` enum

## Suggestions

- [S1] Add structured logging with correlation ID for webhook processing
- [S2] Consider adding a dead-letter queue for failed webhook processing

## Open Questions

- Is there a retry strategy for failed ledger entries?
- Should failed webhooks be stored for manual review?

## Summary

| Severity | Count |
|----------|-------|
| Critical | 2     |
| Major    | 2     |
| Minor    | 1     |
| Suggestions | 2 |

**Production Readiness**: 4/10
**Verdict**: CHANGES REQUESTED
**Must fix before merge**: C1 (SQL injection), C2 (idempotency), M1 (transaction boundary)
