//
//  DatePickerHelper.swift
//  Dreamora
//
//  Created by Rahul on 07/08/25.
//
import UIKit


enum DatePickerHelper {
    static func showTimePickerInAlert(baseDate: Date, on viewController: UIViewController, completion: @escaping (Date) -> Void) {
        let alert = UIAlertController(title: "Select Time", message: "\n\n\n\n\n\n\n\n", preferredStyle: .alert)

        let timePicker = UIDatePicker()
        timePicker.datePickerMode = .time
        timePicker.preferredDatePickerStyle = .wheels
        timePicker.locale = Locale(identifier: "en_GB")
        timePicker.date = baseDate
        timePicker.translatesAutoresizingMaskIntoConstraints = false
        timePicker.tintColor = .secAppColor

        // Restrict past time if baseDate is today
        let calendar = Calendar.current
        if calendar.isDateInToday(baseDate) {
            timePicker.minimumDate = Date()
        }
        
        alert.view.addSubview(timePicker)

        NSLayoutConstraint.activate([
            timePicker.topAnchor.constraint(equalTo: alert.view.topAnchor, constant: 60),
            timePicker.centerXAnchor.constraint(equalTo: alert.view.centerXAnchor),
            timePicker.heightAnchor.constraint(equalToConstant: 160)
        ])
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        let doneAction = UIAlertAction(title: "Done", style: .default) { _ in
            let selectedTime = timePicker.date
            let timeComp = calendar.dateComponents([.hour, .minute], from: selectedTime)
            var dateComp = calendar.dateComponents([.year, .month, .day], from: baseDate)
            dateComp.hour = timeComp.hour
            dateComp.minute = timeComp.minute
            dateComp.second = 0

            completion(calendar.date(from: dateComp) ?? baseDate)
        }

        alert.addAction(cancelAction)
        alert.addAction(doneAction)

        // Tint for Cancel button (text color red)
        alert.view.tintColor = .red

        // After presenting the alert, access buttons and modify appearance
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
            if let doneButton = alert.view.findButton(withTitle: "Done") {
                doneButton.backgroundColor = .red
                doneButton.setTitleColor(.white, for: .normal)
                doneButton.layer.cornerRadius = 8
            }
        }

//        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel))
//        alert.addAction(UIAlertAction(title: "Done", style: .default, handler: { _ in
//            let selectedTime = timePicker.date
//            let timeComp = calendar.dateComponents([.hour, .minute], from: selectedTime)
//            var dateComp = calendar.dateComponents([.year, .month, .day], from: baseDate)
//            dateComp.hour = timeComp.hour
//            dateComp.minute = timeComp.minute
//            dateComp.second = 0
//
//            completion(calendar.date(from: dateComp) ?? baseDate)
//        }))

        viewController.present(alert, animated: true)
    }
}
extension UIView {
    func findButton(withTitle title: String) -> UIButton? {
        return self.subviews.compactMap { subview in
            if let button = subview as? UIButton,
               button.title(for: .normal) == title {
                return button
            }
            return subview.findButton(withTitle: title)
        }.first
    }
}
