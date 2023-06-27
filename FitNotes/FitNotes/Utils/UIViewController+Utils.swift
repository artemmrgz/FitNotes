//
//  UIViewController+Utils.swift
//  FitNotes
//
//  Created by Artem Marhaza on 27/06/2023.
//

import UIKit

extension UIViewController {
    func setTabBarImage(imageName: String, title: String, tag: Int) {
        let configuration = UIImage.SymbolConfiguration(scale: .large)
        let image = UIImage(systemName: imageName, withConfiguration: configuration)
        tabBarItem = UITabBarItem(title: title, image: image, tag: tag)
    }
}
