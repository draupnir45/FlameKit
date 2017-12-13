//
//  UIScreen+screenType.swift
//  FlameCollection
//
//  Created by 박종찬 on 2017. 12. 11..
//  Copyright © 2017년 박종찬. All rights reserved.
//

import UIKit

extension UIScreen {
  enum ScreenType: Int { //스크린 높이를 rawValue로.
    case iPhone1 = 480
    case iPhone5 = 568
    case iPhone6 = 667
    case iPhone6Plus = 736
    case iPhoneX = 812
    case unDefined = 0
  }
  
  class var width: CGFloat {
    return UIScreen.main.bounds.width
  }
  
  class var height: CGFloat {
    return UIScreen.main.bounds.height
  }
  
  class var screenType: ScreenType {
    let height = Int(UIScreen.height)
    if let screenType = ScreenType.init(rawValue: height) {
      return screenType
    } else { return .unDefined }
  }
  
  static var isIphoneX: Bool {
    return UIScreen.screenType == .iPhoneX
  }
}
