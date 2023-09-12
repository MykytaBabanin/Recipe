//
//  UIView+Extensions.swift
//  RecipeApp
//
//  Created by Mykyta Babanin on 07.08.2023.
//

import UIKit

extension UIView {
    func addSubviewAndDisableAutoresizing(_ view: UIView) {
        addSubview(view)
        view.translatesAutoresizingMaskIntoConstraints = false
    }
    
    func pin(toEdges containerView: UIView, constant: CGFloat = 0) {
        translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            topAnchor.constraint(equalTo: containerView.topAnchor, constant: constant),
            bottomAnchor.constraint(equalTo: containerView.bottomAnchor, constant: -constant),
            leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: constant),
            trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -constant)
        ])
    }
    
    func findViewController() -> UIViewController? {
        if let nextResponder = self.next as? UIViewController {
            return nextResponder
        } else if let nextResponder = self.next as? UIView {
            return nextResponder.findViewController()
        } else {
            return nil
        }
    }
    
    func showAnimation(_ completionBlock: @escaping () -> Void) {
        isUserInteractionEnabled = false
        UIView.animate(withDuration: 0.1,
                       delay: 0,
                       options: .curveLinear,
                       animations: { [weak self] in
            self?.transform = CGAffineTransform.init(scaleX: 0.95, y: 0.95)
        }) {  (done) in
            UIView.animate(withDuration: 0.1,
                           delay: 0,
                           options: .curveLinear,
                           animations: { [weak self] in
                self?.transform = CGAffineTransform.init(scaleX: 1, y: 1)
            }) { [weak self] (_) in
                self?.isUserInteractionEnabled = true
                completionBlock()
            }
        }
    }
}
