//
//  Animations.swift
//  ElementaryViews
//
//  Created by James Stewart on 4/10/20.
//  Copyright © 2020 James Stewart. All rights reserved.
//

import SwiftUI

struct SimpleTransition: View {
    @State var visible = false
    
    var body: some View {
        VStack {
            Button("Toggle") { self.visible.toggle() }
            if visible {
                Rectangle()
                    .fill(Color.blue)
                    .frame(width: 100, height: 100)
                    .transition(.slide)
                    .animation(.default)
            }
        }
    }
}

/**
 This animation modifier affects any state change of the view not just when `selected` gets toggled.  Not so useful, and could def lead to unexpected behavior under composition.
 */
struct AnimatedButton: View {
    @State var selected: Bool = false
    var body: some View {
        Button(action: { self.selected.toggle() }) {
            RoundedRectangle(cornerRadius: 10)
                .fill(Color.green)
                .frame(width: selected ? 100 : 50, height: 50)
        }.animation(.linear(duration: 5))
    }
}


/**
 When we run the code below on iOS, at ﬁrst, the animation seems to work as expected. But the moment we rotate the simulator (or device), the dot follows a strange path: it deﬁnitely doesn’t animate in a circle anymore. The change in device orientation causes this problem. Because we used an implicit animation, SwiftUI will animate the frame change of the dot (resulting from the device rotation) using the same inﬁnite animation.

 */
struct DotLoadingIndicatorOdd: View {
    @State var appeared = false
    let animation = Animation
    .linear
    .repeatForever(autoreverses: false)
    
    var body: some View {
        Circle()
            .fill(Color.accentColor)
            .frame(width: 5, height: 5)
            .offset(y: -20)
            .rotationEffect(appeared ? Angle.degrees(360) : .zero)
            .animation(animation)
            .onAppear { self.appeared = true }
    }
}

/**
 The solution to this problem is to use an explicit animation — we only want to animate the changes in the view tree that are caused by the change of the self.appeared state property. To do so, we remove the implicit animation and instead wrap our state change in a call to withAnimation (an explicit animation):
 */

struct DotLoadingIndicator: View {
    @State var appeared = false
    let animation = Animation
    .linear
    .repeatForever(autoreverses: false)
    
    var body: some View {
        Circle()
            .fill(Color.accentColor)
            .frame(width: 5, height: 5)
            .offset(y: -20)
            .rotationEffect(appeared ? Angle.degrees(360) : .zero)
            .onAppear {
                withAnimation(self.animation) { self.appeared = true }
            }
    }
}

/**
 Shake animation using a Custom Animation
 */

struct Shake: AnimatableModifier {
    var times: CGFloat = 0
    let amplitude: CGFloat = 10
    var animatableData: CGFloat {
        get { times }
        set { times = newValue }
    }
    
    func body(content: Content) -> some View {
        return content.offset(x: sin(times * .pi * 2) * amplitude)
    }
}

extension View {
    func shake(times: Int) -> some View {
        return modifier(Shake(times: CGFloat(times)))
    }
}

struct ShakeButton: View {
    @State private var taps: Int = 0
    var body: some View {
        Button("Hello") {
            withAnimation(.linear(duration:0.5)) { self.taps += 1 }
        }
        .shake(times: taps * 3)
    }
}


struct Animations: View {
    var body: some View {
        VStack {
            SimpleTransition()
            AnimatedButton()
            Spacer()
            DotLoadingIndicatorOdd()
            Spacer()
            DotLoadingIndicator()
            Spacer()
            ShakeButton()
            Spacer()
        }
    }
}

struct Animations_Previews: PreviewProvider {
    static var previews: some View {
        Animations()
    }
}
