//
//  UIImageView+Animated.swift
//  GitHub
//
//  Created by M sreekanth  on 09/10/22.
//

import UIKit

extension UIImageView {
    func setImageViewAnimated(newImage: UIImage?) {
        image = newImage
        if image == nil {
            alpha = 0
            UIView.animate(withDuration: 0.25,
                           animations: {
                self.alpha = 1
            })
        }
    }
}
