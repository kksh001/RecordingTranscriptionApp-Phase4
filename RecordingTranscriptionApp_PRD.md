# 录音转文字翻译App MVP 产品需求文档（PRD）  
**（支持录音、转写、翻译实时同步，UI多语言切换）**

---

## 📅 文档更新记录
**最新更新**: 2025年7月1日 17:37 CST  
**更新内容**: Phase 3功能增强详细规划与用户反馈问题记录

### 🎯 Phase 3功能增强架构确认
基于Phase 2智能翻译服务基础设施完成，Phase 3专注于核心功能服务的架构增强：

#### 1. **QianwenSemanticManager开发**（语义增强核心）
- **语义一致性检查**：基于通义千问API实现文本语义连贯性分析
- **内容优化建议**：智能文本润色和结构优化建议
- **翻译质量核对**：原文与译文的语义准确性验证
- **智能文本润色**：基于AI的内容改进和语言优化

#### 2. **TranslationServiceManager完善**（服务管理架构）
- **服务注册发现**：统一翻译服务接口和服务发现机制
- **负载均衡路由**：智能翻译请求分发和服务选择
- **服务健康监控**：实时服务状态监控和故障检测
- **故障转移处理**：自动服务切换和错误恢复机制

#### 3. **性能优化和错误处理**（基础设施增强）
- **批量请求优化**：翻译请求的智能合并和并发处理
- **缓存策略优化**：基于Phase 2缓存架构的深度优化
- **错误分类恢复**：完善的错误处理和恢复策略
- **降级策略实现**：服务不可用时的优雅降级机制

#### 4. **用户反馈问题记录**（Phase 4待解决）
- **翻译分段零碎问题**：缺乏上下文连贯性，需基于QianwenSemanticManager解决
- **状态残留问题**：新录音后前一段翻译文字残留，需基于错误处理架构解决
- **问题归属确认**：明确为Phase 4测试优化阶段处理，基于Phase 3增强架构实现

### 技术架构演进路径：
- **Phase 3输出**：语义分析、服务管理、性能优化三大增强架构
- **Phase 4基础**：基于Phase 3架构解决具体用户体验问题
- **架构完整性**：确保从基础设施→功能增强→体验优化的渐进路线

---

**最新更新**: 2025年6月29日 20:51 CST  
**更新内容**: 智能翻译服务配置与语义梳理AI能力集成 - v1.5版本开发规划

### 🎯 v1.5版本开发规划要点
本次规划基于v1.4完善的UI交互基础上，实现基于网络环境的智能翻译服务配置和增强AI能力：

#### 1. **智能翻译服务配置架构**（核心功能）
- **网络环境自动检测**：基于地理位置和网络环境自动选择最优翻译服务
- **开发者预配置API密钥**：通义千问和Google翻译API密钥由开发者预先配置，用户无需任何配置
- **透明化服务告知**：向用户展示当前使用的翻译服务状态，提供明确反馈
- **服务自动切换逻辑**：中国大陆境内优先通义千问，境外环境优先Google翻译
- **故障转移机制**：服务不可用时自动切换备用服务，确保翻译功能可用性

#### 2. **TranslationSettingsView UI集成**（设置界面改造）
- **SettingsView导航集成**：在Language和About之间添加"Translation Services"导航链接
- **服务状态展示界面**：显示当前使用的翻译服务、网络环境检测结果、服务可用性状态
- **English UI适配**：所有界面文本使用英文，符合现有UI语言标准
- **企业级升级预留**：为未来个人级到企业级API密钥升级预留配置选项和界面空间

#### 3. **语义梳理AI能力集成**（新增功能）
- **基于通义千问的语义分析**：利用通义千问API实现语义一致性检查、内容优化建议
- **智能文本润色**：对转录文本进行语义改进和结构优化
- **语义边界优化**：结合现有智能分段功能，提供基于语义的分段建议
- **翻译质量核对**：对翻译结果进行语义准确性验证和改进建议
- **设置开关控制**：在Settings中提供AI功能的开启/关闭选项

#### 4. **技术架构新增组件**
- **NetworkRegionManager**：地理位置检测、网络环境判断、服务选择逻辑
- **TranslationServiceManager**：统一翻译接口、预配置密钥管理、自动切换逻辑
- **ServiceConfigManager**：企业级配置管理、密钥轮换、服务监控
- **SemanticAnalysisManager**：语义梳理功能、AI辅助分析、内容优化

### 主要技术改进：
- **零配置用户体验**：用户无需输入任何API密钥，完全自动化服务配置
- **网络环境适配**：基于地理位置和网络状况智能选择最佳翻译服务
- **AI能力增强**：通过通义千问API提供语义梳理、内容优化等高级功能
- **架构扩展性设计**：为企业级服务升级和多服务支持预留完整扩展空间

### 开发任务分解：
1. **核心改造任务**：SettingsView添加Translation Services导航链接
2. **TranslationSettingsView重构**：移除用户API密钥输入，改为服务状态展示
3. **新增管理器组件**：NetworkRegionManager、TranslationServiceManager等4个新组件
4. **AI功能集成**：SemanticAnalysisManager基于通义千问API实现语义梳理
5. **预配置密钥管理**：开发者端API密钥配置和自动轮换机制

---

**2025年6月28日 18:50 CST**: UI交互优化与重命名功能系统实现 - v1.4版本功能完善

### 🎯 v1.4版本更新要点
本次更新在v1.3翻译系统真实化基础上，完善了用户交互体验和数据管理功能：

#### 1. **UI交互优化调整**
- **首页默认页面调整**：应用启动默认进入Record页面而非Sessions页面，提升录音功能优先级
- **录音历史区域样式优化**：实现统一卡片化设计，历史区域采用灰色调与当前区域（绿色调）形成视觉区分
- **Sessions页面交互完善**：确认删除功能正常运行，完善左滑操作（删除+分享）

#### 2. **录音记录重命名功能系统**（全新功能）
- **点击名称重命名**：实现符合iOS标准的inline编辑模式，支持点击录音名称直接编辑
- **明确保存行动点**：添加Save/Cancel按钮提供明确操作提示，支持多种保存方式（按钮点击/回车键）
- **智能重复检测**：自动检测重名情况，智能添加序号避免冲突（如"会议记录 (2)"）
- **用户友好提示**：重名处理时弹出提示告知用户最终名称，提升透明度
- **跨页面数据同步**：重命名后自动同步到RecordingDetailView等所有相关页面

#### 3. **分享导出功能架构**（功能整合优化）
- **分享功能整合设计**：将导出功能归类到分享功能下，符合iOS系统设计标准
- **多格式内容支持**：
  - 简单文本分享：录音基本信息（名称、日期、时长、语言等）
  - 详细文件导出：完整转写翻译内容，.txt格式，支持保存到Files应用
  - 系统分享选项：支持邮件、消息、AirDrop、剪贴板等多种分享渠道
- **智能内容适配**：根据不同分享类型自动生成适配的内容格式
- **临时文件管理**：自动创建和清理用于导出的临时文件

#### 4. **数据结构与架构优化**
- **RecordingSession可变性**：name字段改为var类型，支持运行时动态修改
- **状态跟踪机制**：添加lastEditedAt、hasUnsavedChanges等字段跟踪修改状态
- **完善回调机制**：建立RecordingListView → RecordingDetailView的完整数据更新回调链

### 主要技术改进：
- **数据同步架构**：实现跨组件的实时数据同步，确保名称修改立即反映到所有界面
- **用户体验优化**：明确的操作反馈、智能冲突处理、符合iOS设计规范的交互模式
- **功能整合设计**：避免功能重复，将相关功能合理归类整合
- **错误预防机制**：空名称处理、重复检测、取消操作等容错设计

---

