//
//  TextFieldSampleViewModel.swift
//  YDS-Storybook
//
//  Created by Gyuni on 2021/10/02.
//

import Foundation
import RxSwift

class TextFieldSampleViewModel {
    
    //  MARK: - DisposeBag
    private let bag = DisposeBag()
    
    //  MARK: - INPUT
    func confirmButtonDidTap() {
        textFieldShoudShakeWithHaptic.onNext(true)
        textFieldIsNegative.onNext(true)
        confirmButtonIsDisabled.onNext(true)
        shouldShowToastMessage.onNext(true)
    }
    
    func textFieldEditingChanged(text: String?) {
        self.text.onNext(text)
    }
    
    //  MARK: - OUTPUT
    let confirmButtonIsDisabled = BehaviorSubject<Bool>(value: true)
    let textFieldIsPositive = BehaviorSubject<Bool>(value: false)
    let textFieldIsNegative = BehaviorSubject<Bool>(value: false)
    let textFieldShoudShake = PublishSubject<Bool>()
    let textFieldShoudShakeWithHaptic = PublishSubject<Bool>()
    let shouldShowToastMessage = PublishSubject<Bool>()
    
    //  MARK: - Private Observable
    private let text = PublishSubject<String?>()
    
    //  MARK: - Init
    init() {
        bind()
    }
    
    //  MARK: - Func
    private func bind() {
        text
            .debounce(.milliseconds(300), scheduler: MainScheduler.instance)
            .subscribe(onNext: { text in
                self.textDidChanged(to: text)
            })
            .disposed(by: bag)
    }
    
    private func textDidChanged(to text: String?) {
        let isValid = self.checkIsValidNickname(text)
        textFieldIsPositive.onNext(isValid)
        textFieldIsNegative.onNext(!isValid)
        confirmButtonIsDisabled.onNext(!isValid)
    }
    
    private func checkIsValidNickname(_ nickname: String?) -> Bool {
        if let nickname = nickname {
            return NSPredicate(format: "SELF MATCHES %@",
                               nicknameRegEx)
                .evaluate(with: nickname.trimmingCharacters(in: .whitespaces))
        } else {
            return false
        }
    }
    
    //  MARK: - Constant
    private let nicknameRegEx = "[A-Za-z|가-힣|ㄱ-ㅎ|ㅏ-ㅣ\\d\\s]{2,12}$"
}