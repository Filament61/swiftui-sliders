//
//  DefaultTickMark.swift
//
//
//  Created by Serge GORI on 26/12/2023.
//

import SwiftUI

public struct DefaultTickMark: View {
    public init() {}
    public var body: some View {
        Rectangle()
            .fill(Color.secondary.opacity(0.25))
    }
}

public extension CGSize {
    static let defaultTickMarkSize: CGSize = CGSize(width: 3, height: 6)
}

struct DefaultTickMark_Previews: PreviewProvider {
    static var previews: some View {
        DefaultTickMark()
            .previewLayout(.fixed(width: 100, height: 100))
    }
}