**2025年6月28日 16:51 CST**: 翻译系统真实化与语义切分优化 - v1.3版本修复

### 🎯 v1.3版本更新要点
本次更新解决了翻译功能"假翻译"问题和语义切分过于零碎的核心问题：
1. **修复翻译系统真实化**：彻底去除假的"Translating..."占位符，实现真正的通义千问API调用
2. **优化语义切分算法**：解决文本被拆成零碎短语问题，提升翻译质量和用户体验
3. **简化分割架构设计**：禁用冲突的双重分割系统，统一使用语义切分
4. **提升内容质量阈值**：增加最小内容长度要求，避免无意义的短语切分
5. **优化时间参数配置**：调整切分间隔和检测阈值，减少频繁分段

### 主要改进内容：
- **真实翻译API集成**：QianwenTranslateManager统一翻译管理，移除GoogleTranslateManager冲突
- **语义切分参数优化**：segmentInterval 2秒→6秒，maxSegmentDuration 8秒→15秒，停顿阈值2秒→4秒
- **内容质量控制**：全局最小25字符，句子结束15字符，语法停顿30字符，避免零碎分段
- **架构简化设计**：禁用混合分割系统，只使用改进的语义切分，消除重复处理
- **异步更新机制**：翻译完成后自动更新UI，提供真实翻译体验

---

### 📑 历史更新记录
**2025年1月12日 12:31 CST**: Google Translate API集成配置 - 完成API密钥配置和翻译功能实现

### 🎯 本次更新要点
1. **Google Translate API完全集成**: 替换之前的mock翻译，实现真实的Google翻译功能
2. **API密钥安全管理**: 使用iOS Keychain安全存储API密钥
3. **翻译设置界面**: 完整的Google API密钥配置和验证系统
4. **真实翻译功能**: 完全移除之前的假翻译，实现实时真实翻译
5. **安全配置完成**: API密钥 `AIzaSyB4sxehiTrzITnhFejtRxC6eNpA1MJ_mfo` 已配置
6. **iPhone 16 Pro Max验证**: 真机测试确认翻译功能正常工作。

### 📑 历史更新
- **2025年6月21日 16:16 CST**: iOS翻译框架语言包管理策略设计 - MVP核心问题解决与长期规划
- **2025年6月15日 22:17 CST**: 智能编辑系统设计 - 独立编辑与智能提示机制
- **2025年6月15日 17:30 CST**: 录音详情页面设计规范 - 音频播放与文本同步系统
  - 录音详情页面架构: 完整的音频播放控制与转写翻译同步显示系统
  - 三方同步机制: 音频播放进度、转写文字位置、翻译文字位置实时同步
  - 文本编辑系统: 支持转写翻译内容编辑、修改确认、保存机制
  - MVP优先级划分: P0核心功能、P1重要功能、P2增强功能、P3扩展功能
  - 用户体验优化: 上下分布文本布局、拖动同步、高亮显示等交互设计
- **2025年6月9日 14:43 CST**: 实时转写UI状态设计 - 浮动按钮状态指示器系统
  - 状态系统设计: 录音页面浮动按钮状态指示器系统
  - 实时视觉反馈: 蓝色默认、绿色实时、黄色暂停状态
  - 动画与徽章: 连续脉冲动画配合内容数量徽章
  - 避免功能重复: 解决内联转写与单独转写页面的重复问题
  - 持续状态反馈: 强调实时转写的连续性和即时性
- **2025年6月8日 14:42 CST**: v2.0 UI优化 - 录音/转写/翻译语言逻辑重构
  - 录音界面简化: 移除语言预设，专注纯录音体验
  - 转写翻译分离: 转写保持录音原语言，翻译目标固定为系统语言
  - 手动翻译选项: 提供特殊场景下的手动翻译功能
  - 语言检测优化: 在转写阶段进行智能语言检测
  - 分步展示逻辑: 先转写后翻译的清晰用户体验

---

## 变更记录

- 2025-06-29：**智能翻译服务配置与语义梳理AI能力集成** - v1.5版本开发规划：实现基于网络环境的智能翻译服务自动配置（开发者预配置API密钥、用户零配置体验、中国大陆境内优先通义千问境外优先Google翻译）、TranslationSettingsView UI集成到主设置界面、基于通义千问API的语义梳理AI能力（语义一致性检查、内容优化建议、智能文本润色、翻译质量核对）、新增NetworkRegionManager等4个技术架构组件、为企业级服务升级预留完整扩展空间。
- 2025-06-28：**UI交互优化与重命名功能系统实现** - v1.4版本功能完善：实现首页默认页面调整（Record页优先）、录音历史区域样式统一化（灰色调区分）、完整的录音记录重命名系统（点击编辑、重复检测、智能序号、跨页面同步）、分享导出功能架构整合（多格式支持、智能内容适配）、数据结构优化（RecordingSession.name可变性、状态跟踪机制）、完善的用户体验设计（明确操作提示、错误预防机制）。
- 2025-06-28：**翻译系统真实化与语义切分优化** - v1.3版本修复：彻底去除假的"Translating..."占位符实现真正的通义千问API调用、优化语义切分算法解决文本被拆成零碎短语问题、简化分割架构设计禁用冲突的双重分割系统、提升内容质量阈值增加最小内容长度要求、优化时间参数配置调整切分间隔和检测阈值。
- 2025-01-12：**Google Translate API完全集成** - 完成真实翻译功能实现：集成Google Cloud Translation API替换所有mock翻译、实现APIKeyManager使用iOS Keychain安全存储API密钥、创建TranslationSettingsView提供完整的API密钥配置界面、更新RealTimeTranscriptionView使用真实翻译API、移除所有假翻译代码和mock数据、完成iPhone 16 Pro Max真机测试验证、配置API密钥`AIzaSyB4sxehiTrzITnhFejtRxC6eNpA1MJ_mfo`并确认翻译功能正常工作。
- 2025-06-21：**iOS翻译框架语言包管理策略设计** - 系统性解决翻译功能的用户体验问题：MVP阶段提前集成iOS Translation Framework、实现首次启动语言包引导、分离语言检测和翻译请求避免iOS弹窗冲突、移除录音时mock翻译改为真实状态显示、基础的历史内容翻译用户选择机制、确保录音功能优先级；同时完整规划v1.1阶段的智能历史内容处理、网络环境适配、v1.2阶段的高级语言包管理等长期优化方案。
- 2025-06-17：**MVP阶段技术方案调整** - 基于实际开发进度进行务实调整：采用UserDefaults+JSON数据存储方案、功能优先级重新划分、渐进式技术演进路径（MVP→v1.1→v1.2）、简化PlaybackSegment数据结构、优化iOS模拟器兼容性、明确技术债务和迁移计划、确保实现与设计规格一致性。
- 2025-06-15：**智能编辑系统设计** - 基于市场实践和用户行为模式设计智能编辑系统：转写和翻译文本独立编辑机制、智能重新翻译提示功能、完善的编辑状态管理、移动端触摸优化编辑体验、MVP阶段Mock功能到真实API的渐进式实现路径、符合专业转写工具用户习惯的工作流程设计。
- 2025-06-08：**v2.0 语言逻辑重构** - 简化录音界面语言设置，优化转写翻译逻辑：转写保持录音原语言，翻译自动使用系统语言，增加手动翻译选项支持特殊场景。
- 2025-06-07：完成主导航架构设计，新建MainTabView三Tab导航（Sessions/Record/Settings），优化RecordingListView功能分工，移除重复录音入口，分析TranscriptionTranslationView双面板显示逻辑并修复预览问题。
- 2025-06-07：重新设计质量评级系统，废弃事后Excellent/Good/Poor标注，规划实时录音质量监控系统，包括环境监控、录音质量分析、转写翻译质量实时评估和智能预警机制。
- 2025-05-19：优化录音列表页布局，统一列表项设计风格，简化交互逻辑。
- 2025-05-19：优化录音状态栏和底部控制区布局，提升空间利用率和交互体验。
- 2025-05-11：允许源语言和目标语言相同，若相同则仅进行转写不做翻译，相关逻辑已在功能描述中补充。
- 2025-05-11：录音日期和时间默认采用手机系统时间，时区默认为系统时区，未来可支持用户自选时区（非当前优先级）。
- 2025-05-11：录音时用户可选择转写语言和翻译目标语言，转写语言可自动识别并动态变化，翻译目标语言由用户选择并可设为默认，系统记录用户默认翻译语言，每次优先使用。页面UI突出展示默认翻译语言，用户可随时调整。
- 2025-05-11：录音主页面所有操作按钮全部图标化、圆形化，按钮位置固定，停止和重新录音按钮同位切换，界面更简洁专业。
- 2025-05-11：新增"查看转写/翻译内容"按钮，点击后根据录音语言和系统/默认翻译语言是否一致，跳转到只展示转写或上下分屏展示转写+翻译内容的页面。
- 2025-05-11：优化页面跳转和UI逻辑，保证主操作区元素位置不跳动，提升用户体验。
- 2025-05-11：所有页面按钮如有清晰图标可表达功能时仅用图标不加文字，保持极简现代风格。
- 2025-05-11：转写/翻译页面支持分屏板块长按全屏、再次长按恢复分屏，单语转写长按可弹窗选择新翻译语言并切换分屏。
- 2025-05-11：相关交互动画、弹窗、编辑与保存、无障碍等细节优化。
- 2025-05-11：分屏状态下翻译区右上角新增globe图标按钮，点击可切换翻译目标语言，交互直观、专业。
- 2025-05-11：全局多语言适配规划——一旦用户设置了翻译语言，所有交互和界面文字都应自动切换为该语言。此项为MVP后续优化目标。

