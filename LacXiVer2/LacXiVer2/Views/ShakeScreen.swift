//
//  ShakeScreen.swift
//  LacXiVer2
//
//  Created by Trường  on 1/19/24.
//

import SwiftUI
import PhotosUI
import AVKit

struct ShakeScreen: View {
    @Environment(\.dismiss) var dismiss
    @State private var viewModel = ViewModel()
    @Binding var listText: [TextObject] //= ["Không có gì!", "20.000đ", "50.000đ", "60.000đ","100.000đ", "Lại đi!"]
    
    @State var isGotMoney = false
    @State var moneyString = ""
    @State var lixiType: LiXiType = .text
    @State private var showCamera = false
    @State private var selectedImage: UIImage?
    @State var isShaked = false
    @State private var _up = true
    @State private var activeImageIndex = 0
    @State private var startTimer = false
    @State var isShowTool = false
    
    let timer = Timer.publish(every: 0.15, on: .main, in: .common).autoconnect()
    let myShots = ["charac-1", "charac-2", "charac-3", "charac-4", "charac-5", "charac-6", "charac-7", "charac-8"]
    @State var audioPlayer: AVAudioPlayer!
    @State var audioBackgroundPlayer: AVAudioPlayer!
    
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
                        .foregroundColor(.appDarkBrown)
                    Text("by Quang Trường")
                        .font(.appFont(.bold, size: 17))
                        .foregroundColor(.appDarkBrown)
                    Spacer()
                }
                
                if isGotMoney {
                    ZStack {
                        CongratulationView(moneyString: "\(moneyString)", selectedImage: $selectedImage, isShowCamera: $showCamera)
                            .frame(width: geo.size.width - 20, height: 500, alignment: .center)
                            .offset(y: -50)
                        if isShowTool {
                            HStack (spacing: 40) {
                                Button {
                                    isGotMoney = false
                                    isShaked = false
                                    selectedImage = nil
                                    self.audioBackgroundPlayer.play()
                                } label: {
                                    Image("refresh")
                                        .resizable()
                                        .scaledToFit()
                                        .frame(width: 50, height: 50)
                                        .foregroundColor(.appDarkBrown)
                                }
                                
                                
                                Button(action: {
                                    self.showCamera.toggle()
                                }, label: {
                                    Image("camera")
                                        .resizable()
                                        .scaledToFit()
                                        .frame(width: 50, height: 50)
                                        .foregroundColor(.appDarkBrown)
                                })
                                .fullScreenCover(isPresented: self.$showCamera) {
                                    AccessCameraView(selectedImage: self.$selectedImage)
                                }
                                
                                Button(action: {
                                    isShowTool = false
                                    //                                let imageSaver = ImageSaver()
                                    
                                    
                                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                                        guard let image = self.snapshot() else { return }
                                        UIImageWriteToSavedPhotosAlbum(image, nil, nil, nil)
                                        isShowTool = true
                                    }
                                    
                                    //                                 self.snapshot()
                                }, label: {
                                    Image("download")
                                        .resizable()
                                        .scaledToFit()
                                        .frame(width: 50, height: 50)
                                        .foregroundColor(.appDarkBrown)
                                })
                            }
                            .offset(y: 400)
                        }
                        
                    }
                    
                } else {
                    ZStack {
                        Image(self.myShots[self.activeImageIndex])
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .onReceive(self.timer) { time in
                                if self.startTimer {
                                    if self.activeImageIndex != 4 && self._up {
                                        self.activeImageIndex += 1
                                        
                                        if self.activeImageIndex == 4 {
                                            self._up = false
                                        }
                                        
                                    } else {
                                        self.activeImageIndex -= 1
                                        if self.activeImageIndex == 0 {
                                            self._up = true
                                        }
                                    }
                                }
                            }
                    }
                    .frame(width: geo.size.width / 1.5, height: geo.size.height / 2)
                    .background(Color.clear)
                    .offset(y: -50)
                }
            }
            .background(Color.yellow)
            .ignoresSafeArea()
            .navigationBarHidden(true)
            .frame(width: geo.size.width, height: geo.size.height)
        }
        .ignoresSafeArea()
        .background(Color.green)
        .onShake {
            if !isShaked {
                moneyString = viewModel.getMoney(type: lixiType, 0, 0, listText)
                isShaked = true
                let delay = Double.random(in:0.5...1.5)
                DispatchQueue.main.asyncAfter(deadline: .now() + delay) {
                    isGotMoney = true
                    isShowTool = true
                    self.audioBackgroundPlayer.stop()
                    self.audioPlayer.play()
                }
            }
        }
        .onAppear {
            self.startTimer.toggle()
            let sound = Bundle.main.path(forResource: "coinDrop", ofType: "mp3")
            let backgroundSound = Bundle.main.path(forResource: "backgroundSound", ofType: "mp3")
            self.audioBackgroundPlayer = try! AVAudioPlayer(contentsOf: URL(fileURLWithPath: backgroundSound!))
            self.audioBackgroundPlayer.numberOfLoops = -1
            self.audioPlayer = try! AVAudioPlayer(contentsOf: URL(fileURLWithPath: sound!))
            self.audioBackgroundPlayer.play()
        }
        .onTapGesture(count: 5) {
            self.audioBackgroundPlayer.stop()
            dismiss()
        }
    }
}

