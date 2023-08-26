//
//  AlertManager.swift
//  grinta
//
//  Created by Linda adel on 26/08/2023.
//

import Foundation
import UIKit

class AlertManager {
    
    static func showErrorAlertWith(message: String, with parent: UIViewController) {
     
            let alert = UIAlertController(title: "Error", message: message, preferredStyle: .alert)
            let okAction  = UIAlertAction(title: "Ok", style: .default) { (UIAlertAction) in
            }
            alert.addAction(okAction)
        DispatchQueue.main.async {
            parent.present(alert, animated: true, completion: nil)
        }
    }
}
