//
//  BusSeatsVC.swift
//  MTM
//
//  Created by Nandu on 31/01/25.
//

import UIKit

class BusSeatsVC: UIViewController, BoardingPointsDelegate, DropingPointDelegate {
    
    func selectedBoardingPoint(model: DPickupDropItem) {
        selected_board = model
        tf_bording.text = "\(model.area ?? "") \(model.time ?? "")"
        //lbl_Bplaceholder2.text = "\(model.pickupName ?? "") \(model.pickupTime ?? "")"
        lbl_Bplaceholder2.isHidden = true
    }
    func selctedDropPoint(model: DPickupDropItem) {
        selected_drop = model
        tf_drop_point.text = "\(model.area ?? "")  \(model.time ?? "")"
        //lbl_Dplaceholder2.text = "\(model.dropoffName ?? "")  \(model.dropoffTime ?? "")"
        lbl_Dplaceholder2.isHidden  = true
        
    }
    
    @IBOutlet weak var lblTravelsName: UILabel!
    @IBOutlet weak var lblBusType: UILabel!
    @IBOutlet weak var viewLowerDeck: UIView!
    @IBOutlet weak var collLowerDeck: UICollectionView!
    @IBOutlet weak var viewUpperDeck: UIView!
    @IBOutlet weak var collUpperDeck: UICollectionView!
//    @IBOutlet weak var heiConst/raint: NSLayoutConstraint!
    @IBOutlet weak var lblSeatCount: UILabel!
    @IBOutlet weak var lblTotalFare: UILabel!
    @IBOutlet weak var lblGrandTotal: UILabel!
    @IBOutlet var viewPricePop: UIView!
    @IBOutlet weak var tblSeats: UITableView!
    @IBOutlet weak var heiTblConstraint: NSLayoutConstraint!
    @IBOutlet var viewSeatInfoPop: UIView!
    @IBOutlet weak var viewLowerUpperDeck: UIStackView!
    var view_packageTypePop: ToursPackageView?

    var selectedSeats: [SeatDetails] = []
    private let maxSelection = 6
    
    var selected_drop : DPickupDropItem?
    var selected_board : DPickupDropItem?

    @IBOutlet weak var lbl_Bplaceholder2: UILabel!
    @IBOutlet weak var lbl_Dplaceholder2: UILabel!
    @IBOutlet weak var tf_bording: UITextView!
    @IBOutlet weak var tf_drop_point: UITextView!
    var totalCost: Float = 0.0
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.

