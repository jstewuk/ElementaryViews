//
//  TablishView.swift
//  ElementaryViews
//
//  Created by James Stewart on 4/6/20.
//  Copyright © 2020 James Stewart. All rights reserved.
//

import SwiftUI

struct WidthPreference: PreferenceKey {
    static let defaultValue: [Int: CGFloat] = [:]
    static func reduce(value: inout Value, nextValue: () -> Value) {
        value.merge(nextValue(), uniquingKeysWith: max)
    }
}

extension View {
    func widthPreference(column: Int) -> some View {
        background(GeometryReader { proxy in
            Color.clear.preference(key: WidthPreference.self, value: [column: proxy.size.width])
        })
    }
}

struct Table<Cell: View>: View {
    var cells: [[Cell]]
    let padding: CGFloat = 5
    @State private var columnWidths: [Int: CGFloat] = [:]
    
    func cellFor(row: Int, column: Int) -> some View {
        print("cellFor")
        return 
            cells[row][column]
                .widthPreference(column: column)
                .frame(width: columnWidths[column], alignment: .leading)
                .padding(padding)
    }
    
    var body: some View {
        print("body")
        return VStack(alignment: .leading) {
            ForEach(cells.indices) { row in
                HStack(alignment: .top) {
                    ForEach(self.cells[row].indices) { column in
                        self.cellFor(row: row, column: column)
                    }
                }
                .background(row.isMultiple(of: 2) ?
                    Color(.secondarySystemBackground) : Color(.systemBackground))
            }
        }
        .onPreferenceChange(WidthPreference.self) {
            self.columnWidths = $0
        }
    }
}

struct TableView: View {
    var cells = [
        [Text(""), Text("Monday").bold(), Text("Tuesday").bold(), Text("Wednesday").bold() ],
        [Text("Berlin").bold(), Text("Cloudy"), Text("Mostly\nSunny"), Text("Sunny")],
        [Text("London").bold(), Text("Heavy Rain"), Text("Cloudy"), Text("Sunny")]
    ]
    
    var body: some View {
        Table(cells: cells)
            .font(Font.system(.body, design: .serif))
    }
}

struct TablishView: View {
    var body: some View {
        Text(/*@START_MENU_TOKEN@*/"Hello, World!"/*@END_MENU_TOKEN@*/)
    }
}

struct TablishView_Previews: PreviewProvider {
    static var previews: some View {
        TablishView()
    }
}
