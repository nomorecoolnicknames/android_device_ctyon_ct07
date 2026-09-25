#!/bin/bash
#
# Apply the ROM tree patches for the Ctyon CT07.
#
#   device/bird/ct07/patches/apply-patches.sh [ROM root]
#
# Run it after the MediaTek patch set. Every patch is applied with "git am"
# on the checked-out revision of its project. A patch that touches files the
# MediaTek patch set has left modified in the working tree is applied to the
# working tree with "git apply" instead. Patches that are already applied are
# skipped, so the script can be re-run.
#

set -e

VERSION=lineage-14.1
HERE="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
ROOT="$(cd "${1:-$HERE/../../../..}" && pwd)"
PATCHES="$HERE/$VERSION"

if [ ! -f "$ROOT/build/envsetup.sh" ] && [ ! -f "$ROOT/build/make/envsetup.sh" ]; then
    echo "$ROOT does not look like a ROM tree" >&2
    exit 1
fi

if ! git config user.email > /dev/null; then
    export GIT_COMMITTER_NAME="ct07 patches"
    export GIT_COMMITTER_EMAIL="ct07-patches@localhost"
fi

failed=0
for dir in $(cd "$PATCHES" && find . -name '*.patch' -printf '%h\n' | sort -u); do
    project="${dir#./}"
    repo="$ROOT/$project"
    if [ ! -d "$repo/.git" ] && [ ! -f "$repo/.git" ]; then
        echo "!! $project: not a git project in $ROOT" >&2
        failed=1
        continue
    fi
    echo "== $project"
    applied="$(git -C "$repo" log --format=%s -n 500)"
    for patch in "$PATCHES/$project"/*.patch; do
        subject="$(git mailinfo /dev/null /dev/null < "$patch" | sed -n 's/^Subject: //p')"
        if grep -qxF "$subject" <<< "$applied" ||
                git -C "$repo" apply --check -R "$patch" 2> /dev/null; then
            echo "   applied: $subject"
            continue
        fi
        files="$(sed -n 's|^+++ b/||p' "$patch")"
        if [ -n "$(git -C "$repo" status --porcelain -- $files)" ]; then
            if git -C "$repo" apply "$patch"; then
                echo "   ok:      $subject (working tree)"
                continue
            fi
        elif git -C "$repo" am -3 -q "$patch"; then
            echo "   ok:      $subject"
            continue
        else
            git -C "$repo" am --abort || true
        fi
        echo "!! $project: $subject does not apply" >&2
        failed=1
        break
    done
done

exit $failed
