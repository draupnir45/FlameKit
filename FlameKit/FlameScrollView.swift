//
//  FlameScrollView.swift
//  FlameCollection
//
//  Created by 박종찬 on 2017. 12. 11..
//  Copyright © 2017년 박종찬. All rights reserved.
//


import UIKit


/// ScrollView with built-in stackView. 
@objcMembers open class FlameScrollView: UIScrollView, UITextFieldDelegate {
  
  // MARK: - UIViews
  let contentView: UIView = {
    let view = UIView()
    view.translatesAutoresizingMaskIntoConstraints = false
    return view
  }()
  
  public let stackView: UIStackView = {
    let stackView = UIStackView()
    stackView.axis = .vertical
    stackView.alignment = .center
    stackView.distribution = .fill
    stackView.translatesAutoresizingMaskIntoConstraints = false
    return stackView
  }()
  //private let topSpacingView = UIView()
  //private let bottomSpacingView = UIView()
  public var shouldAddNavBarInset: Bool = false {
    didSet {
      if shouldAddNavBarInset {
        if UIScreen.flm.isIphoneX {
          self.contentInset.top = 88.0
          self.contentOffset.y = -88.0
        } else {
          self.contentInset.top = 64.0
          self.contentOffset.y = -64.0
        }
      } else {
        self.contentInset.top = 0.0
        self.contentOffset.y = 0.0
      }
    }
  }
  
  override open var contentInset: UIEdgeInsets {
    didSet {
      self.scrollIndicatorInsets = contentInset
    }
  }

  public var arrangedSubviews: [UIView] {
    return self.stackView.arrangedSubviews
  }
  
  public var spacing: CGFloat {
    get { return stackView.spacing }
    set { stackView.spacing = newValue }
  }
  
  private lazy var visibleSize = self.bounds.size
  private var firstResponder: UIView?
  
  // MARK: - Initial Setting
  
  override public init(frame: CGRect) {
    super.init(frame: frame)
    setInitialState()
  }
  
  required public init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  private func setInitialState() {
    self.alwaysBounceVertical = true
    
    if #available(iOS 11.0, *) {
      self.contentInsetAdjustmentBehavior = .never
    }
    
    if UIScreen.flm.isIphoneX {
      contentInset.bottom = 44.0
    }
    
    self.addSubview(contentView)
    contentView.addSubview(stackView)
    
    let constraintForDynamicHeight = 
      NSLayoutConstraint(item: contentView, attribute: .height, relatedBy: .greaterThanOrEqual, toItem: stackView, attribute: .height, multiplier: 1.0, constant: 0.0)
    constraintForDynamicHeight.priority = UILayoutPriority(rawValue: 900)
    
