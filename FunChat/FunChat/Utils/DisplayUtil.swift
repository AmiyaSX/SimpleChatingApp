//
//  DisplayUtil.swift
//  FunChat
//
//  Created by iOS 打包机 on 2022/7/23.
//

import Foundation
import UIKit

class DisplayUtil {
    private static var statusBarHeight: CGFloat = 0
    private static var bottomBarHeight: CGFloat = 0
    
    public static func getKeyWindow() -> UIWindow? {
        return UIApplication.shared.windows.filter {
            $0.isKeyWindow
        }.first
    }
    
    public static func getScreenWidth() -> CGFloat {
        return UIScreen.main.bounds.width
    }
    public static func getScreenHeight() -> CGFloat {
        return UIScreen.main.bounds.height
    }
    
    public static func getStatusBarHight() -> CGFloat {
        guard statusBarHeight <= 0 else {
            return statusBarHeight
        }
        statusBarHeight = getKeyWindow()?.windowScene?.statusBarManager?.statusBarFrame.height ?? 0
        return statusBarHeight
    }
    
    public static func getBottomBarHeight() -> CGFloat {
        guard bottomBarHeight <= 0 else {
            return bottomBarHeight
        }
        bottomBarHeight = getKeyWindow()?.safeAreaInsets.bottom ?? 0
        return bottomBarHeight
    }
    
}
