What JavaScript and TypeScript code here looks like, JSX and TSX included.

- While writing, every rule here applies to every line you produce.
- A formatting pass, on request, covers the change only: the working diff, the
  branch diff against `origin/main`, or the files the human names. Rules that
  preserve behavior are applied. A fix that changes behavior (410, 803, 804,
  805, a dependency-injection move, a module-boundary change) is reported as a
  suggestion and left unapplied.
- ★ marks the rules professional habit gets wrong. Check every change against
  them one by one.

## Precedence

1. The file's or team's existing convention beats this file. Where a file
   already mixes two forms of the same thing, unify on the form named here,
   inside the change only. Never add to either side of a split.
2. The project's Prettier, ESLint and Stylelint config wins on everything it
   covers: whitespace, wrapping, indentation, quotes, semicolons, import order.
   Run the project's formatter after editing when one is configured.
3. This file is the default for new code and unsettled patterns.

Simpler means faster for the next reader, never fewer lines. Simplicity never
outranks safety.

## Naming

- 101 ★ Acronyms are uppercase in identifiers: `apiURL`, `getAPIURL()`,
  `parseHTMLContent()`. `Id` stays `Id` (`userId`). An external API's own name
  wins (`JsonNode`).
- 102 ★ Boolean variables and fields take no prefix: `enabled`, never
  `isEnabled`. `is` and `has` prefix boolean-returning functions:
  `isEnabled()`. `has` over `contains` or `exists`.
- 103 A variable is named for its type or content: `httpClient`, never `c`.
  Lambda parameters take the domain name: `(user) => user.role`.
- 104 Suffixes mean their type. `fooJSON` is the serialized string; the parsed
  value is `foo` or `fooObject`; a DOM handle is `fooElement`.
- 105 Numbered siblings start at 1: `query1` and `query2`, never `query` beside
  `query2`. A loop variable shadowing an outer base name is `cur`.
- 106 A prefixed English word stays one word: `nonexistent`, `resubmit`,
  `suborganization`. `name` starts a hump (`fileName`, `userName`) except in
  established compounds (`hostname`, `nickname`, `rename`). A name mirroring
  an external key is exempt.
- 107 ★ SCREAMING_SNAKE only for deep immutables: primitives, strings, and
  frozen `as const` literals of them. A module-level `Map`, `Set`, `RegExp` or
  logger has state and stays camelCase.
- 108 A constant family leads with the shared prefix, general to specific:
  `STATUS_ACTIVE`, `STATUS_INACTIVE`.
- 109 Catch bindings are `error`, or the specific type when known
  (`typeError`). Never `e`, `err` or `ex`. Number only on a real scope
  collision.
- 110 A function name starts with the verb for what it does. A function
  returning a collection is plural (`getUsers`). Paired functions mirror
  suffixes (`getFoos`, `getFoosCount`).
- 111 A value takes the name of the function it came from or the parameter it
  feeds: `const status = getStatus()`. Map loops use `entry`, `key`, `value`.
- 112 `do`, `perform` and `handle` go when another verb already names the
  action: `deleteEntry`, never `doDelete`.

## Ordering and declaration

- 201 ★ Sort whatever carries no order: object literal keys, JSX props, union
  and enum members, consecutive setter calls on one object, parallel
  assertions. Natural order: case-insensitive and numeric-aware (`item2`
  before `item10`). An entry that must stay first or last sits apart from the
  sorted block after a blank line. Order that carries meaning (a lifecycle, a
  pipeline) stays as it is.
- 202 Independent declarations in one block sort alphabetically. A derived
  declaration follows what it depends on, next to its use.
- 203 Declare at first use, in the narrowest scope: beside the first use,
  inside the only branch that uses it, after any early exit. An initializer
  with side effects (`create…`, `send…`, `update…`) stays where it is.
- 204 Output first. The accumulator or returned value is declared above the
  code that builds it. Containment hierarchies declare outer to inner, then
  configure inner to outer.
- 205 Constructor assignments reproduce the signature: parameter-fed fields in
  signature order, a blank line, then derived fields.
- 206 ★ Class members in this order: static fields, static methods,
  constructor, public methods, private methods, private fields. Private fields
  go last. Alphabetical within each group, SCREAMING_SNAKE before camelCase.
