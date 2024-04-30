//
//  UsersVC.swift
//  SciflareTaskApp
//
//  Created by Pravin's Mac M1 on 29/04/24.
//

import UIKit
import CoreData

class UsersVC: UITableViewController {

    var userResponse: [UserResponse] = []
    var managedObjectContext: NSManagedObjectContext!

    override func viewDidLoad() {
        super.viewDidLoad()

        // Setup Core Data stack
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
            fatalError("Unable to access AppDelegate")
        }
        managedObjectContext = appDelegate.persistentContainer.viewContext

       setupUI()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        getUsers()
    }

    @IBAction func addUserButtonTapped(_ sender: UIBarButtonItem) {
        performSegue(withIdentifier: "showForm", sender: nil)
    }
    
    func setupUI() {
        navigationController?.navigationBar.topItem?.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
        navigationController?.navigationBar.tintColor = UIColor.white
        navigationController?.navigationBar.barTintColor = UIColor.red
    }

}

//MARK: - Table View Configuration
extension UsersVC {
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        userResponse.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "UsersTVCell", for: indexPath) as! UsersTVCell
        
        let user = userResponse[indexPath.row]
        cell.nameLabel.text = user.name
        cell.emailLabel.text = user.email
        cell.phoneLabel.text = user.mobile
        cell.genderLabel.text = user.gender
        
        cell.editTapHandler = {
            let registerVC = self.storyboard?.instantiateViewController(withIdentifier: "RegisterVC") as! RegisterVC
            registerVC.selectedUser = user
            self.navigationController?.pushViewController(registerVC, animated: true)
        }
        return cell
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 150
    }
}

//MARK: - API Call(Get Users)
extension UsersVC {
    
    func getUsers() {
        let url = "https://crudcrud.com/api/801cc62c1752416f973272a7cdccc21a/register"
        
        APIManager.apiCall(serviceName: url, apiType: .get, parameters: nil, showLoader: true) { [weak self] (response, data, error) in
            guard let self = self else { return }
            
            if error == nil {
                if let httpResponse = response {
                    print("Status code: \(httpResponse.statusCode)")
                    
                    if httpResponse.statusCode == 200 {
                        do {
                            let decoder = JSONDecoder()
                            let users = try decoder.decode([UserResponse].self, from: data!)
                            
                            // Save fetched data to Core Data
                            self.saveUsersToCoreData(users)
                            
                            // Fetch saved data from Core Data and update table view
                            self.fetchUsersFromCoreData()
                        } catch {
                            print("Error decoding JSON: \(error)")
                            AlertManager.showAlert(title: "Error", message: "Failed to decode JSON.")
                        }
                    } else {
                        AlertManager.showAlert(title: "Server Error", message: "An unexpected error occurred. Please try again later.")
                    }
                }
            } else {
                AlertManager.showAlert(title: "Error!", message: "Something went wrong.")
            }
        }
    }
    
}

//MARK: - CoreData Configuration -

extension UsersVC {
    
    func saveUsersToCoreData(_ users: [UserResponse]) {
        // Delete all existing users
        deleteAllUsersFromCoreData()
        
        for userResponse in users {
            let newUser = User(context: managedObjectContext)
            newUser.id = userResponse._id
            newUser.name = userResponse.name
            newUser.email = userResponse.email
            newUser.mobile = userResponse.mobile
            newUser.gender = userResponse.gender
        }
        do {
            try managedObjectContext.save()
        } catch {
            print("Failed to save users to Core Data: \(error)")
        }
    }

    func deleteAllUsersFromCoreData() {
        let fetchRequest: NSFetchRequest<User> = User.fetchRequest()
        do {
            let existingUsers = try managedObjectContext.fetch(fetchRequest)
            for user in existingUsers {
                managedObjectContext.delete(user)
            }
        } catch {
            print("Failed to delete users from Core Data: \(error)")
        }
    }

    func fetchUsersFromCoreData() {
        // Fetch users from Core Data
        let fetchRequest: NSFetchRequest<User> = User.fetchRequest()
        do {
            self.userResponse = try managedObjectContext.fetch(fetchRequest).compactMap { user in
                return UserResponse(_id: user.id, name: user.name, email: user.email, mobile: user.mobile, gender: user.gender)
            }

            if self.userResponse.isEmpty {
                self.tableView.setEmptyMessage("No Data Available!")
            } else {
                self.tableView.restoreMessage()
            }

            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        } catch {
            print("Failed to fetch users from Core Data: \(error)")
        }
    }

}