---

## 🔧 MVP技术实现现状与规划

### **当前阶段: MVP核心功能实现** (已完成)
**目标**: 功能验证和稳定性优先，采用务实技术方案

#### 核心架构已实现
- **主导航架构**: MainTabView三Tab设计（Sessions/Record/Settings）
- **会话管理系统**: RecordingSessionManager + UserDefaults持久化
- **录音管理**: AudioRecordingManager实时录音控制
- **权限管理**: MicrophonePermissionManager完整权限处理
- **错误处理**: ErrorManager统一错误管理

#### 数据存储方案（当前）
- **技术选择**: UserDefaults + JSON序列化
- **优势**: 轻量级、开发快速、调试简单
- **适用场景**: MVP阶段功能验证和用户测试
- **技术债务**: 不适合复杂查询，需在v1.1迁移

#### Google Translate API集成（已完成）
- **真实翻译服务**: 完全替换mock翻译，使用Google Cloud Translation API
- **安全密钥管理**: APIKeyManager使用iOS Keychain安全存储
- **API密钥配置**: `AIzaSyB4sxehiTrzITnhFejtRxC6eNpA1MJ_mfo` (已配置并验证)
- **用户配置界面**: TranslationSettingsView提供完整的API密钥管理
- **错误处理**: 完善的网络错误和API错误处理机制
- **语言支持**: 支持中文、英文等多种语言的双向翻译

### **实时转写UI状态系统** (新增)
**目标**: 避免功能重复，通过状态指示器提供转写反馈

#### 浮动按钮状态指示器设计
**核心理念**: 在录音页面添加状态指示器，避免内联转写与单独转写页面功能重复

**状态系统规范**:
1. **默认状态** (录音开始前/完成后)
   - 颜色: 蓝色圆形背景
   - 图标: 静态文档图标 (doc.text)
   - 动画: 无
   - 徽章: 无

2. **实时转写状态** (录音进行中)
   - 颜色: 绿色圆形背景
   - 图标: 实时转写图标 (waveform.and.mic)
   - 动画: 连续脉冲动画 (持续进行)
   - 徽章: 实时更新的文字数量或转写行数

3. **暂停状态** (录音暂停中)
   - 颜色: 黄色圆形背景
   - 图标: 暂停图标 (pause.circle)
   - 动画: 无 (静态)
   - 徽章: 当前已转写内容数量

**交互逻辑**:
- 录音状态变化时，按钮状态立即同步更新
- 点击按钮可跳转到 TranscriptionTranslationView 查看详细内容
- 实时转写状态下，徽章数字实时变化，提供即时反馈
- 状态切换使用平滑动画过渡，提升用户体验

**技术实现要点**:
- 使用 SwiftUI 的 @State 管理状态变化
- 连续脉冲动画通过 `.animation(.easeInOut.repeatForever())` 实现
- 徽章数字绑定转写内容的实时数据
- 状态颜色使用系统色彩规范确保一致性

### **v1.1阶段规划: 智能化优化** (计划3个月后)
**目标**: 数据架构迁移和智能功能完善

#### 数据存储迁移
- **目标架构**: SwiftData数据管理
- **迁移策略**: UserDefaults数据导入SwiftData
- **优势**: 更好性能、复杂查询、数据版本管理
- **风险控制**: 保留UserDefaults作为备份方案

#### 编辑系统完善
- **完整PlaybackSegment**: 添加编辑历史、状态管理
- **智能编辑辅助**: 语法检查、拼写纠正
- **高级状态管理**: 冲突检测、自动保存

#### 智能语言包管理优化
- **智能历史内容处理**: 自动分批翻译、进度管理
- **网络环境适配**: WiFi/移动网络差异化策略
- **语言包存储管理**: 使用统计、自动清理建议
**转写服务**: iOS Speech Framework (优先) / Cloud Speech API (备选)

### **v2.0 产品逻辑核心**
1. **录音**: 用户自然录音，无需预设语言
2. **转写**: 自动检测录音语言，进行同语言转写
3. **翻译**: 当录音语言≠系统语言时，自动翻译成系统语言
4. **手动翻译**: 提供任意语言翻译选项，覆盖特殊场景

### **用户体验流程**
```
录音 → 转写显示 → 自动判断是否需要翻译 → 可选手动翻译
      (原语言)    (录音语言≠系统语言?)     (用户控制)
```

---

## 一、产品定位

一款面向个人和商务用户的iOS App，支持会议/采访等场景下的长时间录音，**录音、转写、翻译三者实时同步**，并支持导出和本地管理。为未来多端同步、会员收费、Web端管理等功能预留空间。  
**MVP阶段支持中文和英文界面切换。**

---

## 二、核心功能清单

### 1. 实时录音、转写、翻译
- 支持长时间录音（会议场景）
- **录音界面极简化**: 专注录音功能，无语言预设干扰
- **智能语言检测**: 录音完成后自动检测录音的实际语言
- **转写逻辑**: 使用检测到的语言进行准确转写，保持录音原语言
- **翻译逻辑**: 
  - 自动翻译条件: 录音语言 ≠ 系统默认语言
  - 翻译目标: 系统默认语言 (Locale.current.language)
  - 手动翻译: 用户可选择任意目标语言
- **分步显示**: 先显示转写结果，再显示翻译结果
- **特殊场景支持**: 
  - 语言检测错误时的手动修正
  - 同语言录音的第三语言翻译
  - 多语言学习对照需求
- **实时转写UI状态系统**: 
  - 浮动按钮状态指示器避免功能重复
  - 三种状态颜色编码: 蓝色(默认)、绿色(实时转写)、黄色(暂停)
  - 连续脉冲动画配合实时徽章数字反馈
  - 状态切换平滑过渡，点击可查看详细转写内容
