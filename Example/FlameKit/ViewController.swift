//
//  ViewController.swift
//  FlameKit
//
//  Created by markoverthere on 12/14/2017.
//  Copyright (c) 2017 markoverthere. All rights reserved.
//

import UIKit
import FlameKit

class ViewController: UIViewController {
  
  // MARK: - Settings
  
  struct Metric {
    static let contentWidth: CGFloat = UIScreen.flm.width - 32.0
  }
  
  // MARK: - Sample Contents
  
  let sampleTitles = [
    "FlameScrollView",
    "FlameNavigationBar",
    "FlameButton"
  ]
  
  let sampleDescriptions = [
    "기본 베이스는 스크롤 뷰이지만, 버티컬 스택뷰를 포함하고 있는 스크롤뷰입니다. 컨텐트사이즈는 오토 레이아웃을 통해 자동으로 스택 뷰의 높이에 따라 길어집니다. addArrangedSubview(_:animated:horizontalInset:height:) 와 insertArrangedSubview(_:index:animated:horizontalInset:height:)를 이용해서 서브뷰를 추가하면 됩니다.",
    "iOS 11에서 소개된 largeTitleMode를 흉내낸 커스텀 네비게이션바입니다. iOS 9.0에서도 문제없이 사용할 수 있습니다. 등록된 scrollView로부터 스크롤된 상태를 체크하고, 자동으로 Height를 조정하면서 큰 타이틀 작은 타이틀 사이를 번갈아 움직입니다. 초기화할 때 프레임을 넣더라도 무시하고 기본값으로 작동합니다. 현재 사이즈 조정은 지원하지 않지만, 서브뷰를 추가해 사이즈가 커진 것과 같은 효과를 낼 수 있습니다.",
    "액션과 모양을 둘 다 클로저를 이용해 처리하는 커스텀 버튼입니다. 베이스는 UIView입니다. 액션은 add(handler:)를 통해 FlameButtonHandler 클로저를 받아 처리합니다. 모양은 setCustomView(_:appearanceHandler:) 메서드를 통해 또다른 UIView인 customView를 받고, 선택 여부인 Bool값을 파라미터로 가지는 FlameButtonAppearanceHandler 클로저를 설정해 클로징된 커스텀뷰 모양을 바꿉니다."
  ]
  
  // MARK: - Static UIs
  
  let navigationBar: FlameNavigationBar = {
    let nav = FlameNavigationBar()
    nav.title = "FlameKit"
    return nav
  }()
  
  let scrollView: FlameScrollView = {
    let view = FlameScrollView()
    view.backgroundColor = UIColor.darkGray.withAlphaComponent(0.1)
    return view
  }()
  
  let copyrightLabel: UILabel = {
    let label = UILabel()
    label.numberOfLines = 0
    label.text = "Copyright (C) Jongchan Park, All Rights Reserved."
    label.font = UIFont.preferredFont(forTextStyle: UIFontTextStyle.footnote)
    label.textColor = UIColor.lightGray
    label.textAlignment = .center
    return label
  }()
  
  let refreshControl: UIRefreshControl = {
    let control = UIRefreshControl()
    return control
  }()
  
  let stackAddEnableButton: FlameButton = {
    let button = FlameButton.init(frame: CGRect.init(x: 16.0, y: 16.0, width: 100.0, height: 30.0))
    let label = UILabel()
    button.setAppearanceView(label, appearanceHandler: { (isSelected, _) in
      if isSelected {
        label.textColor = .red
        label.text = "Add Button ON"
      } else {
        label.textColor = .gray
        label.text = "Add Button OFF"
      }
    })
    button.isSelected = true
    button.translatesAutoresizingMaskIntoConstraints = false
    return button
  }()
  
  let newStackButton: FlameButton = {
    let button = FlameButton.init(frame: CGRect.init(x: 16.0, y: 16.0, width: 100.0, height: 30.0))
    let label = UILabel()
    label.text = "new stack"
    label.textColor = .red
    
    button.setAppearanceView(label, appearanceHandler: { (_, isEnabled) in
      if isEnabled {
        label.alpha = 1.0        
      } else {
        label.alpha = 0.5
      }
    })
    button.translatesAutoresizingMaskIntoConstraints = false
    return button
  }()
  
  // MARK: - Closures for Repetitive UIs
  
  let newTitleStack: (String) -> UIView = { title in
    let view = UIView()
    view.backgroundColor = .white
    
    let label = UILabel.init(frame: CGRect.init(x: 16.0, y: 16.0, width: Metric.contentWidth, height: 10.0))
    label.text = title
    label.font = UIFont.preferredFont(forTextStyle: UIFontTextStyle.title2)
    label.sizeToFit()
    label.backgroundColor = .white
//    label.characterSpacing = 10.0
    
    view.addSubview(label)
    NSLayoutConstraint.activate(
      [
        NSLayoutConstraint.init(
          item: view, 
          attribute: NSLayoutAttribute.height, 
          relatedBy: NSLayoutRelation.equal, 
          toItem: label, 
          attribute: NSLayoutAttribute.height, 
          multiplier: 1.0, 
          constant: 16.0
        )
      ]
    )
    return view
  }
  
