//
//  FadeOutAnimationController.swift
//  StoreSearch
//
//  Created by Jay on 16/2/5.
//  Copyright © 2016年 look4us. All rights reserved.
//

import UIKit

class FadeOutAnimationController:NSObject,UIViewControllerAnimatedTransitioning {

    
    func transitionDuration(transitionContext: UIViewControllerContextTransitioning?) -> NSTimeInterval {
        
        return 0.4
    }
    
    func animateTransition(transitionContext: UIViewControllerContextTransitioning) {
        
        if let fromView = transitionContext.viewForKey(UITransitionContextFromViewKey){
        
            let duration = transitionDuration(transitionContext)
            
            UIView.animateWithDuration(duration, animations: {
            
                fromView.alpha = 0
                },completion:{finished in
            
                transitionContext.completeTransition(finished)
            })
        
        }
    }

}
