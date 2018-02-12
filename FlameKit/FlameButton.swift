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

@objcMembers open class FlameButton: UIButton {
  
  /// closure to execute when button tapped.
  var handler: FlameButtonHandler?
  
  var appearanceView: UIView?
  var appearanceHandler: FlameButtonAppearanceHandler?
  public var highlightedAppearanceHandler: FlameButtonHighlightedAppearanceHandler?
  
  open override var isSelected: Bool {
    didSet { 
      appearanceHandler?(isSelected, isEnabled) 
    }
  }
  
  open override var isEnabled: Bool {
    didSet {
      appearanceHandler?(isSelected, isEnabled)
    }
  }
  
  open override var isHighlighted: Bool {
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
  
  public override init(frame: CGRect) {
    super.init(frame: frame)
    addTarget(self, action: #selector(self.executeHandler(_:)), for: .touchUpInside)
  }
  
  required public init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  @objc private func executeHandler(_ sender: FlameButton) {
    self.handler?(sender)
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
