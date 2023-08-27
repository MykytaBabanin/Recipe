//
//  UiControl+Extension.swift
//  RecipeApp
//
//  Created by Mykyta Babanin on 19.08.2023.
//

import UIKit
import Combine

extension UIControl {
    func touchUpInsidePublisher() -> AnyPublisher<Void, Never> {
        let subject = PassthroughSubject<Void, Never>()
        
        let target = EventTarget { _ in
            subject.send()
        }
        
        addTarget(target, action: #selector(EventTarget.action(_:)), for: .touchUpInside)
        objc_setAssociatedObject(self, &AssociatedKeys.touchUpInsideKey, target, .OBJC_ASSOCIATION_RETAIN)
        
        return subject
            .handleEvents(receiveCancel: { [weak self] in
                self?.removeTarget(target, action: #selector(EventTarget.action(_:)), for: .touchUpInside)
                objc_setAssociatedObject(self, &AssociatedKeys.touchUpInsideKey, nil, .OBJC_ASSOCIATION_RETAIN)
            })
            .eraseToAnyPublisher()
    }
}

private struct AssociatedKeys {
    static var touchUpInsideKey = "touchUpInsideKey"
}

private class EventTarget {
    private let action: (UIControl) -> Void
    
    init(_ action: @escaping (UIControl) -> Void) {
        self.action = action
    }
    
    @objc func action(_ sender: UIControl) {
        action(sender)
    }
}
