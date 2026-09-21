---
name: update-firefox-policy
description: Sync the macOS Firefox policy profile with upstream just-the-browser. Use when asked to update, refresh, or sync the Firefox policies/mobileconfig.
---

# Update Firefox policy

Target: `__others/MacOS/profiles/kism-dotfiles.firefox.mobileconfig`

Upstream: https://raw.githubusercontent.com/corbindavenport/just-the-browser/main/firefox/firefox.mobileconfig

Policy reference: https://github.com/mozilla/policy-templates/blob/master/mac/org.mozilla.firefox.plist

## Steps

1. Fetch upstream (`curl -s <url>`) and read the target file.
2. Diff the upstream `org.mozilla.firefox` payload against the target's policy keys. Only the stable Firefox payload matters; ignore Developer Edition and Nightly payloads.
3. Merge new or changed upstream policies into the target, keeping the target's formatting (4-space indent, one-line `<key>..</key><value/>` where it fits) and its existing PayloadIdentifier/PayloadUUID values.
4. Validate: `python3 -c "import plistlib;plistlib.load(open('__others/MacOS/profiles/kism-dotfiles.firefox.mobileconfig','rb'))"`.
5. Summarise what was added, changed, and deliberately skipped. Don't commit unless asked.

## User preferences (always hold)

- Do NOT add `DisableTelemetry` or `DisableFirefoxStudies`, because analytics and studies are fine.
- No references to justthebrowser.com (identifiers, organization, comments).
- Keep YouTube in `SearchEngines.Add` (`@youtube`, `https://www.youtube.com/results?search_query={searchTerms}`).
- Keep translation enabled: `TranslateEnabled` true, `AIControls.Translations` = `available`.
- Keep the user's own policies (extensions, password manager/autofill off, `NoDefaultBookmarks`, `FirefoxHome` layout) unless upstream renames a key, in which case use the new name.
