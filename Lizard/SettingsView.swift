import SwiftUI

// MARK: - Settings View (Liquid Glass-ready)

struct SettingsView: View {
    @AppStorage("maxLizards") private var maxLizards: Int = 300
    @AppStorage("lizardSize") private var lizardSize: Double = 80.0
    @AppStorage("rainIntensity") private var rainIntensity: Int = 15

    // Weather settings
    @AppStorage("weatherAutoMode") private var weatherAutoMode: Bool = true
    @AppStorage("weatherOffMode") private var weatherOffMode: Bool = false
    @AppStorage("manualWeatherCondition") private var manualWeatherConditionRaw: String = "clear"

    @Environment(\.dismiss) private var dismiss

    var onSettingsChange: (() -> Void)?
    var onWeatherChange: ((WeatherCondition) -> Void)?
    var onModeChange: ((Bool) -> Void)?

    private var currentWeatherCondition: WeatherCondition {
        if weatherOffMode { return .none }
        switch manualWeatherConditionRaw {
        case "clear":         return .clear
        case "partlyCloudy":  return .partlyCloudy
        case "cloudy":        return .cloudy
        case "rain":          return .rain
        case "storm":         return .storm
        case "winter":        return .winter
        default:              return .clear
        }
    }

    var body: some View {
        NavigationView {
            ScrollView {
                VStack(spacing: 32) {
                    headerSection
                    settingsSection
                    descriptionSection
                    resetSection
                }
                .padding(.horizontal, 24)
                .padding(.vertical, 20)
            }
            // One background for the whole page
            .modifier(PageGlassBackground())
            .navigationTitle("Game Settings")
            .navigationBarTitleDisplayMode(.large)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Done") { dismiss() }
                        .font(.system(size: 16, weight: .semibold))
                        .modifier(GlassButtonStyle())
                }
            }
        }
        .onChange(of: maxLizards) { _, _ in onSettingsChange?() }
        .onChange(of: lizardSize) { _, _ in onSettingsChange?() }
        .onChange(of: rainIntensity) { _, _ in onSettingsChange?() }
        .onChange(of: weatherAutoMode) { _, newValue in onModeChange?(newValue) }
        .onChange(of: weatherOffMode) { _, _ in onWeatherChange?(currentWeatherCondition) }
        .onChange(of: manualWeatherConditionRaw) { _, _ in onWeatherChange?(currentWeatherCondition) }
    }

    // MARK: Header

    private var headerSection: some View {
        VStack(spacing: 16) {
            // Round “chip” with glass
            ZStack {
                RoundedRectangle(cornerRadius: 40, style: .continuous)
                    .frame(width: 80, height: 80)
                    .modifier(GlassChip())
                Image(systemName: "lizard.fill")
                    .font(.system(size: 32, weight: .medium))
                    .foregroundStyle(.green)
            }
            Text("Customize Your Lizard Experience")
                .font(.title2).fontWeight(.semibold)
                .multilineTextAlignment(.center)
                .foregroundStyle(.primary)
        }
        .padding(.top, 16)
    }

    // MARK: Settings

    private var settingsSection: some View {
        // Group everything so it reads as one slab if you prefer.
        Group {
            VStack(spacing: 24) {
                // Max Lizards
                settingCard(
                    title: "Max Lizards",
                    subtitle: "Maximum simultaneous lizards",
                    icon: "number.circle.fill",
                    iconColor: .blue
                ) {
                    VStack(spacing: 12) {
                        HStack {
                            Text("\(maxLizards)")
                                .font(.system(size: 20, weight: .bold, design: .monospaced))
                            Spacer()
                            Pill(text: "lizards", color: .blue)
                        }
                        LiquidGlassSlider(
                            value: Binding(
                                get: { Double(maxLizards) },
                                set: { maxLizards = Int($0) }
                            ),
                            range: 50...500,
                            step: 10,
                            color: .blue
                        )
                    }
                }

                // Lizard Size
                settingCard(
                    title: "Lizard Size",
                    subtitle: "Base size of spawned lizards",
                    icon: "resize",
                    iconColor: .orange
                ) {
                    VStack(spacing: 12) {
                        HStack {
                            Text("\(Int(lizardSize))")
                                .font(.system(size: 20, weight: .bold, design: .monospaced))
                            Spacer()
                            Pill(text: "points", color: .orange)
                        }
                        LiquidGlassSlider(
                            value: $lizardSize,
                            range: 40...120,
                            step: 5,
                            color: .orange
                        )
                    }
                }

                // Rain Intensity
                settingCard(
                    title: "Rain Intensity",
                    subtitle: "Lizards per rain burst",
                    icon: "cloud.rain.fill",
                    iconColor: .cyan
                ) {
                    VStack(spacing: 12) {
                        HStack {
                            Text("\(rainIntensity)")
                                .font(.system(size: 20, weight: .bold, design: .monospaced))
                            Spacer()
                            Pill(text: "per burst", color: .cyan)
                        }
                        LiquidGlassSlider(
                            value: Binding(
                                get: { Double(rainIntensity) },
                                set: { rainIntensity = Int($0) }
                            ),
                            range: 5...30,
                            step: 1,
                            color: .cyan
                        )
                    }
                }

                // Weather Settings
                settingCard(
                    title: "Weather Settings",
                    subtitle: "Control the weather effects in the game",
                    icon: "cloud.sun.fill",
                    iconColor: .purple
                ) {
                    VStack(spacing: 16) {
                        LiquidGlassToggle(
                            title: "Automatic Weather",
                            subtitle: "Dynamic weather based on conditions",
                            isOn: $weatherAutoMode,
                            color: .purple
                        )

                        if !weatherAutoMode {
                            VStack(alignment: .leading, spacing: 8) {
                                Text("Manual Weather")
                                    .font(.subheadline).fontWeight(.medium)
                                Picker("Weather Condition", selection: $manualWeatherConditionRaw) {
                                    Text("Clear").tag("clear")
                                    Text("Partly Cloudy").tag("partlyCloudy")
                                    Text("Cloudy").tag("cloudy")
                                    Text("Rain").tag("rain")
                                    Text("Storm").tag("storm")
                                    Text("Winter").tag("winter")
                                }
                                .pickerStyle(.segmented)
                                .padding(8)
                                .modifier(GlassCard(cornerRadius: 8))
                            }
                            .padding(12)
                            .modifier(GlassCard(cornerRadius: 10))
                        }

                        LiquidGlassToggle(
                            title: "Disable Weather",
                            subtitle: "Turn off all weather effects",
                            isOn: $weatherOffMode,
                            color: .red
                        )
                    }
                }
            }
        }
    }

    // MARK: Description

    private var descriptionSection: some View {
        VStack(alignment: .leading, spacing: 16) {
            HStack(spacing: 12) {
                Image(systemName: "info.circle.fill")
                    .font(.system(size: 20))
                    .foregroundStyle(.blue)
                Text("Setting Effects")
                    .font(.headline).fontWeight(.semibold)
            }
            VStack(alignment: .leading, spacing: 12) {
                infoRow(icon: "number.circle", text: "Max Lizards: Controls performance and visual density")
                infoRow(icon: "resize", text: "Lizard Size: Affects collision detection and visual impact")
                infoRow(icon: "cloud.rain", text: "Rain Intensity: Changes \"Make it Rain\" button behavior")
                infoRow(icon: "cloud.sun", text: "Weather Settings: Adjusts dynamic weather effects")
            }
        }
        .padding(20)
        .modifier(GlassCard(cornerRadius: 16))
    }

    private func infoRow(icon: String, text: String) -> some View {
        HStack(spacing: 12) {
            Image(systemName: icon)
                .font(.system(size: 14))
                .foregroundStyle(.blue)
                .frame(width: 20)
            Text(text)
                .font(.subheadline)
                .foregroundStyle(.secondary)
        }
    }

    // MARK: Reset

    private var resetSection: some View {
        Button(action: resetToDefaults) {
            HStack(spacing: 12) {
                Image(systemName: "arrow.counterclockwise")
                    .font(.system(size: 16, weight: .medium))
                Text("Reset to Defaults")
                    .font(.system(size: 16, weight: .semibold))
            }
            .foregroundStyle(.white)
            .frame(maxWidth: .infinity)
            .padding(.vertical, 16)
            .background(
                RoundedRectangle(cornerRadius: 16)
                    .fill(
                        LinearGradient(
                            colors: [.red.opacity(0.9), .red.opacity(0.7)],
                            startPoint: .topLeading, endPoint: .bottomTrailing
                        )
                    )
            )
            .overlay {
                RoundedRectangle(cornerRadius: 16)
                    .stroke(.white.opacity(0.3), lineWidth: 1)
            }
            .shadow(color: .red.opacity(0.25), radius: 8, x: 0, y: 4)
        }
        .buttonStyle(.plain)
    }

    private func settingCard<Content: View>(
        title: String,
        subtitle: String,
        icon: String,
        iconColor: Color,
        @ViewBuilder content: () -> Content
    ) -> some View {
        VStack(alignment: .leading, spacing: 16) {
            HStack(spacing: 16) {
                ZStack {
                    RoundedRectangle(cornerRadius: 10, style: .continuous)
                        .frame(width: 40, height: 40)
                        .modifier(GlassChip())
                    Image(systemName: icon)
                        .font(.system(size: 18, weight: .semibold))
                        .foregroundStyle(iconColor)
                }
                VStack(alignment: .leading, spacing: 4) {
                    Text(title)
                        .font(.headline).fontWeight(.semibold)
                    Text(subtitle)
                        .font(.caption)
                        .foregroundStyle(.secondary)
                }
                Spacer()
            }
            content()
        }
        .padding(20)
        .modifier(GlassCard(cornerRadius: 20))
    }

    private func resetToDefaults() {
        maxLizards = 300
        lizardSize = 80.0
        rainIntensity = 15
        weatherAutoMode = true
        weatherOffMode = false
        manualWeatherConditionRaw = "clear"
        onSettingsChange?()
    }
}

