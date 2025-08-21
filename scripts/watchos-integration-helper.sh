#!/bin/bash

# watchOS Integration Helper Script
# This script helps prepare the project for watchOS integration in Xcode

set -e

echo "🍎 Lizard watchOS Integration Helper"
echo "===================================="

# Check if we're in the right directory
if [ ! -f "Lizard.xcodeproj/project.pbxproj" ]; then
    echo "❌ Error: Not in Lizard project root directory"
    echo "Please run this script from the root of the Lizard project"
    exit 1
fi

echo "✅ Found Lizard project"

# Check if watchOS source files exist
if [ ! -d "LizardWatch WatchKit App" ]; then
    echo "❌ Error: LizardWatch WatchKit App directory not found"
    exit 1
fi

if [ ! -d "LizardWatchTests" ]; then
    echo "❌ Error: LizardWatchTests directory not found" 
    exit 1
fi

echo "✅ Found watchOS source files"

# Create backup of current project
echo "📦 Creating backup of current project..."
cp -r Lizard.xcodeproj Lizard.xcodeproj.backup
echo "✅ Backup created: Lizard.xcodeproj.backup"

# Verify watchOS files
echo "🔍 Verifying watchOS files..."
WATCHOS_FILES=(
    "LizardWatch WatchKit App/LizardWatchApp.swift"
    "LizardWatch WatchKit App/ContentView.swift"
    "LizardWatch WatchKit App/WatchGameCenterManager.swift"
    "LizardWatch WatchKit App/WatchSoundPlayer.swift"
    "LizardWatch WatchKit App/Info.plist"
    "LizardWatch WatchKit App/LizardWatch.entitlements"
    "LizardWatchTests/LizardWatchTests.swift"
)

for file in "${WATCHOS_FILES[@]}"; do
    if [ -f "$file" ]; then
        echo "✅ $file"
    else
        echo "❌ Missing: $file"
        exit 1
    fi
done

echo ""
echo "🎯 Pre-integration checklist complete!"
echo ""
echo "Next steps:"
echo "1. Open Lizard.xcodeproj in Xcode"
echo "2. Follow the integration guide in docs/WATCHOS_INTEGRATION.md"
echo "3. Add targets in this order:"
echo "   - LizardTests (iOS Unit Tests)"
echo "   - LizardWatch (watchOS App)"  
echo "   - LizardWatchTests (watchOS Unit Tests)"
echo ""
echo "📖 For detailed instructions, see: docs/WATCHOS_INTEGRATION.md"
echo ""
echo "💡 Tip: Keep the backup (Lizard.xcodeproj.backup) until integration is verified"