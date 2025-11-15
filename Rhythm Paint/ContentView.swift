//
//  ContentView.swift
//  Rhythm Paint
//
//  Created by Korgo on 11/14/25.
//

import SwiftUI

struct ContentView: View {
    @State private var display = "title"
    var body: some View {
        ZStack {
            switch display {
            case "title":
                TitleView {
                    withAnimation {
                        self.display = "onboarding"
                    }
                }
                .transition(.move(edge: .leading).combined(with: .opacity))
            case "onboarding":
                OnboardingView {
                    withAnimation {
                        self.display = "player"
                    }
                }
                .transition(.asymmetric(
                    insertion: .move(edge: .trailing).combined(with: .opacity),
                    removal: .move(edge: .leading).combined(with: .opacity)
                ))
            case "player":
                PlayerView()
                    .transition(.move(edge: .trailing).combined(with: .opacity))
            default:
                PlayerView()
            }
        }
        .animation(.easeInOut(duration: 0.5), value: display)
    }
    
}

#Preview {
    ContentView()
}
