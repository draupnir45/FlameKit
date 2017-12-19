//
//  FlameNavigationBar.swift
//  FlameCollection
//
//  Created by 박종찬 on 2017. 12. 11..
//  Copyright © 2017년 박종찬. All rights reserved.
//

import UIKit

public protocol FlameNavigationBarDelegate: class {
  func flameNavigationBarDidResizeHeightTo(_ barHeight: CGFloat)
}

@objcMembers open class FlameNavigationBar: UIView, UIGestureRecognizerDelegate, UIScrollViewDelegate {
  // ----------------------------------------
  //  스테이터스 바 영역 statusBarBackgroundView
  // ----------------------------------------
  //  고정 네비 바 영역 staticNavigationBarView
  // ----------------------------------------
  //  다이나믹 영역 dynamicNavigationBarView
  // ----------------------------------------
  
  weak public var delegate: FlameNavigationBarDelegate?
  
  // MARK: - Settings
  
  public struct Metric {
    static public let screenWidth: CGFloat = UIScreen.flm.width
    static public var statusBarHeight: CGFloat {
      if UIScreen.flm.isIphoneX {
        return 44.0
      } else {
        return 20.0
      }
    }
    static public let staticAreaHeight: CGFloat = 44.0
    static public let dynamicAreaHeight: CGFloat = 52.0
    static public let totalHeight = 
      Metric.statusBarHeight + 
        Metric.staticAreaHeight + 
        Metric.dynamicAreaHeight
  }
  
  public struct Color {
    
  }
  
  public struct Fonts {
    
  }
  
  public var barTintColor: UIColor? {
    didSet {
      statusBarBackgroundView.backgroundColor = barTintColor
      staticNavigationBarView.backgroundColor = barTintColor
      dynamicNavigationBarView.backgroundColor = barTintColor
    }
  }
  
  // MARK: - 프로퍼티들
  public var title: String? {
    didSet {
      
      guard let title = title else { return }
      
      normalTitleLabel.text = title
      normalTitleLabel.sizeToFit()
      normalTitleLabel.alpha = self.isCollapsed ? 1.0 : 0.0
      
      largeTitleLabel.alpha = 0.0
      largeTitleLabel.sizeToFit()
      
      UIView.animate(withDuration: 1) {
        self.largeTitleLabel.text = title
        self.largeTitleLabel.alpha = 1.0
      }
      
      layoutSubviews()
    }
  }
  
  public let normalTitleLabel: UILabel = {
    let label = UILabel()
    label.numberOfLines = 1
    label.font = UIFont.preferredFont(forTextStyle: UIFontTextStyle.headline)
    return label
  }()
  
  public let largeTitleLabel: UILabel = {
    let label = UILabel()
    label.numberOfLines = 1
    label.font = UIFont.boldSystemFont(ofSize: 34.0)
    return label
  }()
  
  
  
  func snap() -> CGFloat {
    if collapsedSize > Metric.dynamicAreaHeight / 2.0 {
      return Metric.dynamicAreaHeight
    } else {
      return 0.0
    }
  }
  
  func snapExpand() {
    if collapsedSize > 0 && collapsedSize < Metric.dynamicAreaHeight - 0.5 {
      UIView.animate(withDuration: 0.5, animations: { 
        self.collapsedSize = 0.0
        self.scrollView?.contentOffset.y = -Metric.totalHeight
      })
    }
  }
  
  var isCollapsed = false {
    didSet {
      UIView.animate(withDuration: 0.3, animations: { 
        self.normalTitleLabel.alpha = self.isCollapsed ? 1.0 : 0.0
      })
    }
  }
  public var collapsedSize: CGFloat = 0.0 {
    didSet {
      if collapsedSize <= 0.0 { // fully expanded
        
        dynamicNavigationBarView.frame.origin = 
          CGPoint.init(x: 0.0, 
                       y: Metric.statusBarHeight + Metric.staticAreaHeight)
        self.frame.size.height = Metric.totalHeight
        
        isCollapsed = false
        
      } else if collapsedSize < Metric.dynamicAreaHeight { // folding...
        
        dynamicNavigationBarView.frame.origin = 
          CGPoint.init(x: 0.0, 
                       y: Metric.statusBarHeight + Metric.staticAreaHeight - collapsedSize)
        self.frame.size.height = Metric.totalHeight - collapsedSize
        
        isCollapsed = false
        
      } else { // fully collapsed
        dynamicNavigationBarView.frame.origin = CGPoint.init(x: 0.0, y: Metric.statusBarHeight + Metric.staticAreaHeight - Metric.dynamicAreaHeight)
        self.frame.size.height = Metric.statusBarHeight + Metric.staticAreaHeight
        isCollapsed = true
      }
      
      layoutSubviews()
      delegate?.flameNavigationBarDidResizeHeightTo(self.frame.size.height)
    }
  }
  
