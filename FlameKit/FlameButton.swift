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

public class FlameButton: UIView {
  
  var handler: FlameButtonHandler?
  
  var customView: UIView?
  var appearanceHandler: FlameButtonAppearanceHandler?
  
  var isSelected: Bool = false {
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
    customView.frame = bounds
    
    self.customView = customView
    self.appearanceHandler = appearanceHandler
    appearanceHandler(isSelected)
  }
  
}
