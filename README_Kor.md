# FlameKit🔥

[![Version](https://img.shields.io/cocoapods/v/FlameKit.svg?style=flat)](http://cocoapods.org/pods/FlameKit)
[![License](https://img.shields.io/cocoapods/l/FlameKit.svg?style=flat)](http://cocoapods.org/pods/FlameKit)
[![Platform](https://img.shields.io/cocoapods/p/FlameKit.svg?style=flat)](http://cocoapods.org/pods/FlameKit)

[English README](README.md)


## 개요

iOS 9.0을 디플로이 타겟으로 하는 앱들을 위한 커스텀 UI 라이브러리입니다. 주요 클래스는 아래와 같습니다.

### FlameScrollView
기본 베이스는 스크롤 뷰이지만, 버티컬 스택뷰를 포함하고 있는 스크롤뷰입니다. 컨텐트사이즈는 오토 레이아웃을 통해 자동으로 스택 뷰의 높이에 따라 길어집니다. addArrangedSubview(_:animated:horizontalInset:height:) 와 insertArrangedSubview(_:index:animated:horizontalInset:height:)를 이용해서 서브뷰를 추가하면 됩니다.
UITableView의 키보드 노티 듣는 기능도 지원합니다. 일반 키보드나 피커에 따라 자동으로 컨텐트 인셋과 인디케이터 인셋을 추가했다 뺐다 합니다.
(아래의 'FlameNavigationBar'와도 잘 호환 되지만, 일반 네비게이션 컨트롤러와도 문제없이 사용할 수 있습니다.)

#### Usage

```swift
let scrollView = FlameScrollView(frame: view.bounds)
scrollView.addArrangedSubview(subView1)
scrollView.addArrangedSubview(subView2)
scrollView.addMarginStack(height: 16.0) // 마진 추가
```

### FlameNavigationBar
iOS 11에서 소개된 largeTitleMode를 흉내낸 커스텀 네비게이션바입니다. iOS 9.0에서도 문제없이 사용할 수 있습니다. 등록된 scrollView로부터 스크롤된 상태를 체크하고, 자동으로 Height를 조정하면서 큰 타이틀 작은 타이틀 사이를 번갈아 움직입니다. 초기화할 때 프레임을 넣더라도 무시하고 기본값으로 작동합니다. 현재 사이즈 조정은 지원하지 않지만, 서브뷰를 추가해 사이즈가 커진 것과 같은 효과를 낼 수 있습니다.

#### Usage

```swift
let navigationBar = FlameNavigationBar()
navigationBar.title = "View Title"
scrollView.delegate = navigationBar
navigationBar.scrollView = scrollView
scrollView.contentInset.top = navigationBar.frame.height
```


### FlameButton
액션과 모양을 둘 다 클로저를 이용해 처리하는 커스텀 버튼입니다. 베이스는 UIView입니다. 액션은 add(handler:)를 통해 FlameButtonHandler 클로저를 받아 처리합니다. 모양은 setCustomView(_:appearanceHandler:) 메서드를 통해 또다른 UIView인 customView를 받고, 선택 여부인 Bool값을 파라미터로 가지는 FlameButtonAppearanceHandler 클로저를 설정해 클로징된 커스텀뷰 모양을 바꿉니다.

#### Usage

```swift
let button = FlameButton()
let customView = UIView() // 외관을 꾸미세요
    
button.action { (button) in
  print("button is tapped!") // 버튼 눌렀을 때 행동.
  button.isSelected = true
}
    
button.setCustomView(customView) { (isSelected, isEnabled) in // 커스텀뷰의 모양을 컨트롤하세요.
  if isSelected {
    customView.backgroundColor = .red
  } else {
    customView.backgroundColor = .blue
  }
  
  if isEnabled {
    label.alpha = 1.0        
  } else {
    label.alpha = 0.5
  }
}
```

### FlameScreenUtil

FlameScreenUtil은 아이폰 스크린 사이즈 대응을 위한 간단한 getter 모음입니다.

#### 지원 사이즈
- iPhone1 - 오리지널 320 x 480 (iPhone 2G ~ iPhone 4S)
- iPhone5 - 와이드1 320 x 568 (iPhone 5 ~ iPhone SE)
- iPhone6 - 와이드2 375 x 667 (iPhone 6 ~ iPhone 8)
- iPhone6Plus - 와이드3 414 x 736 (iPhone 6+ ~ iPhone 8+)
- iPhoneX - 새로운 사이즈 375 x 812 (iPhone X)

#### Usage

```swift
switch UIScreen.flm.screenType { 
case .iPhone6Plus:
  // setting for iPhone 6 Plus..
case .iPhoneX:
  // setting for iPhone X..
default:
  // setting for others...
}

if UIScreen.flm.isIphoneX {
  //setting specific for iPhone X..
}
```

## Requirements

- Swift 4.0 +
- iOS 9.0 +

## Installation

```ruby
pod 'FlameKit'
```

## Objective-C 지원
pod 설치 후 헤더 파일에 아래와 같이 임포트해 주세요.

```objc
@import FlameKit;
```

## Update
- 0.1.9 : FlameButton에 활성화/비활성화(isEnabled) 기능 추가

## Author

Jongchan Mark Park, draupnir45@gmail.com

## License

FlameKit is available under the MIT license. See the LICENSE file for more info.
