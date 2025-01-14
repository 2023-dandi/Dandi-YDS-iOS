//
//  YDSTooltip.swift
//  YDS
//
//  Created by Yonghyun on 2022/03/26.
//

// swiftlint:disable function_body_length nesting

import UIKit

final public class YDSTooltip: UIView {

    // MARK: - 뷰

    /// 툴팁 내부에서 텍스트를 보여주는 label
    private let label: YDSLabel = {
        let label = YDSLabel(style: .caption0)
        label.textColor = YDSColor.textBright
        label.numberOfLines = 1
        return label
    }()

    // MARK: - 외부에서 지정할 수 없는 속성

    /// 툴팁 내부 label의 텍스트를 설정할 때 사용합니다.
    @SetNeeds(.layout) private var text: String = ""

    /// 툴팁의 색깔을 설정합니다.
    @SetNeeds(.layout) private var color: TooltipColor = .tooltipBG

    /// 툴팁의 꼬리 위치를 설정할 때 사용합니다.
    @SetNeeds(.layout) private var tailPosition: TailPosition = .bottomCenter

    /// 툴팁이 뷰에 유지되는 시간을 설정할 때 사용합니다.
    private var duration: TooltipDuration

    /// 툴팁의 꼬리 부분을 표현하는 Layer
    private var tailLayer: CAShapeLayer = CAShapeLayer()

    ///  화면 전체 영역을 차지하고 사용자의 탭을 확인하는 UIControl
    private lazy var touchControl: UIControl = {
        let control = UIControl()
        control.frame = UIScreen.main.bounds
        return control
    }()

    // MARK: - 메소드

