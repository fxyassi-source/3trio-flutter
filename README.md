# 3TRIO Flutter

Fresh, standalone Flutter implementation of 3TRIO.

## Isolation rule
This repository is independent from the legacy Kotlin/Jetpack Compose project. Do not merge or copy the old Android source into this project.

## Product rules
- Adults 18+
- Exactly 5 bottom tabs: Discover, Feed, Map, Likes, Messages
- Maximum 5 profile photos
- Mandatory photo, government-ID and in-app voice verification
- Free users: 100 likes per rolling 24 hours
- Premium: unlimited likes + see who liked you
- Premium pricing: ₹500 monthly / ₹2,500 six months / ₹4,000 yearly
- KM/Miles setting is global
- Map uses approximate/obfuscated location only; never expose exact GPS

## Build
GitHub Actions generates the Android platform project, runs `flutter analyze`, and builds a release APK.

Production integrations such as Firebase, maps, verification, notifications, WebRTC and billing will be added behind modular services/repositories and must not be faked.
