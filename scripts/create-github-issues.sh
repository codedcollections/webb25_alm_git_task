#!/usr/bin/env bash

set -euo pipefail

START_FROM=1

usage() {
  echo "Usage: ./scripts/create-github-issues.sh [--start-from N]"
  echo "Example: ./scripts/create-github-issues.sh --start-from 6"
}

if [[ "${1:-}" == "--help" || "${1:-}" == "-h" ]]; then
  usage
  exit 0
fi

if [[ "${1:-}" == "--start-from" ]]; then
  if [[ -z "${2:-}" ]]; then
    echo "Error: Missing value for --start-from"
    usage
    exit 1
  fi
  START_FROM="$2"
elif [[ -n "${1:-}" ]]; then
  echo "Error: Unknown argument '$1'"
  usage
  exit 1
fi

if ! [[ "$START_FROM" =~ ^[0-9]+$ ]] || (( START_FROM < 1 || START_FROM > 14 )); then
  echo "Error: --start-from must be an integer between 1 and 14"
  exit 1
fi

if ! command -v gh >/dev/null 2>&1; then
  echo "Error: GitHub CLI (gh) is not installed."
  exit 1
fi

if ! gh auth status >/dev/null 2>&1; then
  echo "Error: You are not authenticated. Run: gh auth login"
  exit 1
fi

echo "Creating labels if they do not exist..."
gh label create "good first issue" --color "7057ff" --description "Good for beginners" 2>/dev/null || true
gh label create "bug" --color "d73a4a" --description "Something is broken" 2>/dev/null || true
gh label create "enhancement" --color "a2eeef" --description "New feature or request" 2>/dev/null || true

create_issue() {
  local issue_number="$1"
  local title="$2"
  local labels="$3"
  local body="$4"

  if (( issue_number < START_FROM )); then
    echo "Skipping issue $issue_number (before --start-from $START_FROM)"
    return
  fi

  gh issue create \
    --title "$title" \
    --label "$labels" \
    --body "$body"
}

echo "Creating issues..."

create_issue 1 "Issue 1 - Add required validation for product name" "good first issue" "$(cat <<'BODY'
Product model should require `name`.

## Tasks
- Add validation in the Mongoose schema.
- Return a clear error message if `name` is missing.
- Add or update a test.

## Acceptance criteria
- Creating a product without `name` fails validation.
- The client receives a readable error message.
- Tests cover the behavior.
BODY
)"

create_issue 2 "Issue 2 - Fix incorrect price test expectation" "bug" "$(cat <<'BODY'
A test currently expects incorrect behavior for price validation.

## Tasks
- Find the failing test.
- Fix the expectation.
- Make sure the test reflects actual app behavior.

## Acceptance criteria
- The corrected test matches current schema logic.
- Test suite results are predictable.
BODY
)"

create_issue 3 "Issue 3 - Add clear server startup log" "good first issue" "$(cat <<'BODY'
Improve the startup message when the server runs.

## Tasks
- Log the port number.
- Use a clear and readable message.

Example: `Server running on port 3000`

## Acceptance criteria
- Startup log includes the actual runtime port.
- Message is easy for beginners to understand.
BODY
)"

create_issue 4 "Issue 4 - Add product name filter" "enhancement" "$(cat <<'BODY'
Extend `GET /products` so it supports filtering by product name.

Example: `GET /products?name=shoe`

## Tasks
- Use `req.query.name`.
- Return only matching products.

## Acceptance criteria
- Endpoint still returns all products when no filter is provided.
- Filtered requests return only matching products.
BODY
)"

create_issue 5 "Issue 5 - Improve error handling in product controller" "enhancement" "$(cat <<'BODY'
Current controller error handling is inconsistent.

## Tasks
- Add `try/catch` where needed.
- Return meaningful status codes.
- Avoid leaking raw internal errors to the client.

## Acceptance criteria
- `400` for validation/input problems.
- `404` when a product does not exist.
- `500` for unexpected server errors.
BODY
)"

