//
//  APIManager.swift
//  SciflareTaskApp
//
//  Created by Pravin's Mac M1 on 30/04/24.
//

import Foundation
import ProgressHUD
import Alamofire

class APIManager {
    
    static func apiCall(serviceName: String, apiType: HTTPMethod, parameters: [String: Any]?, showLoader: Bool? = true, completion: @escaping (HTTPURLResponse?, Data?, Error?) -> Void) {
        
        guard isInternetAvailable() else {
            AlertManager.showAlert(title: "Alert!", message: "No internet connection available. Please check your internet connection.")
            return
        }
        
        let shouldShowLoader = showLoader ?? true
        if shouldShowLoader {
            startLoader()
        }
        
        let manager = Alamofire.Session.default
        manager.session.configuration.timeoutIntervalForRequest = 10
        manager.session.configuration.urlCache = nil
        manager.session.configuration.urlCache?.removeAllCachedResponses()
        
        print("Request URL: \(serviceName)")
        
        manager.request(serviceName, method: apiType, parameters: parameters, encoding: JSONEncoding.default).responseJSON { response in
            
            stopLoader()
            print("Response: ", response)
            
            DispatchQueue.main.async {
                completion(response.response, response.data, response.error)
            }
        }
    }
}

extension APIManager {
    
    static func isInternetAvailable() -> Bool {
        let reachability = Reachability()!
        guard reachability.isReachable else {
            return false
        }
        return true
    }
    
    static func startLoader() {
        ProgressHUD.animationType = .circleRippleMultiple
        ProgressHUD.colorHUD = .white
        ProgressHUD.colorBackground = .clear
        ProgressHUD.colorProgress = .red
        ProgressHUD.colorAnimation = .yellow
        
        ProgressHUD.animate("Please wait...", interaction: false)
    }
    
    static func stopLoader() {
        ProgressHUD.dismiss()
    }
}

