//
//  DatePickerPopView.swift
//  JetConnect
//
//  Created by Nandu on 20/12/24.
//

import UIKit

// protocol...
protocol DPickerPopViewDelegate: class {
    func datePickerPopView(_picker: DatePickerPopView, _date: Date)
}

class DatePickerPopView: UIView {
    
    // Outlets...
    @IBOutlet weak var date_picker: UIDatePicker!
    @IBOutlet weak var lbl_title: UILabel!
    @IBOutlet weak var view_header: UIView!
    
    // variables...
    weak var delegate: DPickerPopViewDelegate?
    var dateType = PickerType.Date
    enum PickerType {
        
        case Date
        case Time
        case DateAndTime
        case DownTimer
    }

    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */
    
    override func draw(_ rect: CGRect) {
        
//        // Drawing code
//        self.frame = CGRect.init(x: 0, y: 0, width: UIScreen.main.bounds.size.width, height: UIScreen.main.bounds.size.height)
//        
//        // localization...
//        let usLocale = NSLocale(localeIdentifier: "en_GB")
//        date_picker.locale = usLocale as Locale
//        date_picker.calendar = Calendar(identifier: .gregorian)
//        if dateType == .DateAndTime {
//            date_picker.datePickerMode = .dateAndTime
//            date_picker.minuteInterval = 30
//        }
//        
//        //date_picker.sizeToFit()
        

  
    }
    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.frame = UIScreen.main.bounds
        
        let usLocale = Locale(identifier: "en_GB")
        date_picker.locale = usLocale
        date_picker.calendar = Calendar(identifier: .gregorian)

        if dateType == .DateAndTime {
            date_picker.datePickerMode = .dateAndTime
            date_picker.minuteInterval = 30
        }
    }
    
    // MARK: - Helpers
    func setDefaultPickerTime() {
        
        // Set the minimum time to 00:00
        let calendar = Calendar.current
        var components = calendar.dateComponents([.year, .month, .day, .hour, .minute], from: Date())
        components.hour = 0
        components.minute = 0
        if let minDate = calendar.date(from: components) {
            date_picker.minimumDate = minDate
        }

        date_picker.minuteInterval = 30
        date_picker.datePickerMode = .time
        
        dateType = .Time
        if #available(iOS 13.4, *) {
            date_picker.preferredDatePickerStyle = .wheels
        } else {
            // Fallback on earlier versions
        }
        
       // date_picker.date = setDatePickerTime(datePicker: date_picker)
    }
    
    func setDatePickerTime(datePicker: UIDatePicker) -> Date {
        
    
        let nextDay = Calendar.current.date(byAdding: .day, value: 1, to: Date())!
        let calendar = Calendar.current
        let currentHour = calendar.component(.hour, from: nextDay)
        let currentMinute = calendar.component(.minute, from: nextDay)

        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat =  "HH:mm"

        var pickerOutHour = ""
        var pickerOutMinute = ""

        if (currentMinute > 30 && currentMinute < 60){
            pickerOutMinute = "00"
            pickerOutHour = String((Int(currentHour) + 1) % 24)
        }
  //        else if (currentMinute > -1 && currentMinute < 16) {
  //          pickerOutMinute = "15"
  //          pickerOutHour = String(currentHour)
  //      }
          else if (currentMinute > -1 && currentMinute < 31){
            pickerOutMinute = "30"
            pickerOutHour = String(currentHour)
        }
  //        else if (currentMinute > 30 && currentMinute < 46){
  //          pickerOutMinute = "45"
  //          pickerOutHour = String(currentHour)
  //      }

        let pickerOutDate = dateFormatter.date(from: pickerOutHour + ":" + pickerOutMinute)
        return pickerOutDate!
    }
    
    @IBAction func cancelAndDoneClicked(_ sender: UIButton) {
        
        if sender.tag == 11 {
            // calling delegates...
            self.delegate?.datePickerPopView(_picker: self, _date: date_picker.date)
        }
        self.removeFromSuperview()
    }

    // min, max and current date...
    func setMinimumDate(_date: Date) -> Void {
        date_picker.minimumDate = _date
    }
    
    func setMaximumDate(_date: Date) -> Void {
        date_picker.maximumDate = _date
    }
    
    func setDate(_date: Date) -> Void {
        date_picker.date = _date
    }
}

