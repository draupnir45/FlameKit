# FlameKit

[![Version](https://img.shields.io/cocoapods/v/FlameKit.svg?style=flat)](http://cocoapods.org/pods/FlameKit)
[![License](https://img.shields.io/cocoapods/l/FlameKit.svg?style=flat)](http://cocoapods.org/pods/FlameKit)
[![Platform](https://img.shields.io/cocoapods/p/FlameKit.svg?style=flat)](http://cocoapods.org/pods/FlameKit)

[English README](README.md)


## 개요

iOS 9.0을 디플로이 타겟으로 하는 앱들을 위한 커스텀 UI 라이브러리입니다. 주요 클래스는 아래와 같습니다.

### FlameNavigationBar
iOS 11에서 소개된 largeTitleMode를 흉내낸 커스텀 네비게이션바입니다. iOS 9.0에서도 문제없이 사용할 수 있습니다. 등록된 scrollView로부터 스크롤된 상태를 체크하고, 자동으로 Height를 조정하면서 큰 타이틀 작은 타이틀 사이를 번갈아 움직입니다. 초기화할 때 프레임을 넣더라도 무시하고 기본값으로 작동합니다. 현재 사이즈 조정은 지원하지 않지만, 서브뷰를 추가해 사이즈가 커진 것과 같은 효과를 낼 수 있습니다.

### FlameScrollView
기본 베이스는 스크롤 뷰이지만, 버티컬 스택뷰를 포함하고 있는 스크롤뷰입니다. 컨텐트사이즈는 오토 레이아웃을 통해 자동으로 스택 뷰의 높이에 따라 길어집니다. addArrangedSubview(_:animated:horizontalInset:height:) 와 insertArrangedSubview(_:index:animated:horizontalInset:height:)를 이용해서 서브뷰를 추가하면 됩니다.
UITableView의 키보드 노티 듣는 기능도 지원합니다. 일반 키보드나 피커에 따라 자동으로 컨텐트 인셋과 인디케이터 인셋을 추가했다 뺐다 합니다.

### FlameButton
액션과 모양을 둘 다 클로저를 이용해 처리하는 커스텀 버튼입니다. 베이스는 UIView입니다. 액션은 add(handler:)를 통해 FlameButtonHandler 클로저를 받아 처리합니다. 모양은 setCustomView(_:appearanceHandler:) 메서드를 통해 또다른 UIView인 customView를 받고, 선택 여부인 Bool값을 파라미터로 가지는 FlameButtonAppearanceHandler 클로저를 설정해 클로징된 커스텀뷰 모양을 바꿉니다.

## Requirements

- Swift 4.0
- iOS 9.0 ~

## Installation

```ruby
pod 'FlameKit'
```

## Author

Jongchan Mark Park, draupnir45@gmail.com

## License

FlameKit is available under the MIT license. See the LICENSE file for more info.