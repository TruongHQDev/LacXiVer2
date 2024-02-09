//
//  LacXiVer2App.swift
//  LacXiVer2
//
//  Created by Trường  on 1/19/24.
//

import SwiftUI

@main
struct LacXiVer2App: App {
    var body: some Scene {
        
        WindowGroup {
            let _ = print(FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!.path)
            ContentView()
        }
    }
}
