//
//  ContentView.swift
//  KFoodieScanner
//
//  Created by 서세린 on 8/7/25.
//

import SwiftUI

struct ContentView: View {
    @State private var givenName: String = ""
    @State private var resultText: String = "Result will be ready."
    @State private var isLoading: Bool = false

    var body: some View {
        VStack(spacing: 20) {
            TextField("please insert a menu in korean", text: $givenName)
                .textFieldStyle(.roundedBorder)
                .padding(.horizontal)
                .disableAutocorrection(true)

            Button {
                isLoading = true

                // ✅ 환경 변수에서 API Key 확인
                if let apiKey = Bundle.main.infoDictionary?["GEMINI_API_KEY"] as? String {
                    print("🔑 Loaded API Key: \(apiKey)")
                } else {
                    print("❌ API Key not found in Info.plist")
                }

                // 📝 프롬프트 구성
                let prompt = """
                Translate the following Korean dish name into a one-sentenced English description that explains its ingredients and how it is cooked.
                
                Input: \(givenName)
                Output:
                """

                callGeminiAPI(prompt: prompt) { response in
                    DispatchQueue.main.async {
                        isLoading = false
                        resultText = response ?? "응답을 받아오지 못했습니다."
                    }
                }
            } label: {
                Text("press")
                    .padding()
            }

            if isLoading {
                ProgressView()
            } else {
                ScrollView {
                    Text(resultText)
                        .padding()
                        .frame(maxWidth: .infinity, alignment: .leading)
                }
                .background(Color.gray.opacity(0.1))
                .cornerRadius(8)
                .padding(.horizontal)
                .frame(maxHeight: 300)
            }

            Spacer()
        }
        .padding(.top, 50)
    }
}


#Preview {
    ContentView()
}
