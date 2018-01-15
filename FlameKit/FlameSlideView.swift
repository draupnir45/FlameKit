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
  
  open let pagingScrollView: UIScrollView = {
    let scrollView = UIScrollView()
    scrollView.isPagingEnabled = true
    scrollView.showsVerticalScrollIndicator = false
    scrollView.showsHorizontalScrollIndicator = false
    return scrollView
  }()
  
  open var viewArray: [UIView] = [] {
    didSet {
      layoutSubviews()
      _ = self.viewArray.map { subview in
        subview.frame = CGRect.init(origin: CGPoint.init(x: pagingScrollView.frame.width, y: 0.0), size: pagingScrollView.frame.size)
        self.pagingScrollView.addSubview(subview)
        subview.isHidden = true
      }
      viewArray[currentViewIndex].isHidden = false
    }
  }
  
  var currentViewIndex: Int = 0
  var currentViewFrame: CGRect = CGRect.zero
  var prevViewFrame: CGRect = CGRect.zero
  var nextViewFrame: CGRect = CGRect.zero
  var slideTimeInterval: TimeInterval = 3.0
  
  override init(frame: CGRect) {
    super.init(frame: frame)
    setSubviews()
    
    //    self.isAutoSlideEnabled = true
  }
  
  required public init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  deinit {
    delegate = nil
  }
  
  func setSubviews() {
    addSubview(pagingScrollView)
    pagingScrollView.delegate = self
    pagingScrollView.frame = self.bounds
    layoutCustomViews()
    
  }
  
  override open func layoutSubviews() {
    super.layoutSubviews()
    self.layoutCustomViews()
  }
  
  open var isAutoSlideEnabled = true
  
  var autoSlideTimer: Timer?
  
  func layoutCustomViews() {
    pagingScrollView.frame = self.bounds
    
    prevViewFrame = CGRect.init(
      origin: CGPoint.init(x: 0.0, y: 0.0),
      size: pagingScrollView.frame.size)
    
    currentViewFrame = CGRect.init(
      origin: CGPoint.init(x: pagingScrollView.frame.width, y: 0.0),
      size: pagingScrollView.frame.size)
    
    nextViewFrame = CGRect.init(
      origin: CGPoint.init(x: pagingScrollView.frame.width * 2.0, y: 0.0),
      size: pagingScrollView.frame.size)
    
    pagingScrollView.contentOffset.x = pagingScrollView.frame.width
    pagingScrollView.contentSize = CGSize.init(
      width: self.bounds.width * 3,
      height: self.bounds.height)
    
  }
  
  @objc func goNextView() {
    self.pagingScrollView.setContentOffset(CGPoint.init(x: pagingScrollView.frame.size.width * 2, y: 0.0), animated: true)
  }
  
  public func scrollViewDidScroll(_ scrollView: UIScrollView) {
    
    
    let width = scrollView.frame.width
    
    // 다음 카드로 갈 때
    if scrollView.contentOffset.x > width {
      
      let nextIndex = (currentViewIndex + 1) % viewArray.count
      let nextView = self.viewArray[nextIndex]
      nextView.frame = nextViewFrame
      nextView.isHidden = false
    }
    
    // 이전 카드로 갈 때
    if scrollView.contentOffset.x < width {
      
      let prevIndex = (currentViewIndex + viewArray.count - 1) % viewArray.count
      let prevView = self.viewArray[prevIndex]
      prevView.frame = prevViewFrame
      prevView.isHidden = false
    }
    
    //오프셋 초기화
    if scrollView.contentOffset.x >= width * 2.0 {
      //다음 카드로 완전히 넘어갔을 때
      viewArray[currentViewIndex].isHidden = true
      let nextIndex = (currentViewIndex + 1) % viewArray.count
      currentViewIndex = nextIndex
      scrollView.contentOffset.x -= width
      viewArray[currentViewIndex].frame = currentViewFrame
      setNewTimer()
      
    } else if scrollView.contentOffset.x <= 0.0 {
      //이전 카드로 완전히 넘어갔을 때
      viewArray[currentViewIndex].isHidden = true
      let prevIndex = (currentViewIndex + viewArray.count - 1) % viewArray.count
      currentViewIndex = prevIndex
      scrollView.contentOffset.x += width
      viewArray[currentViewIndex].frame = currentViewFrame
      setNewTimer()
    }
    
    var progress = ((scrollView.contentOffset.x - width) / width) + CGFloat(currentViewIndex)
    
    if progress < 0 {
      progress += CGFloat(viewArray.count)
    }
    
    delegate?.didChanged(contentOffsetX: Double(progress), numberOfViews: viewArray.count)
    
  }
  
  func setNewTimer() {
    if isAutoSlideEnabled {
      
      autoSlideTimer?.invalidate()
      autoSlideTimer = nil
      autoSlideTimer =
        Timer.scheduledTimer(timeInterval: slideTimeInterval, target: self, selector: #selector(self.goNextView), userInfo: nil, repeats: false)
      
    }
  }
}
