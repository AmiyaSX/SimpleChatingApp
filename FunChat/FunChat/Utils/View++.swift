//
//  View++.swift
//  FunChat
//
//  Created by iOS 打包机 on 2022/7/24.
//

import Foundation
import SwiftUI
import UIKit
import Combine

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
    
  
    func tabBarItem<I: Hashable, V: View>(_ index: I, @ViewBuilder _ label: () -> V) -> some View {
        modifier(TabBarItemModifier(index: index, label: label()))
    }
    
    /// Wraps view inside `AnyView`
    func embedInAnyView() -> AnyView {
        AnyView(self)
    }
    
    /// Hide or show the view based on a boolean value.
    ///
    /// Example for visibility:
    ///
    ///     Text("Label")
    ///         .isHidden(true)
    ///
    /// Example for complete removal:
    ///
    ///     Text("Label")
    ///         .isHidden(true, remove: true)
    ///
    /// - Parameters:
    ///   - hidden: Set to `false` to show the view. Set to `true` to hide the view.
    ///   - remove: Boolean value indicating whether or not to remove the view.
    @ViewBuilder
    func isHidden(_ hidden: Bool, remove: Bool = false) -> some View {
        if hidden {
            if !remove {
                self.hidden()
            } else {
                EmptyView()
            }
        } else {
            self
        }
    }
    
    /// Hide keyboard when tap outside the TextField
    func hideKeyboard() {
        UIApplication.shared.sendAction(
            #selector(UIResponder.resignFirstResponder),
            to: nil,
            from: nil,
            for: nil
        )
    }

}

@available(iOS 13.0, *)
struct TabBarItemModifier<SelectionValue: Hashable, Label: View>: ViewModifier {
    var index: SelectionValue
    var label: Label

    func body(content: Content) -> some View {
        content.opacity(index == model.selection ? 1 : 0)
            .preference(key: TabBarItemPreferenceKey.self, value: [.init(index: index, label: label.embedInAnyView())])
    }

    @EnvironmentObject var model: TabBarModel<SelectionValue>
}


extension UIView {
    
    /// Hide keyboard when tap outside the TextField
    @objc func hideKeyboard() {
        UIApplication.shared.sendAction(
            #selector(UIResponder.resignFirstResponder),
            to: nil,
            from: nil,
            for: nil
        )
    }

    /// Load the view from nib (xib) file.
    static func loadFromNib(bundle: Bundle? = nil) -> Self {
        let named = String(describing: Self.self)
        guard
            let view = UINib(nibName: named, bundle: bundle)
                .instantiate(withOwner: nil, options: nil)
                .first as? Self
        else {
            fatalError("First element in xib file \(named) is not of type \(named)")
        }
        
        return view
    }
    
    var snapshot: UIImage {
        let renderer = UIGraphicsImageRenderer(size: bounds.size)
        return renderer.image { [weak self] _ in
            self?.drawHierarchy(in: bounds, afterScreenUpdates: true)
        }
    }

    /// 添加圆角 draw 圆角失效 UILabel 不建议使用
    /// - Parameters:
    ///   - corners: 圆角的脚边
    ///   - cornerRadius: 大小
    func addLayerCornerRadius(
        _ corners: CACornerMask = [.layerMinXMaxYCorner, .layerMinXMinYCorner, .layerMaxXMinYCorner, .layerMaxXMaxYCorner],
        cornerRadius: CGFloat
    ) {
        if self is UILabel {
            layer.masksToBounds = true
        }
        layer.cornerRadius = cornerRadius
        layer.maskedCorners = corners
    }
    
    /// View 添加 border 样式
    /// - Parameters:
    ///   - borderWidth: 宽度
    ///   - borderColor: 颜色
    func layerBorderStyles(with borderWidth: CGFloat, borderColor: UIColor?) {
        layer.borderWidth = borderWidth
        if let bColor = borderColor {
            layer.borderColor = bColor.cgColor
        }
    }

    /// 添加阴影
    func addLayerShadowPath(
        cornerRadius: CGFloat,
        shadowOffset: CGSize = CGSize(width: 0, height: 2),
        shadowOpacity: Float = 0.2,
        shadowRadius: CGFloat = 2.0,
        shadowColor: UIColor = UIColor.black
    ) {
        addLayerShadowPath(
            cornerRadius: cornerRadius,
            rect: bounds,
            shadowOffset: shadowOffset,
            shadowOpacity: shadowOpacity,
            shadowRadius: shadowRadius,
            shadowColor: shadowColor,
            path: nil
        )
    }
    
    /// 添加阴影
    /// - Parameters:
    ///   - cornerRadius: 弧度
    ///   - rect: CGRect
    ///   - shadowOffset: // width -> x height -> y
    ///   - shadowOpacity: 阴影透明度
    ///   - shadowRadius: 阴影范围
    ///   - shadowColor: 颜色
    ///   - corners: 圆角
    ///   - path: 路径
    func addLayerShadowPath(
        cornerRadius: CGFloat,
        rect: CGRect,
        shadowOffset: CGSize = CGSize(width: 0, height: 2),
        shadowOpacity: Float = 0.2,
        shadowRadius: CGFloat = 2.0,
        shadowColor: UIColor = UIColor.black,
        corners: UIRectCorner? = nil,
        path: UIBezierPath? = nil
    ) {
        let shadowPath: UIBezierPath
        if let `path` = path {
            shadowPath = path
        } else {
            if let `corners` = corners, cornerRadius != 0 {
                shadowPath = UIBezierPath(roundedRect: rect, byRoundingCorners: corners, cornerRadii: CGSize(width: cornerRadius, height: cornerRadius))
            } else if cornerRadius != 0 {
                shadowPath = UIBezierPath(roundedRect: rect, cornerRadius: cornerRadius)
            } else {
                shadowPath = UIBezierPath(rect: rect)
            }
        }
        
        layer.shadowColor = shadowColor.cgColor
        layer.shadowOffset = shadowOffset
        layer.shadowOpacity = shadowOpacity
        layer.shadowRadius = shadowRadius
        layer.shadowPath = shadowPath.cgPath
    }
}
