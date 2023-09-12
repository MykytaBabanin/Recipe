//
//  AnimatedTabBarItem.swift
//  RecipeApp
//
//  Created by Никита Бабанин on 08/09/2023.
//

import Lottie
import UIKit

final class AnimatedItem: UIView {
    var animationView: LottieAnimationView?
    
    init(animation: String, speed: CGFloat) {
        super.init(frame: .zero)
        
        animationView = .init(name: animation)
        if let animationView = animationView {
            addSubview(animationView)
            animationView.animationSpeed = speed
            animationView.loopMode = .loop
            animationView.contentMode = .scaleAspectFit
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func play() {
        animationView?.play()
    }
    
    func pause() {
        animationView?.pause()
    }
}
