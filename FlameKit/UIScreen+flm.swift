//
//  UIScreen+screenType.swift
//  FlameCollection
//
//  Created by 박종찬 on 2017. 12. 11..
//  Copyright © 2017년 박종찬. All rights reserved.
//

import UIKit

public extension UIScreen {
  public class var flm: FlameScreenUtil {
    return FlameScreenUtil()
  }
}

public class FlameScreenUtil {
  public enum ScreenType: Int { //스크린 높이를 rawValue로.
    case iPhone1 = 480
    case iPhone5 = 568
    case iPhone6 = 667
    case iPhone6Plus = 736
    case iPhoneX = 812
    case unDefined = 0
  }
  
  public var width: CGFloat {
    return UIScreen.main.bounds.width
  }
  
  public var height: CGFloat {
    return UIScreen.main.bounds.height
  }
  
  public var screenType: ScreenType {
    let height = Int(self.height)
    if let screenType = ScreenType.init(rawValue: height) {
      return screenType
    } else { return .unDefined }
  }
  
  public var isIphoneX: Bool {
    return self.screenType == .iPhoneX
  }
}
