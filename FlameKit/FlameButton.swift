//
//  FlameButton.swift
//  FlameCollection
//
//  Created by 박종찬 on 2017. 12. 11..
//  Copyright © 2017년 박종찬. All rights reserved.
//

import UIKit

typealias FlameButtonHandler = (FlameButton) -> Void
typealias FlameButtonAppearanceHandler = ((Bool) -> Void)

class FlameButton: UIView {
  
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
  
  func add(handler: @escaping FlameButtonHandler) {
    self.handler = handler
  }
  
  override init(frame: CGRect) {
    super.init(frame: frame)
    setInitialState()
  }
  
  required init?(coder aDecoder: NSCoder) {
    super.init(coder: aDecoder)
    setInitialState()
  }
  
  func setCustomView(_ customView: UIView, appearanceHandler: @escaping FlameButtonAppearanceHandler) {
    addSubview(customView)
    customView.frame = bounds
    
    self.customView = customView
    self.appearanceHandler = appearanceHandler
    appearanceHandler(isSelected)
  }
  
}