- 207 ★ A blank line separates every logical step: a declaration group, a
  guard, a loop, the return. In a test, arrange, act and assert. Helper and
  factory bodies included. Statements that read as one step stay adjacent: a
  dependent declaration pair, parallel assertions, a comment and its line. A
  group whose order cannot be made deterministic splits in two. Prettier keeps
  blank lines and never adds them, so a formatting pass checks this rule
  against every function body it touches.
- 208 Recurring parameter families keep one order: `(request, response)`,
  `(source, target)`, `(value, options)`.

## Simplification

- 301 Inline a local computed once and used once, unless its name explains
  something the expression cannot.
- 302 Delete dead writes: assigned then overwritten before a read, assigned
  and never read, or only ever written. `x = null` for deliberate release
  stays.
- 303 Build an object or array as one literal. Conditional keys go inline:
  `...(secure ? {cert} : {})`.
- 304 A module-level constant is complete at its declaration: a literal such
  as `new Map([['a', 'Alpha']])`, or an IIFE when it needs computation. No
  population block after it.
- 305 Drop an argument equal to the parameter's default, a conversion to the
  type the value already has, and type arguments the compiler infers.
- 306 A built-in beats a util twin with the same semantics: `structuredClone`,
  `Object.groupBy`, `at`, `replaceAll`, `find` over `filter(…)[0]`.
- 307 No no-op code: a trailing bare `return;` or `continue;`, last branch
  included; an empty constructor; a constructor that only forwards to
  `super`; a guard for an impossible case.
- 308 ★ Keep the error chain. Rethrow the original, or wrap it with
  `{cause: error}`. Never `new Error(error.message)`. Every catch logs,
  rethrows, or says why it does neither.

## Control flow

- 401 Guard clauses: invert and exit early. No `else` after a branch ending in
  `return`, `throw`, `continue` or `break`. `if (a) { if (b) {…} }` becomes
  `if (a && b)`, except logging and feature-flag guards, which stay nested.
- 402 Chain only on fluent APIs: array and iterable pipelines, promises,
  builders, assertion and mock matchers, query builders. Anywhere else each
  intermediate value gets a name. Never chain off a parenthesized expression
  or an `as` cast. Where a fluent API can chain consecutive calls, chain them.
- 403 ★ Value-to-value dispatch is a lookup object:
  `statusLabels[status] ?? 'Unknown'`. Predicate logic is if/else. `switch`
  only on a TypeScript discriminated union with an exhaustiveness check in
  `default`. Prototype-key safety calls for `Object.create(null)`, a `Map` or
  a `?? fallback`, never `switch`.
- 404 A ternary only when the condition and both arms each fit on one line,
  JSX included. Otherwise if/else, an extracted variable, or a helper
  component.
- 405 A boolean result returns directly: `return (x > 0) && y;`. Never
  if/return true/return false.
- 406 Iterate elements, never indexes kept only for access: `for…of`, `.map`.
  Iterate `Object.entries` or `map.entries()`, never keys plus a lookup per
  key.
- 407 The null check comes before any use of the value in the same condition
  (`list == null || list.length === 0`), or becomes `?.` where that reads
  better.
- 408 Parenthesize every relational subexpression inside `&&`, `||` and
  ternary conditions, and every group where logical operators mix:
  `(a < 0) || ((b < 0) && c)`. No parens around a bare call, a same-operator
  chain, or the whole condition. The literal goes on the right: `count === 0`.
- 409 The most specific method: `startsWith` to guard a prefix strip, never
  `includes`; `includes` over `indexOf(x) !== -1`; exact equality over
  substring matching in runtime logic.
- 410 Independent async work is batched: one bulk call, or `Promise.all` with
  a concurrency cap. Never `await` inside a loop over independent operations.
  `while` over `do…while`.
- 411 ★ Every `if` body goes in braces on its own line, however short. Never
  `if (next instanceof Error) throw next;`.

## Strings, messages and prose

- 501 Template literals for multi-part strings. No `+` chain beyond three
  parts, no `+` mixed with template literals. Merge adjacent literals. Convert
  non-strings explicitly.
- 502 ★ A message is one phrase with no final period, or two or more sentences
  each ending in one. Never one sentence with a period. Covers errors, logs,
  UI copy and doc-comment summaries.
