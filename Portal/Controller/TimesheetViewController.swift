//
//  TimesheetViewController.swift
//  Portal
//
//  Created by Chandu Reddy on 22/01/21.
//

import UIKit
import Firebase
import JGProgressHUD


class TimesheetViewController: UIViewController, UITextFieldDelegate {
    let spinner = JGProgressHUD(style: .dark)
    @IBOutlet var errorMessage1: UILabel!
    @IBOutlet var errorMessage2: UILabel!
    @IBOutlet var errorMessage3: UILabel!
    @IBOutlet var errorMessage4: UILabel!
    @IBOutlet var errorMessage5: UILabel!
    @IBOutlet var projectField: UITextField!
    @IBOutlet var dateField: UITextField!
   @IBOutlet var descField: UITextField!
  //  @IBOutlet var descTextView: UITextView!
    @IBOutlet var statusField: UITextField!
    @IBOutlet var hoursField: UITextField!
    @IBOutlet var submitButton: UIButton!
    let datePicker = UIDatePicker()
    let projectPicker = UIPickerView()
    let statusPicker = UIPickerView()
    var projectsList = ["Connect Doctor", "PDS", "Leave","Hr Portal"]
    var statusList = ["In-Progress", "Completed", "In-hold"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let tap = UITapGestureRecognizer(target: self, action: #selector(UIInputViewController.dismissKeyboard))
        view.addGestureRecognizer(tap)
        showDatePicker()
        projectsPicker()
        errorMessage1.isHidden = true
        errorMessage2.isHidden = true
        errorMessage3.isHidden = true
        errorMessage4.isHidden = true
        errorMessage5.isHidden = true
        projectPicker.delegate = self
        projectPicker.dataSource = self
        statusPicker.delegate = self
        statusPicker.dataSource = self
        projectPicker.tag = 1
        statusPicker.tag = 2
     //   descTextView.delegate = self
//        descTextView.layer.cornerRadius = 5
//        descTextView.layer.borderWidth = 0.5
//        descTextView.layer.borderColor = UIColor.lightGray.cgColor
//        descTextView.textColor = UIColor.lightGray
      //  descTextView.text = "Description*"
    
    }
    
    
    @IBAction func submitButtonTapped(_ sender: Any) {
        let projectText = projectField.text
        let dateText = dateField.text
        let descText = descField.text
        let statusText = statusField.text
        let hoursText = hoursField.text
        guard !projectText!.isEmpty || !dateText!.isEmpty || !descText!.isEmpty || !statusText!.isEmpty || !hoursText!.isEmpty else {
            errorMessage1.isHidden = false
            errorMessage2.isHidden = false
            errorMessage3.isHidden = false
            errorMessage4.isHidden = false
            errorMessage5.isHidden = false
        return
           
        }
        func textFieldDidBeginEditing(_ textField: UITextField) {
            if projectField.text == "" {
                errorMessage1.isHidden = false
            }else {
                errorMessage1.isHidden = true
            }
            
            if descField.text == "" {
                errorMessage3.isHidden = false
            } else {
                errorMessage3.isHidden = true
            }
        }
        spinner.show(in: view)
        // print("Error in submit button")
         DataBaseManager.shared.insertTimesheet(with: TimesheetData(projectTitle: projectText!, currentDate: dateText!, projectDescription: descText!, projectStatus: statusText!, workingHours: hoursText!))
         DispatchQueue.main.async {
             self.spinner.dismiss()
         }
        let alert = UIAlertController(title: "Success Message", message: "Timesheet Successfully Submitted", preferredStyle: .alert)
         let action = UIAlertAction(title: "Ok", style: .default) { (action) in
             self.dismiss(animated: true, completion: nil)

         }
         alert.addAction(action)
         present(alert, animated: true, completion: nil)
    }

    func showDatePicker() {
        datePicker.minimumDate = Date()
        datePicker.datePickerMode = .date
        let toolbar = UIToolbar()
        toolbar.sizeToFit()
        let doneButton = UIBarButtonItem(title: "Done", style: .plain, target: self, action: #selector(donedatePicker))
        let spaceButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.flexibleSpace, target: nil, action: nil)
        let cancelButton = UIBarButtonItem(title: "Cancel", style: .plain, target: self, action: #selector(cancelDatePicker))
        toolbar.setItems([cancelButton,spaceButton,doneButton], animated: false)
        dateField.inputAccessoryView = toolbar
        dateField.inputView = datePicker
        
    }
    @objc func donedatePicker() {
        let formatter = DateFormatter()
        formatter.dateFormat = "dd/MM/YYYY"
        dateField.text = formatter.string(from: datePicker.date)
        self.view.endEditing(true)
    }
    
    @objc func cancelDatePicker() {
        self.view.endEditing(true)
    }
    
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
}

extension TimesheetViewController : UIPickerViewDelegate, UIPickerViewDataSource {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        switch pickerView.tag {
        case 1 :
            return projectsList.count
        case 2 :
            return statusList.count
        default:
            return 1
        }
    }
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        switch pickerView.tag {
        case 1 :
            return projectsList[row]
        case 2 :
            return statusList[row]
        default:
            return "something went wrong"
        }

    }
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        switch pickerView.tag {
        case 1 :
            projectField.text = projectsList[row]
        case 2 :
            statusField.text = statusList[row]
        default:
            return
        }
        
    }
    
    func projectsPicker() {
        let toolbar = UIToolbar()
        toolbar.sizeToFit()
        let doneButton = UIBarButtonItem(title: "Done", style: .plain, target: self, action: #selector(donePicker))
        let spaceButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.flexibleSpace, target: nil, action: nil)
        toolbar.setItems([spaceButton,doneButton], animated: false)
        projectField.inputAccessoryView = toolbar
        projectField.inputView = projectPicker
        statusField.inputAccessoryView = toolbar
        statusField.inputView = statusPicker
    }
    
    @objc private func donePicker() {
        projectField.resignFirstResponder()
        statusField.resignFirstResponder()
        self.view.endEditing(true)
    }
    
    func toastMessages(message : String) {
        let toastLabel = UILabel(frame: CGRect(x: self.view.frame.size.width/2 - 120, y: self.view.frame.size.height-130, width: 250, height: 60))
        view.addSubview(toastLabel)
        toastLabel.text = message
        toastLabel.font = UIFont(name: "Montserrat-Light", size: 12.0)
        toastLabel.backgroundColor = UIColor.link.withAlphaComponent(0.6)
        toastLabel.textColor = .black
        toastLabel.layer.cornerRadius = 15
        toastLabel.layer.borderWidth = 1
        toastLabel.layer.borderColor = UIColor.gray.cgColor
        toastLabel.textAlignment = .center
        toastLabel.alpha = 1
        //toastLabel.lineBreakMode = .byWordWrapping
        toastLabel.numberOfLines = 0
        toastLabel.clipsToBounds = true
        //toastLabel.frame = CGRect(x: 50, y: 500, width: view.frame.width - 60, height: 50)
        UIView.animate(withDuration: 5.0, delay: 4.0, options: .curveEaseOut, animations: {
            toastLabel.alpha = 0.0
        }) { (isAnimated) in
            toastLabel.removeFromSuperview()
        }
    }
    
}

//extension TimesheetViewController : UITextViewDelegate {
//    func textViewDidBeginEditing(_ textView: UITextView) {
//        if descTextView.text == "Description*" {
//            descTextView.text = ""
//            descTextView.textColor = UIColor.black
//
//        }
//    }
//    func textViewDidEndEditing(_ textView: UITextView) {
//        if descTextView.text == "" {
//            descTextView.text = "Description*"
//            descTextView.textColor = UIColor.gray
//        }
//        descTextView.becomeFirstResponder()
//    }
//}
