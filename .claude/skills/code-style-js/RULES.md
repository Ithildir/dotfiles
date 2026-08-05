# Rule Catalog

Numbered blocks: 0xx meta, 1xx naming, 2xx ordering, 3xx simplification, 4xx control flow, 5xx strings and prose, 6xx tests, 7xx TypeScript, 8xx modules. Rules marked ★ are the ones professional habit gets wrong — check them explicitly.

## 0xx — Meta

### 001: Follow the Existing Convention

**Why:** These rules are the default for new code and unsettled patterns, not a mandate to rewrite evolved code. When a file already does something one consistent way, match it — even where it departs from this catalog.

### 002: Do Not Compound a Split Convention

**Why:** A split convention is no convention. When a file mixes two forms for the same kind of call, pick the catalog-compliant form and apply it to every similar site within the change — do not add to either side.

### 003: Defer to Prettier and ESLint

**Why:** The project's formatter and linter own whitespace, wrapping, quotes, semicolons, and import order. Their output wins over any rule here; never hand-format what they cover.

### 004: Touch Only the Code You Are Changing

**Why:** A formatting pass on someone else's untouched lines produces drive-by diffs teammates did not ask for. Apply the catalog to the working diff, the branch diff, or the named files — nothing else.

## 1xx — Naming

### 101: Uppercase Acronyms in Identifiers ★

**Why:** Treating acronyms as uppercase tokens keeps names visually consistent and avoids camelCase drift for the same concept. Exception: `Id` stays `Id` in identifiers (`userId`) — "ID" is uppercase in prose only (rule 508). Defer to the real name of an external API (`JsonNode` stays `JsonNode`).

```diff
-const apiUrl = getApiUrl();
-foo.parseHtmlContent();
+const apiURL = getAPIURL();
+foo.parseHTMLContent();
```

### 102: Boolean Variables Take No Prefix ★

**Why:** `is`/`has` prefixes are for boolean-returning functions; a variable or field is the state itself. Prefer `has` over `contains`/`exists` for functions. Do not "fix" `enabled` into `isEnabled` — the declaration already says it is a boolean.

```diff
-private isEnabled = true;
+private enabled = true;

-function enabled(): boolean {
+function isEnabled(): boolean {
```

### 103: Name a Variable After Its Type or Content

**Why:** The name should tell the reader exactly what the value is. When one instance of a type is in scope, the plain type name is enough; lambda parameters get the domain name, not `u`/`k`/`e`.

```diff
-const c = new HttpClient();
-users.find((u) => u.role === 'admin');
+const httpClient = new HttpClient();
+users.find((user) => user.role === 'admin');
```

### 104: Type Suffixes Mean What They Say

**Why:** Reserved endings encode the type: `fooJSON` is the serialized string, the parsed value is `foo` or `fooObject`; a DOM handle is `fooElement`. A mismatched suffix misleads at every use site.

```diff
-const userJSON = JSON.parse(response);
+const user = JSON.parse(response);

-const user = JSON.stringify(payload);
+const userJSON = JSON.stringify(payload);
```

### 105: Numbered Siblings Start at 1

**Why:** `foo` coexisting with `foo2` hides the relationship; number both. A loop variable shadowing an outer base name takes `cur`.

```diff
-const query = base.clone();
-const query2 = base.clone();
+const query1 = base.clone();
+const query2 = base.clone();
```

### 106: Word-Boundary Spelling

**Why:** English prefixes that form one word stay one word (`nonexistent`, `resubmit`, `suborganization`); `name` starts a new hump (`fileName`, `userName`) except in established compounds (`hostname`, `nickname`, `rename`). A name mirroring an external key is exempt.

```diff
-const subOrganizations = [];
-const filename = upload.name;
+const suborganizations = [];
+const fileName = upload.name;
```

### 107: SCREAMING_SNAKE Only for Immutables ★

**Why:** SCREAMING_SNAKE asserts deep immutability: primitives, strings, and frozen `as const` literals of them. A module-level `Map`, `Set`, `RegExp`, or logger has identity and state — it stays camelCase.

```diff
-const USER_ID_PATTERN = /^[a-z0-9-]+$/;
-const CACHE = new Map();
+const userIdPattern = /^[a-z0-9-]+$/;
+const cache = new Map();
```

### 108: Constant Families Lead With the Shared Prefix

