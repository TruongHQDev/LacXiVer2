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

struct CollectionTextObject: Identifiable {
    var id = UUID()
    var title: String
    var textObjects: [TextObject]
}

struct SettingView: View {
    @Environment(\.dismiss) var dismiss
    @Binding var listText: [TextObject]
    @State var text: String
    @State var textTitle: String = ""
    @State var data: [TextObject] = [ ]
    var gridLayout = [ GridItem() ]
    @State var isShowAddNewCollection = false
    @State var listCollection: [CollectionTextObject] = []
    @State private var selectedCollection: String = ""
    @State var dataNewCollection: [TextObject] = []
    var gridLayoutNewCollection = [ GridItem() ]

    
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
                if isShowAddNewCollection {
                    VStack {
                        TextField("Enter title", text: $textTitle)
                            .background(Color.white)
                            .foregroundColor(Color.black)
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
                            LazyVGrid(columns: gridLayoutNewCollection) {
                                ForEach(dataNewCollection, id: \.id) { item in
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
                } else {
                    VStack(spacing: 20) {
                        Button {
                            //Add new Collection
                            isShowAddNewCollection = true
                        } label: {
                            ButtonView(text: "Add New", fontSize: 20, width: 150, height: 40)
                        }
                        
                        HStack(spacing: 3) {
                            Text("Collection:")
                                .font(.appFont(.bold, size: 15))
                                .foregroundColor(Color.black)
                            if selectedCollection != "" {
                                Picker("Select Collection", selection: $selectedCollection) {
                                    ForEach(listCollection, id: \.title) {
                                        Text($0.title)
                                    }
                                }
                                .frame(width: 150, height: 40, alignment: .leading)
                                .pickerStyle(.menu)
                                .onChange(of: selectedCollection) { value in
                                    print("value \(selectedCollection)")
                                    for item in listCollection {
                                        if item.title == selectedCollection {
                                            self.data = item.textObjects
                                            self.listText = self.data
                                        }
                                    }
                                }
                                Button(action: {
                                    for (i, item) in listCollection.enumerated() {
                                        if item.title == selectedCollection {
                                            listCollection.remove(at: i)
                                            if listCollection.count > 0 {
                                                selectedCollection = listCollection[0].title
                                            } else {
                                                selectedCollection = ""
                                                data.removeAll()
                                            }
                                            break
                                        }
                                    }
                                }, label: {
                                    Image(systemName: "trash")
                                        .foregroundColor(Color.black)
                                })
                            } else {
                                Text("")
                                    .frame(width: 150, height: 40)
                            }
                        }
                        
                        ScrollView {
                            LazyVGrid(columns: gridLayout) {
                                ForEach(data, id: \.id) { item in
                                    Text(item.text)
                                        .font(.appFont(.medium, size: 14))
                                        .foregroundColor(.black)
                                }
                            }
                        }
                        .frame(width: 250, height: 200)
                        .background(Color.appBeige.opacity(0.8))
                        .cornerRadius(15.0)
                        
                        Spacer()
                    }
                    .frame(width: 350, height: 340)
                }
                Spacer()
//                HStack(alignment: .center, spacing: 40, content: {
//                    Button {
//                        self.listText = data
//                        var listString: [String] = []
//                        for str in data {
//                            listString.append(str.text)
//                        }
//                        UserDefaults.standard.set(listString, forKey: "Data")
//                        dismiss()
//                    } label: {
//                        ButtonView(text: "Save", fontSize: 17, width: 100, height: 40)
//                    }
//            
//                    Button {
//                        self.data.removeAll()
//                    } label: {
//                        ButtonView(text: "Remove\nall", fontSize: 15, width: 100, height: 40)
//                    }
//                })
//                .frame(width: 400, height: 70)
                Spacer()
                    .frame(height: 70)
            }
        }
        .navigationBarHidden(true)
        .onAppear(perform: {
            //Load data from db
            self.listCollection.removeAll()
            self.listCollection.append(CollectionTextObject(title: "Trung Bình", textObjects: [TextObject(text: "abc"), TextObject(text: "xyz")]))
            self.listCollection.append(CollectionTextObject(title: "Trung Bình 2", textObjects: [TextObject(text: "abc 2"), TextObject(text: "xyz 2")]))
            
            selectedCollection = listCollection.first!.title
            for item in listCollection {
                if item.title == selectedCollection {
                    self.data = item.textObjects
                    self.listText = self.data
                }
            }
        })
        .onTapGesture {
            hideKeyboard()
        }
    }
}
