//
//  FlameSlideView.swift
//  FlameKit
//
//  Created by 박종찬 on 2018. 1. 15..
//

import UIKit

public protocol FlameSlideViewDelegate: class {
  func didChanged(contentOffsetX value: Double, numberOfViews: Int)
}

@objcMembers open class FlameSlideView: UIView, UIScrollViewDelegate {
  // MARK: - initializers
  
  open weak var delegate: FlameSlideViewDelegate?
  
  var appWillResignActiveObserver: NSObjectProtocol!
  var appDidBecomeActiveObserver: NSObjectProtocol!
  
  open let scrollView: UIScrollView = {
    let scrollView = UIScrollView()
    scrollView.isPagingEnabled = true
    scrollView.showsVerticalScrollIndicator = false
    scrollView.showsHorizontalScrollIndicator = false
    return scrollView
  }()
  
  open var viewArray: [UIView] = [] {
    didSet {
      layoutSubviews()
      
      guard viewArray.count > 0 else { return }
      
      _ = self.viewArray.map { subview in
        subview.frame = CGRect.init(origin: CGPoint.init(x: scrollView.frame.width, y: 0.0), size: scrollView.frame.size)
        subview.clipsToBounds = true
        self.scrollView.addSubview(subview)
        subview.isHidden = true
      }
      
      if viewArray.indices.contains(currentViewIndex) {
        viewArray[currentViewIndex].isHidden = false
      }
    }
  }
  
  var currentViewIndex: Int = 0
  
  public func setIndex(index: Int) {
    self.currentViewIndex = index
    _ = viewArray.map { view in
      view.isHidden = true
    }
    viewArray[index].isHidden = false
    viewArray[index].frame = currentViewFrame
    scrollView.contentOffset.x = scrollView.frame.width
  }
  
  var currentViewFrame: CGRect = CGRect.zero {
    didSet {
      if viewArray.indices.contains(currentViewIndex) {
        viewArray[currentViewIndex].frame = currentViewFrame
      }
    }
  }
  var prevViewFrame: CGRect = CGRect.zero
  var nextViewFrame: CGRect = CGRect.zero
  public var slideTimeInterval: TimeInterval = 3.0
  
  override public init(frame: CGRect) {
    super.init(frame: frame)
    self.isAutoSlideEnabled = true
    setSubviews()
  }
  
  required public init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  deinit {
    delegate = nil
    NotificationCenter.default.removeObserver(appWillResignActiveObserver)
    NotificationCenter.default.removeObserver(appDidBecomeActiveObserver)
  }
  
  func setSubviews() {
    addSubview(scrollView)
    scrollView.delegate = self
    scrollView.frame = self.bounds
    layoutCustomViews()
    
    
    appWillResignActiveObserver = NotificationCenter.default.addObserver(forName: .UIApplicationWillResignActive, object: nil, queue: nil) { notification in
      self.isAutoSlideEnabled = false
    }
    
    appDidBecomeActiveObserver = NotificationCenter.default.addObserver(forName: .UIApplicationDidBecomeActive, object: nil, queue: nil) { notification in
      self.isAutoSlideEnabled = true
    }
    
  }
  
  override open func layoutSubviews() {
    super.layoutSubviews()
    self.layoutCustomViews()
  }
  
  open var isAutoSlideEnabled = true {
    didSet {
      if isAutoSlideEnabled {
        startSlide()
      } else {
        pauseSlide()
      }
    }
  }
  
  var autoSlideTimer: Timer?
  
  public func layoutCustomViews() {
    scrollView.frame = self.bounds
    
    prevViewFrame = CGRect.init(
      origin: CGPoint.init(x: 0.0, y: 0.0),
      size: scrollView.frame.size)
    
    currentViewFrame = CGRect.init(
      origin: CGPoint.init(x: scrollView.frame.width, y: 0.0),
      size: scrollView.frame.size)
    
    nextViewFrame = CGRect.init(
      origin: CGPoint.init(x: scrollView.frame.width * 2.0, y: 0.0),
      size: scrollView.frame.size)
    
    scrollView.contentOffset.x = scrollView.frame.width
    scrollView.contentSize = CGSize.init(
      width: self.bounds.width * 3,
      height: self.bounds.height)
    
  }

  
  public func scrollViewDidScroll(_ scrollView: UIScrollView) {
    
    guard viewArray.count > 0 else { return }
    let width = scrollView.frame.width
    
    // 다음 카드로 가기 전 준비
    if scrollView.contentOffset.x > width {
      let nextIndex = (currentViewIndex + 1) % viewArray.count
      let nextView = self.viewArray[nextIndex]
      nextView.frame = nextViewFrame
      nextView.isHidden = false
    }
    
    // 이전 카드로 가기 전 준비
    if scrollView.contentOffset.x < width {
      let prevIndex = (currentViewIndex + viewArray.count - 1) % viewArray.count
      let prevView = self.viewArray[prevIndex]
      prevView.frame = prevViewFrame
      prevView.isHidden = false
    }
    
    //오프셋 초기화
    if scrollView.contentOffset.x >= width * 2.0 {
      
      //다음 카드로 완전히 넘어갔을 때
      let nextIndex = (currentViewIndex + 1) % viewArray.count
      currentViewIndex = nextIndex
      cleanUp()
      
    } else if scrollView.contentOffset.x <= 0.0 {
      
      //이전 카드로 완전히 넘어갔을 때
      let prevIndex = (currentViewIndex + viewArray.count - 1) % viewArray.count
      currentViewIndex = prevIndex
      cleanUp()
    }
    
    var progress = ((scrollView.contentOffset.x - width) / width) + CGFloat(currentViewIndex)
    
    if progress < 0 {
      progress += CGFloat(viewArray.count)
    }
    
    delegate?.didChanged(contentOffsetX: Double(progress), numberOfViews: viewArray.count)
    
  }
  
  func startSlide() {
      autoSlideTimer?.invalidate()
      autoSlideTimer = nil
      autoSlideTimer =
        Timer
          .scheduledTimer(
            timeInterval: slideTimeInterval,
            target: self,
            selector: #selector(self.goNextView),
            userInfo: nil,
            repeats: false)
  }
  
  
  @objc func goNextView() {
    guard viewArray.count > 0 else { return }
    self.scrollView.setContentOffset(CGPoint.init(x: self.frame.size.width * 2, y: 0.0), animated: true)
  }
  
  func hideAll() {
    _ = viewArray.map({ view in
      view.isHidden = true
    })
  }
  
  func cleanUp() {
    hideAll()
    viewArray[currentViewIndex].frame = currentViewFrame
    viewArray[currentViewIndex].isHidden = false
    scrollView.contentOffset.x = self.frame.width
    if isAutoSlideEnabled { startSlide() }
  }
  
  func pauseSlide() {
      autoSlideTimer?.invalidate()
      autoSlideTimer = nil

  }
  
}
