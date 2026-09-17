//
//  CalendarPopView.swift
//  Internacia
//
//  Created by Admin on 16/10/22.
//

import UIKit

// protocol...
protocol CalendarPopViewDelegate {
    func CalDatePickUpView(_calendar:CalendarPopView, selDate: Date)
}

class CalendarPopView: UIView {

    // Outlets...
    @IBOutlet weak var view_JBCalendar: JTHorizontalCalendarView!
    @IBOutlet weak var lbl_calendarTitle: UILabel!
    @IBOutlet weak var btn_setLoc: UIButton!
    @IBOutlet weak var btn_rightLoc: UIButton!
    @IBOutlet weak var btn_leftLoc: UIButton!
    
    // variables...
    var delegate: CalendarPopViewDelegate?
    var calendarManager = JTCalendarManager()
    var calSelectedDate = Date()
    var departDate = Date()
    
    
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
        
        self.frame = CGRect.init(x: 0, y: 0, width: UIScreen.main.bounds.size.width, height: UIScreen.main.bounds.size.height)
        
        // calendar setup...
        calendarManager.delegate = self
        calendarManager.contentView = self.view_JBCalendar
        calendarManager.setDate(departDate)
        calendarTitleDisplay(sDate: departDate)
        
       //applyLocalizationMethod()
    }
    
    // MARK:- ButtonAction
    @IBAction func calendarDateSetClicked(_ sender: UIButton) {
        
        self.delegate?.CalDatePickUpView(_calendar: self, selDate: calSelectedDate)
        self.removeFromSuperview()
    }
    @IBAction func calenderHiddenClicked(_ sender: UIButton) {
        
        //self.delegate?.CalDatePickUpView(_calendar: self, selDate: calSelectedDate)
        self.removeFromSuperview()
    }
    
    @IBAction func calendarNextPreviousMonthClicked(_ sender: UIButton) {

        if sender.tag == 10 {
            view_JBCalendar.loadNextPageWithAnimation()

        } else if sender.tag == 11 {
            view_JBCalendar.loadPreviousPageWithAnimation()

        }
    }
    
}
//extension CalendarPopView {
//
//    func applyLocalizationMethod() {
//
//        if let langStr = UserDefaults.standard.object(forKey: yLanguageStore) as? String {
//
//            //flip back btn...
//            if langStr == "ar" {
//                btn_rightLoc.setImage(UIImage.init(named: "left"), for: .normal)
//                btn_leftLoc.setImage(UIImage.init(named: "right"), for: .normal)
//            }
//            else {
//                btn_rightLoc.setImage(UIImage.init(named: "right"), for: .normal)
//                btn_leftLoc.setImage(UIImage.init(named: "left"), for: .normal)
//            }
//        }
//
//        // localization...
//        btn_setLoc.setTitle(Localization(key: "SET"), for: .normal)
//    }
//}


extension CalendarPopView: JTCalendarDelegate {
    
    // MARK:- JTCalendarDelegate
    func calendar(_ calendar: JTCalendarManager!, prepareDayView dayView: (UIView & JTCalendarDay)!) {
        
        // JTCalenarDayView type casting...
        let loDayView = dayView as! JTCalendarDayView
        
        if calendarManager.dateHelper.date(departDate, isTheSameDayThan: loDayView.date) {
 
            // Today...
            loDayView.circleView.isHidden = false
            loDayView.circleView.backgroundColor = UIColor.init(hexString: "#FF8A37" )
            loDayView.dotView.backgroundColor = UIColor.white
            loDayView.textLabel.textColor = UIColor.white
            
        }
        else if calendarManager.dateHelper.date(calSelectedDate, isTheSameDayThan: loDayView.date) {
            
            // Selected date...
            loDayView.circleView.isHidden = false
            loDayView.circleView.backgroundColor = UIColor.init(hexString: "#FFC118")
            loDayView.dotView.backgroundColor = UIColor.white
            loDayView.textLabel.textColor = UIColor.white
        }
        else if !calendarManager.dateHelper.date(self.view_JBCalendar.date, isTheSameMonthThan: loDayView.date) {
            
            // Other month
            loDayView.circleView.isHidden = true
            loDayView.dotView.backgroundColor = UIColor.red
            loDayView.textLabel.textColor = UIColor.lightGray
        }
        else if calendarManager.dateHelper.date(departDate, isEqualOrAfter: loDayView.date) {
            
            // same month passed dates...
            loDayView.circleView.isHidden = true
            loDayView.dotView.backgroundColor = UIColor.red
            loDayView.textLabel.textColor = UIColor.lightGray
        }
        else {
            
            // Another day of the current month
            loDayView.circleView.isHidden = true
            loDayView.dotView.backgroundColor = UIColor.red
            loDayView.textLabel.textColor = UIColor.black
        }
    }
    