// MARK: - Liquid Glass Components

struct LiquidGlassSlider: View {
    @Binding var value: Double
    let range: ClosedRange<Double>
    let step: Double
    let color: Color

    var body: some View {
        VStack(spacing: 10) {
            Slider(value: $value, in: range, step: step)
                .tint(color)
                .padding(.horizontal, 6)
                .padding(.vertical, 12)
                .modifier(GlassCard(cornerRadius: 12))
        }
    }
}

struct LiquidGlassToggle: View {
    let title: String
    let subtitle: String
    @Binding var isOn: Bool
    let color: Color

    var body: some View {
        HStack {
            VStack(alignment: .leading, spacing: 4) {
                Text(title).font(.subheadline).fontWeight(.medium)
                Text(subtitle).font(.caption).foregroundStyle(.secondary)
            }
            Spacer()
            Toggle("", isOn: $isOn)
                .tint(color) // system switch adopts the new look on iOS 26
        }
        .padding(12)
        .modifier(GlassCard(cornerRadius: 10))
    }
}

// Little pill for units
private struct Pill: View {
    let text: String
    let color: Color
    var body: some View {
        Text(text)
            .font(.caption)
            .foregroundStyle(.secondary)
            .padding(.horizontal, 8)
            .padding(.vertical, 4)
            .background(
                Capsule().fill(color.opacity(0.12))
            )
            .overlay {
                Capsule().stroke(color.opacity(0.28), lineWidth: 0.5)
            }
    }
}

