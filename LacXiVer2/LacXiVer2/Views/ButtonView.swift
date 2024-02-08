//
//  ButtonView.swift
//  LacXiVer2
//
//  Created by Trường  on 2/6/24.
//

import SwiftUI

struct ButtonView: View {
    @State var text: String
    @State var fontSize: CGFloat
    @State var width: CGFloat
    @State var height: CGFloat
    var body: some View {
        Text("\(text)")
            .font(.appFont(.bold, size: fontSize))
            .foregroundColor(Color.appBeige)
            .frame(width: width, height: height)
            .background(Color.appDarkBrown)
            .cornerRadius(10.0)
    }
}

