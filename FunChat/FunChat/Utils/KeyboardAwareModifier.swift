//
//  KeyboardAwareModifier.swift
//  FunChat
//
//  Created by iOS 打包机 on 2022/7/23.
//

import Foundation
import Combine
import SwiftUI

public struct KeyboardAwareModifier: ViewModifier {
    @State private var keyboardHeight: CGFloat = 0
    @Binding var isKeyboardShow: Bool
    public let keyboardAwareChangeProperty: KeyboardAwareChangeProperty
    
    private var keyboardHeightPublisher: AnyPublisher<CGFloat, Never> {
        Publishers.Merge(
            NotificationCenter.default
                .publisher(for: UIResponder.keyboardWillShowNotification)
                .compactMap{
                    $0.userInfo?[UIResponder.keyboardFrameEndUserInfoKey]
                    as? NSValue
                }
                .map {$0.cgRectValue}
                .map {$0.height},
            NotificationCenter.default
                .publisher(for: UIResponder.keyboardWillHideNotification)
                .map { _ in CGFloat(0) }
        ).eraseToAnyPublisher()
    }
    
    public func body(content: Content) -> some View {
        content
            .vIf(keyboardAwareChangeProperty == .paddingBottom, apply: { c in
                c.padding(.bottom, keyboardHeight)
            })
            .vIf(keyboardAwareChangeProperty == .offsetY, apply: { c in
                c.offset(y: -keyboardHeight)
            })
            .onReceive(keyboardHeightPublisher) { height in
                isKeyboardShow = height > 0
                withAnimation(.easeOut(duration: 0.2)) {
                    keyboardHeight = height
                }
            }
    }
}
public enum KeyboardAwareChangeProperty {
    case paddingBottom
    case offsetY
}