**Why:** `STATUS_ACTIVE`/`STATUS_INACTIVE` sorts the family together; leading with the value scatters it. Order each name general to specific.

```diff
-const ACTIVE_STATUS = 'active';
-const INACTIVE_STATUS = 'inactive';
+const STATUS_ACTIVE = 'active';
+const STATUS_INACTIVE = 'inactive';
```

### 109: Descriptive Catch Bindings

**Why:** `catch (error)` reads on its own line; `e`/`err`/`ex` forces the reader back to the clause. Use the specific name when the type is known (`typeError`); number only on real scope collision.

```diff
-catch (e) {
+catch (error) {
```

### 110: Functions Are Verbs, Collections Are Plural

**Why:** A function name starts with a verb and says what it actually does; a collection-returning function takes a plural name; paired functions mirror suffixes (`getFoos`/`getFoosCount`).

```diff
-function userValidation(user: User) {
-function getUserOverview(): User[] {
+function validateUser(user: User) {
+function getUsers(): User[] {
```

### 111: Parameter-Aligned Naming

**Why:** A value takes the name of the function it came from or the slot it feeds, so the reader never reconciles synonyms. Map loops use `entry`/`key`/`value`.

```diff
-const state = getStatus();
+const status = getStatus();

-send(message, retryCount);
-function send(message: string, attempts: number) {
+send(message, attempts);
+function send(message: string, attempts: number) {
```

### 112: No Wrapper Prefixes

**Why:** `do`/`perform`/`handle` add nothing when the verb already describes the action.

```diff
-function doDelete(id: string) {
+function deleteEntry(id: string) {
```

## 2xx — Ordering and Declaration

### 201: Sort Sortable Sequences ★

**Why:** Whenever order carries no meaning, sort in natural order — case-insensitive, numeric-aware (`item2` before `item10`). Applies to object literal keys, JSX props, union and enum members, consecutive setter calls on one object, and parallel assertions. Entries that must stay first or last separate from the sorted block with a blank line. Order that carries meaning (a lifecycle, a pipeline) is exempt — and the exemption is the reason to sort everything else: the reader can trust that unsorted means intentional.

```diff
 const config = {
-	timeout: 5000,
-	retries: 3,
 	baseURL: 'https://api.example.com',
+	retries: 3,
+	timeout: 5000,
 };
```

### 202: Sort Grouped Independent Declarations

**Why:** A block of independent assignments sorts alphabetically; a derived assignment follows the values it depends on, near its use.

```diff
-const gamma = computeGamma();
-const alpha = computeAlpha();
+const alpha = computeAlpha();
+const gamma = computeGamma();
```

### 203: Declare at First Use, Narrowest Scope

**Why:** The reader should meet each value where it is used, without scanning back to a top-of-function block. Move a declaration next to its first use, into the sole branch that uses it, and past any early exit — unless the initializer has side effects (verb-prefixed calls like `create`/`send`/`update` stay put, because their order matters).

```diff
-const payload = buildPayload(input);
-
 if (!input.valid) {
 	return null;
 }
+
+const payload = buildPayload(input);
```

### 204: Burrito — Output First

**Why:** The accumulator or returned value is declared at the top, wrapping the code that builds it; the clue is that you are returning it. Containment hierarchies declare outer-to-inner, then configure inner-to-outer.

```diff
+const results: Output[] = [];
+
 const sources = await getSources(input.id);
 
-const results: Output[] = [];
-
 for (const source of sources) {
 	results.push(transform(source));
 }
```

### 205: Constructor Assignment Order

**Why:** Reading the assignment block should reproduce the signature: parameter-fed fields first, in signature order; derived fields after a blank line.

```diff
 constructor(host: string, port: number) {
 	this.host = host;
-	this.endpoint = `${host}:${port}`;
 	this.port = port;
+
+	this.endpoint = `${host}:${port}`;
 }
```

### 206: Class Member Order ★

**Why:** One canonical place for everything: static fields → static methods → constructor → public methods → private methods → private fields. Private fields go last, not first — the reader meets the API before the plumbing. Alphabetical within each group; SCREAMING_SNAKE constants before camelCase fields in their group.

```diff
 export class OrderTracker {
-	private cache = new Map<string, Order>();
-
 	constructor(private httpClient: HttpClient) {}
 
 	async getOrder(id: string) { /* … */ }
 
 	private orderURL(id: string) { /* … */ }
+
+	private cache = new Map<string, Order>();
 }
```

