//
//  Style.swift
//  TicTacToad
//
//  Created by Andrew Shepard on 6/28/16.
//  Copyright © 2016 Andrew Shepard. All rights reserved.
//


struct Style {
    struct Colors {
        static let background = Color.hexColor("#323845")
        static let button = Color.hexColor("#E3F09B")
        static let text = Color.hexColor("#323845")

        static let orange = Color.hexColor("#EF946C")
        static let blue = Color.hexColor("#00FCDB")
    }

    struct Font {
        static let piece = (name: "MarkerFelt-Wide", size: 24.0)
        static let debug = (name: "Helvetica", size: 12.0)
    }
}
