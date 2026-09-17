//
//  VKRemoveNull.swift
//  SwiftClassesApp
//
//  Created by Kondaiah on 07/07/18.
//  Copyright © 2018 Kondaiah. All rights reserved.
//

import UIKit

class VKRemoveNull: NSObject {
    
    // Singleton instance...
    static let shared = VKRemoveNull()
    
    // MARK: - Filters
    func filterNulls_inDictionary(dictionary: [String: Any], empty: Bool) -> [String: Any] {
        
        let rmDictObj = DictionaryNullModel()
        return rmDictObj.getNullFilter_Dictionary(previous_dictionary: dictionary, empty: empty)
    }
    
    func filterNulls_inArray(array: [Any], empty: Bool) -> [Any] {
        
        let rmArrayObj = ArrayNullModel()
        return rmArrayObj.getNullFilter_Array(previous_array: array, empty: empty)
    }
}

extension VKRemoveNull {
    
    // MARK: - Strings Filters
    static func filterNulls_withNAString(previous_string: Any) -> Any? {
        
        // if elements value nulls...
        if let filter_string = previous_string as? String {
            
            if filter_string.isEmpty {
                return "NA"
            }
            else if filter_string == "" {
                return "NA"
            }
            else if (filter_string == "<nil>") {
                return "NA"
            }
            else if (filter_string == "<null>") {
                return "NA"
            }
            else if (filter_string == "NULL") {
                return "NA"
            }
            else if (filter_string == "nil") {
                return "NA"
            }
            else if (filter_string == "(null)") {
                return "NA"
            }
            else {}
            
            return filter_string
        }
        else if previous_string is NSNull {
            return "NA"
        }
        else {
            return previous_string
        }
    }
    
    static func filterNulls_withEmptyString(previous_string: Any) -> Any? {
        
        // if elements value nulls...
        if let filter_string = previous_string as? String {
            
            if filter_string.isEmpty {
                return ""
            }
            else if filter_string == "" {
                return ""
            }
            else if (filter_string == "<nil>") {
                return ""
            }
            else if (filter_string == "<null>") {
                return ""
            }
            else if (filter_string == "NULL") {
                return ""
            }
            else if (filter_string == "nil") {
                return ""
            }
            else if (filter_string == "(null)") {
                return ""
            }
            else {}
            
            return filter_string
        }
        else if previous_string is NSNull {
            return ""
        }
        else {
            return previous_string
        }
    }
}

struct ArrayNullModel {
    
    // MARK: - LocalArray
    func getNullFilter_Array(previous_array: [Any], empty: Bool) -> [Any] {
        
        var filter_array = previous_array
        for i in 0 ..< filter_array.count {
            
            let givenObj = filter_array[i]
            if givenObj is [String: Any] {
                
                // dictionary filters calling...
                let rnDictionary = DictionaryNullModel()
                filter_array[i] = rnDictionary.getNullFilter_Dictionary(previous_dictionary: givenObj as! [String: Any], empty: empty)
            }
            else if givenObj is [Any] {
                
                // array filters calling...
                let rnArray = ArrayNullModel()
                filter_array[i] = rnArray.getNullFilter_Array(previous_array: givenObj as! [Any], empty: true)
            }
            else if givenObj is NSNumber {
                print("It's number in array class")
            }
            else  {
                
                // string filters calling...
                if empty {
                    filter_array[i] = VKRemoveNull.filterNulls_withEmptyString(previous_string: givenObj) ?? ""
                } else {
                    filter_array[i] = VKRemoveNull.filterNulls_withNAString(previous_string: givenObj) ?? ""
                }
            }
        }
        return filter_array
    }
}


struct DictionaryNullModel {
    
    // MARK: - LocalDictionary
    func getNullFilter_Dictionary(previous_dictionary: [String: Any], empty: Bool) -> [String: Any] {
        
        var filter_dictionary = previous_dictionary
        for (key, givenObj) in filter_dictionary {
            
            if givenObj is [String: Any] {
                
                // dictionary filters calling...
                let rnDictionary = DictionaryNullModel()
                filter_dictionary[key] = rnDictionary.getNullFilter_Dictionary(previous_dictionary: givenObj as! [String: Any], empty: empty)
            }
            else if givenObj is [Any] {
                
                // array filters calling...
                let rnArray = ArrayNullModel()
                filter_dictionary[key] = rnArray.getNullFilter_Array(previous_array: givenObj as! [Any], empty: true)
            }
            else if givenObj is NSNumber {
                print("It's number in array class")
            }
            else  {
                
                // string filters calling...
                if empty {
                    filter_dictionary[key] = VKRemoveNull.filterNulls_withEmptyString(previous_string: givenObj) ?? ""
                } else {
                    filter_dictionary[key] = VKRemoveNull.filterNulls_withNAString(previous_string: givenObj) ?? ""
                }
            }
        }
        return filter_dictionary
    }
}