- **iOS翻译框架语言包管理**（MVP阶段实现）:
  - **首次启动引导**: 检测系统语言，推荐并引导下载对应语言包
  - **翻译冲突解决**: 分离语言检测和翻译请求，避免实时翻译弹窗冲突
  - **真实状态显示**: 移除mock翻译，显示"等待语言包下载"等真实状态
  - **录音优先原则**: 翻译功能不影响录音核心功能
  - **新语言检测**: 录音过程中检测到新语言时非侵入式提示
  - **基础历史处理**: 语言包下载完成后用户手动选择是否翻译历史内容
- 录音状态栏提供录音状态信息展示
- 转写/翻译页面优化内容展示区域
- 录音列表页采用简洁布局：
  - 列表项展示录音状态图标、名称、时长和转写状态
  - 支持左滑重命名和删除操作
  - 顶部搜索栏支持按名称和时间查找
  - 空状态提供录音引导

### 2. 数据管理
- 录音、原文、译文本地保存
- **录音命名与重命名系统**：
  - **智能命名**：录音完成后自动生成基于时间的默认名称
  - **点击重命名**：支持在Sessions页面点击录音名称进行inline编辑
  - **明确操作提示**：提供Save/Cancel按钮和多种保存方式（按钮点击/回车键）
  - **重复检测**：自动检测重名情况，智能添加序号避免冲突（如"会议记录 (2)"）
  - **用户友好提示**：重名处理时弹出提示告知用户最终名称
  - **跨页面同步**：重命名后自动同步到RecordingDetailView等所有相关页面
- 支持文字内容编辑
- 支持按时间、命名、内容查询和筛选

### 3. 分享与导出功能
- **分享功能整合架构**：将导出功能归类到分享功能下，符合iOS系统设计标准
- **多格式内容支持**：
  - **简单文本分享**：录音基本信息（名称、日期、时长、语言等）
  - **详细文件导出**：完整转写翻译内容，.txt格式，支持保存到Files应用
  - **系统分享选项**：支持邮件、消息、AirDrop、剪贴板等多种分享渠道
- **智能内容适配**：根据不同分享类型自动生成适配的内容格式
- **临时文件管理**：自动创建和清理用于导出的临时文件
- 支持导出录音（mp3/wav）
- 支持导出文字（txt/csv）

### 4. 隐私保障
- 本地数据加密存储
- 预留App锁、Face ID/Touch ID空间

### 5. 多语言UI支持
- 支持中文和英文界面切换
- 用户可在设置页选择界面语言
- 所有界面文本、提示、按钮等随语言切换即时更新

### 6. 预留扩展
- 数据结构预留云同步字段
- UI/代码结构预留分享、标签、批量操作、会员收费等空间

---

## 三、用户流程（User Flow）

1. 用户首次进入App，自动采用系统语言或弹窗选择界面语言（中/英）
2. 用户进入录音列表页
3. 点击"新建录音"进入录音界面，选择录音语言和目标翻译语言
4. 点击"开始录音"，App实时将语音转为文字，并实时翻译
5. 录音界面实时显示原文和译文，用户可随时暂停/继续录音
6. 录音结束后，用户可命名、编辑录音和文字内容
7. 用户可在列表页按时间/命名/内容查询历史记录
8. 用户可导出录音和文字
9. 用户可在设置页随时切换界面语言
10. 未来可升级会员、同步到Web端、分享等

---

## 四、数据结构设计（简化版）

```plaintext
// MVP阶段数据结构（当前实现）
RecordingSession
- id: UUID
- name: String (var) // 可变字段，支持运行时重命名
- duration: TimeInterval
- date: Date
- fileSize: String
- sessionStatus: SessionStatus
- sourceLanguage: String
- targetLanguage: String?
- hasTranslation: Bool
- priority: Priority
- sessionType: RecordingType
- filePath: String
- wordCount: Int
- transcriptionQuality: TranscriptionQuality
- lastEditedAt: Date // 最后编辑时间，用于跟踪修改状态
- hasUnsavedChanges: Bool // 是否有未保存的修改

PlaybackSegment (MVP简化版)
- id: UUID
- startTime: Double
- endTime: Double
- originalText: String
- translatedText: String
- targetLanguage: String
- lastEditedAt: Date
- isEdited: Bool
- needsRetranslation: Bool

// v1.1扩展版本（计划实现）
PlaybackSegment (完整版)
- isTranscriptionEdited: Bool
- isTranslationEdited: Bool
- originalTranscription: String
- editHistory: [EditRecord]
- characterCount: Int

UserSettings
- uiLanguage: String // "zh-Hans" or "en"
- defaultTargetLanguage: String
- googleApiKeyConfigured: Bool // Google API密钥是否已配置
- translationEnabled: Bool // 翻译功能是否启用

GoogleTranslateConfiguration
- apiKey: String // 存储在Keychain中的API密钥
- baseURL: String // "https://translation.googleapis.com"
- requestTimeout: TimeInterval // 请求超时时间
- supportedLanguages: [String] // 支持的语言代码列表
```
> 说明：采用分段存储，便于实时转写、翻译和后续高亮、编辑。

---

## 五、系统架构图（MVP阶段）

```plaintext
// MVP阶段架构（当前实现）
+-------------------+         +-------------------+
|                   |         |                   |
|   iOS App (前端)  |<------->|   UserDefaults    |
|                   |         | (JSON序列化存储)  |
+-------------------+         +-------------------+
        |   |   |                        ^
        |   |   |                        |
        |   |   |                        |
        |   |   +----> iOS Translation Framework
        |   |         (语言包管理+真实翻译)
        |   |
        |   +----> iOS沙盒文件系统 (录音文件)
        |
        +----> v1.1扩展：SwiftData + 智能优化

// v1.1目标架构
+-------------------+         +-------------------+
|                   |         |                   |
|   iOS App (前端)  |<------->|   SwiftData       |
|                   |         | (本地数据库)      |
+-------------------+         +-------------------+
        |   |   |                        ^
        |   |   |                        |
        |   |   +----> Apple Speech/Translate API
        |   |         (真实转写翻译服务)
        |   |
        |   +----> 文件系统 (录音文件)
        |
        +----> v2.0扩展：Web API/云同步
```

---

## 六、开发与运行环境要求

### 1. 开发环境
- macOS 12.0 及以上
- Xcode 14.0 及以上（建议最新版，支持SwiftUI和iOS 15+）
- Swift 5.5 及以上
- Apple Developer账号（用于真机调试和后续上架）
- 推荐使用 Cursor 作为代码编辑器协作

### 2. 运行环境
- iOS 15.0 及以上（支持Apple Speech/Translate API）
- 设备需有麦克风权限
- 未来Web端建议：Node.js 18+/React 18+/PostgreSQL/SQLite

---

## 七、Cursor 协作规则（Cursor Rules）

1. **分支管理**  
   - 主分支（main/master）仅合并稳定代码
   - 每个功能/bugfix单独开分支，命名规范如：`feature/recording`、`fix/translation-bug`

2. **代码提交**  
   - 提交信息需简明扼要，格式如：`feat: 支持录音命名`、`fix: 修复转写崩溃`

3. **时间规范**  
   - 所有PRD、变更记录、日志等涉及日期的内容，除非有特殊要求，均应以实际系统时间为准，不得使用模型时间或手动推断时间。

---

## 八、录音详情页面设计规范

### **设计理念**
录音详情页面是用户查看和编辑录音内容的核心界面，实现音频播放、转写文本、翻译文本的三方实时同步，为用户提供流畅的内容查看和编辑体验。

### **页面架构**

#### **1. 音频播放控制区域**
- **录音信息显示**：录音名称、总时长、当前播放时间
- **播放控制**：播放/暂停/停止按钮（图标化设计）
- **进度控制**：可拖动的时间轴，显示当前播放位置
- **时间显示**：当前时间/总时长格式显示（00:00/00:00）

