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

extension DefaultTickMark {
    static var size: CGSize = .defaultTickMarkSize
    static var position: CGFloat = .defaultTickMarkPosition
    static var number: Int = .defaultTickMarkNumber
}

public extension CGSize {
    static let defaultTickMarkSize: CGSize = CGSize(width: 2, height: 6)
}

public extension CGFloat {
    static let defaultTickMarkPosition: CGFloat = 4.5
}

public extension Int {
    static let defaultTickMarkNumber: Int = 5
}

struct DefaultTickMark_Previews: PreviewProvider {
    static var previews: some View {
        DefaultTickMark()
            .previewLayout(.fixed(width: 100, height: 100))
    }
}
