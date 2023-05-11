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
    
    @State var baseInput = "USD"
    @State var baseOutput = "IDR"
    @State var amountInput = "1"
    @State var amountOutput = "1"
    @State var currencyBaseList:[String] = []
    
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
    
    var body: some View {
        NavigationStack {
            GeometryReader { geometry in
                VStack() {
                    HStack {
                        Text("Rate Ruler")
                            .font(.system(size: 30))
                            .bold()
                            .padding()
                    }
                    VStack {
                        HStack{
                            NavigationLink(destination:
                                            CurrencyPickerView( selectedValue: $baseInput, currencies: currencyBaseList)) {
                                Text("\(baseInput)")
                            }.padding()
                                .frame(width: geometry.size.width*0.2)
                                .background(Color.gray.opacity(0.10))
                                .foregroundColor(Color.black)
                                .cornerRadius(8.0)
                            
                            TextField("Enter amount" ,text: $amountInput)
                                .padding()
                                .frame(width: geometry.size.width*0.6)
                                .background(Color.gray.opacity(0.10))
                                .cornerRadius(8.0)
                                .padding()
                                .keyboardType(.decimalPad)
                                .focused($inputIsFocused)
                                .multilineTextAlignment(.trailing)
                        }.padding(.horizontal)
                        
                        HStack{
                            NavigationLink(destination:
                                            CurrencyPickerView( selectedValue: $baseOutput, currencies: currencyBaseList)) {
                                Text("\(baseOutput)")
                            }.padding()
                                .frame(width: geometry.size.width*0.2)
                                .background(Color.gray.opacity(0.10))
                                .foregroundColor(Color.black)
                                .cornerRadius(8.0)
                            
                            Text("\(amountOutput)")
                                .padding()
                                .frame(width: geometry.size.width*0.6, alignment: .trailing)
                                .background(Color.gray.opacity(0.10))
                                .cornerRadius(8.0)
                                .lineLimit(1)
                                .padding()
                        }.padding(.horizontal)
                        
                        LottieView(fileName: "currency.json", width: 75, height: 75).padding()
                        
                        Button(action: {
                            makeRequest()
                            inputIsFocused = false
                        }) {
                            Text("Convert!")
                                .font(.headline)
                                .fontWeight(.bold)
                                .padding()
                                .frame(minWidth: 0, maxWidth: .infinity)
                                .foregroundColor(.white)
                                .background(Color.blue)
                                .cornerRadius(8.0)
                                .padding()
                                .scaleEffect(buttonScale)
                            //                                .animation(.spring(response: 0.2, dampingFraction: 0.4, blendDuration: 0))
                        }
                        .onTapGesture {
                            buttonScale = 0.8
                        }
                        .onChange(of: buttonScale) { newValue in
                            if newValue == 1 {
                                buttonScale = 0
                            }
                        }
                    }
                    
                }.onAppear() {
                    makeRequest()
                    audio.numberOfLoops = -1
                    audio.play()
                }
            }}
    }
}

struct CurrencyConverterView_Previews: PreviewProvider {
    static var previews: some View {
        CurrencyConverterView()
    }
}
