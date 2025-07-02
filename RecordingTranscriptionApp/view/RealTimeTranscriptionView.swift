import SwiftUI
import NaturalLanguage
import Translation

struct RealTimeTranscriptionView: View {
    @ObservedObject var manager: RealTimeTranscriptionManager
    @Environment(\.dismiss) private var dismiss
    
    // Language pack management
    @ObservedObject private var languagePackManager = LanguagePackManager.shared
    
    // Translation settings
    @State private var targetLanguage: String = "zh"
    @State private var sourceLanguage: String = "auto"

    @State private var isTranslationExpanded: Bool = true
    @State private var autoDetectedLanguage: String = ""
    @State private var isAutoDetecting: Bool = true
    
    // Language pack UI states
    @State private var showLanguagePackDownload: Bool = false
    @State private var showDataUsageWarning: Bool = false
    @State private var showHistoryTranslationAlert: Bool = false
    @State private var showRealTranslationDownload: Bool = false
    
    // Available languages for translation (simplified codes)
    private let availableLanguages = [
        ("en", "English"),
        ("zh", "Chinese"),
        ("es", "Spanish"),
        ("fr", "French"),
        ("de", "German"),
        ("ja", "Japanese"),
        ("ko", "Korean"),
        ("pt", "Portuguese"),
        ("ru", "Russian"),
        ("ar", "Arabic")
    ]
    
    @State private var translationRequest: TranslationSession.Request?
    @State private var translationResponse: TranslationSession.Response?
    
    // 滚动同步状态
    @State private var transcriptionScrollOffset: CGFloat = 0
    @State private var translationScrollOffset: CGFloat = 0
    @State private var isUserScrolling: Bool = false
    @State private var scrollSyncTimer: Timer?
    @State private var shouldSyncScroll: Bool = true // 控制是否同步滚动
    
    var body: some View {
        NavigationView {
            VStack(spacing: 0) {
                statusBar
                settingsBar
                
                // 直接使用VStack布局，避免GeometryReader的复杂性
                VStack(spacing: 16) {
                    transcriptionSection
                        .frame(minHeight: 250)
                }
                .padding(.horizontal, 8)
                .frame(maxWidth: .infinity, maxHeight: .infinity)
            }
            .navigationTitle("Real-time Transcription")
            .navigationBarTitleDisplayMode(.inline)
            .navigationBarItems(trailing: Button("Done") { dismiss() })
            .onAppear {
                detectDefaultLanguage()
                checkLanguagePackStatus()
            }
            .onChange(of: sourceLanguage) { oldValue, newValue in
                // 修复：当语言选择改变时，切换语音识别器的语言
                if newValue != "auto" && newValue != oldValue {
                    let speechLocale = mapToSpeechLocale(newValue)
                    print("🔄 Switching speech recognizer to: \(speechLocale)")
                    manager.switchLanguage(to: speechLocale)
                }
            }
        }
    }

    
    @ViewBuilder
    private var statusBar: some View {
        HStack {
            Circle()
                .fill(manager.isTranscribing ? Color.green : Color.gray)
                .frame(width: 12, height: 12)
                .scaleEffect(manager.isTranscribing ? 1.2 : 1.0)
                .animation(.easeInOut(duration: 0.8).repeatForever(autoreverses: true), value: manager.isTranscribing)
            
            Text(manager.isTranscribing ? "Transcribing..." : "Transcription Paused")
                .font(.caption)
                .foregroundColor(.secondary)
            
            Spacer()
            
            Text("\(manager.realtimeSegments.count) segments")
                .font(.caption2)
                .foregroundColor(.secondary)
        }
        .padding(.horizontal)
        .padding(.vertical, 8)
        .background(Color(UIColor.secondarySystemBackground))
    }
    
