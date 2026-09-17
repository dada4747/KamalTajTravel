//
//  DWishlistModel.swift
//  Internacia
//
//  Created by Admin on 13/11/22.
//

import Foundation
struct DWishlistModel {
    static var wishlist_array : [DWishlistItem] = []
    
    static func clearwishList(){
        self.wishlist_array.removeAll()
    }
    
    static func creatWishListModels(result_dict: [[String: Any]]) {
        clearwishList()
        for result in result_dict {
            let item = DWishlistItem.init(details: result)
            self.wishlist_array.append(item)
        }
    }
    static func gettingWishlitHotels(completion: @escaping (_ success: Bool, _ err: String?) ->()){
//        CommonLoader.shared.startLoader(in: view)
//        SwiftLoader.show(animated: true)
        //getting wishtlist
     let userID = ""
        let param: [String : String] = [
            "module" : "hotel",
            "user_id": userID.getUserId()]
        VKAPIs.shared.getRequestXwwwform(params: param, file: "general/get_wishlist", httpMethod: .POST) { resultObject, success, error in
            if success == true {
                print("Wishlist hotel success: \(String(describing: resultObject))")
                
                if let result = resultObject as? [String: Any] {
                    if result["status"] as? Bool == true {
                        if let data = result["data"] as? [[String: Any]] {
                            // response data...
                            print("create model ")
                            DWishlistModel.creatWishListModels(result_dict: data)
                        }
                    } else {
                        
                        // error message...
                        if let message_str = result["message"] as? String {
                            completion(false, message_str)
                            //                            self.view.makeToast(message: message_str)
                        }
                    }
                } else {
                    print("Hotel Wishlist list formate : \(String(describing: resultObject))")
                }
            } else {
                print("Hotel Wishlist list error : \(String(describing: error?.localizedDescription))")
//                self.view.makeToast(message: error?.localizedDescription ?? "")
            }
//            self.displayHotelList()
            completion(true, "")
//            SwiftLoader.hide()
//            CommonLoader.shared.stopLoader()
        }
    }
    static func removeHotelToWishlist(origin: String, completion: @escaping () ->()) {
        SwiftLoader.show(animated: true)
        let userId = ""
        let param: [String : String] = [
            "module" : "hotel",
            "user_id" : userId.getUserId(),
            "origin" : origin]
        VKAPIs.shared.getRequestXwwwform(params: param, file: "general/remove_wishlist", httpMethod: .POST) { resultObject, success, error in
            if success == true {
                print("Add Wishlist success: \(String(describing: resultObject))")
                if let result = resultObject as? [String : Any] {
                    if result["status"] as? Bool == true {
                        completion()
//                        self.view.makeToast(message: "Added To Wishlist")
                    }else{
                    }
                }else {
                    print("Add Wishlist list formate : \(String(describing: resultObject))")

                }
            }else {
                print("Add Wishlist list error : \(String(describing: error?.localizedDescription))")
//                self.view.makeToast(message: error?.localizedDescription ?? "")
            }
//            self.displayHotelListMethod()
            SwiftLoader.hide()
        }
    }
}
struct DWishlistItem {
    var created_at: String? = ""
    var expirydate: String? = ""
    var module: String? = ""
    var orign: String? = ""
    var booking_source: String? = ""
    var search_id: String? = ""
    var wishkey: DHotelSearchItem?
//    var hotel_array: WishHotel?
    init(details: [String: Any]) {
        if let created_at = details["created_at"] as? String {
            self.created_at = created_at
        }
        if let expirydate = details["expirydate"] as? String {
            self.expirydate = expirydate
        }
        if let module = details["module"] as? String {
            self.module = module
        }
        if let orign = details["orign"] as? String {
            self.orign = orign
        }
        if let booking_source = details["booking_source"] as? String{
            self.booking_source = booking_source
        }
        if let search_id = details["search_id"] as? String {
            self.search_id = search_id
        }
        if let list_array = details["wishkey"] as? [String: Any] {
            let searchItem = DHotelSearchItem.init(details: list_array)
            self.wishkey = searchItem
        }
    }
    
    
}