    public init(text: String = "",
                color: TooltipColor = .tooltipBG,
                tailPosition: TailPosition = .bottomRight,
                duration: TooltipDuration = .long) {
        self.text = text
        self.color = color
        self.tailPosition = tailPosition
        self.duration = duration
        super.init(frame: .zero)
        setupView()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    /// 뷰를 세팅합니다.
    private func setupView() {
        setLayouts()
        setProperties()
    }

    /// 레이아웃을 세팅합니다.
    private func setLayouts() {
        setViewHierarchy()
        setAutolayout()
    }

    /// 뷰의 위계를 세팅합니다.
    private func setViewHierarchy() {
        self.addSubview(label)
    }

    /// 뷰의 오토레이아웃을 세팅합니다.
    private func setAutolayout() {
        label.snp.makeConstraints {
            $0.leading.trailing.equalToSuperview().inset(Dimension.Margin.horizontal)
            $0.top.bottom.equalToSuperview().inset(Dimension.Margin.vertical)
        }
    }

    /// 뷰의 프로퍼티를 세팅합니다.
    private func setProperties() {
        self.layer.cornerRadius = 8
        self.alpha = 0.0
        self.layer.insertSublayer(tailLayer, at: 0)
    }

    public override func layoutSubviews() {
        super.layoutSubviews()
        label.text = text
        backgroundColor = (color == .tooltipBG) ? (YDSColor.tooltipBG) : (YDSColor.tooltipPoint)
        makeTail()
    }

    /// 툴팁의 꼬리 부분을 그립니다.
    private func makeTail() {
        let path = UIBezierPath()

        let frameWidth = frame.size.width
        let frameHeight = frame.size.height

        switch tailPosition {
        case .left, .right:
            let point1 = CGPoint(x: (tailPosition == .left) ? (0) : (frameWidth),
                                 y: Dimension.Tail.start)
            let point2 = CGPoint(x: (tailPosition == .left)
                                    ? (point1.x - Dimension.Tail.height)
                                    : (point1.x + Dimension.Tail.height),
                                 y: point1.y + Dimension.Tail.width/2)
            let point3 = CGPoint(x: point1.x,
                                 y: point1.y + Dimension.Tail.width)
            path.move(to: point1)
            path.addLine(to: point2)
            path.addLine(to: point3)

        case .topLeft, .bottomLeft:
            let point1 = CGPoint(x: Dimension.Tail.start,
                                 y: (tailPosition == .topLeft) ? (0) : (frameHeight))
            let point2 = CGPoint(x: point1.x + Dimension.Tail.width/2,
                                 y: (tailPosition == .topLeft)
                                    ? (-Dimension.Tail.height)
                                    : (point1.y + Dimension.Tail.height))
            let point3 = CGPoint(x: point1.x + Dimension.Tail.width,
                                 y: point1.y)
            path.move(to: point1)
            path.addLine(to: point2)
            path.addLine(to: point3)

        case .topCenter, .bottomCenter:
            let point1 = CGPoint(x: frameWidth/2 - Dimension.Tail.width/2,
                                 y: (tailPosition == .topCenter) ? (0) : (frameHeight))
            let point2 = CGPoint(x: point1.x + Dimension.Tail.width/2,
                                 y: (tailPosition == .topCenter)
                                    ? (-Dimension.Tail.height)
                                    : (point1.y + Dimension.Tail.height))
            let point3 = CGPoint(x: point1.x + Dimension.Tail.width,
                                 y: point1.y)
            path.move(to: point1)
            path.addLine(to: point2)
            path.addLine(to: point3)

        case .topRight, .bottomRight:
            let point1 = CGPoint(x: frameWidth - Dimension.Tail.start,
                                 y: (tailPosition == .topRight) ? (0) : (frameHeight))
            let point2 = CGPoint(x: point1.x - Dimension.Tail.width/2,
                                 y: (tailPosition == .topRight)
                                    ? (-Dimension.Tail.height)
                                    : (point1.y + Dimension.Tail.height))
            let point3 = CGPoint(x: point1.x - Dimension.Tail.width,
                                 y: point1.y)
            path.move(to: point1)
            path.addLine(to: point2)
            path.addLine(to: point3)
        }
        path.close()

        tailLayer.path = path.cgPath
        tailLayer.fillColor = (color == .tooltipBG) ? (YDSColor.tooltipBG.cgColor) : (YDSColor.tooltipPoint.cgColor)
    }

    /// 애니메이션으로 툴팁이 뷰에 보여지고 지정된 duration 동안 유지된 후 사라지게 합니다.
    public func show() {
        guard let superView = self.superview else { return }
        self.addTouchControl(on: superView)

        UIView.animate(withDuration: YDSAnimation.Duration.medium,
                       animations: { self.alpha = 1.0 },
                       completion: { [weak self] _ in
            DispatchQueue.main.asyncAfter(deadline: .now() + (self?.duration.value ?? 1.5),
                                          execute: {
                self?.hide()
            })
        })
    }

    /// 화면 전체 영역을 차지하고 tap을 확인할 수 있는 UIControl을 추가합니다.
    private func addTouchControl(on superView: UIView) {
        superview?.addSubview(touchControl)
        touchControl.addTarget(self, action: #selector(didTapOnScreen), for: .touchDown)
    }

    /// 툴팁을 뷰에서 없애줍니다.
    private func hide() {
        UIView.animate(withDuration: YDSAnimation.Duration.medium,
                       animations: { self.alpha = 0 },
                       completion: { [weak self] _ in
            self?.touchControl.removeFromSuperview()
            self?.removeFromSuperview()
        })
    }

    /// 사용자가 뷰를 탭하면 hide()를 호출해서 툴팁을 뷰에서 없앱니다.
    @objc private func didTapOnScreen() {
        self.hide()
    }

    // MARK: - 외부에서 접근할 수 없는 enum

    private enum Dimension {
        ///  툴팁 내부에 있는 label의 마진 값입니다.
        enum Margin {
            static let horizontal: CGFloat = 16
            static let vertical: CGFloat = 12
        }

        /// 툴팁의 꼬리 너비, 높이, 시작점 값입니다.
        enum Tail {
            static let width: CGFloat = 16
            static let height: CGFloat = 9
            static let start: CGFloat = 12
        }
    }

    // MARK: - 외부에서 접근할 수 있는 enum

    /// 툴팁의 꼬리 위치 종류입니다.
    public enum TailPosition {
        case left, right
        case topLeft, bottomLeft
        case topCenter, bottomCenter
        case topRight, bottomRight
    }

    /// 툴팁 색깔입니다.
    public enum TooltipColor {
        case tooltipBG
        case tooltipPoint
    }

    /// 툴팁이 유지되는 시간입니다.
    public enum TooltipDuration {
        case short
        case long

        fileprivate var value: Double {
            switch self {
            case .short:
                return 1.5
            case .long:
                return 3
            }
        }
    }
}
