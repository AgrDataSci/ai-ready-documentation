#!/usr/bin/env bash
# SPDX-License-Identifier: MIT
#
# verify-history.sh
#
# Checks that the history of this repository has not been rewritten,
# using Software Heritage as an independent witness.
#
# Software Heritage (https://www.softwareheritage.org) archives public
# repositories on its own schedule and keeps every snapshot it takes.
# This script asks it for every snapshot of this repository and checks
# two things against the clone you are running it in.
#
#   1. Every commit that Software Heritage ever saw at the tip of main
#      is still part of main today. Adding commits passes. Removing or
#      rewriting commits fails.
#   2. Every tag that Software Heritage ever saw still exists and still
#      points to the same object. A moved or deleted tag fails.
#
# The script needs a full clone (not shallow) with tags, plus bash,
# git, curl and jq. It only reads. Run it from the repository root.
#
#   git clone https://github.com/AgrDataSci/maniva
#   cd maniva
#   bash tools/verify-history.sh
#
# Settings, all optional, as environment variables.
#   SWH_ORIGINS     space-separated repository URLs to look up
#                   (the repository was renamed, so both names count)
#   VERIFY_BRANCH   branch to check (default main)
#   VERIFY_REF      ref to compare against (default origin/<branch>)
#   SWH_API         Software Heritage API root
#
# Exit codes. 0 all checks passed (or nothing archived yet),
# 1 history differs from the archive, 2 the check could not run.

set -euo pipefail

SWH_API="${SWH_API:-https://archive.softwareheritage.org/api/1}"
SWH_ORIGINS="${SWH_ORIGINS:-https://github.com/AgrDataSci/maniva https://github.com/AgrDataSci/ai-ready-documentation}"
VERIFY_BRANCH="${VERIFY_BRANCH:-main}"
VERIFY_REF="${VERIFY_REF:-origin/${VERIFY_BRANCH}}"

passed=0
failed=0
warned=0
archived_origins=0
report=""

log() { printf '%s\n' "$*"; report+="$*"$'\n'; }
pass() { passed=$((passed + 1)); log "PASS  $*"; }
fail() { failed=$((failed + 1)); log "FAIL  $*"; }
warn() { warned=$((warned + 1)); log "WARN  $*"; }
die() { printf 'ERROR %s\n' "$*" >&2; exit 2; }

for tool in git curl jq; do
  command -v "$tool" >/dev/null 2>&1 || die "$tool is required but not installed."
done

git rev-parse --git-dir >/dev/null 2>&1 || die "Run this script inside a clone of the repository."

if [ "$(git rev-parse --is-shallow-repository)" = "true" ]; then
  die "This clone is shallow. Run 'git fetch --unshallow --tags' or clone again without --depth."
fi

if ! git rev-parse -q --verify "${VERIFY_REF}^{commit}" >/dev/null; then
  VERIFY_REF="$VERIFY_BRANCH"
  git rev-parse -q --verify "${VERIFY_REF}^{commit}" >/dev/null \
    || die "Cannot find branch ${VERIFY_BRANCH} in this clone."
fi

current_tip="$(git rev-parse "${VERIFY_REF}^{commit}")"
tmp="$(mktemp -d)"
trap 'rm -rf "$tmp"' EXIT

# fetch URL OUTFILE. Returns 0 on success, 1 when not found, 2 on any
# other error.
fetch() {
  local code
  code="$(curl -sS -L -m 60 -o "$2" -w '%{http_code}' "$1" 2>/dev/null)" || return 2
  case "$code" in
    200) return 0 ;;
    404) return 1 ;;
    *) return 2 ;;
  esac
}

log "Checking ${VERIFY_REF} at ${current_tip:0:12} against Software Heritage"
log ""

declare -A seen_snapshot=()

