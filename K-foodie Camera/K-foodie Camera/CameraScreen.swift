// CameraScreen.swift
// K-foodie Camera
//
// A new SwiftUI screen that wraps ImagePicker for camera use.

import SwiftUI
import UIKit

// UIKit의 UIImagePickerController를 SwiftUI에서 쓰기 위한 래퍼
struct ImagePicker: UIViewControllerRepresentable {
    @Environment(\.presentationMode) var presentationMode
    @Binding var selectedImage: UIImage?
    var sourceType: UIImagePickerController.SourceType = .camera
    
    func makeUIViewController(context: Context) -> UIImagePickerController {
        let picker = UIImagePickerController()
//        picker.cameraFlashMode = .off
        picker.sourceType = sourceType
        picker.delegate = context.coordinator
        return picker
    }
    
    func updateUIViewController(_ uiViewController: UIImagePickerController, context: Context) {}
    
    func makeCoordinator() -> Coordinator {
        return Coordinator(self)
    }
    
    class Coordinator: NSObject, UINavigationControllerDelegate, UIImagePickerControllerDelegate {
        let parent: ImagePicker
        
        init(_ parent: ImagePicker) {
            self.parent = parent
        }
        
        func imagePickerController(_ picker: UIImagePickerController,
                                   didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
            if let image = info[.originalImage] as? UIImage {
                parent.selectedImage = image
            }
            parent.presentationMode.wrappedValue.dismiss()
        }
    }
}

// 카메라 화면 SwiftUI 뷰
struct CameraScreen: View {
    @Binding var image: UIImage?
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        ZStack {
            // 1. 카메라 프리뷰 배경
            ImagePicker(selectedImage: $image, sourceType: .camera)
                .ignoresSafeArea()
                .onChange(of: image) { _, newValue in
                    if newValue != nil {
                        dismiss()
                    }
                }

            // 2. 상단 안내 배너
            VStack {
                // 상단 전체 폭을 덮는 반투명 배너 (텍스트 뒤 배경 포함)
                HStack {
                    Text("Click highlighted area for the menu’s description")
                        .foregroundColor(.white)
                        .font(.system(size: 15, weight: .medium))
                        .multilineTextAlignment(.center)
                        .frame(maxWidth: .infinity, alignment: .center)
                        .padding(.vertical, 8)
                        .background(
                                    Color.blue.opacity(0.6) // 텍스트 뒤 배경 박스
                                )
                }
                .background(
                    RoundedRectangle(cornerRadius: 8)
                        .fill(Color.black.opacity(0.6))
                )
                .padding(.horizontal, 8)
                .padding(.top, 40)

                Spacer()
            }
            .ignoresSafeArea(edges: .top)
        }
    }
}

#Preview("카메라 프리뷰 (모의)") {
    CameraScreenPreviewHelper()
}

private struct CameraScreenPreviewHelper: View {
    @State private var mockImage: UIImage? = nil // 초기엔 nil 상태
    var body: some View {
        CameraScreen(image: $mockImage)
    }
}

// This provides a preview environment for CameraScreen.