    func calendar(_ calendar: JTCalendarManager!, didTouchDayView dayView: (UIView & JTCalendarDay)!) {
        
        // JTCalenarDayView type casting...
        let loDayView = dayView as! JTCalendarDayView
        
        // today date getting with formate...
        let todayDateStr = DateFormatter.getDateString(formate: "dd-MM-yyyy", date: Date())
        let todayDate = DateFormatter.getDate(formate: "dd-MM-yyyy", date: todayDateStr)
        
        // select date gettign with formate...
        let dateSelectStr = DateFormatter.getDateString(formate: "dd-MM-yyyy", date: loDayView.date)
        let selectDate = DateFormatter.getDate(formate: "dd-MM-yyyy", date: dateSelectStr)
        
        // user selected past date...
        if todayDate.compare(selectDate) == .orderedDescending {
            //self.makeToast(message: "Date already past")
        }
        else if departDate.compare(selectDate) == .orderedDescending && DTravelModel.tripType == .Round  {
            //self.makeToast(message: "Date already past")
        }
        else {
            
            // choose selection date....
            calSelectedDate = loDayView.date
            
            // Animation for the circleView
            loDayView.circleView.transform = CGAffineTransform.init(scaleX: 0.1, y: 0.1)
            UIView.transition(with: dayView, duration: 0.3, options: [], animations: {
                loDayView.circleView.transform = .identity
                self.calendarManager.reload()
            })
            
            // Don't change page in week mode because block the selection of days in first and last weeks of the month...
            if calendarManager.settings.weekModeEnabled {
                return
            }
            
            // Load the previous or next page if touch a day from another month...
            if !calendarManager.dateHelper.date(self.view_JBCalendar.date, isTheSameMonthThan: loDayView.date) {
                
                if self.view_JBCalendar.date.compare(loDayView.date) == .orderedAscending {
                    self.view_JBCalendar.loadNextPageWithAnimation()
                } else {
                    self.view_JBCalendar.loadPreviousPageWithAnimation()
                }
            }
        }
    }
    
    func calendar(_ calendar: JTCalendarManager!, canDisplayPageWith date: Date!) -> Bool {
        
        // Min date will be 2 month before today
        let minCalDate = calendarManager.dateHelper.add(to: Date(), months: 0)
        
        // Max date will be 2 month after today
        let maxCalDate = calendarManager.dateHelper.add(to: Date(), months: 24)
        
        return self.calendarManager.dateHelper.date(date, isEqualOrAfter: minCalDate, andEqualOrBefore: maxCalDate)
    }
    
    func calendarDidLoadNextPage(_ calendar: JTCalendarManager!) {
        // next month...
        calendarTitleDisplay(sDate: calendar.date())
    }
    
    func calendarDidLoadPreviousPage(_ calendar: JTCalendarManager!) {
        
        // previous month...
      
        calendarTitleDisplay(sDate: calendar.date())
    }
    
    func calendarTitleDisplay(sDate: Date) {
        // calender month setup...
        
        if returnMonth(d: Date()) == returnMonth(d: sDate) {
            btn_leftLoc.isHidden = true
        } else {
            btn_leftLoc.isHidden = false
        }
        
        lbl_calendarTitle.text = DateFormatter.getDateString(formate: "MMM yyyy", date: sDate)
    }
    
    func returnMonth(d: Date) -> String {
        let month = DateFormatter.getDateString(formate: "MMM", date: d)
        return month
    }
}

