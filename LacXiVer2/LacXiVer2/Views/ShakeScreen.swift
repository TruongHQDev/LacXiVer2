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
    
    @State var isGotMoney = false
    @State var moneyString = ""
    @State var lixiType: LiXiType = .text
    
    var body: some View {
        GeometryReader { geo in
            ZStack {
                Image("backgroundShake")
                    .resizable()
                    .scaledToFill()
                    .frame(width: geo.size.width, height: geo.size.height)
                    .clipped()
                
                VStack {
                    Spacer()
                        .frame(height: 70)
                    Text("Lắc Xì")
                        .font(.titleFont(.regular, size: 70))
                   Spacer()
                }
                
                if isGotMoney {
                    CongratulationView(moneyString: "\(moneyString)")
                        .frame(width: geo.size.width - 50, height: 300, alignment: .center)
                        .offset(y: -50)
                    
                } else {
                    ZStack {
                        
                    }
                    .frame(width: geo.size.width / 3, height: geo.size.height / 3)
                    .background(Color.blue)
                    .offset(y: -20)
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
            moneyString = viewModel.getMoney(type: lixiType, 0, 0, listText)
            isGotMoney = true
//            viewModel.getMoney(type: .text, 0, 0, listText)
//            viewModel.getMoney(type: .number, 0, 100)
        }
    }
}

struct CongratulationView: View {
    @State var moneyString: String
    
    var body: some View {
        GeometryReader { geo in
            ZStack {
                Text("\(moneyString)")
                    .font(.titleFont(.regular, size: 30))
                    .multilineTextAlignment(.center)
            }
            .frame(width: geo.size.width, height: geo.size.height, alignment: .center)
            .background(Color.pink)
        }
    }
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
            let money = randomInt * 10000
            let text = "\(convertCurrency(money: Double(money)))đ"
            return "\(text)"
            
        }
        
        private func randomNumber(from minValue: Int, to maxValue: Int) -> String {
            let randomInt = Int.random(in: minValue...maxValue)
            return "\(randomInt)"
        }
        
        private func randomText(list: [String]) -> String {
            let randomInt = Int.random(in: 0..<list.count)
            let text = list[randomInt]
            return text
        }
        
        private func convertCurrency(money: Double) -> String {
            let currencyFormatter = NumberFormatter()
            currencyFormatter.usesGroupingSeparator = true
            currencyFormatter.numberStyle = .decimal
            // localize to your grouping and decimal separator
            currencyFormatter.locale = Locale.current

            // We'll force unwrap with the !, if you've got defined data you may need more error checking
            let priceString = currencyFormatter.string(from: NSNumber(value: money))!
            return priceString
        }
    }
}

enum LiXiType: Int {
    case text = 0
    case number = 1
    case tetDong = 2
}
