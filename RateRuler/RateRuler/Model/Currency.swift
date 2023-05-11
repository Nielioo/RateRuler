//
//  Currency.swift
//  RateRuler
//
//  Created by Daniel Aprillio on 08/05/23.
//

// https://api.exchangerate.host/latest?base=USD&amount=100

import Foundation
import Alamofire

// MARK: - Currency
struct Currency: Codable {
    let motd: MOTD
    let success: Bool
    let base, date: String
    let rates: [String: Double]
}

// MARK: - MOTD
struct MOTD: Codable {
    let msg: String
    let url: String
}

// MARK: - ApiRequest
func apiRequest(url: String, completion: @escaping (Currency) -> ()){
    Session.default.request(url).responseDecodable(of: Currency.self) { response in
        switch response.result{
        case .success(let currencies):
            print(currencies)
            completion(currencies)
        case .failure(let error):
            print(error)
        }
        
    }
}