struct CongratulationView: View {
    @State var moneyString: String
    @Binding var selectedImage: UIImage?
    @Binding var isShowCamera: Bool
    
    var body: some View {
        GeometryReader { geo in
            VStack {
                if let selectedImage {
                    Image(uiImage: selectedImage)
                        .resizable()
                        .scaledToFit()
                        .clipShape(.circle)
                        .frame(width: geo.size.width/1.5, height: geo.size.width/1.5)
                        .onTapGesture {
                            isShowCamera = true
                        }
                } else {
                    Image("defaultImage")
                        .resizable()
                        .scaledToFit()
                        .clipShape(.circle)
                        .frame(width: geo.size.width/1.5, height: geo.size.width/1.5)
                        .onTapGesture {
                            isShowCamera = true
                        }
                }
                Text("\(moneyString)")
                    .font(.titleFont(.regular, size: 40))
                    .multilineTextAlignment(.center)
                    .foregroundColor(.appDarkBrown)
                    .offset(y: -30)
                Spacer()
            }
            .frame(width: geo.size.width, height: geo.size.height, alignment: .center)
        }
    }
}

struct AccessCameraView: UIViewControllerRepresentable {
    
    @Binding var selectedImage: UIImage?
    @Environment(\.presentationMode) var isPresented
    
    func makeUIViewController(context: Context) -> UIImagePickerController {
        let imagePicker = UIImagePickerController()
        imagePicker.sourceType = .camera
        imagePicker.allowsEditing = true
        imagePicker.delegate = context.coordinator
        return imagePicker
    }
    
    func updateUIViewController(_ uiViewController: UIImagePickerController, context: Context) {
        
    }
    
    func makeCoordinator() -> Coordinator {
        return Coordinator(picker: self)
    }
}

// Coordinator will help to preview the selected image in the View.
class Coordinator: NSObject, UINavigationControllerDelegate, UIImagePickerControllerDelegate {
    var picker: AccessCameraView
    
    init(picker: AccessCameraView) {
        self.picker = picker
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        guard let selectedImage = info[.originalImage] as? UIImage else { return }
        self.picker.selectedImage = selectedImage
        self.picker.isPresented.wrappedValue.dismiss()
    }
}

extension ShakeScreen {
    class ViewModel {
        func getMoney(type: LiXiType,_ minValue: Int = 0,_ maxValue: Int = 5,_ listText: [TextObject] = []) -> String {
            var money: String = ""
            switch type {
            case .number:
                //random number (example: 100 for 100$)
                money = self.randomNumber(from: minValue, to: maxValue)
                break
            case .text:
                //Custom text which defined at Setting View
                money = self.randomText(list: listText).text
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
        
        private func randomText(list: [TextObject]) -> TextObject {
            if list.count < 1 {
                return TextObject(text: "Chúc Mừng Năm Mới!")
            }
            let randomInt = Int.random(in: 0..<list.count)
            print("int \(randomInt)")
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
