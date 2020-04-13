//
//  ContentView.swift
//  ElementaryViews
//
//  Created by James Stewart on 4/5/20.
//  Copyright © 2020 James Stewart. All rights reserved.
//

import SwiftUI


struct MeasureBehavior<Content: View>: View {
    @State private var width: CGFloat = 100
    @State private var height: CGFloat = 100
    
    var content: Content
    
    var body: some View {
        VStack {
            content
                .border(Color.gray)
                .frame(width: width, height: height)
                .border(Color.black)
            Slider(value: $width, in: 0...500) { Text("Width") }
            Slider(value: $height, in: 0...200) { Text("Height") }
        }
    }
}

struct TrianglePath: View {
    var body: some View {
        Path { p in
            p.move(to: CGPoint(x: 50, y: 0))
            p.addLines([
                CGPoint(x: 100, y: 75),
                CGPoint(x: 0, y: 75),
                CGPoint(x: 50, y: 0)
            ])
        }
    }
}

struct TriangleShape: Shape {
    func path(in rect: CGRect) -> Path {
        return Path { p in
            p.move(to: CGPoint(x: rect.midX, y: rect.minY))
            p.addLines([
                CGPoint(x: rect.maxX, y: rect.maxY),
                CGPoint(x: rect.minX, y: rect.maxY),
                CGPoint(x: rect.midX, y: rect.minY)
            ])
        }
    }
}

/** # Preference Key */
struct WidthKey: PreferenceKey {
    static let defaultValue: CGFloat? = nil
    static func reduce(value: inout CGFloat?,
                       nextValue:()->CGFloat?) {
        value = value ?? nextValue()
    }
}

struct TextWithCircle: View {
    @State private var width: CGFloat? = nil
    var text: String? = nil
    var body: some View {
        Text(text ?? "Hello, world")
        .padding()
            .background(GeometryReader { proxy in
                Color.clear.preference(key: WidthKey.self, value: proxy.size.width)
            })
            .onPreferenceChange(WidthKey.self) {
                self.width = $0
            }
        .frame(width: width, height: width)
        .background(Circle().fill(Color.blue))
    }
}

/** Anchrors */

struct BoundsKey: PreferenceKey {
    static var defaultValue: Anchor<CGRect>? = nil
    static func reduce(value: inout Anchor<CGRect>?, nextValue: () -> Anchor<CGRect>?) {
        value = value ?? nextValue()
    }
}

struct TabView: View {
    let tabs: [Text] = [
    Text("World Clock"),
    Text("Alarm"),
    Text("Bedtime")
    ]
    
    @State var selectedTabIndex = 0
    
    var body: some View {
        HStack {
            ForEach(tabs.indices) { tabIndex in
                Button(
                    action: {
                        self.selectedTabIndex = tabIndex
                },
                    label: { self.tabs[tabIndex] }
                )
                .anchorPreference(
                    key: BoundsKey.self,
                    value: .bounds,
                    transform: { anchor in
                        self.selectedTabIndex == tabIndex ? anchor : nil
                        
                })
                .overlayPreferenceValue(BoundsKey.self, { anchor in
                    if anchor != nil {
                        GeometryReader { proxy in
                            Rectangle()
                                .fill(Color.accentColor)
                                .frame(width: proxy[anchor!].width, height: 2)
                                .offset(x: proxy[anchor!].minX)
                                .frame(width: proxy.size.width,
                                       height: proxy.size.height,
                                       alignment: .bottomLeading)
                                .animation(.default)
                        }
                    }
                })
            }
        }
    }
    
//    func proxyAnchorFixer(proxy: GeometryProxy, anchor: Anchor<CGRect?>?) -> CGRect {
//        if let anchor = anchor {
//            return anchor
//        }
//    }
}


struct ContentView: View {
    var body: some View {
        //MeasureBehavior(content: TriangleShape())
        //TextWithCircle(text: "Free me")
        //TabView()
        //CustomLayoutView()
        //TableView()
        CollapsibleDemo()
    }
}


struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
