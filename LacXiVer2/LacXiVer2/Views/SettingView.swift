//
//  SettingView.swift
//  LacXiVer2
//
//  Created by Trường  on 1/20/24.
//

import SwiftUI
import RealmSwift

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
    @ObservedResults(CollectionModel.self) var collections
    @Environment(\.dismiss) var dismiss
    @Binding var listText: [TextObject]
    @State var text: String = ""
    @State var textTitle: String = ""
    @State var data: [TextObject] = [ ]
    var gridLayout = [ GridItem() ]
    @State var isShowAddNewCollection = false
//    @State var listCollection: [CollectionTextObject] = []
    @State private var selectedCollection: String = ""
    @Binding var selectedCollectionModel: CollectionModel
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
                        TextField("Enter collection title", text: $textTitle)
                            .background(Color.white)
                            .foregroundColor(Color.black)
                            .frame(width: 250)
                        HStack {
                            TextField("Enter text", text: $text)
                                .background(Color.white)
                                .foregroundColor(Color.black)
                            Button(action: {
                                let grid = TextObject(text: text)
                                if grid.text != ""  {
                                    dataNewCollection.insert(grid, at: 0)
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
                                        .font(.appFont(.medium, size: 16))
                                        .foregroundColor(.black)
                                }
                            }
                        }
                        .frame(width: 250, height: 300)
                        .background(Color.appBeige.opacity(0.8))
                        .cornerRadius(15.0)
                        
                        HStack(alignment: .center, spacing: 40, content: {
                            Button {
                                let newCollect = CollectionModel()
                                newCollect.name = textTitle
                                for object in dataNewCollection {
                                    let model = TextModel(text: object.text)
                                    newCollect.textObjects.append(model)
                                }
                                
                                $collections.append(newCollect)
                                selectedCollectionModel = newCollect
                                data = dataNewCollection
                                listText = data
                                selectedCollection = textTitle
                                isShowAddNewCollection = false
                                textTitle = ""
                                text = ""
                                dataNewCollection.removeAll()
                            } label: {
                                ButtonView(text: "Save", fontSize: 17, width: 100, height: 40)
                            }
                            
                            Button {
                                isShowAddNewCollection = false
                            } label: {
                                ButtonView(text: "Back", fontSize: 15, width: 100, height: 40)
                            }
                        })
                        .frame(width: 400, height: 70)
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
                                    ForEach(collections, id: \.name) {
                                        Text($0.name)
                                    }
                                }
                                .frame(width: 150, height: 40, alignment: .leading)
                                .pickerStyle(.menu)
                                .onChange(of: selectedCollection) { value in
                                    print("value \(selectedCollection)")
                                    for item in collections {
                                        if item.name == selectedCollection {
                                            selectedCollectionModel = item
                                            fetchDataFromSelectecCollectionModel()
                                            break
                                        }
                                    }
                                }
                                Button(action: {
                                    let realm = try! Realm()
                                    
                                    try! realm.write {
                                        // Delete all objects from the realm.
                                        realm.delete(realm.objects(CollectionModel.self).filter("name=%@", selectedCollectionModel.name))

                                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.01) {
                                            if collections.count > 0 {
                                                for collection in collections {
                                                    selectedCollectionModel = collection
                                                    fetchDataFromSelectecCollectionModel()
                                                    return
                                                }
                                            } else {
                                                resetData()
                                            }
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
                                        .font(.appFont(.medium, size: 16))
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
                if !isShowAddNewCollection {
                    Button {
                        dismiss()
                    } label: {
                        ButtonView(text: "Home", fontSize: 20, width: 150, height: 40)
                    }
                }
                Spacer()
                    .frame(height: 70)
            }
        }
        .navigationBarHidden(true)
        .onAppear(perform: {
            //Load data from db
            if selectedCollectionModel.textObjects.count < 1 {
                if let collect = collections.first {
                    selectedCollectionModel = collect
                }
            }
            selectedCollection = selectedCollectionModel.name
            fetchDataFromSelectecCollectionModel()
        })
        .onTapGesture {
            hideKeyboard()
        }
    }
    
    func fetchDataFromSelectecCollectionModel() {
        data.removeAll()
        for text in selectedCollectionModel.textObjects {
            let newText = TextObject(text: text.text)
            data.append(newText)
        }
        self.listText = self.data
    }
    
    func resetData() {
        selectedCollection = ""
        selectedCollectionModel = CollectionModel(name: "", textObjects: List<TextModel>())
        self.data.removeAll()
        self.listText.removeAll()
    }
}
