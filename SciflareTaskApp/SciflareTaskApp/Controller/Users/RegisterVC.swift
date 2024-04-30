//
//  RegisterVC.swift
//  SciflareTaskApp
//
//  Created by Pravin's Mac M1 on 29/04/24.
//

import UIKit

class RegisterVC: ConfigurableTableViewController {

    @IBOutlet weak var nameTF: UITextField!
    @IBOutlet weak var emailTF: UITextField!
    @IBOutlet weak var phoneTF: UITextField!
    @IBOutlet weak var maleSwitch: UISwitch!
    @IBOutlet weak var femaleSwitch: UISwitch!
    @IBOutlet weak var submitButton: UIButton!
    
    private var selectedGender: String = ""
    var selectedUser: UserResponse?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setupUI()
        displaySelectedUserData()
    }

    @IBAction func genderSwitchTapped(_ sender: UISwitch) {
        selectedGender = sender == maleSwitch ? "Male" : "Female"
        print("Selected gender: \(selectedGender)")
        
        if sender == maleSwitch {
            if sender.isOn {
                femaleSwitch.setOn(false, animated: true)
            }
        } else if sender == femaleSwitch {
            if sender.isOn {
                maleSwitch.setOn(false, animated: true)
            }
        }
    }
    
    @IBAction func submitButtonTapped(_ sender: UIButton) {
        if selectedUser == nil {
            addNewUser()
        } else {
            updateUser()
        }
    }
    
    private func setupUI() {
        navigationController?.navigationBar.topItem?.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
        navigationController?.navigationBar.tintColor = UIColor.white
        navigationController?.navigationBar.barTintColor = UIColor.red
        StyleUtility.applyTextFieldStyle(to: nameTF, placeholder: "Name", cornerRadius: 20)
        StyleUtility.applyTextFieldStyle(to: emailTF, placeholder: "Email", cornerRadius: 20)
        StyleUtility.applyTextFieldStyle(to: phoneTF, placeholder: "Phone", cornerRadius: 20)
        submitButton.layer.cornerRadius = 25
    }
    
    // Function to display selected user data in UI elements
    private func displaySelectedUserData() {
        if let user = selectedUser {
            nameTF.text = user.name
            emailTF.text = user.email
            phoneTF.text = user.mobile
            
            // Set gender switch based on user's gender
            if user.gender == "Male" {
                maleSwitch.setOn(true, animated: true)
                femaleSwitch.setOn(false, animated: true)
            } else {
                maleSwitch.setOn(false, animated: true)
                femaleSwitch.setOn(true, animated: true)
            }
            
            selectedGender = user.gender ?? ""
        }
    }
    
    func clearTextFields() {
        nameTF.text = ""
        emailTF.text = ""
        phoneTF.text = ""
    }
    
}

extension RegisterVC {
    
    //MARK: - Add New User -
    func addNewUser() {
        guard let name = nameTF.text, let email = emailTF.text, let mobile = phoneTF.text else { return }
        
        
        let param: [String: Any] = ["name": name,
                                    "email": email,
                                    "mobile": mobile,
                                    "gender": selectedGender]
        
        let url = "https://crudcrud.com/api/801cc62c1752416f973272a7cdccc21a/register"
        
        APIManager.apiCall(serviceName: url, apiType: .post, parameters: param, showLoader: true) { [weak self] (response, data, error) in
            if let httpResponse = response {
                if httpResponse.statusCode == 201 {
                    // Show success alert
                    AlertManager.showAlertWithOkCancel(title: "Success", message: "User details were successfully registered", okHandler: {
                        // Clear the fields for the next registration
                        self?.clearTextFields()
                        self?.resignFirstResponder()
                        self?.navigationController?.popViewController(animated: true)
                    })
                } else {
                    AlertManager.showAlert(title: "Error", message: "An error occurred. Please try again later")
                }
            }
        }
    }
    
    //MARK: - Update User -
    func updateUser() {
        guard let user = selectedUser else {
            print("No user data to update")
            return
        }
        
        guard let id = user._id, let name = nameTF.text, let email = emailTF.text, let mobile = phoneTF.text else {
            print("Some fields are empty")
            return
        }
        
        let param: [String: Any] = [ "name": name,
                                     "email": email,
                                     "mobile": mobile,
                                     "gender": selectedGender]
        
        let url = "https://crudcrud.com/api/801cc62c1752416f973272a7cdccc21a/register/\(id)"
        
        APIManager.apiCall(serviceName: url, apiType: .put, parameters: param, showLoader: true) { [weak self] (response, data, error) in
            if let httpResponse = response {
                if httpResponse.statusCode == 200 {
                    // Show success alert
                    AlertManager.showAlertWithOkCancel(title: "Success", message: "User details were successfully updated", okHandler: {
                        // Go back to previous screen
                        self?.navigationController?.popViewController(animated: true)
                    })
                } else {
                    AlertManager.showAlert(title: "Error", message: "An error occurred. Please try again later")
                }
            }
        }
    }
}

extension RegisterVC {
    func validateFields() -> Bool {
        if nameTF.text?.isEmpty ?? true {
            AlertManager.showAlert(title: "Error", message: "Please enter your name")
            return false
        }
        
        if emailTF.text?.isEmpty ?? true || !Validation.isValidEmail(emailTF.text!) {
            AlertManager.showAlert(title: "Error", message: "Please enter a valid email")
            return false
        }
        
        if phoneTF.text?.isEmpty ?? true || !Validation.isValidPhoneNumber(phoneTF.text!) {
            AlertManager.showAlert(title: "Error", message: "Please enter a valid phone number")
            return false
        }
        
        return true
    }
}
