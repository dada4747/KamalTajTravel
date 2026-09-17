//
//  FlightPaxCell.swift
//  JetConnect
//
//  Created by Nandu on 03/01/25.
//

import UIKit


// protocol...
protocol passengerFormCellDelegate {
    
    func titleButtion_Action(sender: UIButton, cell: UITableViewCell)
    func genderButton_Action(sender: UIButton, cell: UITableViewCell)
    func ppNationalityButton_Action(sender: UIButton, cell: UITableViewCell)
    func dobButton_Action(sender: UIButton, cell: UITableViewCell)
    func ppIssuingCountryButton_Action(sender: UIButton, cell: UITableViewCell)
    func ppExpiryButton_Action(sender: UIButton, cell: UITableViewCell)
    func textFieldDidChange(textField:UITextField, cell: UITableViewCell)
    
    func didTapReturn(textField:UITextField, cell: UITableViewCell)
}

class FlightPaxCell: UITableViewCell {
    
    @IBOutlet weak var lblPaxType: UILabel!
//    @IBOutlet weak var txtTitle: UITextField!
    @IBOutlet weak var txtFirstName: UITextField!
    @IBOutlet weak var txtLastName: UITextField!
    @IBOutlet weak var txtGender: UITextField!
    @IBOutlet weak var txtNationality: UITextField!
    @IBOutlet weak var txtDob: UITextField!
    @IBOutlet weak var txtPassportNo: UITextField!
    @IBOutlet weak var txtIssuingCountry: UITextField!
    @IBOutlet weak var txtPPExpDate: UITextField!
    @IBOutlet weak var btnDOB: UIButton!
    @IBOutlet weak var btnPPE: UIButton!
//    @IBOutlet weak var view_title: CRView!
//    @IBOutlet weak var titleHConstraint: NSLayoutConstraint!
    
    @IBOutlet weak var internationalStackView: UIStackView!
    var delegate: passengerFormCellDelegate?
    @IBOutlet weak var buttonStackView: UIStackView!
    var onTitleChanged: ((String) -> Void)?

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        
        txtFirstName.delegate = self
        txtLastName.delegate = self
        txtPassportNo.delegate = self
        
        txtFirstName.returnKeyType = .next
        txtLastName.returnKeyType = .next
        txtPassportNo.returnKeyType = .done
        
        txtFirstName.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingChanged)
        txtLastName.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingChanged)
        txtPassportNo.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingChanged)
        
    }
    
    @objc func textFieldDidChange(_ textField:UITextField){
        delegate?.textFieldDidChange(textField: textField, cell: self)
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    //MARK: - Helper
    func displayPassenger_information(model: DPassengerItem, isDomestic: Bool) {
        internationalStackView.isHidden = false
        if isDomestic {
            internationalStackView.isHidden = true
        }
//        txtTitle.text = model.title_name
        txtFirstName.text = model.first_name ?? ""
        txtLastName.text = model.last_name ?? ""
        txtGender.text = model.gender_value
        txtNationality.text = model.issued_country
        txtDob.text = model.dateOf_birth ?? ""
        txtPassportNo.text = model.passport_no ?? ""
        txtIssuingCountry.text = model.issued_country
        txtPPExpDate.text = model.passport_expiry ?? ""
        
        if model.dateOf_birth != nil {
            
            let displayDate = DateFormatter.getDate(formate: "yyyy-MM-dd", date: model.dateOf_birth ?? "")
            txtDob.text = DateFormatter.getDateString(formate: "dd-MM-yyyy", date: displayDate)
        }
        
        if model.passport_expiry != nil {
            
            let expDate = DateFormatter.getDate(formate: "yyyy-MM-dd", date: model.passport_expiry ?? "")
            txtPPExpDate.text = DateFormatter.getDateString(formate: "dd-MM-yyyy", date: expDate)
        }
//        view_title.isHidden = false
//        titleHConstraint.constant = 62
//        if model.person_type != "Adult" {
//            view_title.isHidden = true
//            titleHConstraint.constant = 0
//        }
    }
    

    //MARK: - Buttton Action
    @IBAction func titleBtnClicked(_ sender: UIButton) {
        delegate?.titleButtion_Action(sender: sender, cell: self)
    }
    
    @IBAction func genderBtnClicked(_ sender: UIButton) {
        delegate?.genderButton_Action(sender: sender, cell: self)
    }
    
    @IBAction func nationalityBtnClicked(_ sender: UIButton) {
        delegate?.ppNationalityButton_Action(sender: sender, cell: self)
    }
    
    @IBAction func dobBtnClicked(_ sender: UIButton) {
        delegate?.dobButton_Action(sender: sender, cell: self)
    }
    
    
    @IBAction func ppIssuingCountryBtnClicked(_ sender: UIButton) {
        delegate?.ppIssuingCountryButton_Action(sender: sender, cell: self)
    }
    @IBAction func ppExpiryBtnClicked(_ sender: UIButton) {
        delegate?.ppExpiryButton_Action(sender: sender, cell: self)
    }
    func configure(with titles: [String], selected: String? = nil) {
            buttonStackView.arrangedSubviews.forEach { $0.removeFromSuperview() }

            for (index, title) in titles.enumerated() {
                let button = UIButton(type: .system)
                button.setTitle(title, for: .normal)
                button.tag = index
                button.addTarget(self, action: #selector(titleTapped), for: .touchUpInside)
                style(button, isSelected: title == selected || (selected == nil && index == 0))
                buttonStackView.addArrangedSubview(button)
            }
        }
    @objc private func titleTapped(_ sender: UIButton) {
        for case let button as UIButton in buttonStackView.arrangedSubviews {
            style(button, isSelected: button == sender)
        }
        onTitleChanged?(sender.title(for: .normal) ?? "")
    }
    private func style(_ button: UIButton, isSelected: Bool) {
        button.backgroundColor = isSelected ? .appColor : .clear
            button.setTitleColor(isSelected ? .white : .appColor, for: .normal)
            button.layer.cornerRadius = 6
            button.layer.borderWidth = 1
            button.layer.borderColor = UIColor.appColor.cgColor
            button.clipsToBounds = true
        }
}

extension FlightPaxCell : UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        delegate?.didTapReturn(textField: textField, cell: self)
        return false // prevent default behavior
    }
}