#### **2. 同步内容显示区域**
- **转写文本区域**（上方）：显示转写文字内容，支持滚动
- **翻译文本区域**（下方）：显示翻译文字内容，支持滚动
- **布局设计**：考虑手机屏幕特性，采用上下分布而非左右分布
- **时间戳同步**：每段文字都有对应的时间戳标记

#### **3. 三方同步机制（移动端优化）**
**核心原则**：音频播放位置 ↔ 转写文字位置 ↔ 翻译文字位置始终保持一致

**同步触发方式**：
- **音频拖动**：拖动音频进度条，文字内容自动滚动到对应位置
- **文字点击**：点击转写或翻译文字，音频跳转到对应时间（带3秒buffer）
- **双向滚动同步**：滚动转写文本时翻译文本自动跟随，反之亦然
- **自动跟随**：播放时文字内容自动滚动跟随播放进度

**智能音频跳转（移动端特性）**：
- **默认Buffer**：点击文字跳转到目标时间前3秒位置
- **上下文理解**：提供语音连贯性，避免突兀跳转
- **触摸优化**：考虑手指触摸精度限制，提供容错机制

**精确文字选择**：
- **段落内选择**：支持段落内特定词语或句子的精确选择
- **时间戳计算**：根据选择位置计算精确时间戳
- **计算公式**：精确时间 = startTime + (endTime - startTime) × 字符位置百分比
- **AttributedString支持**：使用iOS原生文本选择机制

**视觉反馈**：
- **高亮显示**：当前播放对应的文字段落高亮显示
- **位置指示**：清晰的当前位置指示器
- **平滑过渡**：同步调整时使用平滑动画过渡
- **触觉反馈**：点击跳转时提供轻微震动反馈

#### **4. 智能文本编辑系统**

**设计理念**：基于专业转写工具的用户行为模式，采用"独立编辑 + 智能提示"机制，避免意外覆盖用户修正，同时提供智能化编辑辅助。

**核心机制**：
- **独立编辑原则**：转写和翻译文本完全独立编辑，互不影响
- **智能提示机制**：修改转写后显示"重新翻译"建议，用户完全控制
- **编辑状态管理**：完善的编辑历史和状态标记系统
- **移动端优化**：针对触摸交互的编辑体验优化

**功能详情**：
- **内容编辑**：转写和翻译文字可以独立编辑、修改、删减
- **智能重新翻译提示**：修改转写后显示"重新翻译"按钮，用户主动选择
- **编辑状态标记**：显示哪些段落已被用户手动编辑过
- **复制功能**：支持选择和复制文字内容
- **修改状态**：编辑后显示未保存状态提示
- **保存确认**：修改后需要用户确认保存，防止意外丢失

**市场实践参考**：
- **Otter.ai模式**：转写和翻译独立编辑，避免覆盖用户修正
- **Rev模式**：提供编辑建议但不自动应用，用户完全控制
- **Descript模式**：编辑状态清晰标记，支持版本对比

### **MVP功能优先级（移动端优化）**

#### **P0 - 核心必需功能（MVP已实现）**
1. **音频播放控制**：播放/暂停/停止、进度条拖动、时间显示 ✅
2. **同步内容显示**：转写翻译文本上下分布显示 ✅
3. **智能三方同步机制**：音频、转写、翻译位置实时同步 ✅
4. **智能音频跳转**：3秒buffer缓冲跳转，提供上下文理解 ✅
5. **双向滚动同步**：转写和翻译文本滚动联动 ✅
6. **基础文本编辑系统**：独立编辑机制、基础重新翻译提示、简单编辑状态标记 ✅
7. **导航UX实现**：录音列表跳转播放，info按钮访问元数据编辑 ✅

#### **P1 - 重要功能（v1.1实现）**
1. **完整编辑历史系统**：修改历史记录、撤销重做功能、编辑冲突检测
2. **高级PlaybackSegment**：isTranscriptionEdited、isTranslationEdited、originalTranscription
3. **智能编辑辅助**：语法检查、拼写纠正、格式优化
4. **精确文字选择**：段落内精确词语选择和时间戳计算
5. **用户体验优化**：复制功能、快进快退、字体调节
6. **简化Buffer设置**：关闭/标准/较长三个选项（设置页面）
7. **智能语言包管理优化**：自动分批翻译、网络环境适配、存储管理

#### **P2 - 增强功能（v1.2+实现）**
1. **手动时间戳输入**：考虑移动端替代方案（语音输入、滑块选择）
2. **播放体验优化**：播放速度调节、循环播放、静音检测
3. **文本显示优化**：说话人标识、置信度显示
4. **搜索和导航**：文本搜索、书签功能、关键词高亮
5. **性能优化**：大文本虚拟滚动、懒加载机制

#### **P3 - 扩展功能（v2.0+或付费功能）**
1. **导出和分享**：多格式导出、分享功能
2. **编辑历史和版本**：修改历史、版本对比、撤销重做
3. **高级功能**：章节导航、全屏模式、云端同步、无障碍支持
4. **语音时间跳转**："跳转到一分三十秒"语音命令

### **技术实现要点**

#### **数据结构优化**
```plaintext
PlaybackSegment (智能编辑系统优化)
- startTime: Double
- endTime: Double
- originalText: String
- translatedText: String
- targetLanguage: String
- lastEditedAt: Date
- isTranscriptionEdited: Bool (转写是否被编辑)
- isTranslationEdited: Bool (翻译是否被编辑)
- originalTranscription: String (原始转写，用于重新翻译)
- editHistory: [EditRecord] (编辑历史记录)
- characterCount: Int (用于精确时间戳计算)
- needsRetranslation: Bool (是否需要重新翻译提示)

EditRecord (编辑历史记录)
- timestamp: Date
- editType: EditType (转写编辑/翻译编辑/重新翻译)
- beforeText: String
- afterText: String
- userId: String (预留多用户支持)
```

#### **同步算法设计**
- **时间戳映射**：建立音频时间与文本段落的精确映射关系
- **双向滚动同步**：ScrollView间的相互监听和同步机制
- **防循环标志位**：避免滚动同步的无限循环
- **精确时间计算**：段落内字符位置到时间戳的插值算法
- **性能优化**：大文本情况下的虚拟滚动和懒加载

#### **移动端交互优化**
- **触摸区域优化**：最小44pt点击区域，符合iOS设计规范
- **Buffer跳转算法**：默认3秒前置缓冲的时间计算
- **AttributedString集成**：支持段落内精确文字选择
- **触觉反馈集成**：UIImpactFeedbackGenerator的合理使用
- **手势冲突处理**：滚动、点击、长按手势的优先级管理

#### **用户体验细节**
- **响应速度**：触摸响应 < 100ms，跳转响应 < 200ms，滚动同步 < 50ms
- **动画效果**：平滑的滚动和高亮过渡动画
- **错误处理**：音频文件缺失、同步失败、网络异常的降级处理
- **状态保持**：页面切换时保持播放状态和位置
- **内存管理**：长音频文件的分段加载和及时释放

#### **兼容性和开发支持（已实现）**
- **iOS模拟器兼容**：音频文件缺失时的模拟播放机制 ✅
- **演示数据**：预设5个PlaybackSegment示例数据 ✅
- **错误降级处理**：文件系统异常的优雅处理 ✅
- **开发调试支持**：完整的控制台日志和状态追踪 ✅
- **真机测试**：完整的录音和播放功能 ✅

### **智能编辑系统实现路径**

#### **MVP阶段实现（已完成）**
1. **基础编辑界面** ✅：
   - 转写和翻译文本的独立编辑框
   - 编辑状态标记（isEdited字段）
   - 基础的保存和取消功能

2. **智能提示机制** ✅：
   - 修改转写后显示"重新翻译"按钮
   - 点击按钮显示"正在重新翻译..."状态
   - Mock翻译结果生成和显示
   - 用户可选择接受或拒绝新翻译

