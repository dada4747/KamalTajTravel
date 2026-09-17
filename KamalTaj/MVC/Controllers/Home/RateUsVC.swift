//
//  RateUsVC.swift
//  Internacia
//
//  Created by Admin on 03/11/22.
//

import UIKit

class RateUsVC: UIViewController {
    var options : [String] = ["Support Center", "Booking Failure", "Cancellation", "Delay in Refund", "Technical Issue", "Incomplete Details"]
    @IBOutlet weak var rating_view: FloatRatingView!
    @IBOutlet weak var coll_selectoption: UICollectionView!
    var selectedIndex : Int? = -1
    @IBOutlet weak var Hcoll_height: NSLayoutConstraint!
    @IBOutlet weak var tf_textView: UITextView!
    @IBOutlet weak var lbl_placeholder: UILabel!
    var selectedVar: String? = ""
    var rating = ""
    override func viewDidLoad() {
        super.viewDidLoad()
        rating_view.delegate = self
        coll_selectoption.delegate = self
        coll_selectoption.dataSource = self
        tf_textView.delegate = self
        coll_selectoption.register(UINib.init(nibName: "CommonLabelCV", bundle: nil), forCellWithReuseIdentifier: "CommonLabelCV")
//        coll_selectoption.reloadData()
    }
    
    @IBAction func backButtonAction(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)

    }
    
    @IBAction func submitButtonAction(_ sender: Any) {
        
        
        if rating.isEmpty {
            view.makeToast(message: "Please select rating")
        }else if tf_textView.text.isEmpty{
            view.makeToast(message: "Please write message")
        } else {
            submitRating()
        }
//        print("Rating: \(self.rating)")
//        print("Message: \(self.tf_textView.text)")
//        print("Selected option: \(self.selectedVar)")
    }
    
}
extension RateUsVC: FloatRatingViewDelegate, UITextViewDelegate {
    func floatRatingView(_ ratingView: FloatRatingView, isUpdating rating: Double) {
        self.rating = String(format: "%.2f", self.rating_view.rating)
        print(rating)
        print(self.rating)
        }
        
        func floatRatingView(_ ratingView: FloatRatingView, didUpdate rating: Double) {
            self.rating = String(format: "%.2f", self.rating_view.rating)
        }
    func textViewDidChange(_ textView: UITextView) {
        self.lbl_placeholder.isHidden = !tf_textView.text.isEmpty
    }
}
extension RateUsVC: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return options.count
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {

            let l = self.coll_selectoption.frame.width / 2
            print(l)
            return CGSize(width: l, height: 25)
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CommonLabelCV", for: indexPath as IndexPath) as! CommonLabelCV
        
        cell.lbl_title.text = options[indexPath.row]

        if self.selectedIndex == indexPath.row {
            cell.view_bg.backgroundColor = .secInteraciaBlue
        } else {
            cell.view_bg.backgroundColor = .clear
        }
        return cell
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        self.selectedIndex = indexPath.row
        self.selectedVar = options[indexPath.row]
        DispatchQueue.main.async {
            self.coll_selectoption.reloadData()
        }
    }
}
//MARK: - API
extension RateUsVC {
    func submitRating() -> Void {
        let user_id = ""
        CommonLoader.shared.startLoader(in: view)
        let params: [String: Any] = ["rating": rating,
                                     "message": tf_textView.text ?? "",
                                     "created_by": user_id.getUserId()]
        let paramString: [String: String] = ["rating" : VKAPIs.getJSONString(object: params)]
        VKAPIs.shared.getRequestXwwwform(params: paramString, file: "general/rateus", httpMethod: .POST) { resultObject, success, error in
            if success == true {
                print("Ratus user responce: \(String(describing: resultObject))")
                if let result_dict = resultObject as? [String : Any] {
                    if result_dict["status"] as? Bool == true {
                        appDel.window?.makeToast(message: result_dict["msg"] as! String)
                        self.navigationController?.popViewController(animated: true)

                    }
//                }
            } else {
                print("Register user formate : \(String(describing: resultObject))")
            }
            } else {
                print("Rateus user error: \(String(describing: error?.localizedDescription))")
            }
            CommonLoader.shared.stopLoader()

        }
    }
}
