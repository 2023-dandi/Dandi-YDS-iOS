//
//  YDSSearchTextField.swift
//  YDS-iOS
//
//  Created by Gyuni on 2021/07/20.
//

import UIKit

/**
 돋보기가 붙은 TextField입니다.
 */
public class YDSSearchTextField: UITextField {

    // MARK: - 외부에서 지정할 수 있는 속성

    ///  필드를 비활성화 시킬 때 사용합니다.
    @SetNeeds(.layout, .display) public var isDisabled: Bool = false

    ///  새 값이 들어오면 setPlaceholderTextColor를 이용해
    ///  적절한 값을 가진 attributedPlaceholder로 변환합니다.
    public override var placeholder: String? {
        didSet { setNeedsDisplay() }
    }

    // MARK: - 내부에서 사용되는 상수

    ///  필드 높이입니다.
    private static let textFieldHeight: CGFloat = 38

    ///  searchIcon의 너비입니다.
    private var searchIconWidth: CGFloat {
        return searchIcon.frame.width
    }

    ///  clearButton의 너비입니다.
    private var clearButtonWidth: CGFloat {
        return clearButtonRect(forBounds: bounds).width
    }

    // MARK: - 뷰

    ///  필드 왼쪽에 나타나는 searchIcon입니다.
    private let searchIcon: YDSIconView = {
        let icon = YDSIconView()
        icon.image = YDSIcon.searchLine.withRenderingMode(.alwaysTemplate)
        icon.tintColor = YDSColor.textSecondary
        icon.size = .extraSmall
        return icon
    }()

    // MARK: - 메소드
    public init() {
        super.init(frame: .zero)
        setupView()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    ///  view를 세팅합니다.
    private func setupView() {
        self.font = YDSFont.body2
        self.tintColor = YDSColor.textPointed
        self.clearButtonMode = .whileEditing

        self.addSubview(searchIcon)
        searchIcon.snp.makeConstraints {
            $0.leading.equalToSuperview().offset(YDSTextField.Dimension.leftMargin)
            $0.centerY.equalToSuperview()
        }

        self.clipsToBounds = true
        self.layer.cornerRadius = YDSConstant.Rounding.r8
        self.backgroundColor = YDSColor.inputFieldElevated

        self.snp.makeConstraints {
            $0.height.equalTo(YDSSearchTextField.textFieldHeight)
        }

        setState()
    }

    ///  필드의 상태를 세팅합니다.
    ///  우선순위는 isDisabled > isNegative > isPositive 입니다.
    private func setState() {
        if isDisabled {
            self.isEnabled = false
            self.textColor = YDSColor.textDisabled
            self.searchIcon.tintColor = YDSColor.textDisabled
            self.layer.borderWidth = 0
            self.layer.borderColor = nil
            return
        }

        self.isEnabled = true
        self.textColor = YDSColor.textSecondary
        self.searchIcon.tintColor = YDSColor.textSecondary
        self.layer.borderWidth = 0
        self.layer.borderColor = nil
    }

    ///  isDisabled의 값에 따라 placeholder label의 색이 달라집니다.
    private func setPlaceholderTextColor() {
        let placeholderTextColor: UIColor

        if self.isDisabled {
            placeholderTextColor = YDSColor.textDisabled
        } else {
            placeholderTextColor = YDSColor.textTertiary
        }

        if let text = placeholder {
            attributedPlaceholder = NSAttributedString(
                string: text,
                attributes: [NSAttributedString.Key.foregroundColor: placeholderTextColor]
            )
        }
    }

    ///  clearButton의 Bound에 관한 함수입니다.
    ///  clearButton 우측 마진을 주기 위해 사용합니다.
    public override func clearButtonRect(forBounds bounds: CGRect) -> CGRect {
        let rect = super.clearButtonRect(forBounds: bounds)
        return rect.offsetBy(dx: -(YDSTextField.Dimension.rightMargin
                                   - YDSTextField.Dimension.clearButtonDefaultRightMargin),
                             dy: 0
        )
    }

    ///  textRect의 Bound에 관한 함수입니다.
    ///  placeholder label의 너비를 설정하기 위해 사용합니다.
    public override func textRect(forBounds bounds: CGRect) -> CGRect {

        return bounds.inset(by: UIEdgeInsets(top: 0,
                                             left: (YDSTextField.Dimension.leftMargin
                                                    + self.searchIconWidth
                                                    + YDSTextField.Dimension.subviewSpacing),
                                             bottom: 0,
                                             right: (YDSTextField.Dimension.rightMargin
                                                     + self.clearButtonWidth
                                                     + YDSTextField.Dimension.subviewSpacing)
        ))
    }

    ///  editingRect의 Bound에 관한 함수입니다.
    ///  text label의 너비를 설정하기 위해 사용합니다.
    public override func editingRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.inset(by: UIEdgeInsets(top: 0,
                                             left: (YDSTextField.Dimension.leftMargin
                                                    + self.searchIconWidth
                                                    + YDSTextField.Dimension.subviewSpacing),
                                             bottom: 0,
                                             right: (YDSTextField.Dimension.rightMargin
                                                     + self.clearButtonWidth
                                                     + YDSTextField.Dimension.subviewSpacing)
        ))
    }

    public override func layoutSubviews() {
        super.layoutSubviews()

        setState()
    }

    public override func draw(_ rect: CGRect) {
        super.draw(rect)

        setPlaceholderTextColor()
    }
}