3. **简化状态管理** ✅：
   - 基础编辑时间记录（lastEditedAt）
   - 重新翻译需求标记（needsRetranslation）
   - UserDefaults持久化存储

#### **v1.1阶段实现（真实API集成）**
1. **真实重新翻译**：
   - 集成Apple Translate API
   - 智能检测修改内容的语义变化
   - 只对有意义的修改触发重新翻译

2. **高级编辑功能**：
   - 批量编辑和批量重新翻译
   - 编辑建议和语法检查
   - 更完善的编辑历史管理

3. **用户体验优化**：
   - 编辑冲突检测和解决
   - 自动保存和恢复
   - 编辑性能优化

#### **市场实践整合**
- **Otter.ai学习**：独立编辑避免覆盖，用户完全控制重新翻译时机
- **Rev工作流**：专业转写工具的编辑确认机制
- **Descript模式**：清晰的编辑状态标记和版本管理
- **移动端优化**：针对触摸交互的编辑体验设计

### **与现有功能的集成**
- **导航UX优化**：
  - 录音列表点击录音项 → 直接进入播放页面（主要功能）
  - 录音列表info按钮 → 进入元数据编辑页面（次要功能）
  - 解决原有点击录音打开编辑页面的UX问题
- **权限继承**：继承录音页面的麦克风权限状态
- **数据一致性**：与SwiftData存储的录音数据保持一致
- **多语言支持**：界面文本支持中英文切换
- **状态管理**：与现有录音状态管理系统的无缝集成
- **错误处理统一**：复用现有的错误处理和用户提示机制

---

## 九、iOS翻译框架语言包管理策略

### **设计理念**
基于iOS Translation Framework的"按需下载"机制，为录音转写翻译应用设计分阶段的语言包管理策略。MVP阶段解决核心冲突问题并提供基础用户引导，后续版本逐步实现智能化和自动化优化。

### **核心问题分析**
- **实时翻译冲突**: 实时转录文本变化导致iOS翻译弹窗瞬间消失
- **语言包缺失**: 用户首次使用或遇到新语言时翻译功能不可用
- **用户体验**: 确保录音功能优先，翻译功能不中断录音流程
- **Mock翻译问题**: 录音时显示无意义的假翻译内容影响用户体验

## **MVP阶段实现方案**

### **1. 首次启动语言包引导**

#### **系统语言检测和推荐**
```
用户系统语言 → 推荐语言包
中文系统 → en-zh（英语→中文）
英文系统 → zh-en（中文→英语）  
法语系统 → en-fr（英语→法语）
日语系统 → en-ja（英语→日语）
其他语言 → en-[系统语言]
```

#### **引导界面设计（MVP版本）**
```
┌─────────────────────────────┐
│ 🎙️ 欢迎使用录音转写翻译应用    │
│                            │
│ 检测到您的系统语言是中文      │
│ 建议下载英语→中文翻译包       │
│ (约15MB，需要网络连接)       │
│                            │
│ [立即下载] [稍后下载]        │
│                            │
│ 💡 可在设置中随时下载其他语言包│
└─────────────────────────────┘
```

#### **实现要点**
- 检测 `Locale.current.language` 确定系统语言
- 仅推荐一个最重要的语言包（英语↔系统语言）
- 用户可选择立即下载或稍后下载
- 提供设置页面入口管理语言包

### **2. 翻译冲突解决机制**

#### **分离语言检测和翻译请求**
```swift
// MVP实现策略
func onTranscriptionUpdate(newText: String) {
    // 仅进行语言检测，不触发翻译
    let detectedLanguage = detectLanguageOnly(newText)
    
    // 检查语言包可用性（不触发下载）
    if !isLanguagePackAvailable(detectedLanguage) {
        showLanguagePackNeededHint(detectedLanguage)
    }
}

func onUserRequestTranslation() {
    // 仅在用户明确请求时触发翻译
    performTranslationWithDownloadPrompt()
}
```

#### **录音时状态显示**
```
语言包未下载时：
┌─────────────────────────────┐
│ 🔴 录音中                    │
│                            │
│ 📝 转录内容：               │
│ Hello, how are you today?  │
│                            │
│ 🌐 翻译内容：               │
│ ⏳ 需要下载中文翻译包        │
│ [点击下载] [录音结束后下载]   │
└─────────────────────────────┘

语言包下载中：
┌─────────────────────────────┐
│ 🔴 录音中                    │
│                            │
│ 📝 转录内容：               │
│ Hello, how are you today?  │
│                            │
│ 🌐 翻译内容：               │
│ 📥 正在下载中文翻译包...     │
│ ████████░░ 80%            │
└─────────────────────────────┘
```

### **3. 新语言检测和提示**

#### **非侵入式提示机制**
```swift
func onNewLanguageDetected(language: String) {
    // 显示顶部横幅提示，不中断录音
    showTopBanner("🇫🇷 检测到法语 | 点击下载翻译包")
    
    // 记录需要下载的语言包
    pendingLanguageDownloads.append(language)
}
```

#### **录音优先原则**
- 新语言检测不中断录音流程
- 提示信息显示在非关键区域
- 用户可选择立即下载或录音结束后下载
- 录音控制按钮始终可用且优先响应

### **4. 基础历史内容处理（MVP简化版）**

#### **语言包下载完成后的处理**
```swift
func onLanguagePackDownloaded() {
    // 立即翻译新内容
    translateCurrentContent()
    
    // 询问用户是否处理历史内容
    showHistoryTranslationAlert()
}

func showHistoryTranslationAlert() {
    Alert(
        title: "语言包下载完成！",
        message: "是否翻译之前的录音内容？",
        primaryButton: .default("翻译全部") { translateAllHistory() },
        secondaryButton: .cancel("仅翻译新内容")
    )
}
```

#### **用户体验设计**
- 下载完成立即翻译当前正在录制的内容
- 简单的弹窗询问是否翻译历史内容
- 用户完全控制翻译范围
- 避免自动批量处理造成的性能问题

## **v1.1阶段优化方案**（后续实施）

### **1. 智能历史内容处理**

#### **自动分批翻译策略**
```swift
func intelligentHistoryTranslation() {
    // 优先级排序
    let segments = sortSegmentsByPriority()
    
    // 分批处理
    processBatches(segments) { batch in
        translateBatch(batch)
        updateProgress()
    }
}

func sortSegmentsByPriority() -> [PlaybackSegment] {
    // 1. 最近30秒内容（最高优先级）
    // 2. 最近5分钟内容
    // 3. 其余历史内容
}
```

#### **进度管理**
- 显示翻译进度条
- 支持暂停/恢复翻译
- 后台处理不影响新录音
- 错误重试机制

### **2. 网络环境适配**

#### **WiFi环境策略**
- 自动推荐下载多个常用语言包
- 批量下载管理
- 预估下载时间和存储空间

#### **移动网络策略**
```swift
func handleMobileNetworkDownload() {
    showDataUsageWarning("下载将消耗约15MB流量")
    
    options: [
        "使用流量下载",
        "仅WiFi下载", 
        "稍后提醒"
    ]
}
```

### **3. 语言包管理优化**

#### **存储管理**
- 显示已下载语言包列表
- 支持删除不常用语言包
- 存储空间使用统计
- 自动清理建议

#### **更新机制**
- 检测语言包更新
- 增量更新支持
- 版本兼容性管理

## **v1.2+阶段扩展方案**（长期规划）

### **1. 高级用户体验**

#### **个性化推荐**
- 基于使用历史推荐语言包
- 学习用户语言偏好
- 智能预下载机制

#### **使用统计分析**
- 语言使用频率统计
- 翻译准确度反馈
- 用户行为模式分析

### **2. 企业级功能**

