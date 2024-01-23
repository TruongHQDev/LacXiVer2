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
                ZStack {
                    Image("bgMain")
                        .resizable()
                        .scaledToFill()
                        .clipped()
                        .ignoresSafeArea()
                    VStack {
                        Spacer()
                            .frame(height: 70)
                        Text("Lắc Xì")
                            .font(.titleFont(.regular, size: 70))
                        Text("by hqt198 a.k.a Quang Trường")
                            .font(.appFont(.bold, size: 17))
                        Spacer()
                        NavigationLink(destination: ShakeScreen()) {
                            ZStack {
                                Image("backgroundButton")
                                    .resizable()
                                    .scaledToFit()
                                Text("BẮT ĐẦU")
                                    .font(.titleFont(.regular, size: 40))
                                    .foregroundColor(Color.appDarkGreen)
                            }
                            .frame(width: 200)
                            .offset(y: 30)
                        }
                        Spacer()
                        HStack {
                            NavigationLink(destination: SettingView()) {
                                Image("setting")
                                    .resizable()
                                    .scaledToFit()
                                    .frame(width: 50, height: 50)
                            }
                            Spacer()
                                .frame(width: 40)
                            NavigationLink(destination: TutorialView()) {
                                Image("tutorial")
                                    .resizable()
                                    .scaledToFit()
                                    .frame(width: 50, height: 50)
                            }
                        }
                        Spacer()
                            .frame(height: 350)
                    }
                }
            }
            .navigationBarHidden(true)
            .navigationSplitViewStyle(.automatic)
            
        }
        .ignoresSafeArea()
    }
}
