//
//  SettingView.swift
//  LacXiVer2
//
//  Created by Trường  on 1/20/24.
//

import SwiftUI

struct TextObject: Identifiable {
    var id = UUID()
    var text: String
}

struct SettingView: View {
    @Environment(\.dismiss) var dismiss
    @Binding var listText: [TextObject]
    @State var text: String
    @State var data: [TextObject] = [ ]
    var gridLayout = [ GridItem() ]
    
    var body: some View {
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
                Text("Setting View")
                    .font(.titleFont(.regular, size: 50))
                    .foregroundColor(.appDarkBrown)
                Spacer()
                    .frame(height: 30)
                VStack {
                    HStack {
                        TextField("Enter text", text: $text)
                            .background(Color.white)
                            .foregroundColor(Color.black)
                        Button(action: {
                            let grid = TextObject(text: text)
                            if grid.text != ""  {
                                data.insert(grid, at: 0)
                            }
                        }) {
                            Image(systemName: "plus.circle.fill")
                        }
                    }
                    .frame(width: 200, height: 40)
                    ScrollView {
                        LazyVGrid(columns: gridLayout) {
                            ForEach(data, id: \.id) { item in
                                Text(item.text)
                                    .font(.appFont(.medium, size: 12))
                                    .foregroundColor(.black)
                            }
                        }
                    }
                    .frame(width: 250, height: 300)
                    .background(Color.appBeige.opacity(0.8))
                    .cornerRadius(15.0)
                }
                Spacer()
                HStack(alignment: .center, spacing: 40, content: {
                    Button {
                        self.listText = data
                        var listString: [String] = []
                        for str in data {
                            listString.append(str.text)
                        }
                        UserDefaults.standard.set(listString, forKey: "Data")
                        dismiss()
                    } label: {
                        Text("Save")
                            .font(.appFont(.bold, size: 20))
                            .foregroundColor(Color.appDarkGreen)
                            .frame(width: 100, height: 50)
                            .background(Color.appDarkBrown)
                            .cornerRadius(10.0)
                    }
            
                    Button {
                        self.data.removeAll()
                    } label: {
                        Text("Remove\nall")
                            .font(.appFont(.bold, size: 20))
                            .foregroundColor(Color.appDarkGreen)
                            .frame(width: 100, height: 50)
                            
                            .background(Color.appDarkBrown)
                            .cornerRadius(10.0)
                    }
                })
                .frame(width: 400, height: 70)
                Spacer()
                    .frame(height: 70)
            }
        }
        .navigationBarHidden(true)
        .onAppear(perform: {
            data = self.listText
        })
        .onTapGesture {
            hideKeyboard()
        }
    }
}
