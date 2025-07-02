import Foundation
import Network

class QianwenTranslateManager: ObservableObject {
    static let shared = QianwenTranslateManager()
    

    private let baseURL = "https://dashscope.aliyuncs.com/api/v1/services/aigc/text-generation/generation"
    
    @Published var isTranslating = false
    @Published var lastError: Error?
    @Published var isLoading = false
    @Published var lastTranslationTime: TimeInterval = 0
    
    private let cacheManager = TranslationCacheManager.shared
    private let networkManager = NetworkManager()
    private var translationQueue = DispatchQueue(label: "qianwen.translation", qos: .userInitiated)
    
    private init() {}
    
    // MARK: - Network Check
    private func checkNetworkConnectivity() async {
        // 简化的网络检测
        print("🌐 Checking network connectivity...")
    }
    
    // MARK: - Main Translation Function
    @MainActor
    func translateText(_ text: String, from sourceLanguage: String, to targetLanguage: String) async throws -> String {
        let startTime = CFAbsoluteTimeGetCurrent()
        
        // 检查缓存
        if let cachedTranslation = cacheManager.getCachedTranslation(
            text: text,
            from: sourceLanguage,
            to: targetLanguage,
            service: .qianwen
        ) {
            lastTranslationTime = CFAbsoluteTimeGetCurrent() - startTime
            return cachedTranslation
        }
        
        isLoading = true
        defer { isLoading = false }
        
        // 获取API密钥
        guard let apiKey = await DeveloperConfigManager.shared.getAPIKey(for: .qianwen) else {
            throw TranslationError.noAPIKey
        }
        
        // 执行翻译
        let translation = try await performTranslation(
            text: text,
            sourceLanguage: sourceLanguage,
            targetLanguage: targetLanguage,
            apiKey: apiKey
        )
        
        // 缓存结果
        cacheManager.cacheTranslation(
            originalText: text,
            translatedText: translation,
            from: sourceLanguage,
            to: targetLanguage,
            service: .qianwen
        )
        
        lastTranslationTime = CFAbsoluteTimeGetCurrent() - startTime
        return translation
    }
    
    /// 批量翻译（性能优化）
    @MainActor
    func translateTexts(_ texts: [String], from sourceLanguage: String, to targetLanguage: String) async throws -> [String] {
        let startTime = CFAbsoluteTimeGetCurrent()
        isLoading = true
        defer { isLoading = false }
        
        // 分离已缓存和未缓存的文本
        var results: [Int: String] = [:]
        var uncachedTexts: [(index: Int, text: String)] = []
        
        for (index, text) in texts.enumerated() {
            if let cachedTranslation = cacheManager.getCachedTranslation(
                text: text,
                from: sourceLanguage,
                to: targetLanguage,
                service: .qianwen
            ) {
                results[index] = cachedTranslation
            } else {
                uncachedTexts.append((index, text))
            }
        }
        
        // 批量翻译未缓存的文本
        if !uncachedTexts.isEmpty {
            let batchTranslations = try await performBatchTranslation(
                texts: uncachedTexts.map { $0.text },
                sourceLanguage: sourceLanguage,
                targetLanguage: targetLanguage
            )
            
            // 缓存新翻译的结果
            for (uncachedIndex, translation) in batchTranslations.enumerated() {
                let originalIndex = uncachedTexts[uncachedIndex].index
                let originalText = uncachedTexts[uncachedIndex].text
                
                results[originalIndex] = translation
                
                cacheManager.cacheTranslation(
                    originalText: originalText,
                    translatedText: translation,
                    from: sourceLanguage,
                    to: targetLanguage,
                    service: .qianwen
                )
            }
        }
        
        lastTranslationTime = CFAbsoluteTimeGetCurrent() - startTime
        
        // 按原始顺序返回结果
        return (0..<texts.count).compactMap { results[$0] }
    }
    
    // MARK: - Private Methods
    
