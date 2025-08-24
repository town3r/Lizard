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
                .navigationTitle("Lizard Physics")
                .navigationBarTitleDisplayMode(.inline)
        }
        .navigationViewStyle(StackNavigationViewStyle())
    }
}

#Preview {
    PhysicsTabView()
}
