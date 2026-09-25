#!/bin/bash
#
# Apply the ROM tree patches for the Ctyon CT07.
#
#   device/bird/ct07/patches/apply-patches.sh [ROM root]
#
# Every patch is applied with "git am" on the checked-out revision of its
# project. Patches whose subject is already in the project's recent history
# are skipped, so the script can be re-run, e.g. after a repo sync.
#

set -e

VERSION=lineage-16.0
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
        if grep -qxF "$subject" <<< "$applied"; then
            echo "   applied: $subject"
            continue
        fi
        if git -C "$repo" am -3 -q "$patch"; then
            echo "   ok:      $subject"
        else
            git -C "$repo" am --abort || true
            echo "!! $project: $subject does not apply" >&2
            failed=1
            break
        fi
    done
done

exit $failed