  public let statusBarBackgroundView: UIView = {
    let view = UIView(frame: CGRect(origin: CGPoint.zero, 
                                    size: CGSize.init(width: Metric.screenWidth, 
                                                      height: Metric.statusBarHeight)))
    return view
  }()
  
  public let staticNavigationBarView: UIView = {
    let view = UIView(frame: CGRect(x: 0.0, 
                                    y: Metric.statusBarHeight, 
                                    width: Metric.screenWidth, 
                                    height: Metric.staticAreaHeight))
    return view
  }()
  
  public let dynamicNavigationBarView: UIView = {
    let view = UIView(frame: CGRect(x: 0.0, 
                                    y: Metric.statusBarHeight + Metric.staticAreaHeight, 
                                    width: Metric.screenWidth, 
                                    height: Metric.dynamicAreaHeight))
    return view
  }()
  
  public let shadowView: UIView = {
    let view = UIView(frame: CGRect(x: 0.0, 
                                    y: Metric.dynamicAreaHeight, 
                                    width: Metric.screenWidth, 
                                    height: 0.5))
    view.backgroundColor = .lightGray
    return view
  }()
  
  func setSubviews() {
    barTintColor = .white
    addSubview(dynamicNavigationBarView)
    addSubview(statusBarBackgroundView)
    addSubview(staticNavigationBarView)
    dynamicNavigationBarView.addSubview(shadowView)
    
    staticNavigationBarView.addSubview(normalTitleLabel)
    dynamicNavigationBarView.addSubview(largeTitleLabel)
  }
  
  override open func layoutSubviews() {
    super.layoutSubviews()
    
    normalTitleLabel.sizeToFit()
    normalTitleLabel.frame.origin = CGPoint(
      x: (staticNavigationBarView.frame.width - normalTitleLabel.frame.width) / 2.0, 
      y: (staticNavigationBarView.frame.height - normalTitleLabel.frame.height) / 2.0
    )
    
    largeTitleLabel.sizeToFit()
    largeTitleLabel.frame.origin = CGPoint(
      x: 16.0, 
      y: (dynamicNavigationBarView.frame.height - largeTitleLabel.frame.height) / 2.0)
    
  }
  
  convenience public init() {
    self.init(frame: CGRect.zero)
  }
  
  override public init(frame: CGRect) {
    super.init(frame: CGRect(x: 0.0, y: 0.0, width: Metric.screenWidth, height: Metric.totalHeight))
    setSubviews()
  }
  
  required public init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  public var scrollView: UIScrollView?
  var didEndDecelerating = false
  
  public func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
    didEndDecelerating = false
  }
  
  public func scrollViewDidScroll(_ scrollView: UIScrollView) {
    
    if !didEndDecelerating {
      //      print(scrollView.contentOffset.y + scrollView.contentInset.top)
      self.collapsedSize = scrollView.contentOffset.y + scrollView.contentInset.top 
    } else {
      self.snapExpand()
    }
    //    print(#function)
  }
  
  public func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
    
    //    print(#function)
    if !decelerate && self.collapsedSize < FlameNavigationBar.Metric.dynamicAreaHeight {
      //      customNavBar.snap()
      UIView.animate(withDuration: 0.5, animations: { 
        scrollView.setContentOffset(CGPoint(x: 0.0, y: self.snap() - scrollView.contentInset.top), animated: false)
        self.collapsedSize = scrollView.contentOffset.y + scrollView.contentInset.top
      })
    }
  }
  
  public func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
    didEndDecelerating = true
    if collapsedSize < FlameNavigationBar.Metric.dynamicAreaHeight {
      UIView.animate(withDuration: 0.5, animations: { 
        scrollView.setContentOffset(CGPoint(x: 0.0, y: self.snap() - scrollView.contentInset.top), animated: true)
        self.collapsedSize = scrollView.contentOffset.y + scrollView.contentInset.top
      })
    }
  }
}

