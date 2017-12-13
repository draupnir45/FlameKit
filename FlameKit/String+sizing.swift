//
//  String+sizing.swift
//  FlameCollection
//
//  Created by 박종찬 on 2017. 12. 11..
//  Copyright © 2017년 박종찬. All rights reserved.
//

import UIKit

extension String {
  func singleLineWidth(font: UIFont) -> CGFloat {
    let constraintRect = CGSize(width: CGFloat.greatestFiniteMagnitude, height: font.lineHeight)
    let options: NSStringDrawingOptions = [.usesFontLeading]
    let attributes: [NSAttributedStringKey: Any] = [NSAttributedStringKey.font: font]
    let boundingRect = NSString.init(string: self).boundingRect(with: constraintRect, options: options, attributes: attributes, context: nil)
    return ceil(boundingRect.width)
  }
  
  func multiLineHeight(width: CGFloat, font: UIFont, numberOfLines: Int = 0) -> CGFloat {
    let maximumHeight = CGFloat.greatestFiniteMagnitude
    let constraintRect = CGSize(width: width, height: maximumHeight)
    let options: NSStringDrawingOptions = [.usesFontLeading, .usesLineFragmentOrigin]
    let attributes: [NSAttributedStringKey: Any] = [NSAttributedStringKey.font: font]
    let boundingRect = NSString.init(string: self).boundingRect(with: constraintRect, options: options, attributes: attributes, context: nil)
    return ceil(boundingRect.height)
  }
}
