//
//  GeminiModel.swift
//  KFoodieScanner
//
//  Created by 서세린 on 8/21/25.
//

import Foundation

struct GeminiRequest: Codable {
    let contents: [Content]
}

struct Content: Codable {
    let parts: [Part]
}

struct Part: Codable {
    let text: String
}

struct GeminiResponse: Codable {
    let candidates: [Candidate]
}

struct Candidate: Codable {
    let content: Content
}