    @ViewBuilder
    private var settingsBar: some View {
        VStack(spacing: 8) {
            HStack {
                // 源语言选择器
                Menu {
                    Button(action: {
                        sourceLanguage = "auto"
                    }) {
                        HStack {
                            Image(systemName: "wand.and.stars")
                            Text("Auto-detect")
                            if sourceLanguage == "auto" {
                                Spacer()
                                Image(systemName: "checkmark")
                            }
                        }
                    }
                    
                    Divider()
                    
                    ForEach(availableLanguages, id: \.0) { code, name in
                        Button(action: {
                            sourceLanguage = code
                        }) {
                            HStack {
                                Text(name)
                                if sourceLanguage == code {
                                    Spacer()
                                    Image(systemName: "checkmark")
                                }
                            }
                        }
                    }
                } label: {
                    HStack {
                        Image(systemName: "mic")
                        Text("From: \(sourceLanguage == "auto" ? "Auto" : languageDisplayName(sourceLanguage))")
                        Image(systemName: "chevron.down")
                    }
                    .font(.caption)
                    .foregroundColor(.blue)
                }
                
                Image(systemName: "arrow.right")
                    .font(.caption)
                    .foregroundColor(.secondary)
                
                // 目标语言选择器
                Menu {
                    ForEach(availableLanguages, id: \.0) { code, name in
                        Button(action: {
                            isAutoDetecting = false
                            targetLanguage = code
                        }) {
                            HStack {
                                Text(name)
                                if targetLanguage == code {
                                    Spacer()
                                    Image(systemName: "checkmark")
                                }
                            }
                        }
                    }
                } label: {
                    HStack {
                        Image(systemName: "globe")
                        Text("To: \(languageDisplayName(targetLanguage))")
                        Image(systemName: "chevron.down")
                    }
                    .font(.caption)
                    .foregroundColor(.blue)
                }
                
                Spacer()
                
                // 段落计数显示
                Text("\(manager.realtimeSegments.count) segments")
                    .font(.caption2)
                    .foregroundColor(.secondary)
                
                Button(action: {
                    withAnimation {
                        isTranslationExpanded.toggle()
                    }
                }) {
                    HStack(spacing: 4) {
                        Image(systemName: "globe.americas")
                        Text("Translation")
                        Image(systemName: isTranslationExpanded ? "chevron.up" : "chevron.down")
                    }
                    .font(.caption)
                    .foregroundColor(.blue)
                }
            }
            
            if let error = manager.transcriptionError, !error.isEmpty {
                HStack {
                    Image(systemName: "exclamationmark.triangle")
                        .foregroundColor(.orange)
                    Text(error)
                        .font(.caption)
                        .foregroundColor(.orange)
                    Spacer()
                }
            }
        }
        .padding(.horizontal)
        .padding(.vertical, 8)
    }
    
