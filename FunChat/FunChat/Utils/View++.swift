//
//  View++.swift
//  FunChat
//
//  Created by iOS 打包机 on 2022/7/24.
//

import Foundation
import SwiftUI

public extension View {
    
    func keyboardAwarePadding(isKeyboardShow: Binding<Bool>) -> some View {
        ModifiedContent(content: self, modifier: KeyboardAwareModifier(isKeyboardShow: isKeyboardShow, keyboardAwareChangeProperty: .paddingBottom))
    }
    
    @ViewBuilder
    func vIf<T: View>(_ condition: Bool, apply: (Self) -> T) -> some View {
        if condition {
            apply(self)
        } else {
            self
        }
    }

}
