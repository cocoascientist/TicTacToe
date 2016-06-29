//
//  GlyphNode.swift
//  TicTacToad
//
//  Created by Andrew Shepard on 6/24/16.
//  Copyright © 2016 Andrew Shepard. All rights reserved.
//

import SpriteKit
import CoreText

class GlyphNode: SKShapeNode {
    let glyph: String
    
    lazy var font: Font = {
        guard let font = Font(name: "MarkerFelt-Wide", size: 96.0) else {
            fatalError("missing font")
        }
        
        return font
    }()
    
    init(glyph: String) {
        self.glyph = glyph
        
        super.init()

        configure()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    lazy var glyphPath: CGPath? = {
        guard self.glyph.characters.count > 0 else { return nil }
        
        var unichars = [UniChar](self.glyph.utf16)
        var glyphs = [CGGlyph](count: unichars.count, repeatedValue: 0)
        let foundGlyphs = CTFontGetGlyphsForCharacters(self.font, &unichars, &glyphs, unichars.count)
        
        guard foundGlyphs else { return nil }
        
        let path = CTFontCreatePathForGlyph(self.font, glyphs[0], nil)!
        return path
    }()
}

extension GlyphNode {
    private func configure() {
        self.path = glyphPath
    }
}
