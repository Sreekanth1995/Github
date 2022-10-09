//
//  UITableView+ReUseCell.swift
//  GitHub
//
//  Created by M sreekanth  on 09/10/22.
//

import UIKit

extension UITableView {
    func dequeReusableCell<T: UITableViewCell>() -> T {
        let identifier = String(describing: T.self)
        return dequeueReusableCell(withIdentifier: identifier) as! T
    }
}