### 207: Blank Lines Delimit Logical Groups

**Why:** A blank line ends a finished setup block; statements that read as one step stay adjacent. A group whose internal order cannot be made deterministic splits into separate groups, so the reader knows the order is intentional.

```diff
 themeDisplay.setLocale(locale);
 themeDisplay.setUser(user);
+
 const request = new ThemeRequest();
```

### 208: Canonical Order for Recurring Parameter Families

**Why:** `(request, response)`, `(source, target)`, `(value, options)` — one fixed order makes call sites diffable and prevents swapped-argument bugs.

```diff
-function copy(target: Entry, source: Entry) {
+function copy(source: Entry, target: Entry) {
```

## 3xx — Simplification

### 301: Inline Single-Use Locals

**Why:** A local computed once and handed to one call site adds a name without meaning. Keep the name only when it explains something the expression cannot.

```diff
-const url = `${this.baseURL}/api/v1`;
-
-return url;
+return `${this.baseURL}/api/v1`;
```

### 302: Delete Dead Writes

**Why:** A variable assigned then reassigned before any read, assigned and never read, or only ever written is dead code that reads as live. (`x = null` for deliberate release is exempt.)

```diff
-let name = '';
-name = user.displayName;
+let name = user.displayName;
```

### 303: Construct Declaratively

**Why:** An object or array built as one literal expression is inspectable at a glance; create-then-mutate scatters the shape. Conditional keys inline via spread.

```diff
-const options = {};
-options.retries = 3;
-if (secure) {
-	options.cert = cert;
-}
+const options = {
+	retries: 3,
+	...(secure ? {cert} : {}),
+};
```

### 304: Initialize Constants at Declaration

**Why:** A module-level constant populated by a later mutation block is not a constant to the reader. Use a literal, or an IIFE when computation is needed.

```diff
-const labels = new Map();
-labels.set('a', 'Alpha');
-labels.set('b', 'Beta');
+const labels = new Map([
+	['a', 'Alpha'],
+	['b', 'Beta'],
+]);
```

### 305: Drop Redundant Arguments and Conversions

**Why:** An argument equal to the parameter's default implies a non-default was intended; `String(x)` on a string and restated inferable type arguments are noise.

```diff
-fetchUsers(query, undefined);
-const id = String(uuid.toString());
+fetchUsers(query);
+const id = String(uuid);
```

### 306: Prefer Built-Ins Over Util Twins

**Why:** Every helper import is a dependency edge. When a built-in matches the helper's semantics (`structuredClone`, `Object.groupBy`, `at`, `replaceAll`, `find`), use the built-in.

```diff
-const admin = users.filter((user) => user.role === 'admin')[0];
+const admin = users.find((user) => user.role === 'admin');
```

### 307: Remove No-Op Code

**Why:** A trailing bare `return;`/`continue;` (including in the last branch), an empty constructor, a constructor that only forwards to `super`, and a guard for an impossible case all cost reading time and buy nothing.

```diff
 function log(message: string) {
 	console.log(message);
-
-	return;
 }
```

### 308: Preserve the Error Chain ★

**Why:** `new Error(error.message)` throws away the original type and stack. Rethrow the original, or wrap with `{cause}`. "Preserving the message" is not preserving the error. Every catch logs, rethrows, or states why not.

```diff
 catch (error) {
-	throw new Error(error.message);
+	throw new Error('Unable to parse user', {cause: error});
 }
```

## 4xx — Control Flow

### 401: Guard Clauses

**Why:** Inverting and exiting early flattens the method into one straight column. No `else` after a branch ending in `return`/`throw`/`continue`/`break`; merge `if (a) { if (b) {…} }` into `if (a && b)` — logging and feature-flag guards stay nested.

```diff
-if (user.active) {
-	// thirty lines
-}
-else {
-	return null;
-}
+if (!user.active) {
+	return null;
+}
+
+// thirty lines
```

### 402: Chain Only on Fluent Types

**Why:** Chains are for APIs designed for them — array and iterable pipelines, promise chains, builders, assertion and mock matchers, query builders. On anything else, each intermediate value deserves a name and a breakpoint. Never chain off a parenthesized expression or an `as`-cast. When a fluent API can chain consecutive calls, chain them.

```diff
-const name = getUserById(id).getProfile().displayName;
+const user = getUserById(id);
+
+const profile = user.getProfile();
+
+const name = profile.displayName;
```