- 503 ★ User-facing prose is complete and formal: no contractions, the
  articles and linking verbs a sentence needs, failures as "Unable to <verb>"
  and never "Can't", "Cannot" or "Failed to". The system is never "we".
- 504 Quote literal tokens in messages: identifiers, header names, content
  types (`no "application/json" content`).
- 505 Labels are title case: the first word, the last word and every major
  word capitalized; articles, coordinating conjunctions and short prepositions
  lowercase; acronyms keep their casing. Descriptions are sentences (502).
- 506 User-visible sorting goes through `Intl.Collator` with an explicit
  locale. Never raw `<` or `>`, or a bare `localeCompare`, on display strings.
- 507 Comments: `// ` with one space, capitalized, complete sentences, a blank
  line before and after, `TODO` in uppercase. A comment states a constraint
  the code cannot. Never narrate the next line.
- 508 ★ "ID" is uppercase in prose; identifiers keep `Id`. No hyphenated
  compounds: close up prefixes, separate compounds. "cleanup" is the noun,
  "clean up" the verb. One space after a period.
- 509 i18n values carry no HTML: positional placeholders such as `{0}` and
  `{1}`, with wrappers supplied by the rendering layer. Labels take explicit
  keys, never keys derived from identifiers. An ambiguous single-word key
  takes a context suffix: `close[verb]`.

## Tests

- 601 One naming form per repo, `it('should …')` or `test('…')`, never both.
  The name names the subject under test, keeping its `is` or `has` prefix.
  Predicates read `<property> is <state>`: `returns null when barBaz is null`.
- 602 Randomize every value the test does not assert on. Literals only for
  asserted values.
- 603 The most specific matcher: `toBe(true)` over `toEqual(true)`,
  `toHaveLength` and `toContain` over asserting on a derived expression. The
  expected value sits in the expectation slot.
- 604 Delete assertion noise: a `toBeDefined()` the next line already proves,
  a message restating the predicate.
- 605 Await every promise in a test or hook. Wrap React updates in `act()` or
  `waitFor`.
- 606 A hard sleep or a `.skip` carries an adjacent comment linking a ticket
  (`// PROJ-1234: …`). Prefer a real wait condition.
- 607 No shared mutable state between tests. Fresh state per test in
  `beforeEach`; suite-level setup only for a genuinely expensive fixture.
- 608 Expected failures use the framework: `expect(fn).toThrow()`,
  `await expect(promise).rejects.toThrow()`. Where try/catch is unavoidable,
  the failure marker is the last statement of the `try`.
- 609 Unit tests sit beside their subject: `foo.test.ts` next to `foo.ts`.
  Integration and e2e suites get their own root and config. Shared scaffolding
  is named `base-*` and holds no runnable tests.

## TypeScript

- 701 No `any`, and no bare `Array`, `Map`, `Promise` or
  `Record<string, unknown>`.
- 702 `as` only on values you constructed. A foreign value goes through a type
  guard or a validating converter: `parseOrder(payload)`. Remove casts the
  compiler already proves.
- 703 `override` on every override, with `noImplicitOverride` on. Never
  silently redeclare an inherited member.
- 704 Minimal visibility. A member used only inside its class is `private`,
  underscore-prefixed where the team does that. A module-local function is
  not exported. Dead private members are deleted.
- 705 A field linking two places is a union of known values, never `string`.
  Serialized payloads carry an explicit discriminant and version.

## Modules and boundaries

- 801 Import every identifier you use, from public surfaces only. Never reach
  into another package's `internal`, `dist` or `node_modules`. Deprecated
  imports go on a deny-list whose error names the replacement.
- 802 An expensive immutable built inside a hot function, such as a regex,
  moves to module level.
- 803 No side effects at import. A lifecycle-managed client initializes
  lazily: `return (client ??= createClient(env));`.
- 804 Domain logic takes the actor as parameters (`userId`, `locale`, tenant),
  never from ambient session, cookies or `AsyncLocalStorage`.
- 805 Views never call the data layer. Loaders, containers or server
  components fetch and pass narrow typed props. No whole-request or context
  bags in public signatures: pass the fields, or one purpose-built view model.
- 806 Exact dependency versions and a committed lockfile. `workspace:*` is the
  only floating specifier.