    @ViewBuilder
    private var transcriptionSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            
            // 转写和翻译内容区域
            if manager.realtimeSegments.isEmpty && manager.currentTranscript.isEmpty {
                VStack(spacing: 8) {
                    Image(systemName: "waveform")
                        .font(.title2)
                        .foregroundColor(.secondary)
                    Text("Transcription will appear here automatically")
                        .font(.body)
                        .foregroundColor(.secondary)
                        .multilineTextAlignment(.center)
                }
                .frame(maxWidth: .infinity, minHeight: 200)
            } else {
                ScrollViewReader { transcriptionProxy in
                    ScrollView {
                        LazyVStack(alignment: .leading, spacing: 8) {
                            // 当前实时转写使用现代化卡片显示
                            if !manager.currentTranscript.isEmpty {
                                ModernSegmentCard(
                                    segment: RealtimeSegment(
                                        text: manager.currentTranscript,
                                        timestamp: Date(),
                                        confidence: 0.95,
                                        language: "auto",
                                        quality: .good,
                                        duration: 0.0,
                                        translation: ""
                                    ),
                                    isLive: true,
                                    sourceLanguage: sourceLanguage,
                                    targetLanguage: targetLanguage,
                                    showTranslation: isTranslationExpanded
                                )
                                .id("live-transcription")
                            }
                            
                            // 历史段落使用现代化卡片显示
                            ForEach(manager.realtimeSegments.reversed(), id: \.id) { segment in
                                ModernSegmentCard(
                                    segment: segment,
                                    isLive: false,
                                    sourceLanguage: sourceLanguage,
                                    targetLanguage: targetLanguage,
                                    showTranslation: isTranslationExpanded
                                )
                                .id("transcription-\(segment.id)")
                            }
                        }
                        .padding(.vertical, 4)
                    }
                    .frame(maxHeight: .infinity)
                    .onPreferenceChange(ViewOffsetKey.self) { offset in
                        if !isUserScrolling && shouldSyncScroll {
                            transcriptionScrollOffset = offset
                        }
                    }
                    .simultaneousGesture(
                        DragGesture()
                            .onChanged { _ in
                                if !manager.isTranscribing || manager.isPaused {
                                    isUserScrolling = true
                                    shouldSyncScroll = false
                                    scrollSyncTimer?.invalidate()
                                    scrollSyncTimer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: false) { _ in
                                        isUserScrolling = false
                                        if !manager.isTranscribing || manager.isPaused {
                                            shouldSyncScroll = false
                                        } else {
                                            shouldSyncScroll = true
                                        }
                                    }
                                }
                            }
                    )
                    .onChange(of: manager.realtimeSegments.count) { _, _ in
                        if manager.isTranscribing && !isUserScrolling {
                            withAnimation(.easeOut(duration: 0.15)) {
                                if !manager.currentTranscript.isEmpty {
                                    transcriptionProxy.scrollTo("live-transcription", anchor: .bottom)
                                } else if let lastSegment = manager.realtimeSegments.last {
                                    transcriptionProxy.scrollTo("transcription-\(lastSegment.id)", anchor: .bottom)
                                }
                            }
                        }
                    }
                }
            }
        }
        .padding()
        .background(Color(UIColor.systemBackground))
        .cornerRadius(12)
        .shadow(radius: 2)
    }
    

    
    @ViewBuilder
    private func transcriptionSegmentView(_ segment: RealtimeSegment) -> some View {
        VStack(alignment: .leading, spacing: 8) {
            // 时间戳胶囊 - 显著显示
            HStack {
                        Text(segment.timestamp.formatted(date: .omitted, time: .standard))
            .font(.caption)
            .fontWeight(.medium)
            .foregroundColor(.white)
            .padding(.horizontal, 10)
            .padding(.vertical, 4)
            .background(Color.blue)
            .clipShape(Capsule())
                
                Spacer()
                
                // 置信度指示器
                Text("Confidence: \(Int(segment.confidence * 100))%")
                    .font(.caption2)
                    .foregroundColor(.secondary)
            }
            
            // 转录内容
            Text(segment.text)
                .font(.body)
                .lineSpacing(4)
                .foregroundColor(.primary)
        }
        .padding(12)
        .background(Color(UIColor.systemBackground))
        .cornerRadius(10)
        .shadow(color: Color.black.opacity(0.05), radius: 2, x: 0, y: 1)
    }
    

    
    private func languageDisplayName(_ code: String) -> String {
        availableLanguages.first { $0.0 == code }?.1 ?? "Unknown"
    }
    
    private func mapToSpeechLocale(_ languageCode: String) -> String {
        switch languageCode {
        case "en": return "en-US"
        case "zh": return "zh-CN"
        case "es": return "es-ES"
        case "fr": return "fr-FR"
        case "de": return "de-DE"
        case "ja": return "ja-JP"
        case "ko": return "ko-KR"
        case "pt": return "pt-PT"
        case "ru": return "ru-RU"
        case "ar": return "ar-SA"
        default: return "en-US"
        }
    }
    
    private func detectDefaultLanguage() {
        let systemLanguage = Locale.current.language.languageCode?.identifier ?? "en"
        let preferredTarget = systemLanguageToTargetLanguage(systemLanguage)
        
        // Set target language based on system language
        targetLanguage = preferredTarget
        autoDetectedLanguage = preferredTarget
        

    }
    
    private func systemLanguageToTargetLanguage(_ systemLang: String) -> String {
        switch systemLang {
        case "zh": return "zh"
        case "es": return "es"
        case "fr": return "fr"
        case "de": return "de"
        case "ja": return "ja"
        case "ko": return "ko"
        case "pt": return "pt"
        case "ru": return "ru"
        case "ar": return "ar"
        default: return "zh"
        }
    }
    
    // MARK: - Language Pack Management Methods
    
    private func checkLanguagePackStatus() {
        // Detect language from current transcript
        if !manager.currentTranscript.isEmpty {
            if let detectedLang = languagePackManager.detectLanguageOnly(manager.currentTranscript) {
                sourceLanguage = detectedLang
                languagePackManager.onNewLanguageDetected(detectedLang)
            }
        }
    }
    
    private func downloadRequiredLanguagePack() {
        showRealTranslationDownload = true
    }
    
    private func onLanguagePackDownloadComplete() {
        showRealTranslationDownload = false
        showLanguagePackDownload = false
        
        // Update language pack manager state
        Task {
            await MainActor.run {
                if let index = languagePackManager.availableLanguagePacks.firstIndex(where: { 
                    $0.sourceLanguage == sourceLanguage && $0.targetLanguage == targetLanguage 
                }) {
                    languagePackManager.availableLanguagePacks[index].isDownloaded = true
                    languagePackManager.availableLanguagePacks[index].lastUsed = Date()
                }
                
                showHistoryTranslationAlert = languagePackManager.shouldOfferHistoryTranslation()
            }
        }
    }
    
    private func translateHistoryContent() {
        // Implement history translation logic
        Task {
            for segment in manager.realtimeSegments {
                _ = await languagePackManager.translateText(
                    segment.text,
                    from: sourceLanguage,
                    to: targetLanguage
                )
            }
        }
    }
    
    // MARK: - UI Components
    
    @ViewBuilder
    private var languagePackDownloadSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                Text("Language Pack Required")
                    .font(.headline)
                    .foregroundColor(.orange)
                Spacer()
                Image(systemName: "arrow.down.circle")
                    .foregroundColor(.orange)
            }
            
            Text("Download the \(languageDisplayName(targetLanguage)) language pack to enable real-time translation.")
                .font(.body)
                .foregroundColor(.secondary)
            
            HStack {
                Button("Download Now") {
                    if languagePackManager.shouldWarnAboutDataUsage() {
                        showDataUsageWarning = true
                    } else {
                        downloadRequiredLanguagePack()
                    }
                }
                .buttonStyle(.borderedProminent)
                
                Button("Later") {
                    showLanguagePackDownload = false
                }
                .buttonStyle(.bordered)
                
                Spacer()
            }
            
            if let progress = languagePackManager.getDownloadProgress(for: "\(sourceLanguage)-\(targetLanguage)") {
                VStack(alignment: .leading, spacing: 4) {
                    HStack {
                        Text("Downloading...")
                            .font(.caption)
                            .foregroundColor(.blue)
                        Spacer()
                        Text("\(Int(progress * 100))%")
                            .font(.caption)
                            .foregroundColor(.blue)
                    }
                    
                    ProgressView(value: progress)
                        .progressViewStyle(LinearProgressViewStyle())
                }
            }
        }
        .padding()
        .background(Color.orange.opacity(0.1))
        .cornerRadius(12)
        .overlay(
            RoundedRectangle(cornerRadius: 12)
                .stroke(Color.orange.opacity(0.3), lineWidth: 1)
        )
    }
    
    @ViewBuilder
    private func languagePackNeededView(for text: String) -> some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack {
                Image(systemName: "exclamationmark.triangle")
                    .foregroundColor(.orange)
                Text("Translation Unavailable")
                    .font(.caption)
                    .foregroundColor(.orange)
                Spacer()
                Button("Download Pack") {
                    Task {
                        _ = await languagePackManager.downloadLanguagePack(
                            sourceLanguage: sourceLanguage,
                            targetLanguage: targetLanguage
                        )
                    }
                }
                .font(.caption)
                .buttonStyle(.bordered)
            }
            
            Text("Original: \(text)")
                .font(.body)
                .foregroundColor(.secondary)
                .italic()
        }
        .padding()
        .background(Color.orange.opacity(0.1))
        .cornerRadius(8)
        .overlay(
            RoundedRectangle(cornerRadius: 8)
                .stroke(Color.orange.opacity(0.3), lineWidth: 1)
        )
    }
    
    // MARK: - Helper Functions
    
    private func formatTimeFromDate(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "HH:mm:ss"
        return formatter.string(from: date)
    }
}

