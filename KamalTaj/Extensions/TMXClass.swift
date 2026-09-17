//
//  TMXClass.swift
//  Internacia
//
//  Created by Admin on 29/10/22.
//

import UIKit
import CommonCrypto

typealias CurrencyHandler = (_ message: String) -> Void

class TMXClass: NSObject {
    
    // instance
    static let shared = TMXClass()
    
    // init...
    private override init() {
        super.init()
        
    }
}

extension TMXClass {
    
    // get currency converter...
    func getCurrencyConverterList(handler: @escaping CurrencyHandler) -> Void {
        
        DispatchQueue.global().async {
            
            // calling api...
            VKAPIs.shared.getRequest(file: Get_CurrencyList, httpMethod: .GET)
            { (resultObj, success, error) in
                
                // success status...
                if success == true {
                    print("Currency Converter success: \(String(describing: resultObj))")
                    
                    if let result = resultObj as? [String: Any] {
                        
                        // response date...
                        if let data_array = result["data"] as? [[String: Any]] {
                            DCurrencyModel.createModel_Currency(result_array: data_array)
                        }
                        DispatchQueue.main.async {
                            handler("Success")
                        }
                        if result["status"] as? Bool == true {
                            

                        } else {
                            // error message...
                            if let message_str = result["message"] as? String {
                                DispatchQueue.main.async {
                                    handler(message_str)
                                }
                            }
                        }
                    } else {
                        print("Currency Converter formate : \(String(describing: resultObj))")
                        DispatchQueue.main.async {
                            handler("Formate error")
                        }
                    }
                }
                else {
                    // error message...
                    DispatchQueue.main.async {
                        handler(error?.localizedDescription ?? "")
                    }
                }
            }
        }
    }
    func md5(_ string: String) -> String {
        let messageData = string.data(using:.utf8)!
        var digestData = Data(count: Int(CC_MD5_DIGEST_LENGTH))
        
        _ = digestData.withUnsafeMutableBytes {digestBytes in
            messageData.withUnsafeBytes {messageBytes in
                CC_MD5(messageBytes.baseAddress, CC_LONG(messageData.count), digestBytes.bindMemory(to: UInt8.self).baseAddress)
            }
        }
        return digestData.map { String(format: "%02hhx", $0) }.joined()
    }
    
}