### 403: Lookup Objects Over switch ★

**Why:** Value-to-value dispatch is data, not control flow; a lookup object shows the whole mapping at a glance. Predicate logic uses if/else. `switch` is allowed only on a discriminated union with an exhaustiveness check in `default`. If prototype-key safety worries you, that argues for `Object.create(null)`, a `Map`, or a `?? fallback` — not for `switch`.

```diff
-switch (status) {
-	case 'active':
-		return 'Active';
-	case 'inactive':
-		return 'Inactive';
-	default:
-		return 'Unknown';
-}
+const statusLabels: Record<string, string> = {
+	active: 'Active',
+	inactive: 'Inactive',
+};
+
+return statusLabels[status] ?? 'Unknown';
```

### 404: Ternaries Are One-Liners

**Why:** A ternary is allowed only when condition and both arms each fit on one line — in JSX too. Anything longer becomes if/else, an extracted variable, or a helper component.

```diff
-const label = user.isAdmin
-	? formatAdminLabel(user, permissions)
-	: formatMemberLabel(user, team, locale);
+let label;
+
+if (user.isAdmin) {
+	label = formatAdminLabel(user, permissions);
+}
+else {
+	label = formatMemberLabel(user, team, locale);
+}
```

### 405: Direct Boolean Returns

**Why:** A boolean expression is already the answer; wrapping it in if/return-true/return-false adds four lines of ceremony.

```diff
-if (user != null && user.name.length > 0) {
-	return true;
-}
-
-return false;
+return user != null && user.name.length > 0;
```

### 406: Iterate Directly

**Why:** An index used only for element access is bookkeeping; `for…of`/`.map` says what happens to each element. Iterate `Object.entries`/`map.entries()` — never keys plus a per-key lookup.

```diff
-for (const key of Object.keys(filters)) {
-	apply(key, filters[key]);
-}
+for (const [key, value] of Object.entries(filters)) {
+	apply(key, value);
+}
```

### 407: Null Guard Leads

**Why:** The nullish check comes before any use of the value in the same condition — or disappears into `?.` where that reads better.

```diff
-if (list.length === 0 || list == null) {
+if (list == null || list.length === 0) {
```

### 408: Parentheses by Rule, Not Taste

**Why:** Parenthesize every relational subexpression inside `&&`/`||` and ternary conditions, and every group when mixing different logical operators; no parens around a bare call, a same-operator chain, or the whole condition. The literal goes on the right — no Yoda conditions.

```diff
-if (a < 0 || b < 0 && c) {
+if ((a < 0) || ((b < 0) && c)) {

-if (0 === count) {
+if (count === 0) {
```

### 409: Use the Semantic Method

**Why:** The most specific method states intent: `startsWith` guards a prefix strip (never `includes`); `includes` over `indexOf(x) !== -1`; exact equality over substring matching in runtime logic.

```diff
-if (path.indexOf(prefix) !== -1) {
+if (path.startsWith(prefix)) {
 	return path.slice(prefix.length);
 }
```

### 410: Batch Independent Async Work

**Why:** `await` inside a loop over independent operations serializes what could be one round trip — the classic N+1. Collect and issue one bulk call, or `Promise.all` with a concurrency cap. In a formatting pass this changes behavior: report it, do not apply it. Prefer `while` over `do…while`.

```diff
-for (const id of ids) {
-	await httpClient.delete(`${baseURL}/users/${id}`);
-}
+await Promise.all(
+	ids.map((id) => httpClient.delete(`${baseURL}/users/${id}`))
+);
```

## 5xx — Strings, Messages, and Prose

### 501: One String Mechanism

**Why:** Template literals for multi-part strings; never a `+` chain beyond three parts, never `+` mixed with template literals; merge adjacent literals; convert non-strings explicitly.

```diff
-const url = base + '/users/' + id + '?timeout=' + timeout;
+const url = `${base}/users/${id}?timeout=${timeout}`;
```

### 502: Phrase vs Sentence ★

**Why:** A message is a single phrase with no terminating period, or two-plus sentences each with one — never one sentence with a period. Applies to errors, logs, UI copy, and doc-comment summaries.

```diff
-throw new Error('The order was not found.');
+throw new Error('The order was not found');
```

### 503: User-Facing Prose Is Complete and Formal ★

**Why:** No contractions; include the articles a sentence needs; restore linking verbs; failures read "Unable to <verb>", not "Can't"/"Cannot"/"Failed to". No first-person plural ("We couldn't find…") — the system is not a "we".