// MARK: - Enhanced Translation View

struct EnhancedTranslationView: View {
    let text: String
    let sourceLanguage: String
    let targetLanguage: String
    
    @State private var translationConfiguration: TranslationSession.Configuration?
    @State private var translatedText: String = ""
    @State private var isTranslating: Bool = false
    @State private var lastTranslatedText: String = ""
    @State private var lastLanguagePair: String = ""
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack {
                Text("Translation: \(sourceLanguage.uppercased()) → \(targetLanguage.uppercased())")
                    .font(.caption)
                    .foregroundColor(.blue)
                Spacer()
                if isTranslating {
                    ProgressView()
                        .scaleEffect(0.8)
                    Text("Translating...")
                        .font(.caption)
                        .foregroundColor(.secondary)
                }
            }
            

            
            // 显示翻译结果或原文
            Text(translatedText.isEmpty ? text : translatedText)
                .font(.body)
                .foregroundColor(.primary)
                .padding(.vertical, 4)
                .onAppear {
                    performDirectTranslation()
                }
                .onChange(of: text) { _, _ in
                    performDirectTranslation()
                }
                .onChange(of: sourceLanguage) { _, _ in
                    performDirectTranslation()
                }
                .onChange(of: targetLanguage) { _, _ in
                    performDirectTranslation()
                }
            

        }
    }
    
    private func performDirectTranslation() {
        let currentLanguagePair = "\(sourceLanguage)->\(targetLanguage)"
        
        // 避免重复翻译相同的文本和语言对
        guard !text.isEmpty else {
            return
        }
        
        guard text != lastTranslatedText || currentLanguagePair != lastLanguagePair else {
            return
        }
        
        Task {
            await performDirectTranslationAsync()
        }
    }
    
    @MainActor
    private func performDirectTranslationAsync() async {
        isTranslating = true
        
        do {
            // 直接检查API密钥，不依赖hasQianwenKey标志
            guard let apiKey = APIKeyManager.shared.getQianwenAPIKey(), !apiKey.isEmpty else {
                print("🌍 TRANSLATION: ❌ No API key found in keychain")
                self.translatedText = "⚙️ Please configure Qianwen API key in Settings to enable translation."
                self.isTranslating = false
                return
            }
            
            // 处理自动检测源语言
            let actualSourceLanguage: String
            if sourceLanguage == "auto" {
                // 使用语言检测
                actualSourceLanguage = QianwenTranslateManager.shared.detectLanguage(text)
                print("🌍 TRANSLATION: 🔍 Auto-detected source language: \(actualSourceLanguage)")
            } else {
                actualSourceLanguage = sourceLanguage
            }
            
            print("🌍 TRANSLATION: ✅ API key found: \(apiKey.prefix(10))...")
            print("🌍 TRANSLATION: Translating from \(actualSourceLanguage) to \(targetLanguage): '\(text)'")
            
            // 使用通义千问API进行真实翻译
            let translatedText = try await QianwenTranslateManager.shared.translateText(
                text,
                from: actualSourceLanguage,
                to: targetLanguage
            )
            
            print("🌍 TRANSLATION: ✅ Translation successful: '\(translatedText)'")
            self.translatedText = translatedText
            
            // 记录已翻译的内容
            lastTranslatedText = text
            lastLanguagePair = "\(actualSourceLanguage)->\(targetLanguage)"
            
        } catch let error as TranslationError {
            print("🌍 TRANSLATION: ❌ Translation error: \(error.localizedDescription)")
            self.translatedText = "❌ \(error.localizedDescription)"
        } catch {
            print("🌍 TRANSLATION: ❌ Unexpected error: \(error.localizedDescription)")
            self.translatedText = "❌ Translation failed: \(error.localizedDescription)"
        }
        
        isTranslating = false
    }
    

    
    private func resetAndStartTranslation() {
        // 重置状态
        translationConfiguration = nil
        translatedText = ""
        isTranslating = false
        
        startTranslation()
    }
    
    private func startTranslation() {
        guard !text.isEmpty else { return }
        

        
        // 先检查语言支持
        Task {
            await checkLanguageAvailabilityAndTranslate()
        }
    }
    
    @MainActor
    private func checkLanguageAvailabilityAndTranslate() async {
        isTranslating = true
        
        let sourceLocale = getLanguageCode(sourceLanguage)
        let targetLocale = getLanguageCode(targetLanguage)
        
        // 检查语言是否受支持
        let availability = LanguageAvailability()
        let status = await availability.status(from: sourceLocale, to: targetLocale)
        
        switch status {
        case .installed:
            translationConfiguration = TranslationSession.Configuration(
                source: sourceLocale,
                target: targetLocale
            )
        case .supported:
            // 创建配置来触发下载
            let tempConfig = TranslationSession.Configuration(
                source: sourceLocale,
                target: targetLocale
            )
            
            translationConfiguration = tempConfig
        case .unsupported:
            translatedText = "Language pair \(sourceLanguage)->\(targetLanguage) not supported"
            isTranslating = false
        @unknown default:
            translatedText = "Unknown language status"
            isTranslating = false
        }
    }
    
    @MainActor
    private func performRealTranslation(session: TranslationSession) async {
        guard !text.isEmpty else { return }
        
        do {
            // 添加语言包状态检查
            let sourceLocale = getLanguageCode(sourceLanguage)
            let targetLocale = getLanguageCode(targetLanguage)
            let availability = LanguageAvailability()
            _ = await availability.status(from: sourceLocale, to: targetLocale)
            
            let response = try await session.translate(text)
            
            self.translatedText = response.targetText
            self.isTranslating = false
            
            // 记录已翻译的内容，避免重复翻译
            self.lastTranslatedText = text
            self.lastLanguagePair = "\(sourceLanguage)->\(targetLanguage)"
            
        } catch let error as NSError {
            // 显示错误信息给用户
            if error.domain.contains("Translation") || error.code == -1 {
                self.translatedText = "Language pack download required. Please download the language pack in Settings."
            } else {
                self.translatedText = "Translation failed: \(error.localizedDescription)"
            }
            
            self.isTranslating = false
        }
    }
    
    private func getLanguageCode(_ languageCode: String) -> Locale.Language {
        // 使用iOS Translation Framework推荐的语言代码格式
        switch languageCode {
        case "en":
            return Locale.Language(identifier: "en")
        case "zh":
            return Locale.Language(identifier: "zh-Hans")
        case "es":
            return Locale.Language(identifier: "es")
        case "fr":
            return Locale.Language(identifier: "fr")
        case "de":
            return Locale.Language(identifier: "de")
        case "ja":
            return Locale.Language(identifier: "ja")
        case "ko":
            return Locale.Language(identifier: "ko")
        case "pt":
            return Locale.Language(identifier: "pt")
        case "ru":
            return Locale.Language(identifier: "ru")
        case "ar":
            return Locale.Language(identifier: "ar")
        default:
            return Locale.Language(identifier: "en")
        }
    }
    
    private func languageToLocale(_ languageCode: String) -> Locale {
        switch languageCode {
        case "en":
            return Locale(identifier: "en-US")
        case "zh":
            return Locale(identifier: "zh-Hans")
        case "es":
            return Locale(identifier: "es-ES")
        case "fr":
            return Locale(identifier: "fr-FR")
        case "de":
            return Locale(identifier: "de-DE")
        case "ja":
            return Locale(identifier: "ja-JP")
        case "ko":
            return Locale(identifier: "ko-KR")
        case "pt":
            return Locale(identifier: "pt-PT")
        case "ru":
            return Locale(identifier: "ru-RU")
        case "ar":
            return Locale(identifier: "ar-SA")
        default:
            return Locale(identifier: "en-US")
        }
    }

}