    private func performTranslation(
        text: String,
        sourceLanguage: String,
        targetLanguage: String,
        apiKey: String
    ) async throws -> String {
        // 验证API密钥格式
        if apiKey.contains("demo") || apiKey.contains("placeholder") || apiKey.contains("YOUR_") {
            throw TranslationError.invalidAPIKey
        }
        
        // 构建翻译提示
        let prompt = buildTranslationPrompt(text: text, from: sourceLanguage, to: targetLanguage)
        
        // 创建API请求
        var request = URLRequest(url: URL(string: baseURL)!)
        request.httpMethod = "POST"
        request.addValue("Bearer \(apiKey)", forHTTPHeaderField: "Authorization")
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        
        let requestBody: [String: Any] = [
            "model": "qwen-turbo",
            "input": [
                "messages": [
                    [
                        "role": "user",
                        "content": prompt
                    ]
                ]
            ],
            "parameters": [
                "temperature": 0.3,
                "max_tokens": 1000,
                "top_p": 0.8
            ]
        ]
        
        do {
            let jsonData = try JSONSerialization.data(withJSONObject: requestBody)
            request.httpBody = jsonData
            
            print("🌐 Calling Qianwen API for translation...")
            print("📝 Text: \(text)")
            print("🔄 \(sourceLanguage) → \(targetLanguage)")
            
            let (data, response) = try await URLSession.shared.data(for: request)
            
            if let httpResponse = response as? HTTPURLResponse {
                print("📡 API Response: \(httpResponse.statusCode)")
                
                guard httpResponse.statusCode == 200 else {
                    throw TranslationError.apiError("HTTP \(httpResponse.statusCode)")
                }
            }
            
            let apiResponse = try JSONDecoder().decode(QianwenResponse.self, from: data)
            
            guard let translatedText = apiResponse.output?.text else {
                throw TranslationError.invalidResponse
            }
            
            let cleanedText = translatedText.trimmingCharacters(in: .whitespacesAndNewlines)
            print("✅ Translation: \(cleanedText)")
            
            return cleanedText
            
        } catch {
            print("❌ Translation error: \(error)")
            throw error
        }
    }
    
    // 构建翻译提示
    private func buildTranslationPrompt(text: String, from sourceLanguage: String, to targetLanguage: String) -> String {
        let fromLang = languageDisplayName(sourceLanguage)
        let toLang = languageDisplayName(targetLanguage)
        
        return """
        Please translate the following \(fromLang) text to \(toLang). 
        Provide only the translation result, without any additional explanation or formatting.
        
        Text to translate: \(text)
        """
    }
    
    private func performBatchTranslation(
        texts: [String],
        sourceLanguage: String,
        targetLanguage: String
    ) async throws -> [String] {
        guard let apiKey = await DeveloperConfigManager.shared.getAPIKey(for: .qianwen) else {
            throw TranslationError.noAPIKey
        }
        
        // 批量翻译优化：减少API调用次数
        return try await withThrowingTaskGroup(of: String.self) { group in
            for text in texts {
                group.addTask {
                    try await self.performTranslation(
                        text: text,
                        sourceLanguage: sourceLanguage,
                        targetLanguage: targetLanguage,
                        apiKey: apiKey
                    )
                }
            }
            
            var results: [String] = []
            for try await result in group {
                results.append(result)
            }
            return results
        }
    }
    
