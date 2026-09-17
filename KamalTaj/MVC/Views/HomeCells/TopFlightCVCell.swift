//
//  TopFlightCVCell.swift
//  Internacia
//
//  Created by Admin on 19/10/22.
//

import UIKit

class TopFlightCVCell: UICollectionViewCell {
    
    @IBOutlet weak var image: UIImageView!
    @IBOutlet weak var from_dest: UILabel!
    @IBOutlet weak var to_dest: UILabel!
    
    @IBOutlet weak var img_source: CRImageView!
    var buttonAction: (() -> Void)?

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    func displayFlightInfo(model : DCommonTrendingFlightItem){
//        print(URL.init(string: model.image!.replacingOccurrences(of: " ", with: "%20"))!)
        from_dest.text = model.from_airport_name
        to_dest.text = model.to_airport_name
        image.sd_setImage(with: URL.init(string: (model.image?.replacingOccurrences(of: " ", with: "%20"))!), completed: nil)
        img_source.sd_setImage(with: URL.init(string: (model.image?.replacingOccurrences(of: " ", with: "%20"))!), completed: nil)

    }
    @IBAction func btnSelectAction(_ sender: UIButton) {

        buttonAction?()

    }


    override func preferredLayoutAttributesFitting(_ layoutAttributes: UICollectionViewLayoutAttributes) -> UICollectionViewLayoutAttributes {
        setNeedsLayout()
        layoutIfNeeded()

        let size = contentView.systemLayoutSizeFitting(layoutAttributes.size)
                
            var frame = layoutAttributes.frame
            frame.size.height = ceil(size.height)
                
            layoutAttributes.frame = frame
        return layoutAttributes

       }
}