        addPopup()
        addDelegates()
        updateFareDetails()
        displayBusInfo()
        addFrameAddView()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        
    }
    func addFrameAddView(){
        self.view_packageTypePop = ToursPackageView.loadViewFromNib() as? ToursPackageView
        self.view_packageTypePop?.isHidden = true
        self.view_packageTypePop?.tag = 102
        UIApplication.shared.keyWindow?.addSubview(self.view_packageTypePop!)
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
    func addPopup() {
        viewPricePop.isHidden = true
        viewPricePop.frame = self.view.frame
        self.view.addSubview(viewPricePop)
        
        
        viewSeatInfoPop.isHidden = true
        viewSeatInfoPop.frame = self.view.frame
        self.view.addSubview(viewSeatInfoPop)
    }
    func addDelegates() {
        
        tblSeats.delegate = self
        tblSeats.dataSource = self
        tblSeats.rowHeight = UITableView.automaticDimension
        tblSeats.estimatedRowHeight = 50
        
        
        collLowerDeck.delegate = self
        collLowerDeck.dataSource = self
        
        collUpperDeck.delegate = self
        collUpperDeck.dataSource = self
        
        // register...
        collUpperDeck.register(UINib.init(nibName: "BusSeatsCVCell", bundle: nil), forCellWithReuseIdentifier: "BusSeatsCVCell")
        collLowerDeck.register(UINib.init(nibName: "BusSeatsCVCell", bundle: nil), forCellWithReuseIdentifier: "BusSeatsCVCell")
        
        
        let columnLayout = ColumnFlowLayout (
            cellsPerRow: DBusSeatModel.maxColumns,
            minimumInteritemSpacing: 0,
            minimumLineSpacing: 0,
            sectionInset: UIEdgeInsets(top: 10, left: 0, bottom: 10, right: 0)
        )
        
        collLowerDeck?.collectionViewLayout = columnLayout
        collLowerDeck?.contentInsetAdjustmentBehavior = .always
        
        
        let columnLayout1 = ColumnFlowLayout (
            cellsPerRow: DBusSeatModel.maxColumnsU,
            minimumInteritemSpacing: 0,
            minimumLineSpacing: 0,
            sectionInset: UIEdgeInsets(top: 10, left: 0, bottom: 10, right: 0)
        )
        
        collUpperDeck?.collectionViewLayout = columnLayout1
        collUpperDeck?.contentInsetAdjustmentBehavior = .always
        
        viewLowerDeck.isHidden = false
        viewUpperDeck.isHidden = true
        viewLowerUpperDeck.isHidden = false
        if DBusSeatModel.upperDeckArray.count == 0 {
            
            viewLowerUpperDeck.isHidden = true
            viewUpperDeck.isHidden = true
        }
        
        collLowerDeck.reloadData()
        collUpperDeck.reloadData()
        
    }
    
    func displayBusInfo() {
        
        lblTravelsName.text = DBTravelModel.selectdBus.CompanyName ?? ""
        lblBusType.text = "\(DBTravelModel.selectdBus.BusTypeName ?? "") | \(DBTravelModel.selectdBus.DeptTime ?? "")"
    }
    
    
    
    // MARK: - ButtonAction
    @IBAction func backBtnClicked(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    @IBAction func selectBoardingPoint(_ sender: Any) {
        self.view_packageTypePop?.packageType = .BoardingPoints
        self.view_packageTypePop?.boardingPointArray = DBusSeatModel.pickupPointArray// DBusDetailModel.pickups
        self.view_packageTypePop?.displayInfo()
        self.view_packageTypePop?.boardingDelegate = self
        self.view_packageTypePop?.isHidden = false
        UIApplication.shared.keyWindow?.bringSubviewToFront(self.view_packageTypePop!)
    }
    @IBAction func selectDropPoint(_ sender: Any) {
        self.view_packageTypePop?.packageType = .DropPoints
        self.view_packageTypePop?.dropPointArray = DBusSeatModel.dropPointArray
        self.view_packageTypePop?.displayInfo()
        self.view_packageTypePop?.droppingDelegate = self
        self.view_packageTypePop?.isHidden = false
        UIApplication.shared.keyWindow?.bringSubviewToFront(self.view_packageTypePop!)
    }
//    @IBAction func boardingDropBtnClicked(_ sender: UIButton) {
//        
//        if selectedSeats.count == 0 {
//            self.view.makeToast(message: "Please select seats")
//            return
//        }
//        
//        DBTravelModel.selectedSeats.removeAll()
//        DBTravelModel.selectedSeats = selectedSeats
//        
//        let nextObj = BUS_STORYBOARD.instantiateViewController(withIdentifier: "BusBoardingPointsVC") as! BusBoardingPointsVC
//        self.navigationController?.pushViewController(nextObj, animated: true)
//    }
    
    @IBAction func infoBtnClicked(_ sender: UIButton) {
        
        if selectedSeats.count == 0 {
            self.view.makeToast(message: "Please select seats")
            return
        }
        tblSeats.reloadData()
        heiTblConstraint.constant = CGFloat(selectedSeats.count * 44)
        self.viewPricePop.isHidden = false
    }
    
    @IBAction func dismissPricePopBtnClicked(_ sender: UIButton) {
        self.viewPricePop.isHidden = true
    }
    
    @IBAction func dismissSeatInfoPopBtnClicked(_ sender: UIButton) {
        self.viewSeatInfoPop.isHidden = true
    }
    
    @IBAction func seatInfoBtnClicked(_ sender: UIButton) {
        self.viewSeatInfoPop.isHidden = false
    }
    
    @IBAction func lowerUpperDeckBtnClicked(_ sender: UIButton) {
        
        viewLowerDeck.isHidden = true
        viewUpperDeck.isHidden = true
        
        if sender.tag == 10 {
            viewLowerDeck.isHidden = false
        }
        else if sender.tag == 11 {
            viewUpperDeck.isHidden = false
        }
        else {}
        
        // deck selection...
        for childView in viewLowerUpperDeck.subviews {
            
            if let child_view = childView as? UIButton {
                
                child_view.setTitleColor(UIColor(hexString: "#192031"), for: .normal)
                child_view.backgroundColor = .white
            }
            
            if childView.tag == sender.tag {
                if let child_view = childView as? UIButton {
                    child_view.setTitleColor(UIColor.white, for: .normal)
                    child_view.backgroundColor = UIColor.appColor
                }
            }
        }
    }
    @IBAction func continueAction(_ sender: Any) {
        let seatNumberList = selectedSeats.map{$0.seatName}
        var seatAttrDict : [String: Any] = [:]
        
        if seatNumberList.count == 0 {
            self.view.makeToast(message: "Please select the seat to continue")
        } else if tf_bording.text.isEmpty == true {
            self.view.makeToast(message: "Please select the Boarding point to continue")
        } else if tf_drop_point.text.isEmpty == true {
            self.view.makeToast(message: "Please select the Drop point to continue")
        }else{
            for i in 0..<seatNumberList.count {
                for j in 0..<selectedSeats.count {
                    if (seatNumberList[i] == selectedSeats[j].seatName) {
                        var localDict : [String : Any] = [:]
                        let dict = selectedSeats[j]
                        localDict["decks"] = dict.isUpper == true ? "Upper" : "Lower"
                        localDict["Fare"] = String(dict.seatFare)
                        localDict["IsAcSeat"] = String(dict.seatType) == "2" ? "false" : "true"
                        localDict["Markup_Fare"] = String(dict.seatFare)
                        localDict["SeatType"] = String(dict.seatType)
                        localDict["SeatName"] = String(dict.seatIndex)
                        localDict["seq_no"] = "0"
                        localDict["APIFare"] = String(dict.apiFare)
                        
                        seatAttrDict[String(dict.seatName)] = localDict
                    }
                }
            }
            var dict_final_seat : [String : Any] =  [:]
            dict_final_seat["markup_price_summary"] = String(totalCost)
            dict_final_seat["total_price_summary"] =  String(totalCost)
            dict_final_seat["domain_deduction_fare"] = String(totalCost)
            dict_final_seat["default_currency"] = "INR"
            dict_final_seat["seats"] = seatAttrDict
            DBusResultModel.busSeatAttributDetails = dict_final_seat
//            DBusResultModel.bus_final_total_price = finalCost
            DBusResultModel.selected_boarding = selected_board!
            DBusResultModel.selected_dropOff = selected_drop!
            DBusResultModel.selectedBus = DBTravelModel.selectdBus
            DBusResultModel.bus_Selected_Seats_list = selectedSeats
            DBTravelModel.boardingPoint = selected_board!
            DBTravelModel.dropPoint = selected_drop!
            navigateToPassendgerInfo()
        }
    }
    
    func navigateToPassendgerInfo(){
        let vc = BUS_STORYBOARD.instantiateViewController(withIdentifier: "BusPassengerDetails") as! BusPassengerDetails
        
        navigationController?.pushViewController(vc, animated: true)
        
    }
}

extension BusSeatsVC: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    // MARK: - UICollectionViewDelegate
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        if collectionView == collUpperDeck {
            let loWidt = (Int(collectionView.frame.width) - 20) / DBusSeatModel.maxColumnsU
            return CGSize(width: loWidt, height: 70)
        } else {
            
            let loWidt = (Int(collectionView.frame.width) - 20) / DBusSeatModel.maxColumns
            print("loWidt: \(loWidt)")
            return CGSize(width: loWidt, height: 70) //70
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        if collectionView == collUpperDeck {
//            return DBusSeatModel.maxRowsU * DBusSeatModel.maxColumnsU
//            let rows = DBusSeatModel.validUpperRowIndexes()
//            return rows.count * DBusSeatModel.maxColumnsU
            
            let rows = DBusSeatModel.validUpperRowIndexes().count
            let cols = DBusSeatModel.maxColumnsU
            
            return rows * cols
            
        } else {
//            return DBusSeatModel.maxRows * DBusSeatModel.maxColumns
//            let rows = DBusSeatModel.validLowerRowIndexes()
//            return rows.count * DBusSeatModel.maxColumns
            
            let rows = DBusSeatModel.validLowerRowIndexes().count
            let cols = DBusSeatModel.maxColumns

            return rows * cols
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        // cell creation...
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "BusSeatsCVCell", for: indexPath as IndexPath) as! BusSeatsCVCell
        
        guard let seat = getSeat(for: collectionView, indexPath: indexPath) else {
            cell.reset()
            return cell
        }
        configure(cell: cell, with: seat)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        guard let seat = getSeat(for: collectionView, indexPath: indexPath) else {
            return
        }
        toggleSelection(for: seat)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        
        return 0
    }
}

