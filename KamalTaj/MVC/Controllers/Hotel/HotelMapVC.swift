//
//  HotelMapVC.swift
//  EzyAirline
//
//  Created by Rahul on 25/03/25.
//

import UIKit
import MapKit

class HotelMapVC: UIViewController {
    var hotelsList_array: [DHotelSearchItem] = []
    private var selectedHotel: DHotelSearchItem?
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var collectionView:UICollectionView!
    
    @IBOutlet weak var headerview: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        headerview.viewShadow()
        hotelsList_array = DHotelSearchModel.hotelsSearch_array
        selectedHotel = hotelsList_array.first // Set the first hotel as selected initially
        setupUI()
        setupMap()
        DispatchQueue.main.async {
            self.collectionView.reloadData()
        }
    }
    
    private func fitAllAnnotations() {
        guard !mapView.annotations.isEmpty else { return }
        
        var zoomRect = MKMapRect.null
        for annotation in mapView.annotations {
            let annotationPoint = MKMapPoint(annotation.coordinate)
            let pointRect = MKMapRect(x: annotationPoint.x, y: annotationPoint.y, width: 0.1, height: 0.1)
            zoomRect = zoomRect.union(pointRect)
        }
        
        let edgePadding = UIEdgeInsets(top: 50, left: 50, bottom: 50, right: 50)
        mapView.setVisibleMapRect(zoomRect, edgePadding: edgePadding, animated: true)
    }
    
    private func setupUI() {
        mapView.delegate = self
        
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.register(UINib.init(nibName: "HotelMapCVCell", bundle: nil), forCellWithReuseIdentifier: "HotelMapCVCell")
        
    }
    
    private func setupMap() {
        for hotel in hotelsList_array {
            let annotation = HotelAnnotation(hotel: hotel)
            mapView.addAnnotation(annotation)
        }
        
        fitAllAnnotations()
    }
    
    @IBAction func backAction(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
}

//MARK: - UICollectionView_DataSource And Delegate

extension HotelMapVC: UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return hotelsList_array.count
    }
    // MARK: - Dynamic Cell Width Calculation
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
//        let label = UILabel()
//        label.text = hotelsList_array[indexPath.item].hotel_name
//        label.font = UIFont(name: "Poppins-Medium", size: 20)
//        label.sizeToFit()
        let screenWidth = UIScreen.main.bounds.width
                let width = screenWidth * 0.8
        let cellPadding: CGFloat = 141 // Extra padding for spacing
//        let width = label.frame.width + cellPadding
        let height: CGFloat = 105 // Fixed height
        
        return CGSize(width: width, height: height)
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "HotelMapCVCell", for: indexPath as IndexPath) as! HotelMapCVCell //best holiday cell
        
        let hotel = hotelsList_array[indexPath.item]
        cell.configure(with: hotel, isSelected: hotel.resultToken == selectedHotel?.resultToken)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        selectedHotel = hotelsList_array[indexPath.item]
        DispatchQueue.main.async {
            self.updateSelection()
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
    private func updateSelection() {
        
        // Find the selected hotel index
        if let selectedHotel = selectedHotel, let selectedIndex = hotelsList_array.firstIndex(where: { $0.resultToken == selectedHotel.resultToken }) {
            let indexPath = IndexPath(item: selectedIndex, section: 0)
            collectionView.scrollToItem(at: indexPath, at: .centeredHorizontally, animated: true)
        }
        DispatchQueue.main.async {
            self.collectionView.reloadData()
        }
        mapView.removeAnnotations(mapView.annotations)
        setupMap()
    }
    
}

//MARK: - MKMapViewDelegate

extension HotelMapVC : MKMapViewDelegate {
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        guard let hotelAnnotation = annotation as? HotelAnnotation else { return nil }
        let identifier = "HotelAnnotationView"
        var annotationView = mapView.dequeueReusableAnnotationView(withIdentifier: identifier) as? HotelAnnotationView
        
        if annotationView == nil {
            annotationView = HotelAnnotationView(annotation: annotation, reuseIdentifier: identifier)
        }
        annotationView?.configure(with: hotelAnnotation.hotel, isSelected: hotelAnnotation.hotel.resultToken == selectedHotel?.resultToken)
        return annotationView
    }
    
    func mapView(_ mapView: MKMapView, didSelect annotation: MKAnnotation) {
        guard let hotelAnnotation = annotation as? HotelAnnotation else { return }
        selectedHotel = hotelAnnotation.hotel
        
        let region = MKCoordinateRegion(center: hotelAnnotation.coordinate,
                                        latitudinalMeters: 100, // Keep moderate zoom
                                        longitudinalMeters: 100) // Adjust as needed
        mapView.setRegion(region, animated: true)
        updateSelection()
    }
}


//MARK: - HotelAnnotation

class HotelAnnotation: NSObject, MKAnnotation {
    let coordinate: CLLocationCoordinate2D
    let hotel: DHotelSearchItem
    
    init(hotel: DHotelSearchItem) {
        self.hotel = hotel
        self.coordinate = CLLocationCoordinate2D(latitude: hotel.latitude, longitude: hotel.longitude)
    }
}


//MARK: - custom annotation view

class HotelAnnotationView: MKAnnotationView {
    private let containerView = UIView()
    private let backgroundImageView = UIImageView()
    private let priceLabel = UILabel()
    
    override init(annotation: MKAnnotation?, reuseIdentifier: String?) {
        super.init(annotation: annotation, reuseIdentifier: reuseIdentifier)
        setupView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupView() {
        addSubview(containerView)
        
        // Configure Container View
        containerView.clipsToBounds = true
        
        // Configure Background ImageView (stretches to fill containerView)
        backgroundImageView.contentMode = .scaleToFill
        backgroundImageView.clipsToBounds = true
        containerView.addSubview(backgroundImageView)
        
        // Configure Price Label (centered but moved upwards)
        priceLabel.textAlignment = .center
        priceLabel.font = UIFont.systemFont(ofSize: 20, weight: .medium)
        priceLabel.adjustsFontSizeToFitWidth = true
        priceLabel.minimumScaleFactor = 0.8
        containerView.addSubview(priceLabel)
    }
    
    func configure(with hotel: DHotelSearchItem, isSelected: Bool) {
        priceLabel.text = String(format: "%@ %.0f", DCurrencyModel.currency_saved?.currency_symbol ?? "$", ((hotel.hotel_price + hotel.hotel_gst)  * (DCurrencyModel.currency_saved?.currency_value ?? 1.0)))
        
        // Calculate dynamic width based on text size
        let textWidth = priceLabel.intrinsicContentSize.width + 32 // Adding padding
        let height = isSelected ? 56 : 41
        
        // Set container frame
        containerView.frame = CGRect(x: 0, y: 0, width: Int(textWidth), height: height)
        frame = containerView.frame
        
        // Background image fills container
        backgroundImageView.frame = containerView.bounds
        
        // Move Price Label slightly **UP**
        let labelYOffset: CGFloat = -5 // Adjust this value to move it more or less
        priceLabel.frame = CGRect(x: 0, y: labelYOffset, width: textWidth, height: CGFloat(height))
        priceLabel.center.x = containerView.center.x
        
        // Apply different styles based on selection state
        backgroundImageView.image = UIImage(named: isSelected ? "selectedBackground" : "defaultBackground")
        priceLabel.textColor = isSelected ? .white : .black
    }
}
