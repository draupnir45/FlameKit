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
  
  struct Color {
    
  }
  
  struct Fonts {
    
  }
  
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
  
  // MARK: - Closures for Repetitive UIs
  
  let newTitleStack: (String) -> UIView = { title in
    let view = UIView()
    view.backgroundColor = .white
    
    let label = UILabel.init(frame: CGRect.init(x: 16.0, y: 16.0, width: Metric.contentWidth, height: 10.0))
    label.text = title
    label.font = UIFont.preferredFont(forTextStyle: UIFontTextStyle.title2)
    label.sizeToFit()
    label.backgroundColor = .white
    
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
    
//    let navigationBar = FlameNavigationBar()
    scrollView.delegate = navigationBar
    navigationBar.scrollView = scrollView
    scrollView.contentInset.top = navigationBar.frame.height
    
    scrollView.addSubview(refreshControl)
    refreshControl.addTarget(self, action: #selector(self.refresh), for: UIControlEvents.valueChanged)
    

    
    setContent()
  }
  
  @objc func refresh() {
    if #available(iOS 10.0, *) {
      _ = Timer.scheduledTimer(withTimeInterval: 3.0, repeats: false, block: { _ in
        self.refreshControl.endRefreshing()
      })
    } else {
      _ = Timer.scheduledTimer(timeInterval: 3.0, target: self.refreshControl, selector: #selector(self.refreshControl.endRefreshing), userInfo: nil, repeats: false)
    }
  }
  
  func setContent() {
    
    let button = FlameButton()
    let customView = UIView()
    
    button.add { (button) in
      print("button is tapped!")
    }
    
    button.setCustomView(customView) { (isSelected) in
      if isSelected {
        customView.backgroundColor = .red
      } else {
        customView.backgroundColor = .blue
      }
    }
    
    scrollView.addMarginStack(height: 16.0)
    scrollView.addArrangedSubview(newTitleStack("FlameNavigationBar"))
    scrollView.addArrangedSubview(newLabelStack("  iOS 11에서 소개된 largeTitleMode를 흉내낸 커스텀 네비게이션바입니다. iOS 9.0에서도 문제없이 사용할 수 있습니다. 등록된 scrollView로부터 스크롤된 상태를 체크하고, 자동으로 Height를 조정하면서 큰 타이틀 작은 타이틀 사이를 번갈아 움직입니다. 초기화할 때 프레임을 넣더라도 무시하고 기본값으로 작동합니다. 현재 사이즈 조정은 지원하지 않지만, 서브뷰를 추가해 사이즈가 커진 것과 같은 효과를 낼 수 있습니다."))
    scrollView.addMarginStack(height: 16.0)
    scrollView.addArrangedSubview(newTitleStack("FlameScrollView"))
    scrollView.addArrangedSubview(newLabelStack("  기본 베이스는 스크롤 뷰이지만, 버티컬 스택뷰를 포함하고 있는 스크롤뷰입니다. 컨텐트사이즈는 오토 레이아웃을 통해 자동으로 스택 뷰의 높이에 따라 길어집니다. addArrangedSubview(_:animated:horizontalInset:height:) 와 insertArrangedSubview(_:index:animated:horizontalInset:height:)를 이용해서 서브뷰를 추가하면 됩니다."))
    scrollView.addMarginStack(height: 16.0)
    scrollView.addArrangedSubview(newTitleStack("FlameButton"))
    scrollView.addArrangedSubview(newLabelStack("  액션과 모양을 둘 다 클로저를 이용해 처리하는 커스텀 버튼입니다. 베이스는 UIView입니다. 액션은 add(handler:)를 통해 FlameButtonHandler 클로저를 받아 처리합니다. 모양은 setCustomView(_:appearanceHandler:) 메서드를 통해 또다른 UIView인 customView를 받고, 선택 여부인 Bool값을 파라미터로 가지는 FlameButtonAppearanceHandler 클로저를 설정해 클로징된 커스텀뷰 모양을 바꿉니다."))
    scrollView.addMarginStack(height: 16.0)
    scrollView.addArrangedSubview(copyrightLabel)
  }
  
  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
    
  }
  
  
}

