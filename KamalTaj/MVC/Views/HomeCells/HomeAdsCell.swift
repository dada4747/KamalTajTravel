//
//  HomeAdsCell.swift
//  Internacia
//
//  Created by Admin on 16/10/22.
//

import UIKit
protocol TopDestinationsProtocol {
    func selectToDestHotels(index: Int)
    func selectFlightDest(index: Int)
    func selectBusesDest(index: Int)
    func selectpromocode(message: String)
}

class HomeAdsCell: UITableViewCell, ApplyPromoDelegateCVCell{
    func didCopyPromoCode(message: String) {
        topDestinationsDelegate?.selectpromocode(message: message)
    }
    
    @IBOutlet weak var lbl_title: UILabel!
    @IBOutlet weak var bg_view: GradientView!
    @IBOutlet weak var coll_ads: UICollectionView!
    
    var adsType = ""
    var trendingHotel_Array: [DCommonTrendingHotelItems] = []
    var trendingFlight_Array: [DCommonTrendingFlightItem] = []
    //    var topHolidayDestinationArray: [DCommonTrendingPackageItem] = []
    var promocodeArray:[DCommonTopOfferItems] = []
    
    var topDestinationsDelegate: TopDestinationsProtocol?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        addDelegates()
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    override func prepareForReuse(){
        super.prepareForReuse()
        
    }
    func addDelegates() {
        
        // delegate...
        coll_ads.delegate = self
        coll_ads.dataSource = self
        
        // register...
        coll_ads.register(UINib.init(nibName: "TopDestinationCVCell", bundle: nil), forCellWithReuseIdentifier: "TopDestinationCVCell")
        coll_ads.register(UINib.init(nibName: "TopFlightCVCell", bundle: nil), forCellWithReuseIdentifier: "TopFlightCVCell")
        coll_ads.register(UINib.init(nibName: "PromoCodeCVCell", bundle: nil), forCellWithReuseIdentifier: "PromoCodeCVCell")
    }
    
    func displayTopHotelDestination(dest_array: [DCommonTrendingHotelItems]) {
        
        trendingHotel_Array = dest_array
        lbl_title.text = "Top Hotel Destinations"
        reloadCollection()
        
    }
    
    func displayTopFlighDestination(trendingFlight_Array: [DCommonTrendingFlightItem]){
        self.trendingFlight_Array = trendingFlight_Array
        lbl_title.text = "Top Flight Routes"
        reloadCollection()
        
    }
    
    func topHolidayDestination(trendingHolidayPackage: [DCommonTopOfferItems]){
        lbl_title.text = "Offers For You"
        promocodeArray = trendingHolidayPackage
        reloadCollection()
    }
    
    func reloadCollection(){
        DispatchQueue.main.async {
            self.coll_ads.reloadData()
            
        }
    }
}

extension HomeAdsCell: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    // MARK:- UICollectionViewDelegate
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        if adsType == "Flight" {
            let item = DCommonModel.trendingFligh_Array[indexPath.row]
            let from = item.from_airport_name ?? ""
            
            let to = item.to_airport_name ?? ""
            
            let text = "\(from) To \(to)"
            
            let font = UIFont.init(name: "Poppins-Medium", size: 16) ?? UIFont.systemFont(ofSize: 16)
            
            let textWidth = text.size(withAttributes: [.font: font]).width
            
            let totalWidth = textWidth + 34
            let finalWidth = max(totalWidth, 170)
            return CGSize(width: finalWidth, height: 270)
            //            return CGSize(width: 200, height: 270)
        } else if adsType == "Hotel" {
            //            114
            let item = DCommonModel.trendingHotel_Array[indexPath.row]
            
            let text = item.cityName ?? ""
            
            let font = UIFont.init(name: "Poppins-Medium", size: 16) ?? UIFont.systemFont(ofSize: 16)
            
            let textWidth = text.size(withAttributes: [.font: font]).width
            
            let totalWidth = textWidth + 115
            let finalWidth = max(totalWidth, 170)
            
            return CGSize(width: finalWidth, height: 270)
            
        } else if adsType == "PromoCode"{
            return CGSize(width: 260, height: 210)
        } else {
            return CGSize(width: 240, height: 243)
        }
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        if adsType == "Flight" {
            return trendingFlight_Array.count
        } else if adsType == "Hotel" {
            return trendingHotel_Array.count
        } else if adsType == "PromoCode" {
            return promocodeArray.count
        } else {
            return 0//trendingHotel_Array.count
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        if adsType == "Hotel" {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "TopDestinationCVCell", for: indexPath as IndexPath) as! TopDestinationCVCell //best holiday cell
            
            //display information...
            cell.displayTrendingHotelInformation(model: trendingHotel_Array[indexPath.row])
            cell.buttonAction = { [weak self] in
                print("Tapped \(indexPath.item)")
                
                self?.topDestinationsDelegate?.selectToDestHotels(index: indexPath.item)
            }
            return cell
        }
        
        if adsType == "Flight" {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "TopFlightCVCell", for: indexPath as IndexPath) as! TopFlightCVCell //best holiday cell
            
            //display information...
            cell.displayFlightInfo(model: trendingFlight_Array[indexPath.row])
            cell.buttonAction = { [weak self] in
                print("Tapped \(indexPath.item)")
                
                self?.topDestinationsDelegate?.selectFlightDest(index: indexPath.item)
            }
            return cell
        } else if adsType == "PromoCode" {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "PromoCodeCVCell", for: indexPath as IndexPath) as! PromoCodeCVCell //best holiday cell
            
            //display information...
            //            cell.displayTrendingPackageInfo(model: topHolidayDestinationArray[indexPath.row])
            cell.delegate = self
            cell.display(model: promocodeArray[indexPath.row])
            
            if indexPath.row % 2 == 0 {
                cell.view_bg.startColor = UIColor(hexString: "#E0FFF7")
                cell.view_bg.endColor = UIColor(hexString: "#C4FFEE")
                cell.view_bg.borderColor = UIColor(hexString: "#C4FFEE")
            } else {
                cell.view_bg.startColor = UIColor(hexString: "#FFE6EB")
                cell.view_bg.endColor = UIColor(hexString: "#FFD5DC")
                cell.view_bg.borderColor = UIColor(hexString: "#FFD5DC")
            }
            return cell
        } else {
            return UICollectionViewCell()
        }
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if adsType == "Hotel" {
            //            print("this is selected hotel")
//            topDestinationsDelegate?.selectToDestHotels(index:  indexPath.row)
        } else if adsType == "Flight" {
//            topDestinationsDelegate?.selectFlightDest(index: indexPath.row)
        }else if adsType == "PromoCode" {
            //            topDestinationsDelegate?.selectTopHolidays(index: indexPath.row)
            
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        
        return 10
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 10
        
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return  UIEdgeInsets(top: 0, left: 20, bottom: 0, right: 20)
    }
}
