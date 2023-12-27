//
//  DefaultMarker.swift
//
//
//  Created by Serge GORI on 22/12/2023.
//

import SwiftUI

public struct DefaultMarker: View {
    public init() {}
    public var body: some View {
        Rectangle()
            .fill(Color.secondary.opacity(0.25))
//            .shadow(color: Color.black.opacity(0.3), radius: 2, x: 0, y: 1.5)
    }
}

public extension CGSize {
    static let defaultMarkerSize: CGSize = CGSize(width: 2, height: 22)
//    static let defaultMarkerInteractiveSize : CGSize = CGSize(width: 44, height: 44)
}

struct DefaultMarker_Previews: PreviewProvider {
    static var previews: some View {
        DefaultMarker()
            .previewLayout(.fixed(width: 100, height: 100))
    }
}
