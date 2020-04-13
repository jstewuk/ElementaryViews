//
//  InfiniteLoadingIndicator.swift
//  ElementaryViews
//
//  Created by James Stewart on 4/10/20.
//  Copyright © 2020 James Stewart. All rights reserved.
//

import SwiftUI

/**
 Because animations are driven by state changes, some animations require us to get creative. For example, what if we want to build something like iOS’s built-in activity indicator, in which an image rotates inﬁnitely? We can solve this through the use of a few tricks. First of all, we need some state that we can change to trigger the animation, so we’ll use a Boolean property, which we immediately set to true when the view appears. Second, we need to repeat the animation indeﬁnitely by adding repeatForever to a linear animation. By default, a repeating animation reverses itself every other repeat, but we don’t want that (it would cause the indicator to rotate a full turn and then rotate backward), so we specify autoreverses to be false:

 */

struct InfiniteLoadingIndicator: View {
    @State private var animating = false
    var body: some View {
        Image(systemName: "rays")
            .rotationEffect(animating ? Angle.degrees(360) : .zero)
            .animation(Animation.linear(duration: 2)
                .repeatForever(autoreverses: false)
        )
            .onAppear { self.animating = true }

    }
}

struct InfiniteLoadingIndicator_Previews: PreviewProvider {
    static var previews: some View {
        InfiniteLoadingIndicator()
    }
}
