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
  var highlightedAppearanceHandler: FlameButtonHighlightedAppearanceHandler?
  
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
      if let handler = highlightedAppearanceHandler {
        handler(isHighlighted, appearanceView)
      } else {
        appearanceView?.alpha = isHighlighted ? 0.5 : 1.0
      }
    }
  }
  
  //  let tapGestureRecognizer = UITapGestureRecognizer()
  
  private func setInitialState() {
    //    addGestureRecognizer(tapGestureRecognizer)
    //    tapGestureRecognizer.addTarget(self, action: #selector(self.executeHandler(_:)))
    
  }
  
  open override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
    super.touchesMoved(touches, with: event)
    let touchedPoint = touches.first?.location(in: self.superview) ?? CGPoint.zero
    
    if frame.contains(touchedPoint) && !isHighlighted {
      isHighlighted = true
    }
    
    if !frame.contains(touchedPoint) && isHighlighted {
      isHighlighted = false
    }
    
  }
  
  override open func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
    super.touchesEnded(touches, with: event)
    let touchedPoint = touches.first?.location(in: self.superview) ?? CGPoint.zero
    
    guard event?.allTouches?.count == 1 else { return }
    let touchEndedInView = self.frame.contains(touchedPoint)
    if touchEndedInView {
      handler?(self)
    }
    
    isHighlighted = false
  }
  
//  @objc func executeHandler(_ sender: UITapGestureRecognizer) {
//    handler?(self)
//  }
  
  public func action(handler: @escaping FlameButtonHandler) {
    self.handler = handler
  }
  
  override public init(frame: CGRect) {
    super.init(frame: frame)
    setInitialState()
  }
  
  required public init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  public func setAppearanceView(_ view: UIView, appearanceHandler: @escaping FlameButtonAppearanceHandler) {
    addSubview(view)
    view.frame = self.bounds
    view.translatesAutoresizingMaskIntoConstraints = false
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

