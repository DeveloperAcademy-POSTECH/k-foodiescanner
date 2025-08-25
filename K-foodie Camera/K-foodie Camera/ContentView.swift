//
//  ContentView.swift
//  K-foodie Camera
//
//  Created by Libby on 8/25/25.
//

import SwiftUI
import UIKit

// SwiftUI 뷰
struct ContentView: View {
    @State private var navigateToCamera = false
    @State private var image: UIImage?
    
    var body: some View {
        NavigationStack {
            VStack {
                if let image = image {
                    Image(uiImage: image)
                        .resizable()
                        .scaledToFit()
                        .frame(height: 300)
                } else {
                    Text("아직 사진이 없습니다 📷")
                }
                
                Button("카메라 열기") {
                    navigateToCamera = true
                }
                .padding()
            }
            .navigationDestination(isPresented: $navigateToCamera) {
                CameraScreen(image: $image)
            }
        }
    }
}

#Preview("사진 없음") {
    // 버튼/레이아웃만 확인하는 프리뷰 (빈 상태)
    ContentView()
}

#Preview("사진 있는 상태(모의)") {
    // 프리뷰에서는 카메라를 실제로 못 열기 때문에,
    // 가짜 이미지를 주입해서 화면 모양을 확인합니다.
    ContentViewWithMockImage()
}

/// 프리뷰용 헬퍼: ContentView에 임의 이미지를 주입
private struct ContentViewWithMockImage: View {
    @State private var mockImage: UIImage? = {
        // 간단히 SF Symbol을 UIImage로 만들기 (자산 없이 동작)
        let config = UIImage.SymbolConfiguration(pointSize: 160, weight: .regular)
        let img = UIImage(systemName: "photo", withConfiguration: config)?
            .withTintColor(.systemGray, renderingMode: .alwaysOriginal)
        return img
    }()

    var body: some View {
        ContentView(image: mockImage) // 아래 init 확장 사용
    }
}

// ContentView에 프리뷰 편의를 위한 init 확장 (실제 앱 동작엔 영향 없음)
extension ContentView {
    init(image: UIImage?) {
        _navigateToCamera = State(initialValue: false)
        _image = State(initialValue: image)
    }
}