// MARK: - Glass Helpers (iOS 26 with fallback)

/// Page-wide background: Liquid Glass underlay on iOS 26, material fallback otherwise.
private struct PageGlassBackground: ViewModifier {
    func body(content: Content) -> some View {
        content
            .background {
                if #available(iOS 26.0, *) {
                    Rectangle()
                        .glassBackgroundEffect(in: .rect, displayMode: .underlay)
                        .ignoresSafeArea()
                } else {
                    // Fallback: single material layer with a faint vertical tint
                    ZStack {
                        Rectangle().fill(.ultraThinMaterial).ignoresSafeArea()
                        LinearGradient(
                            colors: [Color.primary.opacity(0.05), .clear, Color.primary.opacity(0.04)],
                            startPoint: .top, endPoint: .bottom
                        ).ignoresSafeArea()
                    }
                }
            }
    }
}

/// A card look that uses real Liquid Glass on iOS 26, otherwise a good material fallback.
struct GlassCard: ViewModifier {
    var cornerRadius: CGFloat = 20
    @Environment(\.colorScheme) private var scheme

    func body(content: Content) -> some View {
        if #available(iOS 26.0, *) {
            // True Liquid Glass
            GlassEffectContainer {
                content
                    .padding(.zero) // content already has padding where needed
                    .glassEffect(.regular, in: RoundedRectangle(cornerRadius: cornerRadius, style: .continuous))
            }
        } else {
            // Fallback: frosted card with hairline stroke and subtle highlight
            content
                .background(.ultraThinMaterial, in: RoundedRectangle(cornerRadius: cornerRadius, style: .continuous))
                .overlay {
                    RoundedRectangle(cornerRadius: cornerRadius, style: .continuous)
                        .strokeBorder(
                            LinearGradient(
                                colors: [
                                    .white.opacity(scheme == .light ? 0.22 : 0.12),
                                    .black.opacity(scheme == .light ? 0.06 : 0.22)
                                ],
                                startPoint: .topLeading, endPoint: .bottomTrailing
                            ),
                            lineWidth: 1
                        )
                }
                .overlay {
                    RoundedRectangle(cornerRadius: cornerRadius, style: .continuous)
                        .strokeBorder(.white.opacity(0.30))
                        .blendMode(.overlay)
                        .opacity(0.5)
                }
        }
    }
}

/// Smaller chip variant for icons and small controls.
struct GlassChip: ViewModifier {
    var cornerRadius: CGFloat = 10
    func body(content: Content) -> some View {
        if #available(iOS 26.0, *) {
            GlassEffectContainer {
                content
                    .glassEffect(.regular, in: RoundedRectangle(cornerRadius: cornerRadius, style: .continuous))
            }
        } else {
            content
                .background(.thinMaterial, in: RoundedRectangle(cornerRadius: cornerRadius, style: .continuous))
                .overlay {
                    RoundedRectangle(cornerRadius: cornerRadius, style: .continuous)
                        .stroke(.white.opacity(0.22), lineWidth: 1)
                }
        }
    }
}

/// Toolbar button that adopts the system’s glass style on iOS 26.
struct GlassButtonStyle: ViewModifier {
    func body(content: Content) -> some View {
        if #available(iOS 26.0, *) {
            content.buttonStyle(.glass)
        } else {
            content
                .foregroundStyle(.blue)
                .padding(.horizontal, 16)
                .padding(.vertical, 8)
                .background(.ultraThinMaterial, in: Capsule())
                .overlay { Capsule().stroke(.blue.opacity(0.3), lineWidth: 1) }
        }
    }
}

// MARK: - Preview

#Preview {
    SettingsView()
}
