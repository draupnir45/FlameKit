//
//  NSAttributedString+attributes.swift
//  FlameCollection
//
//  Created by 박종찬 on 2017. 12. 11..
//  Copyright © 2017년 박종찬. All rights reserved.
//

import UIKit

extension NSAttributedString {
  static func attributes(font: UIFont, color: UIColor? = nil, customLineHeight: CGFloat? = nil, alignment: NSTextAlignment? = nil, kern: Double? = nil, lineBreakMode: NSLineBreakMode = .byCharWrapping, bulletHead: String? = nil) -> [NSAttributedStringKey: Any] {
    let finalColor: UIColor = color ?? UIColor.darkGray
    let finalKern: Double = kern ?? -0.3
    
    let paragraphStyle = NSMutableParagraphStyle()
    
    if let customLineHeight = customLineHeight {
      paragraphStyle.lineSpacing = customLineHeight - font.lineHeight
    }
    
    if let alignment = alignment {
      paragraphStyle.alignment = alignment
    }
    
    paragraphStyle.lineBreakMode = lineBreakMode
    
    if let bullet = bulletHead {
      paragraphStyle.headIndent = bullet.singleLineWidth(font: font)
    }
    
    let attributes: [NSAttributedStringKey: Any] = [
      NSAttributedStringKey.foregroundColor: finalColor,
      NSAttributedStringKey.font: font,
      NSAttributedStringKey.kern: finalKern,
      NSAttributedStringKey.paragraphStyle: paragraphStyle
    ]
    return attributes
  }
}
