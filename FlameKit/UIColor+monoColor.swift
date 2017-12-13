//
//  UIColor+monoColor.swift
//  FlameCollection
//
//  Created by 박종찬 on 2017. 12. 13..
//  Copyright © 2017년 박종찬. All rights reserved.
//

import UIKit

extension UIColor {
  static func monoColor(with brightness: CGFloat) -> UIColor {
    return UIColor(red: brightness / 255.0, green: brightness / 255.0, blue: brightness / 255.0, alpha: 1.0)
  }
}
