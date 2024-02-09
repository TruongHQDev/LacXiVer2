//
//  ContentView.swift
//  LacXiVer2
//
//  Created by Trường  on 1/19/24.
//

import SwiftUI

struct ContentView: View {
    
//    @State var listText: [TextObject] = ["Chúc may mắn nha!", "20.000đ", "5.000đ", "Lại đi!", "5.000đ", "5.000đ", "5.000đ", "5.000đ", "5.000đ", "5.000đ", "5.000đ", "10.000đ", "10.000đ", "10.000đ", "5.000đ", "May mắn lần sau nghen!", "Liu liu!"]
//    @State var listText: [TextObject] = [TextObject(text: "10.000đ"), TextObject(text: "20.000đ"), TextObject(text: "50.000đ"), TextObject(text: "Chúc Mừng Năm Mới!")]
    @State var listText: [TextObject] = []
    @State var selectedCollectionModel: CollectionModel = CollectionModel()
    
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
                            .foregroundColor(.appDarkBrown)
                        Text("by hqt198 a.k.a Quang Trường")
                            .font(.appFont(.bold, size: 17))
                            .foregroundColor(.appDarkBrown)
                        Spacer()
                        NavigationLink(destination: ShakeScreen(listText: $listText)) {
                            ZStack {
                                Image("backgroundButton")
                                    .resizable()
                                    .scaledToFit()
                                Text("Start")
                                    .font(.titleFont(.regular, size: 40))
                                    .foregroundColor(Color.appDarkGreen)
                            }
                            .frame(width: 200)
                            .offset(y: 30)
                        }
                        Spacer()
                        HStack {
                            NavigationLink(destination: SettingView(listText:$listText, selectedCollectionModel: $selectedCollectionModel)) {
                                Image("setting")
                                    .resizable()
                                    .scaledToFit()
                                    .frame(width: 50, height: 50)
                                    .foregroundColor(.appDarkBrown)
                            }
                            Spacer()
                                .frame(width: 40)
                            NavigationLink(destination: TutorialView()) {
                                Image("tutorial")
                                    .resizable()
                                    .scaledToFit()
                                    .frame(width: 50, height: 50)
                                    .foregroundColor(.appDarkBrown)
                            }
                        }
                        Spacer()
                            .frame(height: 350)
                    }
                }
            }
            .navigationBarHidden(true)
        }
        .ignoresSafeArea()
        .onAppear(perform: {

        })
    }
}
