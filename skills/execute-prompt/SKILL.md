---
name: execute-prompt
description: Execute a well-crafted prompt at Staff Engineer level — SOLID, Clean Code, ACID, Security, Performance. Handles code, writing, analysis, and design.
argument-hint: "the prompt to execute (or path to a file containing the prompt)"
---

# Execute Prompt

Execute the given prompt with Staff/Principal Engineer level quality.

## Input

The prompt to execute is: **$ARGUMENTS**

If no prompt was provided, ask the user to provide one.

If the argument looks like a file path, read the file and use its content as the prompt.

## Process

### Step 1: Analyze the prompt

Before executing, identify:
- **Type**: What kind of output is expected? (code, text, analysis, design, plan, etc.)
- **Scope**: How large/complex is the request?
- **Tools needed**: Which tools will be required? (file I/O, web search, bash, etc.)
- **Success criteria**: What makes a good result for this specific prompt?
- **Tech stack**: If code-related, detect language, framework, and existing patterns in the project

### Step 2: Execute with engineering excellence

Follow the prompt's instructions exactly while applying rigorous engineering standards.

**Faithfulness:**
- Do exactly what the prompt asks — no more, no less
- Respect all constraints, formats, and specifications stated in the prompt
- If the prompt specifies a persona/role, adopt it fully

**For code output, detect whether the task is Backend, Frontend, or Full-stack, then enforce the appropriate standards below.**

---

### Backend Standards

#### SOLID Principles
- **Single Responsibility**: Each function/class does one thing. If a function needs "and" to describe it, split it.
- **Open/Closed**: Extend via abstraction, not by modifying existing code. Use interfaces/protocols.
- **Liskov Substitution**: Subtypes must be substitutable for their base types without breaking behavior.
- **Interface Segregation**: Small, focused interfaces. No client should depend on methods it doesn't use.
- **Dependency Inversion**: Depend on abstractions, not concretions. Inject dependencies.

#### Clean Code
- Methods under 20 lines. If longer, extract.
- Intention-revealing names — no abbreviations, no single-letter vars (except loops)
- No magic numbers or strings — use named constants
- Max 2 levels of nesting. If deeper, extract or use early returns.
- No dead code, no commented-out code, no TODOs without tickets
- Functions take max 3 parameters. More? Use an object/struct.

#### ACID (for database operations)
- **Atomicity**: Wrap related DB operations in transactions
- **Consistency**: Validate data integrity with constraints, not just app logic
- **Isolation**: Use appropriate isolation levels. Be aware of race conditions.
- **Durability**: Critical writes must be confirmed, not fire-and-forget

#### Security
- Never trust user input — validate and sanitize at system boundaries
- No SQL injection: use parameterized queries, never string concatenation
- No mass assignment: whitelist allowed fields explicitly
- Redact sensitive data in logs and error messages
- Authentication and authorization checks on every endpoint
- No secrets in code — use environment variables or secret managers

#### Performance & Optimization
- No N+1 queries — use eager loading, joins, or batch fetching
- Add database indexes for columns used in WHERE, JOIN, ORDER BY
- Paginate list endpoints — never return unbounded results
- Cache expensive computations and repeated queries
- Be aware of memory: stream large datasets, avoid loading everything into memory
- Use async/concurrent patterns where I/O bound

#### Readability & Maintainability
- Code reads like a story — top-level functions tell the "what", helpers tell the "how"
- Consistent patterns throughout — if the codebase uses pattern X, follow pattern X
- Error handling is explicit: no swallowed exceptions, no generic catch-all
- Logging at appropriate levels: ERROR for failures, WARN for unexpected but handled, INFO for business events, DEBUG for troubleshooting
- Types/interfaces for all public APIs — no `any`, no implicit types

#### Testing
- Write tests for non-trivial logic. At minimum: happy path + edge cases + error cases.
- Tests are independent, deterministic, and fast
- Use descriptive test names that explain the scenario and expectation
- Mock external dependencies, not internal logic

---

### Frontend Standards

#### Component Architecture
- **Single Responsibility**: One component = one concern. Split if it handles both data fetching and rendering.
- **Composition over inheritance**: Compose small components. Avoid deep component hierarchies.
- **Container/Presenter pattern**: Separate data logic (hooks/containers) from UI (presentational components)
- **Colocation**: Keep styles, tests, types, and utils close to the component that uses them

#### UI/UX Quality
- **Responsive by default**: Mobile-first approach. Use relative units (rem, %, vh/vw), not fixed px for layout.
- **Accessibility (a11y)**: Semantic HTML (`<button>`, `<nav>`, `<main>`), not div soup. ARIA labels on interactive elements. Keyboard navigable. Color contrast ratios meet WCAG AA.
- **Loading states**: Skeleton loaders or spinners for async content. Never show blank screens.
- **Error states**: User-friendly error messages with recovery actions. Never show raw error objects.
- **Empty states**: Meaningful empty states with call-to-action, not just "No data".