#### **批量语言包管理**
- 企业统一语言包配置
- 批量部署和更新
- 使用策略管理

#### **高级错误处理**
- 网络中断恢复
- 下载失败重试策略
- 降级方案管理

### **技术实现架构**

#### **MVP阶段技术栈**
```swift
// 语言检测（不触发下载）
SFSpeechRecognizer.supportedLocales

// 语言包状态检测
Translation.Session.Configuration.isAvailable

// 用户触发的翻译下载
translationTask(source:target:) modifier
```

#### **数据结构扩展**
```swift
// MVP阶段添加
struct LanguagePackStatus {
    let sourceLanguage: String
    let targetLanguage: String
    let isDownloaded: Bool
    let downloadProgress: Double?
    let lastUsed: Date?
}

// v1.1阶段扩展
struct LanguagePackManagement {
    let availablePacks: [LanguagePackStatus]
    let downloadQueue: [LanguagePackDownloadTask]
    let usageStatistics: [LanguageUsageStats]
    let userPreferences: LanguagePreferences
}
```

### **与市场竞品的差异化优势**

#### **相比通用翻译应用**
- 专注录音转写场景的语言包管理
- 录音功能优先的设计理念
- 实时转录与翻译的无缝集成

#### **相比其他录音应用**
- 原生iOS翻译框架深度集成
- 智能语言检测和包管理
- 分阶段用户体验优化

#### **技术创新点**
- 分离语言检测和翻译请求的冲突解决方案
- 录音优先的语言包下载策略
- 渐进式用户体验设计（MVP→v1.1→v1.2）

---

## 十、v1.2版本：智能语言检测与用户引导优化设计

### **设计背景**
基于MVP版本的实际使用反馈，发现了语言检测硬编码和翻译功能过度自动化的问题。v1.2版本重新设计语言检测机制和用户引导流程，实现更智能、更用户友好的语言处理体验。

### **核心问题分析**
1. **语言检测硬编码问题**：源语言固定为英语，无法正确处理其他语言的录音
2. **翻译功能过度自动化**：强制显示翻译界面，造成同语言录音时的界面混乱
3. **用户决策疲劳**：首次引导要求用户一次性做太多复杂决策
4. **缺乏渐进式学习**：翻译功能缺乏情境化的使用引导

### **1. 智能语言检测系统设计**

#### **语言检测策略重构**
```swift
// 新的语言检测机制
struct IntelligentLanguageDetection {
    // 检测触发条件
    let detectionTriggers: DetectionTriggers
    
    // 检测结果处理
    let confidenceHandling: ConfidenceHandling
    
    // 用户偏好学习
    let preferenceMemory: PreferenceMemory
}

struct DetectionTriggers {
    let textLengthThreshold: Int = 20  // 文本长度阈值
    let timeThreshold: TimeInterval = 15  // 时间阈值
    let sessionBasedDetection: Bool = true  // 会话级检测
}

struct ConfidenceHandling {
    let highConfidence: Double = 0.8  // 直接应用
    let mediumConfidence: Double = 0.5  // 询问确认
    let lowConfidence: Double = 0.3  // 保持当前设置
}
```

#### **检测时机优化**
- **避免过度检测**：一个录音会话只检测一次
- **智能触发**：累积文本达到20字符或录音15秒后触发
- **用户控制**：提供"重新检测语言"手动选项
- **状态管理**：记录检测状态，避免重复检测

#### **检测结果处理机制**
```
高置信度(>80%) → 直接应用 + 非侵入式提示
中等置信度(50%-80%) → 显示确认对话框
低置信度(<50%) → 保持当前设置 + 建议手动选择
```

### **2. 按需翻译设计重构**

#### **翻译触发逻辑优化**
```swift
enum TranslationMode {
    case hidden           // 同语言录音，不显示翻译
    case onDemand        // 用户主动选择翻译
    case autoEnabled     // 跨语言录音，自动启用
    case userSelected    // 用户已选择目标语言
}

func determineTranslationMode() -> TranslationMode {
    if detectedLanguage == userPrimaryLanguage {
        return .hidden  // 同语言录音默认隐藏翻译
    } else {
        return .autoEnabled  // 跨语言录音自动启用
    }
}
```

#### **UI状态驱动设计**
```
状态1: 纯转录模式 (同语言录音)
┌─────────────────────────────────┐
│ 🎙️ 录音中 - 中文               │
│                                │
│ 你好，今天天气怎么样？           │
│ 我想去公园散步。                │
│                                │
│          [🌐 翻译]              │
└─────────────────────────────────┘

状态2: 翻译选择模式 (用户点击翻译)
┌─────────────────────────────────┐
│ 选择翻译目标语言：               │
│ ○ 🇺🇸 English                  │
│ ○ 🇯🇵 日本語                   │
│ ○ 🇰🇷 한국어                   │
│ [确认翻译] [取消]               │
└─────────────────────────────────┘

状态3: 跨语言自动翻译模式
┌─────────────────────────────────┐
│ 🎙️ 录音中 - 检测到英文         │
│ [切换为英文] [保持中文]         │
│                                │
│ Hello, how are you today?      │
│                                │
│ ⚡ 自动翻译为中文：              │
│ 你好，你今天怎么样？             │
│ [更改翻译语言] [关闭翻译]       │
└─────────────────────────────────┘
```

### **3. 渐进式用户引导系统**

#### **首次启动引导简化**
```
第一步：核心功能引导 (30秒内完成)
┌─────────────────────────────────┐
│         欢迎使用录音转写         │
│ 检测到您的系统语言：中文 🇨🇳     │
│                                │
│ 您主要使用什么语言录音？         │
│ ○ 中文（简体）✓                │
│ ○ English                      │
│ ○ 自动检测                     │
│                                │
│ 💡 这将作为默认转录语言         │
│         [继续]                 │
└─────────────────────────────────┘

第二步：多语言场景询问 (简化版)
┌─────────────────────────────────┐
│ 除了中文，您还会录制其他语言吗？ │
│ ○ 是的，我会录制多种语言        │
│ ○ 主要录制中文，偶尔其他语言    │
│ ○ 只录制中文 ✓                 │
│                                │
│ 💡 翻译功能可在需要时启用        │
│      [完成设置]                │
└─────────────────────────────────┘
```

#### **使用时渐进式引导**
```
首次点击翻译按钮时：
┌─────────────────────────────────┐
│          首次翻译设置           │
│ 🌐 您想将中文翻译为什么语言？    │
│ ○ 🇺🇸 English (推荐)           │
│ ○ 🇯🇵 日本語                   │
│ ○ 🇰🇷 한국어                   │
│                                │
│ ☑️ 记住此选择，下次直接翻译      │
│ ☑️ 自动下载翻译语言包           │
│    [开始翻译] [取消]            │
└─────────────────────────────────┘

检测到新语言时：
┌─────────────────────────────────┐
│        检测到新语言             │
│ 🔍 检测到英文内容               │
│ Hello, how are you?             │
│                                │
│ 选择处理方式：                  │
│ ○ 切换为英文转录模式            │
│ ○ 保持中文，自动翻译为中文      │
│ ○ 仅显示英文，不翻译            │
│                                │
│ ☑️ 记住此语言的处理方式          │
│      [确认] [稍后决定]          │
└─────────────────────────────────┘
```

### **4. 用户偏好学习与管理**

