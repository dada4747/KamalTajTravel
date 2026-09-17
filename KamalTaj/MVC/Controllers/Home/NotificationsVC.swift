//
//  NotificationsVC.swift
//  Internacia
//
//  Created by Admin on 08/11/22.
//

import UIKit

class NotificationsVC: UIViewController {

    @IBOutlet weak var tbl_notifications: UITableView!
    var notificationArry : [DNotificationItem] = []
    override func viewDidLoad() {
        super.viewDidLoad()
        getApiNotification()
        addDelegates()
    }
    func addDelegates(){
        tbl_notifications.delegate = self
        tbl_notifications.dataSource = self
        tbl_notifications.rowHeight = UITableView.automaticDimension
        tbl_notifications.estimatedRowHeight = 200
    }
    func displayNotifications(){
        //add data from backend first
        notificationArry = DNotificationModel.notification_array
        print(notificationArry)
        print(DNotificationModel.notification_array)
        tbl_notifications.reloadData()
    }
    @IBAction func backButtonAction(_ sender: Any) {
        navigationController?.popViewController(animated: true)
    }
    
}
extension NotificationsVC : UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return notificationArry.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell = tableView.dequeueReusableCell(withIdentifier: "NotificationsCell") as? NotificationsCell
        if cell == nil {
            tableView.register(UINib(nibName: "NotificationsCell", bundle: nil), forCellReuseIdentifier: "NotificationsCell")
            cell = tableView.dequeueReusableCell(withIdentifier: "NotificationsCell") as? NotificationsCell
     
        }
        cell?.selectionStyle = .none
        cell?.lbl_title.text = notificationArry[indexPath.row].message
        cell?.lbl_date.text = notificationArry[indexPath.row].created_datetime
        return cell!
    }
}
extension NotificationsVC {
    func getApiNotification() -> Void {
        let user_id = ""
        CommonLoader.shared.startLoader(in: view)
        let param: [String : String] = ["created_by" : user_id.getUserId()]
        VKAPIs.shared.getRequestXwwwform(params: param, file: "general/notification", httpMethod: .POST) { resultObject, success, error in
            if success == true {
                print("Notifications response : \(String(describing: resultObject))")
                if let result_dict = resultObject as? [String: Any] {
                    if result_dict["status"] as? Bool == true {
                        if let data = result_dict["data"] as? [[String: Any]]{
                            print(data)
                            DNotificationModel.createNotificationModels(result_array: data)
                        }
                    }
                    
                } else {
                    print(resultObject)
                }
            } else {
                print(error?.localizedDescription)
            }
            CommonLoader.shared.stopLoader()
            self.displayNotifications()
        }
        
    }
}