#### State Management
- **Minimize state**: Derive what you can. Don't store what you can compute.
- **Colocate state**: Keep state as close to where it's used as possible. Lift only when necessary.
- **Server state vs client state**: Use dedicated tools (React Query, SWR, TanStack Query) for server state. Don't put API responses in global state.
- **URL as state**: Filters, pagination, tabs — use URL params so users can share/bookmark.
- **Optimistic updates**: For common actions (like, save, toggle), update UI immediately and reconcile on server response.

#### Performance (Frontend-specific)
- **Bundle size**: Lazy load routes and heavy components. Dynamic imports for below-the-fold content.
- **Render optimization**: Memoize expensive renders (`React.memo`, `useMemo`, `useCallback`). Avoid re-renders from unstable references.
- **Image optimization**: Use `next/image`, `srcset`, WebP/AVIF formats. Lazy load images below the fold.
- **Virtualization**: For lists > 100 items, use virtual scrolling (react-window, tanstack-virtual).
- **Debounce/throttle**: Search inputs, scroll handlers, resize listeners — always debounce.
- **Web Vitals**: Target LCP < 2.5s, FID < 100ms, CLS < 0.1.

#### Styling
- **Consistent design tokens**: Colors, spacing, typography, shadows — use design tokens/CSS variables, not hardcoded values.
- **No inline styles** for anything beyond truly dynamic values (e.g., computed positions).
- **Follow the project's approach**: If Tailwind, use Tailwind. If CSS Modules, use CSS Modules. Don't mix.
- **Responsive breakpoints**: Use the project's established breakpoints. Don't invent new ones.

#### Security (Frontend-specific)
- **XSS prevention**: Never use `dangerouslySetInnerHTML` / `v-html` unless sanitized with DOMPurify or equivalent.
- **No sensitive data in client**: API keys, tokens — never in client bundle. Use server-side proxies.
- **CSRF protection**: Ensure forms use CSRF tokens when communicating with same-origin APIs.
- **Input validation**: Validate on client for UX, but ALWAYS validate on server for security.
- **Content Security Policy**: Be aware of CSP headers. No inline scripts in production.

#### Testing (Frontend-specific)
- **Component tests**: Test behavior, not implementation. Click buttons, fill forms, assert outcomes.
- **Don't test implementation details**: No testing internal state, private methods, or CSS classes.
- **Integration over unit**: Prefer testing components with their hooks/context over isolated unit tests.
- **Visual regression**: For design-critical components, use snapshot or visual regression tests.
- **Accessibility tests**: Use `jest-axe` or `@testing-library`'s a11y matchers in component tests.

---

### Full-stack: Apply both Backend and Frontend standards to the respective parts.

---

**For non-code output:**
- **Writing**: Match requested tone, style, audience. Be concise and structured.
- **Analysis**: Evidence-based, structured sections, key findings first. Cite sources.
- **Design**: Follow established patterns, consider scalability and maintainability.

### Step 3: Self-review as Staff Engineer

Before presenting the result, review your own work critically:

**Backend checklist:**
- [ ] SOLID principles followed — no god classes, no leaky abstractions
- [ ] Clean Code — readable, no magic values, proper naming, small functions
- [ ] Security — no injection risks, input validated, secrets handled properly
- [ ] Performance — no N+1, queries optimized, pagination in place
- [ ] ACID — transactions where needed, race conditions considered
- [ ] Error handling — explicit, no swallowed errors, proper logging
- [ ] Edge cases — nulls, empty collections, concurrent access, timeouts
- [ ] Tests included for non-trivial logic
- [ ] Matches existing project patterns and conventions

**Frontend checklist:**
- [ ] Component architecture — single responsibility, composition, proper separation
- [ ] Accessibility — semantic HTML, ARIA labels, keyboard navigation, color contrast
- [ ] Responsive — works on mobile, tablet, desktop. No fixed px layouts.
- [ ] States covered — loading, error, empty, success for all async operations
- [ ] Performance — lazy loading, memoization, virtualization for long lists, debounced inputs
- [ ] No XSS — no dangerouslySetInnerHTML, no unsanitized user content in DOM
- [ ] State management — minimal, colocated, server state separated from client state
- [ ] Design tokens — consistent colors, spacing, typography from project tokens
- [ ] Tests — behavior-based, not implementation-based. a11y checks included.

**General checklist:**
- [ ] All requirements from the prompt are addressed
- [ ] Output format matches what was requested
- [ ] No hallucinated information or made-up data
- [ ] Would pass a Senior Engineer's code review

If any check fails, fix it before presenting.

### Step 4: Deliver

Present the result clearly:
- **Code**: Write to files, highlight key design decisions and trade-offs
- **Text/Writing**: Clean formatting, structured sections
- **Analysis**: Key findings first, then supporting detail
- **Mixed**: Organize by type with clear sections

After delivering, provide:
- What was produced
- Key design decisions and why
- Any assumptions made
- Trade-offs considered