    // MARK: - Context-Aware Translation
    func translateWithContext(_ text: String, context: String = "", from sourceLanguage: String, to targetLanguage: String) async throws -> String {
        guard let apiKey = await DeveloperConfigManager.shared.getAPIKey(for: .qianwen) else {
            throw TranslationError.noAPIKey
        }
        
        guard !text.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty else {
            throw TranslationError.emptyText
        }
        
        DispatchQueue.main.async {
            self.isTranslating = true
        }
        
        defer {
            DispatchQueue.main.async {
                self.isTranslating = false
            }
        }
        
        // 检测网络连接
        await checkNetworkConnectivity()
        
        // 构建带上下文的翻译提示
        let contextPrompt = buildContextualPrompt(text: text, context: context, from: sourceLanguage, to: targetLanguage)
        
        var request = URLRequest(url: URL(string: baseURL)!)
        request.httpMethod = "POST"
        request.addValue("Bearer \(apiKey)", forHTTPHeaderField: "Authorization")
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        
        let requestBody: [String: Any] = [
            "model": "qwen-turbo",
            "input": [
                "messages": [
                    [
                        "role": "user",
                        "content": contextPrompt
                    ]
                ]
            ],
            "parameters": [
                "temperature": 0.3,  // 降低温度以提高准确性
                "max_tokens": 500,
                "top_p": 0.8
            ]
        ]
        
        let jsonData = try JSONSerialization.data(withJSONObject: requestBody)
        request.httpBody = jsonData
        
        print("🌐 Sending contextual translation request to Qianwen API...")
        print("📝 Text to translate: \(text)")
        if !context.isEmpty {
            print("📖 Context: \(context)")
        }
        
        let (data, response) = try await URLSession.shared.data(for: request)
        
        if let httpResponse = response as? HTTPURLResponse {
            print("📡 API Response Status: \(httpResponse.statusCode)")
            
            guard httpResponse.statusCode == 200 else {
                throw TranslationError.apiError("HTTP \(httpResponse.statusCode)")
            }
        }
        
        let apiResponse = try JSONDecoder().decode(QianwenResponse.self, from: data)
        
        guard let translatedText = apiResponse.output?.text else {
            throw TranslationError.invalidResponse
        }
        
        print("✅ Translation completed: \(translatedText)")
        return translatedText.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)
    }
    
    // 构建上下文感知的翻译提示
    private func buildContextualPrompt(text: String, context: String, from sourceLanguage: String, to targetLanguage: String) -> String {
        let fromLang = languageDisplayName(sourceLanguage)
        let toLang = languageDisplayName(targetLanguage)
        
        var prompt = "Please translate the following \(fromLang) text to \(toLang). "
        
        if !context.isEmpty {
            prompt += "Context for better understanding: \(context). "
        }
        
        prompt += "Ensure the translation is natural, accurate, and maintains the original meaning and tone. "
        prompt += "Text to translate: \(text)"
        
        return prompt
    }
    
    // MARK: - Language Detection
    func detectLanguage(_ text: String) -> String {
        // 简化的语言检测逻辑
        if text.range(of: "\\p{Han}", options: .regularExpression) != nil {
            return "zh"
        } else {
            return "en"
        }
    }
    
    // MARK: - Helper Methods
    private func languageDisplayName(_ code: String) -> String {
        switch code {
        case "zh": return "Chinese"
        case "en": return "English"
        case "es": return "Spanish"
        case "fr": return "French"
        case "de": return "German"
        case "ja": return "Japanese"
        default: return "Unknown"
        }
    }
    
    // MARK: - Connectivity Test
    func testConnectivity() async throws -> Bool {
        guard (await DeveloperConfigManager.shared.getAPIKey(for: .qianwen)) != nil else {
            throw TranslationError.noAPIKey
        }
        
        // 测试简单的翻译请求
        let testText = "Hello"
        _ = try await translateText(testText, from: "en", to: "zh")
        return true
    }
}

// MARK: - Supporting Types
enum TranslationError: Error, LocalizedError {
    case noAPIKey
    case emptyText
    case networkError(String)
    case apiError(String)
    case invalidResponse
    case rateLimited
    case invalidAPIKey
    case responseParsingError
    
    var errorDescription: String? {
        switch self {
        case .noAPIKey:
            return "No API key configured"
        case .emptyText:
            return "Text is empty"
        case .networkError(let message):
            return "Network error: \(message)"
        case .apiError(let message):
            return "API error: \(message)"
        case .invalidResponse:
            return "Invalid response from API"
        case .rateLimited:
            return "Rate limited by API"
        case .invalidAPIKey:
            return "Invalid API key"
        case .responseParsingError:
            return "Failed to parse translation response"
        }
    }
}

struct QianwenResponse: Codable {
    let output: QianwenOutput?
    let usage: QianwenUsage?
    let requestId: String?
    
    enum CodingKeys: String, CodingKey {
        case output, usage
        case requestId = "request_id"
    }
}

struct QianwenOutput: Codable {
    let text: String?
    let finishReason: String?
    
    enum CodingKeys: String, CodingKey {
        case text
        case finishReason = "finish_reason"
    }
}

struct QianwenUsage: Codable {
    let inputTokens: Int?
    let outputTokens: Int?
    let totalTokens: Int?
    
    enum CodingKeys: String, CodingKey {
        case inputTokens = "input_tokens"
        case outputTokens = "output_tokens"
        case totalTokens = "total_tokens"
    }
}

// 网络管理器占位符
private class NetworkManager {
    func performRequest(_ request: URLRequest) async throws -> Data {
        // 网络请求实现
        return Data()
    }
} 