#### **数据存储设计**
```swift
// 用户偏好数据结构
struct UserLanguagePreferences {
    // 基础设置
    @AppStorage("hasCompletedOnboarding") var hasCompletedOnboarding: Bool = false
    @AppStorage("primaryLanguage") var primaryLanguage: String = "auto"
    @AppStorage("hasUsedTranslation") var hasUsedTranslation: Bool = false
    
    // 翻译偏好
    @AppStorage("preferredTranslationTargets") var preferredTargets: [String] = []
    @AppStorage("lastUsedTranslationTarget") var lastUsedTarget: String = ""
    
    // 语言检测设置
    @AppStorage("languageDetectionMode") var detectionMode: DetectionMode = .automatic
    @AppStorage("detectionSensitivity") var sensitivity: DetectionSensitivity = .medium
    
    // 使用统计
    @AppStorage("languageUsageStats") var usageStats: [String: Int] = [:]
    @AppStorage("lastUsedLanguages") var recentLanguages: [String] = []
}

enum DetectionMode: String, CaseIterable {
    case automatic = "auto"     // 自动检测并提示
    case ask = "ask"           // 检测后询问确认  
    case manual = "manual"     // 仅手动切换
}

enum DetectionSensitivity: String, CaseIterable {
    case high = "high"         // 少量文本即检测
    case medium = "medium"     // 适量文本后检测
    case low = "low"          // 大量文本后检测
}
```

#### **智能推荐算法**
```swift
func getRecommendedTranslationLanguages() -> [String] {
    var recommendations: [String] = []
    
    // 1. 用户最近使用的语言
    recommendations.append(contentsOf: recentLanguages.prefix(2))
    
    // 2. 使用频率最高的语言
    let frequentLanguages = usageStats.sorted { $0.value > $1.value }
        .prefix(3).map { $0.key }
    recommendations.append(contentsOf: frequentLanguages)
    
    // 3. 系统语言相关的常用语言
    recommendations.append(contentsOf: getSystemLanguageDefaults())
    
    // 去重并返回前5个
    return Array(Set(recommendations)).prefix(5).map { $0 }
}
```

### **5. 引导触发条件与状态管理**

#### **引导触发逻辑**
```swift
class OnboardingManager: ObservableObject {
    @Published var shouldShowOnboarding: Bool = false
    @Published var shouldShowTranslationGuide: Bool = false
    @Published var shouldShowLanguageSwitchGuide: Bool = false
    
    func checkOnboardingNeeds() {
        // 首次启动检查
        if !UserDefaults.standard.bool(forKey: "hasCompletedOnboarding") {
            shouldShowOnboarding = true
            return
        }
        
        // 首次翻译检查
        if !UserDefaults.standard.bool(forKey: "hasUsedTranslation") {
            // 等待用户点击翻译按钮时触发
        }
        
        // 新语言检测检查
        // 在检测到与主语言不同的语言时触发
    }
}
```

#### **状态流转设计**
```
应用启动 → 检查引导状态 → 显示相应引导
    ↓
录音开始 → 语言检测 → 更新语言状态
    ↓
用户点击翻译 → 首次翻译引导 → 记录使用状态
    ↓
检测到新语言 → 语言切换引导 → 更新偏好设置
```

### **6. 技术实现要点**

#### **语言检测优化**
```swift
class IntelligentLanguageDetector {
    private var lastDetectionTime: Date?
    private var detectionCache: [String: String] = [:]
    private let minimumDetectionInterval: TimeInterval = 10
    
    func detectLanguage(from text: String) -> String? {
        // 避免频繁检测
        guard shouldPerformDetection() else { return nil }
        
        // 使用缓存
        if let cached = detectionCache[text] {
            return cached
        }
        
        // 执行检测
        let result = performNSLinguisticTagging(text)
        
        // 更新缓存和时间
        detectionCache[text] = result
        lastDetectionTime = Date()
        
        return result
    }
    
    private func shouldPerformDetection() -> Bool {
        guard let lastTime = lastDetectionTime else { return true }
        return Date().timeIntervalSince(lastTime) > minimumDetectionInterval
    }
}
```

#### **UI状态管理**
```swift
class TranslationUIState: ObservableObject {
    @Published var mode: TranslationMode = .hidden
    @Published var isLanguageSelectionVisible: Bool = false
    @Published var isTranslating: Bool = false
    @Published var translatedText: String = ""
    
    func updateMode(based detectedLanguage: String, primaryLanguage: String) {
        if detectedLanguage == primaryLanguage {
            mode = .hidden
        } else {
            mode = .autoEnabled
        }
    }
    
    func handleTranslationRequest() {
        if mode == .hidden {
            isLanguageSelectionVisible = true
        } else {
            performTranslation()
        }
    }
}
```

### **7. 用户体验优化细节**

#### **非侵入式提示设计**
- **Toast提示**：语言检测结果的轻量提示
- **状态指示器**：录音界面的语言状态显示
- **可选择性**：所有自动化行为都可以用户控制
- **可逆性**：用户可以撤销自动检测结果

#### **性能优化策略**
- **检测节流**：避免频繁的语言检测调用
- **缓存机制**：相同文本的检测结果缓存
- **异步处理**：语言检测不阻塞录音功能
- **内存管理**：及时清理检测缓存和历史数据

#### **错误处理与降级**
- **检测失败**：回退到用户设定的主语言
- **网络异常**：本地语言检测优先
- **用户取消**：保持当前设置不变
- **系统限制**：适配不同iOS版本的API差异

### **8. 与现有功能的集成**

#### **数据迁移策略**
```swift
class DataMigrationManager {
    func migrateToV12() {
        // 迁移现有的语言设置
        migrateLanguageSettings()
        
        // 初始化新的偏好设置
        initializeUserPreferences()
        
        // 更新数据结构
        updateRecordingDataStructure()
    }
    
    private func migrateLanguageSettings() {
        // 将硬编码的英语设置迁移到用户偏好
        if let existingSettings = loadLegacySettings() {
            UserLanguagePreferences.primaryLanguage = existingSettings.sourceLanguage
            UserLanguagePreferences.preferredTargets = [existingSettings.targetLanguage]
        }
    }
}
```

#### **向后兼容性**
- **数据结构兼容**：保持现有录音数据的完整性
- **API兼容**：现有翻译功能的平滑升级
- **用户习惯**：最小化对现有用户工作流的影响

### **9. 测试与验证策略**

#### **功能测试场景**
1. **首次启动测试**：验证引导流程的完整性和正确性
2. **语言检测测试**：测试各种语言的检测准确度
3. **翻译触发测试**：验证按需翻译的触发时机
4. **偏好学习测试**：验证用户行为的学习和记忆
5. **异常处理测试**：测试各种错误情况的处理

#### **用户体验测试**
- **新用户体验**：从零开始的完整使用流程
- **老用户升级**：现有用户的功能迁移体验
- **多语言场景**：复杂语言环境下的功能表现
- **网络环境测试**：不同网络条件下的功能可用性

### **10. 后续版本规划**

#### **v1.3预期优化**
- **智能语言学习**：基于用户行为的语言使用模式学习
- **批量语言处理**：历史录音的批量语言检测和翻译
- **高级用户设置**：更细粒度的语言检测和翻译控制

#### **v2.0展望**
- **多模态语言识别**：结合语音特征和文本内容的综合识别
- **个性化翻译引擎**：根据用户领域和习惯优化的翻译质量
- **跨设备偏好同步**：用户语言偏好的云端同步

---

## 总结

v1.2版本的智能语言检测与用户引导优化，通过重新设计语言检测机制、优化翻译触发逻辑、简化用户引导流程，解决了MVP版本中的核心用户体验问题。这个版本的设计理念是"智能而不强加、简单而不简陋"，在提供智能化功能的同时，确保用户始终拥有完全的控制权。

核心价值：
1. **解决技术债务**：修复语言检测硬编码问题
2. **优化用户体验**：减少界面混乱，提供按需功能
3. **简化决策流程**：降低用户认知负担
4. **建立学习机制**：为未来的智能化优化奠定基础

这个设计为录音转写应用提供了更加成熟和用户友好的语言处理体验，是从MVP功能验证向产品化迈进的重要一步。