```diff
-throw new Error("Can't fetch user because the id isn't valid.");
+throw new Error('Unable to fetch user because the ID is not valid');
```

### 504: Quote Literal Tokens in Messages

**Why:** Quoting identifiers, header names, and content types separates the data from the sentence.

```diff
-throw new Error('Request body has no application/json content');
+throw new Error('Request body has no "application/json" content');
```

### 505: Title Case for Labels

**Why:** Labels capitalize the first word, the last word, and every major word; articles, coordinating conjunctions, and short prepositions stay lowercase; acronyms keep their casing. Descriptions are sentences instead (rule 502).

```diff
-const title = 'Export of the report';
+const title = 'Export of the Report';
```

### 506: Collate With an Explicit Locale

**Why:** Raw `<`/`>` or bare `localeCompare` on display strings breaks outside English (`Á` sorts after `Z`). User-visible sorting goes through `Intl.Collator` with an explicit locale — never an ambient default.

```diff
-names.sort();
+const collator = new Intl.Collator(locale);
+
+names.sort(collator.compare);
```

### 507: Comment Form

**Why:** `// ` with one space, capitalized, complete sentences, blank line before and after; `TODO` uppercase. A comment states a constraint the code cannot — never narration of the next line.

```diff
-//compute the score
+// The score must be computed before caching because the cache key includes it.
```

### 508: Prose Conventions ★

**Why:** "ID" is uppercase in prose (identifiers keep `Id`: `userId`); no hyphenated compounds (close up prefixes, separate compounds); "cleanup" is the noun, "clean up" the verb; single space after a period.

```diff
-// Clean-up the cache when the id changes
+// Clean up the cache when the ID changes
```

### 509: i18n Strings Are Clean and Explicit

**Why:** No HTML in catalog values — positional placeholders instead, with wrappers supplied by the rendering layer; labels carry explicit keys, never auto-derived from identifiers; ambiguous single-word keys take a context suffix (`close[verb]`).

```diff
-'click-link': 'Click this <a href="{0}">link</a>.'
+'click-link': 'Click this {0}link{1}.'
```

## 6xx — Tests

### 601: One Naming Convention

**Why:** Test names follow the repo's single convention (`it('should …')` or `test('…')`, not both) and name the subject under test, keeping its `is`/`has` prefix. Predicate phrasing is `<property> is <state>` so sorted names group by property.

```diff
-it('should work when bar has null baz', …);
+it('returns null when barBaz is null', …);
```

### 602: Randomize Unasserted Values

**Why:** A literal in a test claims the test checks it. Randomize everything the test does not assert on; keep literals only for asserted values.

```diff
-const user = createUser({name: 'Test User'});
+const user = createUser({name: randomString()});
```

### 603: Most Specific Matcher, Canonical Slots

**Why:** `toBe(true)` not `toEqual(true)`; `toHaveLength`/`toContain` over asserting on a derived expression — the specific matcher produces the better failure message. The expected value sits in the expectation slot.

```diff
-expect(items.length === 3).toBe(true);
+expect(items).toHaveLength(3);
```

### 604: Delete Redundant Assertion Noise

**Why:** A `toBeDefined()` the next line already proves, and a narrative message restating the predicate, add length without coverage.

```diff
-expect(user).toBeDefined();
 expect(user.name).toBe('alice');
```

### 605: No Floating Promises in Tests

**Why:** An unawaited promise in a test or hook is the largest single source of flakes — the assertion runs before the work. Await everything; wrap React updates in `act()`/`waitFor`.

```diff
-service.disable(component);
+await service.disable(component);
```

### 606: Sleeps and Skips Carry Tickets

**Why:** A hard sleep standing in for a real condition, or a `.skip`, is tracked debt — it needs an adjacent ticket-linked comment, and preferably a real wait condition instead.

```diff
-await page.waitForTimeout(3000);
+// PROJ-1234: The widget animates for up to 3s and exposes no ready event.
+await page.waitForTimeout(3000);
```

### 607: No Shared Mutable State Between Tests

**Why:** Module-level `let` in a test file and fixtures shared across tests couple them silently. Fresh state per test; suite-level setup only when the fixture is genuinely expensive.

```diff
-let tracker: OrderTracker;
-
-beforeAll(() => {
-	tracker = createTracker();
-});
+beforeEach(() => {
+	tracker = createTracker();
+});
```