for origin in $SWH_ORIGINS; do
  status=0
  fetch "${SWH_API}/origin/${origin}/visits/?per_page=1000" "$tmp/visits.json" || status=$?
  if [ "$status" -eq 1 ]; then
    log "INFO  ${origin} has not been archived yet."
    continue
  elif [ "$status" -ne 0 ]; then
    die "Could not reach Software Heritage for ${origin}. Try again later."
  fi

  archived_origins=$((archived_origins + 1))

  # One line per usable visit, oldest first. date<TAB>snapshot
  jq -r '[.[] | select(.snapshot != null)] | sort_by(.date) | .[] | "\(.date)\t\(.snapshot)"' \
    "$tmp/visits.json" > "$tmp/snapshots.tsv"

  n_visits="$(wc -l < "$tmp/snapshots.tsv" | tr -d ' ')"
  log "INFO  ${origin} has ${n_visits} archived snapshot(s)."

  while IFS=$'\t' read -r visit_date snapshot; do
    [ -n "${seen_snapshot[$snapshot]:-}" ] && continue
    seen_snapshot[$snapshot]=1
    day="${visit_date:0:10}"

    fetch "${SWH_API}/snapshot/${snapshot}/?branches_count=10000" "$tmp/snap.json" \
      || die "Could not read snapshot ${snapshot} from Software Heritage."

    if [ "$(jq -r '.next_branch // empty' "$tmp/snap.json")" != "" ]; then
      warn "Snapshot of ${day} has more refs than one page. Only the first page was checked."
    fi

    # Check 1. The archived tip of the branch is still in its history.
    archived_tip="$(jq -r --arg b "refs/heads/${VERIFY_BRANCH}" \
      '.branches[$b] | select(. != null and .target_type == "revision") | .target' "$tmp/snap.json")"
    if [ -n "$archived_tip" ]; then
      if ! git cat-file -e "${archived_tip}^{commit}" 2>/dev/null; then
        fail "${VERIFY_BRANCH} on ${day} was ${archived_tip:0:12}, which no longer exists in this repository."
      elif ! git merge-base --is-ancestor "$archived_tip" "$current_tip"; then
        fail "${VERIFY_BRANCH} on ${day} was ${archived_tip:0:12}, which is no longer part of ${VERIFY_BRANCH}."
      else
        pass "${VERIFY_BRANCH} on ${day} (${archived_tip:0:12}) is still part of ${VERIFY_BRANCH}."
      fi
    fi

    # Check 2. Every archived tag still exists and has not moved.
    while IFS=$'\t' read -r ref target; do
      [ -z "$ref" ] && continue
      tag="${ref#refs/tags/}"
      local_target="$(git rev-parse -q --verify "refs/tags/${tag}" 2>/dev/null || true)"
      if [ -z "$local_target" ]; then
        fail "Tag ${tag}, archived on ${day}, has been deleted."
      elif [ "$local_target" != "$target" ]; then
        fail "Tag ${tag} pointed to ${target:0:12} on ${day} and now points to ${local_target:0:12}."
      else
        pass "Tag ${tag} still points to ${target:0:12}, as archived on ${day}."
      fi
    done < <(jq -r '.branches | to_entries[]
      | select(.key | startswith("refs/tags/"))
      | select(.value != null)
      | "\(.key)\t\(.value.target)"' "$tmp/snap.json")
  done < "$tmp/snapshots.tsv"
done

log ""
if [ "$archived_origins" -eq 0 ]; then
  log "RESULT Nothing to compare yet. Software Heritage has not archived this repository."
  result=0
elif [ "$failed" -gt 0 ]; then
  log "RESULT ${failed} check(s) failed, ${passed} passed. The history differs from the independent archive."
  result=1
else
  log "RESULT All ${passed} check(s) passed. The history matches every archived snapshot."
  result=0
fi

if [ -n "${GITHUB_STEP_SUMMARY:-}" ]; then
  {
    echo "## History verification"
    echo
    echo '```'
    printf '%s' "$report"
    echo '```'
  } >> "$GITHUB_STEP_SUMMARY"
fi

exit "$result"