extension BusSeatsVC {
    
    // MARK: - Seat Mapping
    private func getSeat(
        for collectionView: UICollectionView,
        indexPath: IndexPath
    ) -> SeatDetails? {

        if collectionView == collUpperDeck {

            let rows = DBusSeatModel.validUpperRowIndexes()
            let cols = DBusSeatModel.maxColumnsU

            guard cols > 0 else { return nil }

            let row = indexPath.item / cols
            let col = indexPath.item % cols

            guard row < rows.count else { return nil }

            return DBusSeatModel.getUpperSeatDetails(
                rowId: rows[row],
                columnId: col
            )
        }
        else {

            let rows = DBusSeatModel.validLowerRowIndexes()
            let cols = DBusSeatModel.maxColumns

            guard cols > 0 else { return nil }

            let row = indexPath.item / cols
            let col = indexPath.item % cols

            guard row < rows.count else { return nil }

            return DBusSeatModel.getSeatDetails(
                rowId: rows[row],
                columnId: col
            )
        }
    }
    
    func configure(cell: BusSeatsCVCell, with seat: SeatDetails) {

        cell.reset()

        cell.imgSeats.isHidden = false
        cell.lblSeats.text = seat.isAvailable ? ("\(seat.seatName)") : ""

        let isSelected = selectedSeats.contains { $0.seatIndex == seat.seatIndex }

        // ✅ ONE common height rule for ALL seats
       // cell.seatImageHeightConstraint.constant = cell.contentView.bounds.height * 1.2 //0.9
        
//        let cellWidth = cell.contentView.bounds.height
//
//        switch seat.seatType {
//        case "Vertical Sleeper":
//            cell.seatImageHeightConstraint.constant = cellWidth * 1.35
//        case "Horizontal Sleeper":
//            cell.seatImageHeightConstraint.constant = cellWidth * 0.65
//        case "Seater":
//            cell.seatImageHeightConstraint.constant = cellWidth * 0.75
//        default:
//            cell.seatImageHeightConstraint.constant = cellWidth * 0.75
//        }

//        switch seat.seatType {

//        case /*"Seater"*/1:
       if seat.seatType == 1 {
           if isSelected {
               cell.imgSeats.image = UIImage(named: "ic_seater_selected")
           } else if !seat.isAvailable {
               if seat.isLadiesSeat {
                   cell.imgSeats.image = UIImage(named: "ic_seater_booked_ladies")
               } else if seat.isMalesSeat {
                   cell.imgSeats.image = UIImage(named: "ic_seater_booked_gents")
               } else {
                   cell.imgSeats.image = UIImage(named: "ic_seater_blocked")
               }
           } else if seat.isLadiesSeat {
               cell.imgSeats.image = UIImage(named: "ic_seater_reserved_ladies")
           } else if seat.isMalesSeat {
               cell.imgSeats.image = UIImage(named: "ic_seater_reserved_gents")
           } else {
               cell.imgSeats.image = UIImage(named: "ic_seater_available")
           }

       } else  {
            if seat.width == 2 {
                if isSelected {
                    cell.imgSeats.image = UIImage(named: "ic_sleeper_selected_v")
                } else if !seat.isAvailable {
                    if seat.isLadiesSeat {
                        cell.imgSeats.image = UIImage(named: "ic_sleeper_booked_ladies_v")
                    } else if seat.isMalesSeat {
                        cell.imgSeats.image = UIImage(named: "ic_sleeper_booked_gents_v")
                    } else {
                        cell.imgSeats.image = UIImage(named: "ic_sleeper_blocked_v")
                    }
                } else if seat.isLadiesSeat {
                    cell.imgSeats.image = UIImage(named: "ic_sleeper_reserved_ladies_v")
                } else if seat.isMalesSeat {
                    cell.imgSeats.image = UIImage(named: "ic_sleeper_reserved_gents_v")
                } else {
                    cell.imgSeats.image = UIImage(named: "ic_sleeper_available_v")
                }
            } else {
                if isSelected {
                    cell.imgSeats.image = UIImage(named: "ic_sleeper_selected")
                } else if !seat.isAvailable {
                    if seat.isLadiesSeat {
                        cell.imgSeats.image = UIImage(named: "ic_sleeper_booked_ladies")
                    } else if seat.isMalesSeat {
                        cell.imgSeats.image = UIImage(named: "ic_sleeper_booked_gents")
                    } else {
                        cell.imgSeats.image = UIImage(named: "ic_sleeper_blocked")
                    }
                } else if seat.isLadiesSeat {
                    cell.imgSeats.image = UIImage(named: "ic_sleeper_reserved_ladies")
                } else if seat.isMalesSeat {
                    cell.imgSeats.image = UIImage(named: "ic_sleeper_reserved_gents")
                } else {
                    cell.imgSeats.image = UIImage(named: "ic_sleeper_available")
                }
                
            }
//           else {
//                           cell.imgSeats.image = nil
//
//           }
       }
            
//        case 2/*"Vertical Sleeper"*/:
            
            


//        default:
//            cell.imgSeats.image = nil
//        }

        cell.layoutIfNeeded()
    }
}

