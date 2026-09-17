//
//  AddTravellerCell.swift
//  EasiTripBooking
//
//  Created by Admin on 29/10/25.
//

import UIKit
protocol AddTravellerCellDelegate {
    func textFieldDidChange(textField:UITextField, cell: UITableViewCell)
    func didTapReturn(textField:UITextField, cell: UITableViewCell)

//    func typeSelected(sender: UIButton, cell: UITableViewCell)
//    func firstNameTextField(sender: UITextField, cell: UITableViewCell)
//    func lastNameTextField(sender: UITextField, cell: UITableViewCell)
}

class AddTravellerCell: UITableViewCell {
    @IBOutlet weak var buttonStackView: UIStackView!

    @IBOutlet weak var tf_firstName: UITextField!
    @IBOutlet weak var tf_lastName: UITextField!
    @IBOutlet weak var tf_age: UITextField!
    @IBOutlet weak var lbl_travellerSeat: UILabel!
    
    var selectedIndexPath : IndexPath?
    var onTitleChanged: ((String) -> Void)?

    var delegate: AddTravellerCellDelegate?
    override func awakeFromNib() {
        super.awakeFromNib()
        tf_firstName.delegate = self
        tf_lastName.delegate = self
        tf_firstName.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingChanged)
        tf_lastName.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingChanged)
        tf_age.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingChanged)
        tf_age.delegate = self
    }
//    @IBAction func nameTitleBtnTapped(_ sender: UIButton) {
//        delegate?.typeSelected(sender: sender, cell: self)
//    }
    
    
//    @objc func valueChanged(_ textField: UITextField){
//        if textField == tf_firstName {
//            delegate?.firstNameTextField(sender: textField, cell: self)
//        } else if textField == tf_lastName {
//            delegate?.lastNameTextField(sender: textField, cell: self)
//        }
//        
//    }
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
    private func style(_ button: UIButton, isSelected: Bool) {
        button.backgroundColor = isSelected ? .secAppColor : .clear
        button.setTitleColor(isSelected ? .white : .secAppColor, for: .normal)
        button.layer.cornerRadius = 6
        button.layer.borderWidth = 1
        button.layer.borderColor = UIColor.secAppColor.cgColor
        button.clipsToBounds = true
    }
    func getTitleGenderValue(for title: String) -> (titleValue: String, genderValue: String)? {
        switch title.trimmingCharacters(in: .whitespaces) {
        case "Mr":     return ("1", "1")
        case "Ms":     return ("2", "2")
        case "Miss":   return ("3", "2")
        case "Master", "Mstr": return ("4", "1")
        case "Mrs":    return ("5", "2")
        default:       return nil
        }
    }
    @objc private func titleTapped(_ sender: UIButton) {
        for case let button as UIButton in buttonStackView.arrangedSubviews {
            style(button, isSelected: button == sender)
        }
        onTitleChanged?(sender.title(for: .normal) ?? "")
    }
    @objc func textFieldDidChange(_ textField:UITextField){
        delegate?.textFieldDidChange(textField: textField, cell: self)
    }
    

//MARK: - IBActions method
}
extension AddTravellerCell : UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        delegate?.didTapReturn(textField: textField, cell: self)
        return false
    }
}
