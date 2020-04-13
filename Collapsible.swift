//
//  Collapsible.swift
//  ElementaryViews
//
//  Created by James Stewart on 4/10/20.
//  Copyright © 2020 James Stewart. All rights reserved.
//

import SwiftUI

/**
 To create the collapsible HStack, we use a regular HStack with a particular frame modiﬁer on each of its children. When the stack is expanded, we set a nil width for the item (i.e. we don’t interfere with the width of the item). When the stack is collapsed, we set a ﬁxed-width frame (to collapsedWidth) on each child except for the last one. It’s also important to explicitly set the horizontal alignment to .leading. Otherwise, the children are centered in their frames by default:
 */

struct Collapsible<Element, Content:View>: View {
    var data: [Element]
    @State var expanded: Bool = false
    var spacing: CGFloat? = 8
    var alignment: VerticalAlignment = .center
    var collapsedWidth: CGFloat = 10
    var content: (Element) -> Content
    
    func child(at index: Int) -> some View {
        let showExpanded = expanded || index == self.data.endIndex - 1
        return content(data[index])
            .frame(width: showExpanded ? nil: collapsedWidth, alignment: Alignment(horizontal: .leading, vertical: alignment))
    }
    
    var body: some View {
        HStack(alignment: alignment, spacing: expanded ? spacing : 0) {
            ForEach(data.indices) { self.child(at: $0) }
        }.onTapGesture {
            self.expanded.toggle()
        }
        .animation(.default)
    }
}

struct CollapsibleDemo: View {
    let colors: [(Color, CGFloat)] = [(.red, 50), (.green, 30), (.blue, 75)]
    var body: some View {
        Collapsible(data: colors) {
            item in
            Rectangle()
            .fill(item.0)
            .frame(width:item.1, height:item.1)
        }
    }
}

struct Collapsible_Previews: PreviewProvider {
    static var previews: some View {
        CollapsibleDemo()
    }
}
