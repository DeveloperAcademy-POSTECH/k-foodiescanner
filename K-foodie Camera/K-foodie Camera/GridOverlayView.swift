//
//  GridOverlayView.swift
//  K-foodie Camera
//
//  Created by 서세린 on 8/26/25.
//

import SwiftUI

struct GridOverlayView: View {
    let rows: Int = 3
    let columns: Int = 3
    let color: Color = .white.opacity(0.4)
    let lineWidth: CGFloat = 1

    var body: some View {
        GeometryReader { geometry in
            let width = geometry.size.width
            let height = geometry.size.height

            Path { path in
                // 세로선
                for i in 1..<columns {
                    let x = width * CGFloat(i) / CGFloat(columns)
                    path.move(to: CGPoint(x: x, y: 0))
                    path.addLine(to: CGPoint(x: x, y: height))
                }

                // 가로선
                for i in 1..<rows {
                    let y = height * CGFloat(i) / CGFloat(rows)
                    path.move(to: CGPoint(x: 0, y: y))
                    path.addLine(to: CGPoint(x: width, y: y))
                }
            }
            .stroke(color, lineWidth: lineWidth)
        }
    }
}
