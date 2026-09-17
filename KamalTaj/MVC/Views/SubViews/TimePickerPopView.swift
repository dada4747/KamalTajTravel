//
//  TimePickerPopView.swift
//  Dreamora
//
//  Created by Rahul on 07/08/25.
//

import UIKit

class TimePickerPopView: UIView {
    @IBOutlet weak var timePicker: UIDatePicker!
    @IBOutlet weak var lbl_title: UILabel!
    @IBOutlet weak var view_header: UIView!
    var completion: ((Date) -> Void)?
    var baseDate = Date()
    let calendar = Calendar.current
    var minuteInterval: Int = 1  // Default is 1, can be overridden
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    private func setupUI() {
        self.frame = UIScreen.main.bounds

        let usLocale = Locale(identifier: "en_GB")
        timePicker.locale = usLocale
        timePicker.datePickerMode = .time
        timePicker.preferredDatePickerStyle = .wheels
        timePicker.tintColor = .secAppColor
        timePicker.calendar = Calendar(identifier: .gregorian)
        timePicker.minuteInterval = minuteInterval
        timePicker.date = baseDate

        if calendar.isDateInToday(baseDate) {
            timePicker.minimumDate = Date()
        }
    }
    
    func configure(baseDate: Date, minuteInterval: Int = 1, completion: @escaping (Date) -> Void) {
        self.baseDate = baseDate
        self.minuteInterval = minuteInterval
        self.completion = completion
        setupUI()
    }
    
    func time12HrsFormat() {
        let usLocale = Locale(identifier: "en_US_POSIX")
        timePicker.locale = usLocale
        timePicker.locale = Locale(identifier: "en_US_POSIX")
        timePicker.minimumDate = .none

    }
    
    @IBAction func cancelAndDoneClicked(_ sender: UIButton) {
        
        if sender.tag == 11 {
            let selectedTime = timePicker.date
            let timeComp = calendar.dateComponents([.hour, .minute], from: selectedTime)
            var dateComp = calendar.dateComponents([.year, .month, .day], from: baseDate)
            dateComp.hour = timeComp.hour
            dateComp.minute = timeComp.minute
            dateComp.second = 0

            completion?(calendar.date(from: dateComp) ?? baseDate)
            
        }
        self.removeFromSuperview()
    }
    
}