// MARK: - Modern Segment Card View

struct ModernSegmentCard: View {
    let segment: RealtimeSegment
    let isLive: Bool
    let sourceLanguage: String
    let targetLanguage: String
    let showTranslation: Bool
    
    @State private var isTranslating: Bool = false
    
    private var qualityColor: Color {
        switch segment.quality {
        case .excellent: return .green
        case .good: return .blue
        case .fair: return .orange
        case .poor: return .red
        case .unknown: return .gray
        }
    }
    
    private var timeString: String {
        let formatter = DateFormatter()
        formatter.dateFormat = "HH:mm:ss"
        return formatter.string(from: segment.timestamp)
    }
    
    // 状态高亮颜色
    private var statusHighlightColor: Color {
        if isLive {
            if isTranslating {
                return .green  // 翻译中 - 绿色
            } else {
                return .blue   // 转录中 - 蓝色
            }
        }
        return .clear
    }
    
    // 状态边框颜色和宽度
    private var statusBorderWidth: CGFloat {
        return isLive ? 2.0 : 0.5
    }
    
    private var statusBorderColor: Color {
        if isLive {
            return statusHighlightColor
        }
        return Color(.separator)
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            // Header with timestamp and quality indicator
            HStack(alignment: .center, spacing: 12) {
                // Segment number
                Text(String(format: "%02d", segment.id.hashValue % 100))
                    .font(.system(.caption, design: .monospaced, weight: .semibold))
                    .foregroundColor(.secondary)
                    .frame(width: 24)
                
                // Timestamp
                Text(timeString)
                    .font(.system(.footnote, design: .monospaced, weight: .medium))
                    .foregroundColor(.primary)
                
                // Duration indicator
                Text("• \(String(format: "%.1fs", segment.duration))")
                    .font(.system(.caption2, design: .default))
                    .foregroundColor(.secondary)
                
                Spacer()
                
                // Quality indicator - clean dot design
                Circle()
                    .fill(qualityColor)
                    .frame(width: 6, height: 6)
                
                if isLive {
                    Text(isTranslating ? "TRANSLATING" : "TRANSCRIBING")
                        .font(.system(.caption2, design: .default, weight: .bold))
                        .foregroundColor(statusHighlightColor)
                        .padding(.horizontal, 6)
                        .padding(.vertical, 2)
                        .background(statusHighlightColor.opacity(0.15))
                        .clipShape(Capsule())
                }
            }
            .padding(.horizontal, 16)
            .padding(.vertical, 12)
            .background(
                isLive ? 
                statusHighlightColor.opacity(0.08) : 
                Color(.systemGray6).opacity(0.3)
            )
            
            // Content area
            VStack(alignment: .leading, spacing: 12) {
                // Transcription text
                Text(segment.text)
                    .font(.system(.body, design: .default))
                    .lineSpacing(4)
                    .foregroundColor(.primary)
                    .fixedSize(horizontal: false, vertical: true)
                
                // Translation if enabled
                if showTranslation && !segment.translation.isEmpty {
                    Rectangle()
                        .fill(Color(.separator).opacity(0.3))
                        .frame(height: 0.5)
                        .padding(.vertical, 4)
                    
                    HStack(alignment: .top, spacing: 8) {
                        Image(systemName: "globe")
                            .font(.caption)
                            .foregroundColor(.blue)
                            .padding(.top, 2)
                        
                        VStack(alignment: .leading, spacing: 4) {
                            Text("\(sourceLanguage.uppercased()) → \(targetLanguage.uppercased())")
                                .font(.system(.caption2, weight: .medium))
                                .foregroundColor(.blue)
                            
                            Text(segment.translation)
                                .font(.system(.body, design: .default))
                                .lineSpacing(4)
                                .foregroundColor(.secondary)
                                .fixedSize(horizontal: false, vertical: true)
                        }
                    }
                }
            }
            .padding(.horizontal, 16)
            .padding(.vertical, 12)
        }
        .background(Color(.systemBackground))
        .clipShape(RoundedRectangle(cornerRadius: 8, style: .continuous))
        .overlay(
            RoundedRectangle(cornerRadius: 8, style: .continuous)
                .stroke(statusBorderColor, lineWidth: statusBorderWidth)
        )
        .shadow(
            color: .black.opacity(0.04),
            radius: 1,
            x: 0,
            y: 1
        )
        .onAppear {
            // 简单检测：如果是live段落且显示翻译，根据translation内容判断翻译状态
            if isLive && showTranslation {
                // 模拟翻译状态检测：如果有翻译内容表示翻译中或已完成
                isTranslating = !segment.translation.isEmpty
            }
        }
    }
}

