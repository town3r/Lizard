//
//  PhysicsTabView.swift
//  Lizard
//
//  Main physics simulation tab containing the lizard game
//

import SwiftUI

struct PhysicsTabView: View {
    var body: some View {
        NavigationView {
            ContentView()
                .navigationBarHidden(true)
        }
        .navigationViewStyle(StackNavigationViewStyle())
    }
}

#Preview {
    PhysicsTabView()
}
