//
//  UIViewController+Instantiate.swift
//  Comutty
//
//  Created by Maksim Dimitrov on 11.05.20.
//  Copyright © 2020 Maksim Dimitrov. All rights reserved.
//

import UIKit

extension UIViewController {
    static func instantiateFromStoryboard() -> Self {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        return storyboard.instantiateViewController(withIdentifier: String(describing: Self.self)) as! Self
    }
}