// MARK: - Selection
extension BusSeatsVC {

    private func toggleSelection(for seat: SeatDetails) {

        guard seat.isAvailable else { return }

        if let index = selectedSeats.firstIndex(where: {
            $0.seatIndex == seat.seatIndex
        }) {
            selectedSeats.remove(at: index)
        }
        else {

            let limit = DBTravelModel.bookingType == "Self" ? 1 : maxSelection

            guard selectedSeats.count < limit else {
                view.makeToast(message: "Selection limit reached")
                return
            }

            selectedSeats.append(seat)
        }

        updateFareDetails()

        if viewLowerDeck.isHidden {
            collUpperDeck.reloadData()
        } else {
            collLowerDeck.reloadData()
        }
    }

    private func updateFareDetails() {

        let total = selectedSeats.reduce(0) { $0 + $1.seatFare }
        self.totalCost = total
        lblTotalFare.text = String(format: "INR %.2f", total)
        lblGrandTotal.text = String(format: "INR %.2f", total)
        lblSeatCount.text = "\(selectedSeats.count) seats Selected"
    }
}

extension BusSeatsVC: UITableViewDelegate, UITableViewDataSource {

    // MARK: - UITableViewDelegate
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return selectedSeats.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 44 //UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
//        // cell creation...
        var cell = tableView.dequeueReusableCell(withIdentifier: "BusSeatsSelectedTVCell") as? BusSeatsSelectedTVCell
        if cell == nil {
            tableView.register(UINib(nibName: "BusSeatsSelectedTVCell", bundle: nil), forCellReuseIdentifier: "BusSeatsSelectedTVCell")
            cell = tableView.dequeueReusableCell(withIdentifier: "BusSeatsSelectedTVCell") as? BusSeatsSelectedTVCell
        }
        
