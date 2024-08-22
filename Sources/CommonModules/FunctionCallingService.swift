//
//  FunctionCallingService.swift
//
//
//  Created by 伊藤史 on 2024/05/24.
//

import Foundation

/// An enumeration representing different function calling services.
public enum FunctionCallingService: String, Codable {
    /// [Anthropic Claude](https://www.anthropic.com/claude)
    case claude
    /// [Chat GPT](https://chatgpt.com)
    case chatGPT
    /// [Llama](https://www.llama-api.com) and [Gemini](https://ai.google.dev/gemini-api) has the same structure
    case llamaOrGemini
}
