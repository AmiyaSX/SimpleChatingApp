//
//  TabBar.swift
//  FunChat
//
//  Created by iOS 打包机 on 2022/8/7.
//
import SwiftUI


@available(iOS 13.0, *)
struct TabBarItemPreferenceKey: PreferenceKey {
    struct Item: Identifiable {
        let id = UUID()
        let index: Any
        let label: AnyView

        init<V: View>(index: Any, label: V) {
            self.index = index
            self.label = label.embedInAnyView()
        }
    }

    typealias Value = [Item]

    static var defaultValue: [Item] = []

    static func reduce(value: inout [Item], nextValue: () -> [Item]) {
        value.append(contentsOf: nextValue())
    }
}


@available(iOS 13.0, *)
public struct TabBar<SelectionValue, Content>: View where SelectionValue: Hashable, Content: View {
    private let model: TabBarModel<SelectionValue>
    private let content: Content

    public init(selection: Binding<SelectionValue>, @ViewBuilder content: () -> Content) {
        self.model = TabBarModel(selection: selection)
        self.content = content()
    }

    public var body: some View {
        ZStack {
            content
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .padding(.bottom, DisplayUtil.getBottomBarHeight() + 52)
                .environmentObject(model)

            VStack(spacing: 0) {
                Spacer()

                Rectangle()
                    .fill(Color("color_FFE1E3E6"))
                    .frame(height: 0.5)

                Spacer()
                    .frame(height: 52 + DisplayUtil.getBottomBarHeight())
            }
        }
        .overlayPreferenceValue(TabBarItemPreferenceKey.self) { preferences in
            VStack(spacing: 0) {
                Spacer()

                HStack(spacing: 0) {
                    ForEach(preferences) { preference in
                        preference.label
                            .frame(width: UIScreen.main.bounds.width / CGFloat(preferences.count))
                            .onTapGesture {
                                if let i = preference.index as? SelectionValue {
                                    self.model.selection = i
                                }
                            }
                    }
                }
                .frame(height: 52)
//                .padding(.bottom, DisplayUtil.getBottomBarHeight())
                .background(Color.white)
            }
        }
    }
}

@available(iOS 13.0, *)
public extension TabBar where SelectionValue == Int {
    init(@ViewBuilder content: () -> Content) {
        self.model = TabBarModel(selection: .constant(0))
        self.content = content()
    }
}

@available(iOS 13.0, *)
class TabBarModel<SelectionValue: Hashable>: ObservableObject {
    @Binding var selection: SelectionValue

    init(selection: Binding<SelectionValue>) {
        self._selection = selection
    }
}