        cell?.displaySelectedSeats(model: selectedSeats[indexPath.row])

        cell?.selectionStyle = .none
        return cell!
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        

    }
}
class ColumnFlowLayout: UICollectionViewFlowLayout {

    let cellsPerRow: Int

    init(cellsPerRow: Int, minimumInteritemSpacing: CGFloat = 0, minimumLineSpacing: CGFloat = 0, sectionInset: UIEdgeInsets = .zero) {
        self.cellsPerRow = cellsPerRow
        super.init()

        self.minimumInteritemSpacing = minimumInteritemSpacing
        self.minimumLineSpacing = minimumLineSpacing
        self.sectionInset = sectionInset
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func prepare() {
        super.prepare()

        guard let collectionView = collectionView else { return }
        let marginsAndInsets = sectionInset.left + sectionInset.right + collectionView.safeAreaInsets.left + collectionView.safeAreaInsets.right + minimumInteritemSpacing * CGFloat(cellsPerRow - 1)
        let itemWidth = ((collectionView.bounds.size.width - marginsAndInsets) / CGFloat(cellsPerRow)).rounded(.down)
        itemSize = CGSize(width: itemWidth, height: itemWidth)
    }

    override func invalidationContext(forBoundsChange newBounds: CGRect) -> UICollectionViewLayoutInvalidationContext {
        let context = super.invalidationContext(forBoundsChange: newBounds) as! UICollectionViewFlowLayoutInvalidationContext
        context.invalidateFlowLayoutDelegateMetrics = newBounds.size != collectionView?.bounds.size
        return context
    }

}
