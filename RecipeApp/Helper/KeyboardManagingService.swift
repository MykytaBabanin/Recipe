//
//  KeyboardManaginService.swift
//  RecipeApp
//
//  Created by Никита Бабанин on 12/09/2023.
//

import Combine
import UIKit

protocol KeyboardManagingProtocol {
    func setupKeyboardHandling(for viewController: UIViewController, scrollView: UIScrollView)
    func setupKeyboardHiddingWhileTapOutside(viewController: UIViewController)
}

class KeyboardManager: KeyboardManagingProtocol {
    private var subscriptions = Set<AnyCancellable>()
    
    func setupKeyboardHandling(for viewController: UIViewController, scrollView: UIScrollView) {
        NotificationCenter.default.publisher(for: UIResponder.keyboardWillShowNotification)
            .sink { [weak viewController, weak scrollView] notification in
                if let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue,
                   let scrollView = scrollView {
                    let keyboardHeight = keyboardSize.height
                    
                    var contentInsets = scrollView.contentInset
                    contentInsets.bottom = keyboardHeight
                    
                    scrollView.contentInset = contentInsets
                    scrollView.scrollIndicatorInsets = contentInsets
                }
            }
            .store(in: &subscriptions)
        
        NotificationCenter.default.publisher(for: UIResponder.keyboardWillHideNotification)
            .sink { [weak scrollView] _ in
                if let scrollView = scrollView {
                    var contentInsets = scrollView.contentInset
                    contentInsets.bottom = 0
                    
                    scrollView.contentInset = contentInsets
                    scrollView.scrollIndicatorInsets = contentInsets
                    
                    scrollView.contentOffset = CGPoint(x: 0, y: 0)
                }
            }
            .store(in: &subscriptions)
    }
    
    
    func setupKeyboardHiddingWhileTapOutside(viewController: UIViewController) {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(didTapView))
        viewController.view.addGestureRecognizer(tapGesture)
    }
    
    @objc func didTapView(gesture: UITapGestureRecognizer, viewController: UIViewController) {
        viewController.view.endEditing(true)
    }
}