### 608: Expected Failures Use the Framework

**Why:** `expect(fn).toThrow(…)` / `await expect(p).rejects.toThrow(…)` — not try/catch with a trailing `fail()`. Where the idiom is unavoidable, the failure marker is the last statement of the `try`.

```diff
-try {
-	parse(input);
-	fail();
-}
-catch (error) {}
+expect(() => parse(input)).toThrow();
```

### 609: Tests Live With Their Subject

**Why:** Unit tests colocate (`foo.test.ts` beside `foo.ts`); integration and e2e suites get their own root with their own config; shared scaffolding is named `base-*` and contains no runnable tests.

## 7xx — TypeScript

### 701: No Untyped Escape Hatches

**Why:** `any` and bare `Array`/`Map`/`Promise`/`Record<string, unknown>` defer type errors to runtime and let mutually inconsistent settings type-check.

```diff
-private cache = new Map<string, any>();
+private cache = new Map<string, User>();
```

### 702: No as-Downcasts on Foreign Values

**Why:** `as` is for values you constructed; anything else goes through a type guard or a validating converter — an unchecked `as` is a runtime assumption in a type costume. Remove casts the compiler already proves.

```diff
-const order = payload as Order;
+const order = parseOrder(payload);
```

### 703: Explicit Overrides

**Why:** `override` (with `noImplicitOverride`) makes shadowing visible and lets the compiler catch signature drift; never silently redeclare an inherited member.

```diff
+override
 dispose() {
 	super.dispose();
 }
```

### 704: Minimal Visibility

**Why:** A member used only inside the class is `private` (underscore-prefixed where the team does that); a module-local function is not exported; dead private members are deleted, not kept as reference.

```diff
-export function normalizeKey(key: string) {
+function normalizeKey(key: string) {
```

### 705: Close the String Types

**Why:** A field linking two places is a union of known values, not `string` — a typo becomes a compile error instead of a silently missing section. Serialized payloads carry an explicit discriminant and version.

```diff
-function setCategory(category: string) {
+const CATEGORIES = ['audit', 'security'] as const;
+
+function setCategory(category: (typeof CATEGORIES)[number]) {
```

## 8xx — Modules and Boundaries

### 801: Import Explicitly, From Public Surfaces

**Why:** Every identifier used is imported; no reaching into another package's `internal`/`dist`/`node_modules`. Deprecated imports live on a deny-list whose error names the replacement.

```diff
-import {debounce} from 'some-pkg/node_modules/lodash';
+import {debounce} from 'lodash';
```

### 802: Hoist Heavy Constants

**Why:** A regex or other expensive immutable built inside a hot function is rebuilt per call; compile once at module level.

```diff
-function isValidId(id: string) {
-	return new RegExp('^[a-z0-9-]+$').test(id);
-}
+const idPattern = /^[a-z0-9-]+$/;
+
+function isValidId(id: string) {
+	return idPattern.test(id);
+}
```

### 803: No Side Effects at Import

**Why:** Work at import time runs before config exists and breaks tests. Lifecycle-managed clients initialize lazily; a formatting pass reports this, it does not restructure.

```diff
-export const client = createClient(env);
+let client: Client | undefined;
+
+export function getClient() {
+	return (client ??= createClient(env));
+}
```

### 804: Domain Logic Takes the Actor Explicitly

**Why:** A service function that reads ambient session, cookies, or `AsyncLocalStorage` cannot be tested or called from a job. It receives `userId`/`locale`/tenant as parameters. In a formatting pass, report — do not apply.

```diff
-async function deletePost(id: string) {
-	const {userId} = await getSession();
+async function deletePost(id: string, actorId: string) {
```

### 805: Views Do Not Call the Data Layer

**Why:** Data is fetched in loaders, containers, or server components and passed as narrow typed props; no whole-request or context bags in public signatures — pass the fields, or one purpose-built view model. In a formatting pass, report — do not apply.

```diff
-function ProfileCard({request}: {request: Request}) {
+function ProfileCard({displayName, locale}: {displayName: string; locale: string}) {
```

### 806: Pin Dependency Versions

**Why:** Floating specifiers resolve differently on release branches than on main — green CI today, broken tag build later. Exact versions, committed lockfile; `workspace:*` is the only floating exception.

```diff
-"left-pad": "^1.3.0",
+"left-pad": "1.3.0",
```
