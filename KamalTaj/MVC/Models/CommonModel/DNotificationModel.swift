//
//  DNotificationModel.swift
//  Internacia
//
//  Created by Admin on 09/11/22.
//

import Foundation
struct DNotificationModel {
    static var notification_array : [DNotificationItem] = []
    init(){}
    static func clearAll(){
        
    }
    static func createNotificationModels(result_array: [[String: Any]]){
//        if let data_array = result_array
        for item in result_array {
            let model = DNotificationItem.init(details: item)
            self.notification_array.append(model)
        }
        
    }
}
struct DNotificationItem {
    var origin : String? = ""
    var message : String? = ""
    var created_by : String? = ""
    var status : String? = ""
    var created_datetime : String? = ""
    init(details: [String: Any]) {
        self.origin = ""
        self.message = ""
        self.created_by = ""
        self.status = ""
        self.created_datetime = ""
        
        if let origin = details["origin"] as? String {
            self.origin = origin
        }
        if let message = details["message"] as? String {
            self.message = message
        }
        if let created_by = details["created_by"] as? String {
            self.created_by = created_by
        }
        if let status = details["status"] as? String {
            self.status = status
        }
        if let created_datetime = details["created_datetime"] as? String {
            
            let destinDate = DateFormatter.getDate(formate: "yyyy-MM-dd HH:mm:ss", date: created_datetime)
//            self.start_date = destinDate
            self.created_datetime = DateFormatter.getDateString(formate: "dd MMM yyyy", date: destinDate)
        }
        
    }
}
