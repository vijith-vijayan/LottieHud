//
//  LottieLoader.swift
//  LottieAnimations
//
//  Created by Vijith TV on 21/11/19.
//  Copyright © 2019 NdimensionZ. All rights reserved.
//

import UIKit
import Lottie

class LottieHUD: UIView {
    
    //MARK: Internal properties
    internal var animator: AnimationView?
    internal var overlay: UIView?
    internal var kleftAnchor: CGFloat = 0.0
    internal var kbottomAnchor: CGFloat = 0.0
    internal var keywindow = UIApplication.shared.windows.first
    internal static let lottie = LottieHUD()
    
    override init(frame: CGRect) {
           super.init(frame: frame)
           guard let window = keywindow else {
               return
           }
           self.frame = CGRect(x: 0, y: 0, width: window.frame.size.width, height: window.frame.size.height)
            updateHUD()
       }
       
       required init?(coder: NSCoder) {
           super.init(coder: coder)
       }
    
    // MARK: UI Update
    internal func updateHUD() {
        
        // Overlay view
        overlayView()
        
        // Lottie HUD
        self.isUserInteractionEnabled = false
        self.backgroundColor = .clear
        
        //Animator View and Animations
        animator = AnimationView()
        let animation = Animation.named("animator", bundle: Bundle.main, subdirectory: nil, animationCache: nil)
        animator?.animation = animation
        animator?.contentMode = .scaleAspectFit
        addConstraints()
    }
    
    // MARK: Show loader
   static func showHUD() {
        lottie.topview()
        lottie.animator?.play(fromProgress: 0.0, toProgress: 1.0, loopMode: LottieLoopMode.loop, completion: nil)
    }
    
    // MARK: Configure Overlay View
    internal func overlayView() {
        // Overlay view
        let width = self.bounds.size.width / 3.5
        let height = self.bounds.size.width / 3.5
        let x = self.bounds.size.width/2 - width/2
        let y = self.bounds.size.height/2 - height/2
        let frame = CGRect(x: x, y: y, width: width, height: height)
        overlay = UIView(frame: frame)
        overlay?.backgroundColor = .white
        overlay?.alpha = 0.9
        overlay?.layer.cornerRadius = 10.0
        overlay?.clipsToBounds = true
        self.addSubview(overlay!)
    }
    
    // MARK: Finding the top view controller and subview LottieHud
    internal func topview() {
        if let topVC = UIApplication.getTopViewController() {
            topVC.view.addSubview(self)
        }
    }
    
    // MARK: Configure animator view and subview it in overlay view
    internal func addConstraints() {
        guard let overlay = self.overlay else { return }
        kleftAnchor = (overlay.frame.size.width/2) - 50.0
        kbottomAnchor = (overlay.bounds.size.height/2) - 50.0
        animator?.frame = CGRect(x: kleftAnchor, y: kbottomAnchor, width: 100.0, height: 100.0)
        guard let animatorUnwraped = animator else { return }
        overlay.addSubview(animatorUnwraped)
    }
    
    // MARK: Hide Lottie hud
    static func hideHUD()  {
        lottie.animator?.stop()
        UIView.animate(withDuration: 0.3, animations: { [weak lottie] in
            guard let ws = lottie, let overlay = ws.overlay else { return }
            ws.kleftAnchor = overlay.frame.size.width/2
            ws.kbottomAnchor = overlay.frame.size.height/2
            ws.animator?.frame = CGRect(x: ws.kleftAnchor, y: ws.kbottomAnchor, width: 0.0, height: 0.0)
        }) { [weak lottie] (success) in
            guard let ws = lottie else { return }
            if success {
                ws.animator?.removeFromSuperview()
                ws.overlay?.removeFromSuperview()
                ws.removeFromSuperview()
                ws.isUserInteractionEnabled = true
            }
        }
       
    }
    
}
