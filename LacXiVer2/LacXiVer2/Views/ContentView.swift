//
//  ContentView.swift
//  LacXiVer2
//
//  Created by Trường  on 1/19/24.
//

import SwiftUI

struct ContentView: View {
    
    var body: some View {
        ZStack {
            NavigationView {
                VStack {
                    Text("Lắc Xì")
                        .font(.azuki(.regular, size: 50))
                    Text("by Trường aka hqt198")
                    NavigationLink(destination: ShakeScreen()) {
                        Text("Start")
                            .background(Color.blue)
                            .foregroundColor(Color.black)
                    }
                    HStack {
                        NavigationLink(destination: SettingView()) {
                            Image(systemName: "cloud")
                        }
                        NavigationLink(destination: TutorialView()) {
                            Image(systemName: "circle")
                        }
                    }
                }
            }
            .navigationBarHidden(true)
            .navigationSplitViewStyle(.automatic)
            
        }
        .ignoresSafeArea()
    }
}

#Preview {
    ContentView()
}
