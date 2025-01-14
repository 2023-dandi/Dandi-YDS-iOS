//
//  YDSBadge.swift
//  YDS-iOS
//
//  Created by Gyuni on 2021/07/31.
//

import UIKit

public class YDSBadge: UIView {

    // MARK: - 외부에서 지정할 수 있는 속성

    ///  뱃지의 글귀를 설정할 때 사용합니다.
    @SetNeeds(wrappedValue: nil, .layout) public var text: String?

    ///  뱃지에 들어갈 아이콘 이미지를 설정할 때 사용합니다.
    @SetNeeds(wrappedValue: nil, .layout) public var icon: UIImage?

    ///  뱃지의 색상을 설정할 때 사용합니다.
    @SetNeeds(.layout) public var color: YDSItemColor = .mono

    // MARK: - 내부에서 사용되는 상수

    private enum Dimension {

        ///  뱃지의 높이입니다.
        static let height: CGFloat = 24

        ///  아이콘과 라벨 사이 간격입니다.
        static let stackViewSpacing: CGFloat = 4

        ///  뱃지의 좌우 패딩 값입니다.
        static let horizontalPadding: CGFloat = 8

        ///  icon이 nil일 때 뱃지의 좌우 패딩 값입니다.
        static let horizontalPaddingWithoutIcon: CGFloat = 12
    }

    // MARK: - 뷰

    ///  icon과 label을 담는 stackView
    private let stackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.alignment = .center
        stackView.spacing = Dimension.stackViewSpacing
        stackView.isLayoutMarginsRelativeArrangement = true
        return stackView
    }()

    ///  뱃지의 글자를 그리는 label입니다.
    private let label: YDSLabel = {
        let label = YDSLabel(style: .caption1)
        label.textColor = YDSColor.monoItemText
        return label
    }()

    ///  뱃지의 아이콘을 그리는 iconView입니다.
    private let iconView: YDSIconView = {
        let iconView = YDSIconView()
        iconView.tintColor = YDSColor.monoItemText
        iconView.size = .extraSmall
        return iconView
    }()

    // MARK: - 메소드

    public init() {
        super.init(frame: .zero)
        setupViews()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    ///  뷰를 세팅합니다.
    private func setupViews() {
        setProperties()
        setLayouts()

        setText()
        setIcon()
        setColor()
    }

    ///  뷰의 레이아웃을 설정합니다.
    private func setLayouts() {
        setViewHierarchy()
        setAutolayout()
    }

    ///  모서리 곡률을 2로 만듭니다.
    private func setProperties() {
        self.layer.cornerRadius = YDSConstant.Rounding.r2
        self.clipsToBounds = true
    }

    ///  뷰의 위계를 세팅합니다.
    private func setViewHierarchy() {
        self.addSubview(stackView)
        stackView.addArrangedSubview(iconView)
        stackView.addArrangedSubview(label)
    }

    ///  뱃지의 높이를 Dimension.height 으로 설정합니다.
    private func setAutolayout() {
        self.snp.makeConstraints {
            $0.height.equalTo(Dimension.height)
        }

        stackView.snp.makeConstraints {
            $0.top.leading.trailing.bottom.equalToSuperview()
        }
    }

    ///  label의 text를 세팅합니다.
    ///  text가 nil이라면 label을 숨깁니다.
    private func setText() {
        label.isHidden = (text == nil)
        label.text = text
    }

    ///  icon에 관련된 뷰를 세팅합니다.
    private func setIcon() {
        setIconImage()
        setLayoutAccordingToIcon()
    }

    ///  iconView의 icon(image)를 세팅합니다.
    ///  icon이 nil이라면 iconView를 숨깁니다.
    private func setIconImage() {
        iconView.isHidden = (icon == nil)
        iconView.image = icon?.withRenderingMode(.alwaysTemplate)
    }

    ///  icon이 nil인지 아닌지에 따라 stackView의 padding 값을 변경합니다.
    private func setLayoutAccordingToIcon() {
        let padding = (icon != nil)
            ? Dimension.horizontalPadding
            : Dimension.horizontalPaddingWithoutIcon

        stackView.layoutMargins = UIEdgeInsets(top: 0, left: padding, bottom: 0, right: padding)
    }

    ///  badge의 배경 컬러를 설정합니다.
    private func setColor() {
        self.backgroundColor = color.backgroundColor
    }

    public override func layoutSubviews() {
        super.layoutSubviews()

        setText()
        setIcon()
        setColor()
    }
}
