//
//  FlameButton.swift
//  FlameCollection
//
//  Created by 박종찬 on 2017. 12. 11..
//  Copyright © 2017년 박종찬. All rights reserved.
//

import UIKit

public typealias FlameButtonHandler = (FlameButton) -> Void
public typealias FlameButtonAppearanceHandler = ((Bool) -> Void)

@objcMembers open class FlameButton: UIView {
  
  var handler: FlameButtonHandler?
  
  var customView: UIView?
  var appearanceHandler: FlameButtonAppearanceHandler?
  
  public var isSelected: Bool = false {
    didSet { appearanceHandler?(isSelected) }
  }
  
  let tapGestureRecognizer = UITapGestureRecognizer()
  
  private func setInitialState() {
    addGestureRecognizer(tapGestureRecognizer)
    tapGestureRecognizer.addTarget(self, action: #selector(self.executeHandler(_:)))
  }
  
  @objc func executeHandler(_ sender: UITapGestureRecognizer) {
    if let handler = handler {
      handler(self)
    }
  }
  
  public func add(handler: @escaping FlameButtonHandler) {
    self.handler = handler
  }
  
  override public init(frame: CGRect) {
    super.init(frame: frame)
    setInitialState()
  }
  
  required public init?(coder aDecoder: NSCoder) {
    super.init(coder: aDecoder)
    setInitialState()
  }
  
  public func setCustomView(_ customView: UIView, appearanceHandler: @escaping FlameButtonAppearanceHandler) {
    addSubview(customView)
    NSLayoutConstraint.activate(
      [
        NSLayoutConstraint.init(
          item: customView, 
          attribute: NSLayoutAttribute.width, 
          relatedBy: NSLayoutRelation.equal, 
          toItem: self, 
          attribute: NSLayoutAttribute.width, 
          multiplier: 1.0, 
          constant: 0.0
        ),
        NSLayoutConstraint.init(
          item: customView, 
          attribute: NSLayoutAttribute.height, 
          relatedBy: NSLayoutRelation.equal, 
          toItem: self, 
          attribute: NSLayoutAttribute.height, 
          multiplier: 1.0, 
          constant: 0.0
        ),
        NSLayoutConstraint.init(
          item: customView, 
          attribute: NSLayoutAttribute.centerX, 
          relatedBy: NSLayoutRelation.equal, 
          toItem: self, 
          attribute: NSLayoutAttribute.centerX, 
          multiplier: 1.0, 
          constant: 0.0
        ),
        NSLayoutConstraint.init(
          item: customView, 
          attribute: NSLayoutAttribute.centerY, 
          relatedBy: NSLayoutRelation.equal, 
          toItem: self, 
          attribute: NSLayoutAttribute.centerY, 
          multiplier: 1.0, 
          constant: 0.0
        )
      ]
    )
    
    self.customView = customView
    self.appearanceHandler = appearanceHandler
    appearanceHandler(isSelected)
  }
  
}