  let newLabelStack: (String) -> UIView = { content in
    let view = UIView()
    view.backgroundColor = .white
    
    let label = UILabel.init(frame: CGRect.init(x: 16.0, y: 16.0, width: Metric.contentWidth, height: 10.0))
    label.text = content
    label.font = UIFont.preferredFont(forTextStyle: UIFontTextStyle.body)
    label.numberOfLines = 0
    label.sizeToFit()
    label.backgroundColor = .white
    label.preferredMaxLayoutWidth = 50.0
    
    view.addSubview(label)
    NSLayoutConstraint.activate(
      [
        NSLayoutConstraint.init(
          item: view, 
          attribute: NSLayoutAttribute.height, 
          relatedBy: NSLayoutRelation.equal, 
          toItem: label, 
          attribute: NSLayoutAttribute.height, 
          multiplier: 1.0, 
          constant: 32.0
        )
      ]
    )
    
    return view
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    view.addSubview(scrollView)
    scrollView.frame = view.bounds
    
    view.addSubview(navigationBar)
    scrollView.delegate = navigationBar
    navigationBar.scrollView = scrollView
    scrollView.contentInset.top = navigationBar.frame.height
    
    //버튼들 추가
    navigationBar.staticNavigationBarView.addSubview(stackAddEnableButton)
    NSLayoutConstraint.activate([
      NSLayoutConstraint.init(item: stackAddEnableButton, 
                              attribute: NSLayoutAttribute.left, 
                              relatedBy: NSLayoutRelation.equal, 
                              toItem: navigationBar.staticNavigationBarView, 
                              attribute: NSLayoutAttribute.left, 
                              multiplier: 1.0, 
                              constant: 16.0),
      NSLayoutConstraint.init(item: stackAddEnableButton, 
                              attribute: NSLayoutAttribute.centerY, 
                              relatedBy: NSLayoutRelation.equal, 
                              toItem: navigationBar.staticNavigationBarView, 
                              attribute: NSLayoutAttribute.centerY, 
                              multiplier: 1.0, 
                              constant: 0.0)
      ])
    
    stackAddEnableButton.action { button in
      button.isSelected = !button.isSelected
      self.newStackButton.isEnabled = button.isSelected
    }
    
    navigationBar.staticNavigationBarView.addSubview(newStackButton)
    NSLayoutConstraint.activate([
      NSLayoutConstraint.init(item: newStackButton, 
                              attribute: .right, 
                              relatedBy: .equal, 
                              toItem: navigationBar.staticNavigationBarView, 
                              attribute: .right, 
                              multiplier: 1.0, 
                              constant: -16.0),
      NSLayoutConstraint.init(item: newStackButton, 
                              attribute: .centerY, 
                              relatedBy: .equal, 
                              toItem: navigationBar.staticNavigationBarView, 
                              attribute: .centerY, 
                              multiplier: 1.0, 
                              constant: 0.0)
      ])
    
    newStackButton.action { button in
      self.addNewContentStacks()
    }
    
    scrollView.addSubview(refreshControl)
    refreshControl.addTarget(self, action: #selector(self.refresh), for: UIControlEvents.valueChanged)
    
    setContent()
  }
  
  @objc func refresh() {
    _ = scrollView.arrangedSubviews.map({ view in
      view.removeFromSuperview()
    })
    
    setContent()
    
    if #available(iOS 10.0, *) {
      _ = Timer.scheduledTimer(
        withTimeInterval: 0.5, 
        repeats: false, 
        block: { [weak self] _ in
          guard let `self` = self else { return }
          self.refreshControl.endRefreshing()
      })
    } else {
      _ = Timer.scheduledTimer(timeInterval: 0.5, target: self.refreshControl, selector: #selector(self.refreshControl.endRefreshing), userInfo: nil, repeats: false)
    }
  }
  
  func setContent() {
    scrollView.addMarginStack(height: 16.0)
    scrollView.addArrangedSubview(copyrightLabel)
    addNewContentStacks()
  }
  
  var sampleIndex: Int = 0
  
  func addNewContentStacks() {
    let index = sampleIndex % sampleTitles.count
    
    scrollView.insertArrangedSubview(
      newTitleStack(sampleTitles[index]), 
      index: scrollView.arrangedSubviews.count - 1, 
      animated: true
    )
    
    scrollView.insertArrangedSubview(
      newLabelStack(sampleDescriptions[index]), 
      index: scrollView.arrangedSubviews.count - 1, 
      animated: true
    )
    
    scrollView.insertMarginStack(height: 16.0, index: scrollView.arrangedSubviews.count - 1)
    sampleIndex += 1
  }
  
  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
    
  }
  
  
}

