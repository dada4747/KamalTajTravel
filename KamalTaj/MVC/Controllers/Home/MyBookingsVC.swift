//
//  MyBookingsVC.swift
//  EasiTripBooking
//
//  Created by Nandu on 04/03/25.
//

import UIKit

class MyBookingsVC: UIViewController {
    
    @IBOutlet weak var view_header: UIView!
    @IBOutlet weak var view_subHeader: UIView!
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var containerView: UIView!
    
    var currentViewController: UIViewController?
    var selectedIndex: Int = 0
    var modulesArray: [String] = ["Flight", "Hotels", "Buses"/*,"Transfers", "Activities", "Holidays"*/]
    
    

    override func viewDidLoad() {
        super.viewDidLoad()
        view_header.viewShadow()
        view_subHeader.viewShadow()
        // Do any additional setup after loading the view.
        
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.register(UINib.init(nibName: "CommonLabelCV", bundle: nil), forCellWithReuseIdentifier: "CommonLabelCV")
        
        refreshHomeAds()
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
    // MARK: - ButtonAction
    @IBAction func menuBtnClicked(_ sender: Any) {
        // menu moving...
        appDel.sideMenu_actions()
    }
    
    // MARK: - Helpers
    func refreshHomeAds() {
        
        if let viewController = currentViewController {
            
            remove(asChildViewController: viewController)
            selectedIndex = 0
            collectionView.reloadData()
        }
        
        addFlightView()
    }
    
    func reloadTableview() {
        collectionView.reloadData()
    }
    
    // MARK: - Add ViewController as Subviews
    private lazy var flightHistoryVC: FlightHistoryVC = {

        // Instantiate View Controller
        var viewController = FLIGHT_STORYBOARD.instantiateViewController(withIdentifier: "FlightHistoryVC") as! FlightHistoryVC

        // Add View Controller as Child View Controller
        self.addViewCotroller(asChildViewController: viewController)

        return viewController
    }()
    
    private lazy var hotelHistoryVC: HotelHistoryVC = {

        // Instantiate View Controller
        var viewController = HOTEL_STORYBOARD.instantiateViewController(withIdentifier: "HotelHistoryVC") as! HotelHistoryVC

        // Add View Controller as Child View Controller
        self.addViewCotroller(asChildViewController: viewController)

        return viewController
    }()
    
    private lazy var busHistoryVC: BusHistoryVC = {

        // Instantiate View Controller
        var viewController = BUS_STORYBOARD.instantiateViewController(withIdentifier: "BusHistoryVC") as! BusHistoryVC

        // Add View Controller as Child View Controller
        self.addViewCotroller(asChildViewController: viewController)

        return viewController
    }()
    
    
    
//    private lazy var transferHistoryVC: TransferHistoryVC = {
////
////        // Instantiate View Controller
//        var viewController = TRANSFERS_STORYBOARD.instantiateViewController(withIdentifier: "TransferHistoryVC") as! TransferHistoryVC
//
//        // Add View Controller as Child View Controller
//        self.addViewCotroller(asChildViewController: viewController)
//
//        return viewController
//    }()
    
//    private lazy var activityHistoryVC: ActivityHistoryVC = {
//
//        // Instantiate View Controller
//        var viewController = ACTIVITIES_STORYBOARD.instantiateViewController(withIdentifier: "ActivityHistoryVC") as! ActivityHistoryVC
//
//        // Add View Controller as Child View Controller
//        self.addViewCotroller(asChildViewController: viewController)
//
//        return viewController
//    }()
    
//    private lazy var holidayHistoryVC: HolidayHistoryVC = {
//
//        // Instantiate View Controller
//        var viewController = HOLIDAY_STORYBOARD.instantiateViewController(withIdentifier: "HolidayHistoryVC") as! HolidayHistoryVC
//
//        // Add View Controller as Child View Controller
//        self.addViewCotroller(asChildViewController: viewController)
//
//        return viewController
//    }()

}

extension MyBookingsVC {
    
    private func addFlightView() {
        addViewCotroller(asChildViewController: flightHistoryVC)
    }
    private func addHotelView() {
        addViewCotroller(asChildViewController: hotelHistoryVC)
    }
    private func addBusView() {
        addViewCotroller(asChildViewController: busHistoryVC)
    }
    
    
//    private func addTransferView() {
//        addViewCotroller(asChildViewController: transferHistoryVC)
//    }
    
//    private func addActivityView() {
//        addViewCotroller(asChildViewController: activityHistoryVC)
//    }
    
//    private func addHolidayView() {
//        addViewCotroller(asChildViewController: holidayHistoryVC)
//    }
    

    private func addViewCotroller(asChildViewController viewController: UIViewController) {
        
        currentViewController?.view.removeFromSuperview()
        currentViewController?.removeFromParent()
        
        currentViewController = viewController
        
        // Add Child View Controller
        addChild(viewController)

        // Add Child View as Subview
        view.addSubview(viewController.view)

        // Configure Child View
        viewController.view.frame = containerView.frame
        viewController.view.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        
        viewController.view.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            viewController.view.leadingAnchor.constraint(equalTo: containerView.leadingAnchor),
            viewController.view.trailingAnchor.constraint(equalTo: containerView.trailingAnchor),
            viewController.view.topAnchor.constraint(equalTo: containerView.topAnchor),
            viewController.view.bottomAnchor.constraint(equalTo: containerView.bottomAnchor)
         ])

        // Notify Child View Controller
        viewController.didMove(toParent: self)
    }
    
    private func remove(asChildViewController viewController: UIViewController) {
        
        // Notify Child View Controller
        viewController.willMove(toParent: nil)

        // Remove Child View From Superview
        viewController.view.removeFromSuperview()

        // Notify Child View Controller
        viewController.removeFromParent()
    }
    

}

extension MyBookingsVC: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return modulesArray.count
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let itemsPerRow: CGFloat = 3
        let leftRightInset: CGFloat = 20 + 20
        let spacing: CGFloat = 10 * (itemsPerRow - 1)
        
        let availableWidth = collectionView.frame.width - leftRightInset - spacing
        let cellWidth = floor(availableWidth / itemsPerRow)
        
        return CGSize(width: cellWidth, height: 40)
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CommonLabelCV", for: indexPath as IndexPath) as! CommonLabelCV
        
        cell.lbl_title.text = modulesArray[indexPath.row]
        cell.view_bg.backgroundColor = .white
        cell.view_bg.layer.borderColor = UIColor.appColor.cgColor
//        cell.view_bg.borderWidth = 1
        cell.lbl_title.textColor = .appColor
        
        if selectedIndex == indexPath.row {
            
            cell.view_bg.backgroundColor = .appColor
            cell.lbl_title.textColor = .white
        }
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        selectedIndex = indexPath.row
        reloadTableview()
        
        switch selectedIndex {
        case 0:
            addFlightView()
        case 1:
            addHotelView()
        case 2:
            addBusView()
//        case 3:
//            addTransferView()
//        case 4:
//            addActivityView()
//        case 5:
//            addHolidayView()
        default:
            break
        }
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 10
    }

    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 10
    }

    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 0, left: 20, bottom: 0, right: 20)
    }
}

