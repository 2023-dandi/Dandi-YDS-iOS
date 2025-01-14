//
//  LabelPageViewController.swift
//  YDS-Storybook
//
//  Created by Gyuni on 2021/11/21.
//

import SnapKit
import UIKit
import YDS

class LabelPageViewController: StoryBookViewController {

    private let sampleLabel = YDSLabel()

    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        addOptions()
    }

    private func setupView() {
        setViewProperty()
        setViewLayouts()
    }

    private func setViewProperty() {
        title = "Label"
    }

    private func setViewLayouts() {
        setViewHierarchy()
        setAutolayout()
    }

    private func setViewHierarchy() {
        sampleView.addSubviews(sampleLabel)
    }

    private func setAutolayout() {
        sampleLabel.snp.makeConstraints {
            $0.edges.equalToSuperview().inset(16)
        }
    }

    private func addOptions() {
        addOption(description: "text",
                  defaultValue: "Label") { [weak self] value in
            self?.sampleLabel.text = value
        }

        addOption(description: "style",
                  cases: String.TypoStyle.allCases,
                  defaultIndex: 0) { [weak self] value in
            self?.sampleLabel.style = value
        }

        addOption(description: "numberOfLines",
                  defaultValue: 0) { [weak self] value in
            self?.sampleLabel.numberOfLines = value
        }

        addOption(description: "textColor",
                  cases: textColors.items,
                  defaultIndex: 0) { [weak self] colorInfo in
            self?.sampleLabel.textColor = colorInfo.color
        }

        addOption(description: "lineBreakMode",
                  cases: NSLineBreakMode.allCases,
                  defaultIndex: 0) { [weak self] value in
            self?.sampleLabel.lineBreakMode = value
        }

        addOption(description: "alignment",
                  cases: NSTextAlignment.allCases,
                  defaultIndex: 1) { [weak self] value in
            self?.sampleLabel.alignment = value
        }

        if #available(iOS 14.0, *) {
            addOption(description: "lineBreakStrategy",
                      cases: NSParagraphStyle.LineBreakStrategy.allCases,
                      defaultIndex: 2) { [weak self] value in
                self?.sampleLabel.lineBreakStrategy = value
            }
        }
    }

}

extension String.TypoStyle: CaseIterable {
    public static var allCases: [String.TypoStyle] = [.display1, .display2,
                                                      .title1, .title2, .title3,
                                                      .subtitle1, .subtitle2, .subtitle3,
                                                      .body1, .body2,
                                                      .button0, .button1, .button2, .button3, .button4,
                                                      .caption0, .caption1, .caption2]
}

extension NSLineBreakMode: CaseIterable {
    public static var allCases: [NSLineBreakMode] = [.byWordWrapping,
                                                     .byCharWrapping,
                                                     .byClipping,
                                                     .byTruncatingHead,
                                                     .byTruncatingMiddle,
                                                     .byTruncatingTail ]
}

extension NSTextAlignment: CaseIterable {
    public static var allCases: [NSTextAlignment] = [.left,
                                                     .center,
                                                     .right,
                                                     .justified,
                                                     .natural]
}

@available(iOS 14.0, *)
extension NSParagraphStyle.LineBreakStrategy: CaseIterable {
    public static var allCases: [NSParagraphStyle.LineBreakStrategy] = [[],
                                                                        .pushOut,
                                                                        .hangulWordPriority,
                                                                        .standard]
}
