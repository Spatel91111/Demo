//
//  Extension+UIView.swift
//  ButtonEffect
//
//  Created by Subhash Kimani on 12/05/23.
//

import UIKit

extension UIView {
    /// showAnimation is used to animation view with zoom in/out
    /// - Parameters:
    ///   - scale: CGFloat type, pass value to scale view
    ///   - completion: completion call back once animation complete
    func showAnimation(scale:CGFloat = 0.96, _ completion: @escaping () -> Void) {
        // disable user interation
        isUserInteractionEnabled = false
        
        // animation for scaling
        UIView.animate(withDuration: 0.1,
                       delay: 0,
                       options: .curveLinear,
                       animations: { [weak self] in
            self?.transform = CGAffineTransform.init(scaleX: scale, y: scale)
        }) {  [weak self] (done) in
            // reset scaling animation
            UIView.animate(withDuration: 0.1,
                           delay: 0,
                           options: .curveLinear,
                           animations: { [weak self] in
                self?.transform = CGAffineTransform.init(scaleX: 1, y: 1)
            }) { [weak self] (_) in
                // enable user interaction
                self?.isUserInteractionEnabled = true
                // callback completion
                completion()
            }
        }
    }
    
    func flashAnimation() {
        // create object
        let flashAnimation = CABasicAnimation(keyPath: "opacity")
        // dureation of animation
        flashAnimation.duration = 0.2
        // from value opacity
        flashAnimation.fromValue = 1
        // to value opacity
        flashAnimation.toValue = 0.1
        flashAnimation.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.easeInEaseOut)
        // backwards after playing forwards
        flashAnimation.autoreverses = true
        // repeat animation count
        flashAnimation.repeatCount = 2
        
        layer.add(flashAnimation, forKey: nil)
    }
    
    func shakeAnimation() {
        // create object
        let shakeAnimation = CABasicAnimation(keyPath: "position")
        // dureation of animation
        shakeAnimation.duration = 0.1
        // repeat animation count
        shakeAnimation.repeatCount = 1
        // backwards after playing forwards
        shakeAnimation.autoreverses = true
        
        let fromPoint = CGPoint(x: center.x - 5, y: center.y)
        let fromValue = NSValue(cgPoint: fromPoint)
        
        let toPoint = CGPoint(x: center.x + 5, y: center.y)
        let toValue = NSValue(cgPoint: toPoint)
        
        // from point value
        shakeAnimation.fromValue = fromValue
        // to point value
        shakeAnimation.toValue = toValue
        
        layer.add(shakeAnimation, forKey: "position")
    }
}
