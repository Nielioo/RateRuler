//
//  CurrencyPickerView.swift
//  RateRuler
//
//  Created by Daniel Aprillio on 09/05/23.
//

import SwiftUI

struct CurrencyPickerView: View {
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    
    @Binding var selectedValue: String
    
    @State var searchString = ""
    
    var currencies: [String] = []
    
    var body: some View {
        NavigationStack {
                List {
                    ForEach(currencies, id:\.self) { currency in
                        if currency.uppercased().contains(searchString.uppercased()) || searchString.isEmpty {
                            Button(action: {
                                selectedValue = currency
                                self.presentationMode.wrappedValue.dismiss()
                            }) {
                                Text(currency)
                            }
                        }
                    }
                }.searchable(text: $searchString, placement: .navigationBarDrawer(displayMode: .always))
            
        }.navigationBarBackButtonHidden(true)
    }
}

struct CurrencyPickerView_Previews: PreviewProvider {
    static var previews: some View {
        CurrencyPickerView(
            selectedValue: .constant(""),
            currencies: ["USD", "JPY", "IDR", "AUD"]
        )
    }
}