create_issue 6 "Issue 6 - Add test for missing product name" "enhancement" "$(cat <<'BODY'
Add a test that verifies a product cannot be created without `name`.

## Tasks
- Check that validation fails.
- Assert that the returned error is reasonable.
- Keep the test isolated and readable.

## Acceptance criteria
- Behavior is covered by a clear and focused test.
BODY
)"

create_issue 7 "Issue 7 - Add minimum price validation" "enhancement" "$(cat <<'BODY'
Products should not allow negative prices.

## Tasks
- Update the Product schema.
- Add validation for `price >= 0`.
- Add tests for valid and invalid prices.

## Acceptance criteria
- Negative price is rejected.
- `0` and positive values are accepted.
BODY
)"

create_issue 8 "Issue 8 - Support price range filtering" "enhancement" "$(cat <<'BODY'
Extend `GET /products` so users can filter by price range.

Examples:
- `GET /products?minPrice=100`
- `GET /products?maxPrice=500`
- `GET /products?minPrice=100&maxPrice=500`

## Tasks
- Parse query params safely.
- Return filtered products.
- Add tests.

## Acceptance criteria
- Filters work independently and together.
- Invalid query values are handled consistently.
BODY
)"

create_issue 9 "Issue 9 - Add sorting to GET /products" "enhancement" "$(cat <<'BODY'
Support sorting products by `price` or `name`.

Examples:
- `GET /products?sort=price`
- `GET /products?sort=-price`
- `GET /products?sort=name`

## Tasks
- Interpret ascending and descending sort.
- Reject unsupported sort fields gracefully.
- Add tests for sorting behavior.

## Acceptance criteria
- Supported fields sort correctly.
- Unsupported sort fields return a predictable response.
BODY
)"

create_issue 10 "Issue 10 - Add pagination to GET /products" "enhancement" "$(cat <<'BODY'
Add pagination support to the products endpoint.

Examples:
- `GET /products?page=1&limit=5`
- `GET /products?page=2&limit=5`

## Tasks
- Use sensible defaults.
- Validate invalid input.
- Return paginated results only.
- Add tests.

Optional: include metadata such as `page`, `limit`, and `total`.
BODY
)"

create_issue 11 "Issue 11 - Refactor controller logic into a service layer" "enhancement" "$(cat <<'BODY'
The controller currently handles too much logic directly.

## Tasks
- Extract product-related business logic into a service module.
- Keep routes/controllers thin.
- Do not change external API behavior.
- Ensure tests still pass.

## Acceptance criteria
- External API behavior remains unchanged.
- Code organization is clearer and easier to maintain.
BODY
)"

create_issue 12 "Issue 12 - Add case-insensitive partial search" "enhancement" "$(cat <<'BODY'
Improve name filtering so it supports partial and case-insensitive search.

Example: `GET /products?name=shoe`

Should match:
- `Running Shoe`
- `shoe cleaner`
- `SHOE BOX`

## Tasks
- Use MongoDB/Mongoose query features appropriately.
- Keep behavior predictable.
- Add tests.

## Acceptance criteria
- Partial, case-insensitive matching works consistently.
BODY
)"

create_issue 13 "Issue 13 - Add validation test suite structure" "enhancement" "$(cat <<'BODY'
Refactor the tests so validation-related tests are grouped clearly.

## Tasks
- Use `describe` blocks.
- Improve naming.
- Keep setup readable.
- Add at least one missing edge case.

## Acceptance criteria
- Validation tests are easier to scan and extend.
BODY
)"

create_issue 14 "Issue 14 - Add category field with simple enum validation" "enhancement" "$(cat <<'BODY'
Add a lightweight optional `category` field to Product.

Allowed values:
- `electronics`
- `clothing`
- `home`

## Tasks
- Add `category` to the schema.
- Keep it optional.
- Restrict values to enum list.
- Update tests.

## Acceptance criteria
- Valid categories are accepted.
- Invalid categories fail with a clear message.
BODY
)"

echo "Done. Created all issues in the current GitHub repository context."
