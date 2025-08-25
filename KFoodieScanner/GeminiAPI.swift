//
//  GeminiAPI.swift
//  KFoodieScanner
//
//  Created by 서세린 on 8/21/25.
//

import Foundation

func callGeminiAPI(prompt: String, completion: @escaping (String?) -> Void) {
    let apiKey = Bundle.main.infoDictionary?["GEMINI_API_KEY"] as? String ?? ""
    let endpoint = "https://generativelanguage.googleapis.com/v1beta/models/gemini-2.5-flash-lite:generateContent"

    guard let url = URL(string: "\(endpoint)?key=\(apiKey)") else {
        print("❌ 잘못된 URL")
        completion(nil)
        return
    }

    var request = URLRequest(url: url)
    request.httpMethod = "POST"
    request.setValue("application/json", forHTTPHeaderField: "Content-Type")

    let body = GeminiRequest(contents: [Content(parts: [Part(text: prompt)])])
    do {
        request.httpBody = try JSONEncoder().encode(body)
    } catch {
        print("❌ JSON 인코딩 실패: \(error)")
        completion(nil)
        return
    }

    URLSession.shared.dataTask(with: request) { data, response, error in
        if let error = error {
            print("❌ 네트워크 에러: \(error)")
            completion(nil)
            return
        }

        guard let data = data else {
            print("❌ 응답 데이터 없음")
            completion(nil)
            return
        }

        // 상태 코드 확인
        if let httpResponse = response as? HTTPURLResponse {
            print("📡 상태 코드: \(httpResponse.statusCode)")
        }

        do {
            let decoded = try JSONDecoder().decode(GeminiResponse.self, from: data)
            let result = decoded.candidates.first?.content.parts.first?.text
            completion(result)
        } catch {
            print("❌ 디코딩 실패: \(error)")
            print("📦 응답 원문: \(String(data: data, encoding: .utf8) ?? "없음")")
            completion(nil)
        }
    }.resume()
}
