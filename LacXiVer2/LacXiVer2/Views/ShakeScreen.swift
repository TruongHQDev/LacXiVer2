//
//  ShakeScreen.swift
//  LacXiVer2
//
//  Created by Trường  on 1/19/24.
//

import SwiftUI

struct ShakeScreen: View {
    @State private var viewModel = ViewModel()
    private let listText: [String] = ["Không có gì!", "Có nha", "Còn khuya"]
    
    var body: some View {
        GeometryReader { geo in
            ZStack {
                Image("backgroundShake")
                    .resizable()
                    .scaledToFill()
                    .frame(width: geo.size.width, height: geo.size.height)
                    .clipped()
                VStack {
                    Text("Lắc Xì")
                    Text("by hqt198")
                    ZStack {
                        
                    }
                    .frame(width: geo.size.width / 3, height: geo.size.height / 3)
                    .background(Color.blue)
                    
                }
            }
            .background(Color.yellow)
            .ignoresSafeArea()
            .toolbar(.hidden)
            .frame(width: geo.size.width, height: geo.size.height)
        }
        .ignoresSafeArea()
        .background(Color.green)
        .onShake {
            print("Device shaken!")
            viewModel.getMoney(type: .tetDong)
//            viewModel.getMoney(type: .text, 0, 0, listText)
//            viewModel.getMoney(type: .number, 0, 100)
        }
    }
}

#Preview {
    ShakeScreen()
}


extension ShakeScreen {
    @Observable
    class ViewModel {
        func getMoney(type: LiXiType,_ minValue: Int = 0,_ maxValue: Int = 5,_ listText: [String] = []) -> String {
            var money: String = ""
            switch type {
            case .number:
                //random number (example: 100 for 100$)
                money = self.randomNumber(from: minValue, to: maxValue)
                break
            case .text:
                //Custom text which defined at Setting View
                money = self.randomText(list: listText)
                break
            case .tetDong:
                //A multiple of 10.000 (10.000 is minimum money by Polyester at Viet Nam
                money =  self.randomVietnameseDong(from: minValue, to: maxValue)
                break
            }
            
            return money
        }
        
        
        private func randomVietnameseDong(from minValue: Int, to maxValue: Int) -> String { //A multiple of 10.
            let randomInt = Int.random(in: minValue...maxValue)
            print("VietnamDong: \(randomInt * 10000)đ")
            return "\(randomInt)"
            
        }
        
        private func randomNumber(from minValue: Int, to maxValue: Int) -> String {
            let randomInt = Int.random(in: minValue...maxValue)
            print("Number: \(randomInt)$")
            return "\(randomInt)"
        }
        
        private func randomText(list: [String]) -> String {
            let randomInt = Int.random(in: 0..<list.count)
            let text = list[randomInt]
            print("Text: \(text)")
            return text
        }
    }
}

enum LiXiType: Int {
    case text = 0
    case number = 1
    case tetDong = 2
}