// 添加滚动偏移量追踪
struct ViewOffsetKey: PreferenceKey {
    static var defaultValue: CGFloat = 0
    static func reduce(value: inout CGFloat, nextValue: () -> CGFloat) {
        value = nextValue()
    }
}

struct ViewOffsetModifier: ViewModifier {
    func body(content: Content) -> some View {
        content
            .background(
                GeometryReader { geometry in
                    Color.clear
                        .preference(key: ViewOffsetKey.self, value: geometry.frame(in: .global).minY)
                }
            )
    }
}

extension View {
    func trackScrollOffset() -> some View {
        modifier(ViewOffsetModifier())
    }
}

#Preview("iPhone 16 Pro Max") {
    RealTimeTranscriptionView(manager: RealTimeTranscriptionManager())
        .previewDevice(PreviewDevice(rawValue: "iPhone 16 Pro Max"))
        .previewDisplayName("iPhone 16 Pro Max")
}

#Preview("iPhone 16 Pro") {
    RealTimeTranscriptionView(manager: RealTimeTranscriptionManager())
        .previewDevice(PreviewDevice(rawValue: "iPhone 16 Pro"))
        .previewDisplayName("iPhone 16 Pro")
}

#Preview("iPhone 15 Pro") {
    RealTimeTranscriptionView(manager: RealTimeTranscriptionManager())
        .previewDevice(PreviewDevice(rawValue: "iPhone 15 Pro"))
        .previewDisplayName("iPhone 15 Pro")
}