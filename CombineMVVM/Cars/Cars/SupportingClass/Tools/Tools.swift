//
//  Tools.swift


import UIKit
import Foundation
import KRProgressHUD

class Tools {
    
    static let shared : Tools = {
        let instance = Tools()
        return instance
    }()
    
    // MARK:- ProgressHUD methods
        
    func showProgressHUD() {
        KRProgressHUD.show(withMessage: "Fetching Cars...")
    }
    
    func hideProgressHUD() {
        KRProgressHUD.dismiss()
    }

    // MARK:- Reachability methods
    
    func hasConnectivity() -> Bool {
        
        if Reachability.isConnectedToNetwork() {
            print("Internet Connection Available!")
            return true
        } else {
            print("Internet Connection not Available!")
            return false
        }
    }
}
