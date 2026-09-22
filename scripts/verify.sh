#!/bin/bash
# 从任意工作目录运行。只进行本地检查，不上传、不部署。
set -euo pipefail
course_root="$(cd "$(dirname "$0")/.." && pwd)"
cd "$course_root"
node scripts/check-course.mjs
swift test --package-path examples/SwiftFoundations
swift run --package-path examples/SwiftFoundations foundation-lab all
swift test --package-path examples/ConcurrencyLab
swift run --package-path examples/ConcurrencyLab ConcurrencyDemo all
swift -swift-version 6 examples/PlatformRecipes/Ownership.swift
swift -swift-version 6 examples/PlatformRecipes/TypedThrows.swift
xcrun swiftc -swift-version 6 -typecheck examples/PlatformRecipes/ImportWorkshop.swift examples/PlatformRecipes/LifecycleWorkshop.swift
xcodebuild -project examples/NativeStudy/NativeStudy.xcodeproj -scheme NativeStudy-macOS -destination 'platform=macOS' -derivedDataPath artifacts/DerivedData-macOS CODE_SIGNING_ALLOWED=NO test
xcodebuild -project examples/NativeStudy/NativeStudy.xcodeproj -scheme NativeStudy-iOS -destination 'generic/platform=iOS Simulator' -derivedDataPath artifacts/DerivedData-iOS CODE_SIGNING_ALLOWED=NO build