    let constraints = [
      // contentView
      NSLayoutConstraint(item: contentView, attribute: .left, relatedBy: .equal, toItem: self, attribute: .left, multiplier: 1.0, constant: 0.0),
      NSLayoutConstraint(item: contentView, attribute: .right, relatedBy: .equal, toItem: self, attribute: .right, multiplier: 1.0, constant: 0.0),
      NSLayoutConstraint(item: contentView, attribute: .top, relatedBy: .equal, toItem: self, attribute: .top, multiplier: 1.0, constant: 0.0),
      NSLayoutConstraint(item: contentView, attribute: .bottom, relatedBy: .equal, toItem: self, attribute: .bottom, multiplier: 1.0, constant: 0.0),
      NSLayoutConstraint(item: contentView, attribute: .width, relatedBy: .equal, toItem: self, attribute: .width, multiplier: 1.0, constant: 0.0),
      
      // rootStackView
      NSLayoutConstraint(item: stackView, attribute: .top, relatedBy: .equal, toItem: contentView, attribute: .top, multiplier: 1.0, constant: 0.0),
      NSLayoutConstraint(item: stackView, attribute: .width, relatedBy: .equal, toItem: contentView, attribute: .width, multiplier: 1.0, constant: 0.0),
      NSLayoutConstraint(item: stackView, attribute: .centerX, relatedBy: .equal, toItem: contentView, attribute: .centerX, multiplier: 1.0, constant: 0.0),
      constraintForDynamicHeight
    ]
    NSLayoutConstraint.activate(constraints)
    listenToTheKeyboard()
  }
  
  var keyboardWillShowObserver: NSObjectProtocol?
  var keyboardWillHideObserver: NSObjectProtocol?
  var bottomInsetBuffer: CGFloat = 0.0
  
  func listenToTheKeyboard() {
    keyboardWillShowObserver = NotificationCenter.default.addObserver(forName: NSNotification.Name.UIKeyboardWillShow, object: nil, queue: nil) {[weak self] notification in
      guard 
        let `self` = self,
        let frameValue = notification.userInfo?[UIKeyboardFrameEndUserInfoKey] as? NSValue 
        else { return }
      self.bottomInsetBuffer = self.contentInset.bottom
      var calculatedContentInsets = self.contentInset
      var calculatedScrollIndicatorInsets = self.scrollIndicatorInsets
      let keyboardFrame = frameValue.cgRectValue
      calculatedContentInsets.bottom = keyboardFrame.size.height
      calculatedScrollIndicatorInsets.bottom = keyboardFrame.size.height
      self.contentInset = calculatedContentInsets
      self.scrollIndicatorInsets = calculatedScrollIndicatorInsets
      self.setNeedsLayout()
      self.layoutIfNeeded()
    }
    
    keyboardWillHideObserver = NotificationCenter.default.addObserver(forName: NSNotification.Name.UIKeyboardWillHide, object: nil, queue: nil) {[weak self] _ in
      guard 
        let `self` = self
        else { return }
      
      var calculatedContentInsets = self.contentInset
      var calculatedScrollIndicatorInsets = self.scrollIndicatorInsets
      
      calculatedContentInsets.bottom = self.bottomInsetBuffer
      calculatedScrollIndicatorInsets.bottom = self.bottomInsetBuffer
      self.contentInset = calculatedContentInsets
      self.scrollIndicatorInsets = calculatedScrollIndicatorInsets
      self.setNeedsLayout()
      self.layoutIfNeeded()
    }
  }
  
  deinit {
    keyboardWillHideObserver = nil
    keyboardWillShowObserver = nil
  }
  
  override open func layoutSubviews() {
    super.layoutSubviews()
    layoutIfNeeded()
  }
  
  // MARK: - Subviews Control
  
  public func insertArrangedSubview(_ view: UIView,
                                    index: Int, 
                                    animated: Bool = false, 
                                    horizontalInset: CGFloat = 0.0, 
                                    height: CGFloat = 0.0) {
    
    view.translatesAutoresizingMaskIntoConstraints = false
    
    var constraints: [NSLayoutConstraint] = []
    
    
    constraints.append(NSLayoutConstraint.init(
      item: view, 
      attribute: .width, 
      relatedBy: .equal, 
      toItem: stackView, 
      attribute: .width, 
      multiplier: 1.0, 
      constant: -horizontalInset * 2.0))
    
    
    if height > 0.0 {
      constraints.append(NSLayoutConstraint.init(
        item: view, 
        attribute: .height, 
        relatedBy: .equal, 
        toItem: nil, 
        attribute: .notAnAttribute, 
        multiplier: 1.0, 
        constant: height))
    }
    
    stackView.insertArrangedSubview(view, at: index)
    NSLayoutConstraint.activate(constraints)
    
    if animated {
      view.isHidden = true
      view.alpha = 0.0
      
      UIView.animate(withDuration: 0.5) { 
        view.isHidden = false
        view.alpha = 1.0
      }
    }
  }
  
  public func addArrangedSubview(_ view: UIView, animated: Bool = false, horizontalInset: CGFloat = 0.0, height: CGFloat = 0.0) {
    
    self.insertArrangedSubview(view, 
                               index: stackView.arrangedSubviews.count,
                               animated: animated, 
                               horizontalInset: horizontalInset,
                               height: height)
  }
  
  public func removeArrangedSubview(_ view: UIView, animated: Bool) {
    if animated {
      UIView.animate(withDuration: 0.5, animations: { 
        view.isHidden = true
        view.alpha = 0.0
      }, completion: { _ in
        self.stackView.removeArrangedSubview(view)
        view.removeFromSuperview()
      })
    } else {
      stackView.removeArrangedSubview(view)
      view.removeFromSuperview()
    }
  }
  
  public func scrollToBottom() {
    let bottom = contentSize.height - frame.height + contentInset.bottom
    UIView.animate(withDuration: 0.5) { 
      self.contentOffset = CGPoint(x: 0.0, y: bottom)
    }
  }
  
  /// 마진을 중간에 추가하고자 할 때 씁니다. 레이아웃이 다이나믹한 곳에서 쓰면, arrangedSubview들 순서 때문에 컨트롤이 곤란할 수 있습니다.
  ///
  /// - Parameter 
  ///   - height: 마진의 높이입니다.
  ///   - color: 마진 색입니다.
  public func insertMarginStack(height: CGFloat, color: UIColor = .clear, index: Int) {
    let marginView = UIView()
    marginView.backgroundColor = color
    NSLayoutConstraint.activate([NSLayoutConstraint(item: marginView, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1.0, constant: height)])
    self.insertArrangedSubview(marginView, index: index, animated: false)
  }
  
  /// 마진을 맨 아래에 추가하고자 할 때 씁니다. 레이아웃이 다이나믹한 곳에서 쓰면, arrangedSubview들 순서 때문에 컨트롤이 곤란할 수 있습니다.
  ///
  /// - Parameter 
  ///   - height: 마진의 높이입니다.
  ///   - color: 마진 색입니다.
  public func addMarginStack(height: CGFloat, color: UIColor = .clear) {
    insertMarginStack(height: height, color: color, index: self.arrangedSubviews.count)
  }
  
}

