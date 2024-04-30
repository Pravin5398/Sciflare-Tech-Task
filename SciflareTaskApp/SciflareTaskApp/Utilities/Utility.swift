//
//  Utility.swift
//  SciflareTaskApp
//
//  Created by Pravin's Mac M1 on 29/04/24.
//

import UIKit

// MARK: - Alert Handling

class AlertManager {
    
    static func showAlertWithOkCancel(
        title: String?,
        message: String?,
        okTitle: String = "OK",
        cancelTitle: String? = nil,
        okHandler: (() -> Void)? = nil,
        cancelHandler: (() -> Void)? = nil
    ) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        
        let okAction = UIAlertAction(title: okTitle, style: .default) { _ in
            okHandler?()
        }
        alertController.addAction(okAction)
        
        if let cancelTitle = cancelTitle {
            let cancelAction = UIAlertAction(title: cancelTitle, style: .cancel) { _ in
                cancelHandler?()
            }
            alertController.addAction(cancelAction)
        }
        
        presentAlertController(alertController)
    }
    
    static func showAlert(
        title: String?,
        message: String?,
        okTitle: String = "OK"
    ) {
        showAlertWithOkCancel(title: title, message: message, okTitle: okTitle)
    }
    
    private static func presentAlertController(_ alertController: UIAlertController) {
        if let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
           let topController = windowScene.windows.first?.rootViewController {
            topController.present(alertController, animated: true, completion: nil)
        }
    }

}

// MARK: - UI Styling

class StyleUtility {
    
    static func applyTextFieldStyle(to textField: UITextField, placeholder: String, cornerRadius: CGFloat? = nil) {
        textField.placeholder = placeholder
        textField.tintColor = .red
        textField.backgroundColor = .white
        textField.textColor = .red
//        textField.layer.borderColor = UIColor.white.cgColor
//        textField.layer.borderWidth = 1.0
        
        if let radius = cornerRadius {
            textField.layer.cornerRadius = radius
            textField.clipsToBounds = true
        }
    }
}

// MARK: - Validation

class Validation {
    
    static func isValidEmail(_ email: String) -> Bool {
        // Regular expression for email validation
        let emailRegex = "^[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}$"
        return NSPredicate(format: "SELF MATCHES %@", emailRegex).evaluate(with: email)
    }
    
    static func isValidPhoneNumber(_ phoneNumber: String) -> Bool {
        // Regular expression for phone number validation (10 digits)
        let phoneRegex = "^\\d{10}$"
        return NSPredicate(format: "SELF MATCHES %@", phoneRegex).evaluate(with: phoneNumber)
    }
}

// MARK: - Table View Controller Configuration

class ConfigurableTableViewController: UITableViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureTableViewSectionHeaderFooter()
    }
    
    private func configureTableViewSectionHeaderFooter() {
        tableView.delegate = self
    }
    
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return section == 0 ? 0.0 : UITableView.automaticDimension
    }
    
    override func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return section == 0 ? 0.0 : UITableView.automaticDimension
    }
}

// MARK: - Table View Empty Data Handling

extension UITableView {
    
    func setEmptyMessage(_ message: String) {
        let messageLabel = UILabel(frame: CGRect(x: 0, y: 0, width: bounds.size.width, height: bounds.size.height))
        messageLabel.text = message
        messageLabel.textColor = .white
        messageLabel.numberOfLines = 0
        messageLabel.textAlignment = .center
        messageLabel.font = UIFont.systemFont(ofSize: 20, weight: .bold)
        messageLabel.sizeToFit()
        
        backgroundView = messageLabel
        separatorStyle = .none
    }
    
    func restoreMessage() {
        backgroundView = nil
        separatorStyle = .none
    }
}
