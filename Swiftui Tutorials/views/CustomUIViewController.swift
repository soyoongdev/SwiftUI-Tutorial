//
//  CustomUIViewController.swift
//  Swiftui Tutorials
//
//  Created by Hau Nguyen on 23/09/2021.
//

import SwiftUI

struct CustomUIViewController: View {
    @State var selectedDate = Date()

        static let formatter: DateFormatter = {
            let formatter = DateFormatter()
            formatter.setLocalizedDateFormatFromTemplate("yyyy MM dd")
            return formatter
        }()
    @State var isShowing: Bool = false
    
    
    var body: some View {
        VStack {
            Text("Selected date: \(selectedDate, formatter: Self.formatter)")
            
            Button(action: {
                withAnimation(.spring()) {
                    self.showDatePickerAlert()
                }
            }){
                Text("Show action")
            }
        }
    }
    
    func showDatePickerAlert() {
        let alertVC = UIAlertController(title: "Title", message: "\n\n\n\n\n\n\n\n\n\n", preferredStyle: .actionSheet)
        let datePicker: UIDatePicker = UIDatePicker()
        datePicker.timeZone = NSTimeZone.local
        datePicker.preferredDatePickerStyle = .wheels
        datePicker.frame = CGRect(x: -8, y: 30, width: react.width, height: 200)
        datePicker.datePickerMode = .date
        
        alertVC.view.addSubview(
            datePicker
        )
        
        let okAction = UIAlertAction(title: "OK", style: .default) { _ in
            self.selectedDate = datePicker.date
        }
        alertVC.addAction(okAction)
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel)
        alertVC.addAction(cancelAction)
        
        if let viewController = UIApplication.shared.windows.first?.rootViewController {
            viewController.present(alertVC, animated: true, completion: nil)
        }
    }
}


struct CustomUIViewController_Previews: PreviewProvider {
    static var previews: some View {
        CustomUIViewController()
    }
}
