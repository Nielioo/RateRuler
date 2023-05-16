//
//  CurrencyConverterView.swift
//  RateRuler
//
//  Created by Daniel Aprillio on 05/05/23.
//


import SwiftUI
import AVFoundation
import Lottie

struct CurrencyConverterView: View {
    
    @Environment(\.colorScheme) var colorScheme
    
    @State var baseInput = "USD"
    @State var baseOutput = "IDR"
    @State var tmpBase = ""
    @State var amountInput = "1"
    @State var amountOutput = "1"
    @State var tmpAmount = ""
    @State var currencyBaseList:[String] = []
    
    @State private var isPlayAudio: Bool = true
    @State private var searchTerm: String = ""
    @State private var buttonScale: Double = 1.0
    @FocusState private var inputIsFocused: Bool
    
    let audio = try! AVAudioPlayer(contentsOf: Bundle.main.url(forResource: "song", withExtension: "mp3")!)
    
    func makeRequest() {
        apiRequest(url: "https://api.exchangerate.host/latest?base=\(baseInput)&amount=\(amountInput)") { currency in
            
            var tempList: [String] = []
            
            for currency in currency.rates {
                tempList.append("\(currency.key)")
                tempList.sort()
                
                if baseOutput.uppercased() == currency.key{
                    amountOutput = String(format: "%.2f",currency.value)
                }
            }
            currencyBaseList.self = tempList
        }
    }
    
    func playAudio(){
        audio.numberOfLoops = -1
        audio.play()
    }
    
    func stopAudio(){
        audio.stop()
    }
    
    var body: some View {
        NavigationStack {
            GeometryReader { geometry in
                VStack() {
                    HStack {
                        Text("Rate Ruler")
                            .font(.system(size: 30))
                            .bold()
                            .padding()
                        Spacer()
                        Button(action: {
                            isPlayAudio.toggle()
                            if isPlayAudio{
                                playAudio()
                            } else {
                                stopAudio()
                            }
                        }, label: {
                            if isPlayAudio{
                                Image(systemName: "speaker.wave.1.fill")
                                    .foregroundColor(colorScheme == .dark ? Color.white : Color.black)
                                    .font(.system(size: 24))
                            } else {
                                Image(systemName: "speaker.slash.fill")
                                    .foregroundColor(colorScheme == .dark ? Color.white : Color.black)
                                    .font(.system(size: 24))
                            }
                        }).padding(.trailing, geometry.size.width*0.1)
                    }.padding(.vertical)
                    
                    VStack {
                        HStack{
                            NavigationLink(destination:
                                            CurrencyPickerView( selectedValue: $baseInput, currencies: currencyBaseList)) {
                                Text("\(baseInput)")
                            }.padding()
                                .frame(width: geometry.size.width*0.2)
                                .background(.ultraThinMaterial)
                                .foregroundColor(colorScheme == .dark ? Color.white : Color.black)
                                .cornerRadius(8.0)
                            
                            TextField("Enter amount" ,text: $amountInput)
                                .padding()
                                .frame(width: geometry.size.width*0.7)
                                .background(.ultraThinMaterial)
                                .cornerRadius(8.0)
//                                .keyboardType(.decimalPad)
                                .focused($inputIsFocused)
                                .multilineTextAlignment(.trailing)
                                .onSubmit(of: .text){
                                    makeRequest()
                                }
                                .submitLabel(.done)
                        }.padding(.horizontal)
                        
                        Button(action: {
                            tmpBase = baseInput
                            baseInput = baseOutput
                            baseOutput = tmpBase
                            
                            tmpAmount = amountInput
                            amountInput = amountOutput
                            amountOutput = tmpAmount
                        }) {
                            HStack{
                                Image(systemName: "arrow.up.arrow.down")
                                    .foregroundColor(Color.blue)
                                    .font(.system(size: 24))
                                Text("Swap")
                            }
                        }.padding()
                        
                        HStack{
                            NavigationLink(destination:
                                            CurrencyPickerView( selectedValue: $baseOutput, currencies: currencyBaseList)) {
                                Text("\(baseOutput)")
                            }.padding()
                                .frame(width: geometry.size.width*0.2)
                                .background(.ultraThinMaterial)
                                .foregroundColor(colorScheme == .dark ? Color.white : Color.black)
                                .cornerRadius(8.0)
                            
                            Text("\(amountOutput)")
                                .bold()
                                .padding()
                                .frame(width: geometry.size.width*0.7, alignment: .trailing)
                                .background(.ultraThinMaterial)
                                .foregroundColor(Color.secondary)
                                .cornerRadius(8.0)
                                .lineLimit(1)
                        }.padding(.horizontal)
                        
                        if !inputIsFocused{
                            LottieView(fileName: "currency.json", width: 75, height: 75)
                                .padding()
                                .padding()
                        }
                        
//                        Button(action: {
//                            makeRequest()
//                            inputIsFocused = false
//                        }) {
//                            Text("Convert!")
//                                .font(.headline)
//                                .fontWeight(.bold)
//                                .padding()
//                                .frame(minWidth: 0, maxWidth: .infinity)
//                                .foregroundColor(.white)
//                                .background(Color.blue)
//                                .cornerRadius(8.0)
//                                .padding()
//                                .scaleEffect(buttonScale)                        }
//                        .onTapGesture {
//                            buttonScale = 0.8
//                        }
//                        .onChange(of: buttonScale) { newValue in
//                            if newValue == 1 {
//                                buttonScale = 0
//                            }
//                        }
                    }
                    
                }.onAppear() {
                    makeRequest()
                    if isPlayAudio{
                        playAudio()
                    }
                }
            }}
    }
}

struct CurrencyConverterView_Previews: PreviewProvider {
    static var previews: some View {
        CurrencyConverterView()
    }
}
