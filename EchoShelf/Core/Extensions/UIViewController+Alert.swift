//
//  UIViewController+Alert.swift
//  EchoShelf
//
//  Created by Ibrahim Kolchi on 29.04.26.
//
import UIKit

extension UIViewController {

    func showErrorAlert(_ message: String, title: String = "Xəta") {
        DispatchQueue.main.async {
            let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default))
            self.present(alert, animated: true)
        }
    }

    func showAlert(title: String, message: String, action: String = "OK", handler: (() -> Void)? = nil) {
        DispatchQueue.main.async {
            let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: action, style: .default) { _ in handler?() })
            self.present(alert, animated: true)
        }
    }
}
