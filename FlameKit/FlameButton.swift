//
//  FlameButton.swift
//  FlameCollection
//
//  Created by 박종찬 on 2017. 12. 11..
//  Copyright © 2017년 박종찬. All rights reserved.
//

import UIKit

public typealias FlameButtonHandler = (FlameButton) -> Void
public typealias FlameButtonAppearanceHandler = ((_ isSelected: Bool, _ isEnabled: Bool) -> Void)
public typealias FlameButtonHighlightedAppearanceHandler = ((_ isHighlighted: Bool, _ appearanceView: UIView?) -> Void)

@objcMembers open class FlameButton: UIView {
  
  
  /// closure to execute when button tapped.
  var handler: FlameButtonHandler?
  
  var appearanceView: UIView?
  var appearanceHandler: FlameButtonAppearanceHandler?
  public var highlightedAppearanceHandler: FlameButtonHighlightedAppearanceHandler?
  
  public var isSelected: Bool = false {
    didSet { 
      appearanceHandler?(isSelected, isEnabled) 
    }
  }
  
  public var isEnabled: Bool = true {
    didSet {
      appearanceHandler?(isSelected, isEnabled)
    }
  }
  
  public var isHighlighted: Bool = false {
    didSet {
      guard isEnabled else { return }
      if let handler = highlightedAppearanceHandler {
        handler(isHighlighted, appearanceView)
      } else {
        appearanceView?.alpha = isHighlighted ? 0.5 : 1.0
      }
    }
  }
  
  // MARK: - initializers
  
//  open override func gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool {
//    return false
//  }
  
  open override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
    
    let touchedPoint = touches.first?.location(in: self.superview) ?? CGPoint.zero
    
    if frame.contains(touchedPoint) && !isHighlighted {
      isHighlighted = true
    }
    
    if !frame.contains(touchedPoint) && isHighlighted {
      isHighlighted = false
    }
    super.touchesMoved(touches, with: event)
    
  }
  
  open override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
    let touchedPoint = touches.first?.location(in: self.superview) ?? CGPoint.zero
    
    guard event?.allTouches?.count == 1 else { return }
    let touchEndedInView = self.frame.contains(touchedPoint)
    if touchEndedInView {
      handler?(self)
    }
    
    isHighlighted = false
  }
  

  
  open override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
    
    print(#function)
    let touchedPoint = touches.first?.location(in: self.superview) ?? CGPoint.zero

    if frame.contains(touchedPoint) && !isHighlighted {
      isHighlighted = true
    }

    if !frame.contains(touchedPoint) && isHighlighted {
      isHighlighted = false
    }
    super.touchesMoved(touches, with: event)
  }
  
  override open func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
    
    let touchedPoint = touches.first?.location(in: self.superview) ?? CGPoint.zero

    guard event?.allTouches?.count == 1 else { return }
    let touchEndedInView = self.frame.contains(touchedPoint)
    if touchEndedInView {
      handler?(self)
    }

    isHighlighted = false

  }

  public func action(handler: @escaping FlameButtonHandler) {
    self.handler = handler
  }
  
  
  
  public func setAppearanceView(_ view: UIView, appearanceHandler: @escaping FlameButtonAppearanceHandler) {
    addSubview(view)
    view.frame = self.bounds
    view.translatesAutoresizingMaskIntoConstraints = false
    view.isUserInteractionEnabled = false
    NSLayoutConstraint.activate(
      [
        NSLayoutConstraint.init(
          item: view, 
          attribute: NSLayoutAttribute.width, 
          relatedBy: NSLayoutRelation.equal, 
          toItem: self, 
          attribute: NSLayoutAttribute.width, 
          multiplier: 1.0, 
          constant: 0.0
        ),
        NSLayoutConstraint.init(
          item: view, 
          attribute: NSLayoutAttribute.height, 
          relatedBy: NSLayoutRelation.equal, 
          toItem: self, 
          attribute: NSLayoutAttribute.height, 
          multiplier: 1.0, 
          constant: 0.0
        ),
        NSLayoutConstraint.init(
          item: view, 
          attribute: NSLayoutAttribute.centerX, 
          relatedBy: NSLayoutRelation.equal, 
          toItem: self, 
          attribute: NSLayoutAttribute.centerX, 
          multiplier: 1.0, 
          constant: 0.0
        ),
        NSLayoutConstraint.init(
          item: view, 
          attribute: NSLayoutAttribute.centerY, 
          relatedBy: NSLayoutRelation.equal, 
          toItem: self, 
          attribute: NSLayoutAttribute.centerY, 
          multiplier: 1.0, 
          constant: 0.0
        )
      ]
    )
    self.appearanceView = view
    self.appearanceHandler = appearanceHandler
    appearanceHandler(isSelected, isEnabled)
  }
}

//extension FlameButton: UIGestureRecognizerDelegate {
//  public func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
//    return true
//  }
//}

