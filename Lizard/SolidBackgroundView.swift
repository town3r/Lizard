import SwiftUI

/// Simple solid color background that adapts to light/dark mode
struct SolidBackgroundView: View {
    @Environment(\.colorScheme) private var colorScheme
    
    var body: some View {
        Rectangle()
            .fill(colorScheme == .dark ? Color.black : Color.white)
            .ignoresSafeArea()
    }
}

#Preview {
    SolidBackgroundView()
}