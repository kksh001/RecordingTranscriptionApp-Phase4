# GitHub 集成规则文档

## 1. 配置文件

### 1.1 基本配置
- 配置文件位置：`/Users/kamakomawu/.cursor/mcp.json`
- 文件权限：600 (仅所有者可读写)
- 所有者：kamakomawu:staff

### 1.2 配置文件结构
```json
{
    "GITHUB_PERSONAL_ACCESS_TOKEN": "your_token_here",
    "settings": {
        "auto_auth": true,
        "token_check_interval": "daily"
    }
}
```

## 2. GitHub Token 管理

### 2.1 Token 要求
- 格式：以 `ghp_YOUR_TOKEN_HERE` 或 `ghs_` 开头，后跟36个字符
- 权限：repo (全部)，workflow，admin:org
- 有效期：建议90天，最少30天

### 2.2 Token 获取方法（2025年6月更新）

#### 2.2.1 生成新Token
1. 访问 GitHub Settings > Developer settings > Personal access tokens
2. 选择 "Tokens (classic)"
3. 点击 "Generate new token (classic)"
4. 设置权限：
   - `repo` (完整仓库权限)
   - `workflow` (工作流权限)
   - `admin:org` (组织管理权限，如需要)
5. 设置过期时间：建议90天
6. 生成并复制token

#### 2.2.2 Token 本地保存方法
```bash
# 1. 保存到项目根目录（推荐）
echo "ghp_YOUR_TOKEN_HERE" > .github_token
chmod 600 .github_token
echo ".github_token" >> .gitignore

# 2. 保存到全局配置
echo "ghp_YOUR_TOKEN_HERE" > ~/.github_token
chmod 600 ~/.github_token

# 3. 验证token有效性
AUTH_TOKEN=$(cat .github_token)
curl -H "Authorization: token ${AUTH_TOKEN}" https://api.github.com/user
```

### 2.3 Token 检查
- 定期检查：每日自动检查token有效性
- 警告阈值：
  - 警告：剩余30天
  - 严重：剩余7天
  - 临界：剩余3天

### 2.4 Token 更新流程
1. 生成新token：
   - 访问 GitHub Settings > Developer settings > Personal access tokens
   - 选择 "Tokens (classic)"
   - 点击 "Generate new token"

2. 更新配置：
```bash
# 1. 更新本地token文件
echo "new_token_here" > .github_token

# 2. 更新 mcp.json
sed -i '' "s/GITHUB_PERSONAL_ACCESS_TOKEN\": \".*\"/GITHUB_PERSONAL_ACCESS_TOKEN\": \"新token\"/" ~/.cursor/mcp.json

# 3. 验证更新
source ~/.cursor/scripts/test_token.sh
```

## 3. 安全规范

### 3.1 文件安全
- 配置文件权限：600
- 脚本文件权限：755
- 目录权限：700

### 3.2 Token 安全
- 禁止在代码中硬编码token
- 禁止在日志中打印token
- 禁止在公共场合分享token
- 使用 `.gitignore` 防止token文件被提交

### 3.3 日志管理
- 日志位置：`/Users/kamakomawu/.cursor/logs/mcp.log`
- 日志轮转：每周，保留4周
- 日志权限：600

## 4. 集成功能

### 4.1 自动认证
- 启用条件：配置文件中 `auto_auth` 为 true
- 触发时机：Git操作前自动验证
- 失败处理：阻止未授权操作

### 4.2 Token 验证
- 验证时机：
  - Git操作前
  - 定期检查
  - 手动触发
- 验证内容：
  - 文件存在性
  - Token格式
  - Token有效性
  - 权限范围

### 4.3 通知机制
- 通知方式：
  - 终端提示
  - 系统通知
- 通知场景：
  - Token即将过期
  - 验证失败
  - 权限不足

## 5. 维护和监控

### 5.1 定期维护
```bash
# 1. 备份配置
backup_dir="$HOME/.cursor/backups/$(date +%Y%m%d)"
mkdir -p "$backup_dir"
cp ~/.cursor/mcp.json "$backup_dir/"
cp ~/.cursor/settings.json "$backup_dir/"

# 2. 检查文件权限
chmod 600 ~/.cursor/mcp.json
chmod 600 ~/.cursor/settings.json
```

### 5.2 日志管理
```bash
# 日志目录
/Users/kamakomawu/.cursor/logs/
├── mcp.log
└── token_check.log

# 备份目录
/Users/kamakomawu/.cursor/backups/
├── YYYYMMDD/
│   ├── mcp.json
│   └── settings.json
```

### 5.3 权限维护
```bash
# 设置日志目录权限
chown -R kamakomawu:staff /Users/kamakomawu/.cursor/logs/
chmod 700 /Users/kamakomawu/.cursor/logs/
chmod 600 /Users/kamakomawu/.cursor/logs/*.log

# 设置备份目录权限
chown -R kamakomawu:staff /Users/kamakomawu/.cursor/backups/
chmod 700 /Users/kamakomawu/.cursor/backups/
```

## 6. 故障排除

### 6.1 常见问题
1. Token 验证失败
   - 检查token格式
   - 验证token权限
   - 确认token未过期

2. 权限问题
   - 检查文件权限
   - 确认用户所有权
   - 验证目录权限

3. 配置问题
   - 验证配置文件格式
   - 检查必要字段
   - 确认路径正确

### 6.2 诊断命令
```bash
# 检查配置
cat ~/.cursor/mcp.json | jq .

# 验证token
~/.cursor/scripts/test_token.sh

# 检查权限
ls -la ~/.cursor/
```

## 7. IP调用方法（2025年6月更新）

### 7.1 概述
当通过域名调用GitHub API遇到网络问题时，可以直接使用IP地址调用GitHub API。这种方法特别适用于网络环境受限的情况。

### 7.2 核心参数（已验证有效）
```bash
# GitHub API IP地址（2025年6月验证有效）
IP="20.205.243.168"

# 必需的请求头
HOST="api.github.com"

# 当前有效Token示例（需要替换为您的token）
AUTH_TOKEN="ghp_YOUR_TOKEN_HERE"

# 从本地文件读取token的方法
AUTH_TOKEN=$(cat .github_token)
```

### 7.3 调用示例

#### 7.3.1 验证token有效性
```bash
# 测试token是否有效
curl -k \
  -H "Host: api.github.com" \
  -H "Authorization: token ${AUTH_TOKEN}" \
  -H "Accept: application/vnd.github.v3+json" \
  "https://${IP}/user"
```

#### 7.3.2 获取仓库内容
```bash
# 获取文件内容和SHA值
curl -k \
  -H "Host: api.github.com" \
  -H "Authorization: token ${AUTH_TOKEN}" \
  -H "Accept: application/vnd.github.v3+json" \
  "https://${IP}/repos/kksh001/RecordingTranscriptionApp/contents/README.md?ref=master"
```

#### 7.3.3 推送文件到仓库（完整流程）

##### 创建新文件
```bash
# 1. 准备文件内容（转换为base64）
CONTENT=$(base64 -i yourfile.txt | tr -d '\n')

# 2. 创建新文件
curl -k \
  -X PUT \
  -H "Host: api.github.com" \
  -H "Authorization: token ${AUTH_TOKEN}" \
  -H "Accept: application/vnd.github.v3+json" \
  -H "Content-Type: application/json" \
  -d "{
    \"message\": \"Add new file\",
    \"content\": \"${CONTENT}\",
    \"branch\": \"master\"
  }" \
  "https://${IP}/repos/kksh001/RecordingTranscriptionApp/contents/path/to/newfile.txt"
```

##### 更新现有文件
```bash
# 1. 获取现有文件的SHA值
SHA=$(curl -k \
  -H "Host: api.github.com" \
  -H "Authorization: token ${AUTH_TOKEN}" \
  -H "Accept: application/vnd.github.v3+json" \
  "https://${IP}/repos/kksh001/RecordingTranscriptionApp/contents/path/to/file.txt?ref=master" \
  | jq -r '.sha')

# 2. 准备新的文件内容
CONTENT=$(base64 -i updated_file.txt | tr -d '\n')

# 3. 更新文件
curl -k \
  -X PUT \
  -H "Host: api.github.com" \
  -H "Authorization: token ${AUTH_TOKEN}" \
  -H "Accept: application/vnd.github.v3+json" \
  -H "Content-Type: application/json" \
  -d "{
    \"message\": \"Update file\",
    \"content\": \"${CONTENT}\",
    \"sha\": \"${SHA}\",
    \"branch\": \"master\"
  }" \
  "https://${IP}/repos/kksh001/RecordingTranscriptionApp/contents/path/to/file.txt"
```

### 7.4 完整推送脚本示例

#### 7.4.1 单文件推送脚本
```bash
#!/bin/bash
# push_file.sh - 推送单个文件到GitHub

set -e

# 配置
IP="20.205.243.168"
REPO="kksh001/RecordingTranscriptionApp"
BRANCH="master"

# 从本地文件读取token
if [ -f ".github_token" ]; then
    AUTH_TOKEN=$(cat .github_token)
else
    echo "错误: 未找到 .github_token 文件"
    exit 1
fi

# 参数检查
if [ $# -ne 3 ]; then
    echo "用法: $0 <本地文件路径> <远程文件路径> <提交信息>"
    echo "示例: $0 README.md README.md \"更新README文档\""
    exit 1
fi

LOCAL_FILE="$1"
REMOTE_PATH="$2"
COMMIT_MESSAGE="$3"

# 检查本地文件是否存在
if [ ! -f "$LOCAL_FILE" ]; then
    echo "错误: 本地文件 $LOCAL_FILE 不存在"
    exit 1
fi

echo "开始推送文件: $LOCAL_FILE -> $REMOTE_PATH"

# 1. 检查远程文件是否存在，获取SHA值
echo "检查远程文件状态..."
RESPONSE=$(curl -k -s \
  -H "Host: api.github.com" \
  -H "Authorization: token ${AUTH_TOKEN}" \
  -H "Accept: application/vnd.github.v3+json" \
  "https://${IP}/repos/${REPO}/contents/${REMOTE_PATH}?ref=${BRANCH}")

# 检查是否返回了有效的JSON
if echo "$RESPONSE" | jq -e '.sha' > /dev/null 2>&1; then
    SHA=$(echo "$RESPONSE" | jq -r '.sha')
    echo "文件已存在，SHA: $SHA"
    UPDATE_EXISTING=true
else
    echo "文件不存在，将创建新文件"
    UPDATE_EXISTING=false
fi

# 2. 准备文件内容
echo "准备文件内容..."
CONTENT=$(base64 -i "$LOCAL_FILE" | tr -d '\n')

# 3. 构建请求数据
if [ "$UPDATE_EXISTING" = true ]; then
    REQUEST_DATA="{
        \"message\": \"$COMMIT_MESSAGE\",
        \"content\": \"$CONTENT\",
        \"sha\": \"$SHA\",
        \"branch\": \"$BRANCH\"
    }"
else
    REQUEST_DATA="{
        \"message\": \"$COMMIT_MESSAGE\",
        \"content\": \"$CONTENT\",
        \"branch\": \"$BRANCH\"
    }"
fi

# 4. 推送文件
echo "推送文件到GitHub..."
PUSH_RESPONSE=$(curl -k -s \
  -X PUT \
  -H "Host: api.github.com" \
  -H "Authorization: token ${AUTH_TOKEN}" \
  -H "Accept: application/vnd.github.v3+json" \
  -H "Content-Type: application/json" \
  -d "$REQUEST_DATA" \
  "https://${IP}/repos/${REPO}/contents/${REMOTE_PATH}")

# 5. 检查推送结果
if echo "$PUSH_RESPONSE" | jq -e '.commit.sha' > /dev/null 2>&1; then
    COMMIT_SHA=$(echo "$PUSH_RESPONSE" | jq -r '.commit.sha')
    echo "✅ 推送成功!"
    echo "提交SHA: $COMMIT_SHA"
    echo "文件URL: https://github.com/${REPO}/blob/${BRANCH}/${REMOTE_PATH}"
else
    echo "❌ 推送失败!"
    echo "错误信息:"
    echo "$PUSH_RESPONSE" | jq .
    exit 1
fi
```

### 7.5 参数说明

#### 7.5.1 必需参数
- **IP地址**: `20.205.243.168` - GitHub API服务器IP（2025年6月验证有效）
- **Host头**: `api.github.com` - 指定访问的主机名
- **Authorization**: `token ${AUTH_TOKEN}` - 身份验证token
- **Accept头**: `application/vnd.github.v3+json` - API版本

#### 7.5.2 重要注意事项
- **-k**: 必须使用，跳过SSL证书验证（因为IP访问时证书域名不匹配）
- **Content编码**: 文件内容必须进行base64编码
- **SHA值**: 更新现有文件时必须提供正确的SHA值
- **分支名**: 确认使用正确的分支名（master 或 main）

### 7.6 使用场景

#### 7.6.1 适用情况
- DNS解析问题导致无法访问api.github.com
- 网络代理或防火墙阻止域名访问
- 需要绕过某些网络限制
- 提高API调用的稳定性
- 自动化脚本中的可靠推送

#### 7.6.2 成功案例
- ✅ 2025年6月21日成功推送 RecordingTranscriptionApp_PRD.md
- ✅ 2025年6月21日成功推送 RealTimeTranscriptionView.swift
- ✅ 验证token `ghp_YOUR_TOKEN_HERE` 有效

### 7.7 故障排除

#### 7.7.1 常见错误及解决方案

1. **SSL证书错误**
   ```bash
   # 错误: SSL certificate problem
   # 解决方案: 必须添加 -k 参数
   curl -k -H "Host: api.github.com" ...
   ```

2. **Host头缺失**
   ```bash
   # 错误: {"message":"Not Found","documentation_url":"..."}
   # 解决方案: 确保包含Host头
   curl -H "Host: api.github.com" ...
   ```

3. **认证失败**
   ```bash
   # 错误: {"message":"Bad credentials","documentation_url":"..."}
   # 解决方案: 检查token格式和权限
   echo $AUTH_TOKEN | wc -c  # 应该是41个字符（包括换行符）
   ```

4. **文件编码错误**
   ```bash
   # 错误: {"message":"content is not valid Base64","documentation_url":"..."}
   # 解决方案: 确保正确的base64编码
   base64 -i file.txt | tr -d '\n'  # 移除换行符
   ```

5. **SHA值不匹配**
   ```bash
   # 错误: {"message":"sha does not match","documentation_url":"..."}
   # 解决方案: 重新获取最新的SHA值
   curl -k -H "Host: api.github.com" -H "Authorization: token $TOKEN" \
        "https://$IP/repos/owner/repo/contents/path?ref=branch" | jq -r '.sha'
   ```

## 8. 目录结构

### 8.1 基本结构
```
~/.cursor/
├── mcp.json                # MCP 配置 (600)
├── settings.json           # IDE 设置 (600)
├── scripts/               # 脚本目录 (700)
│   ├── github_token_validator.sh
│   ├── check_token_expiry.sh
│   ├── test_token.sh
│   ├── push_file.sh       # 单文件推送脚本
│   └── push_multiple_files.sh  # 批量推送脚本
├── logs/                  # 日志目录 (700)
│   └── mcp.log
└── backups/              # 备份目录 (700)

# 项目目录结构
project_root/
├── .github_token          # GitHub token (600)
├── .gitignore            # 包含 .github_token
├── GITHUB_INTEGRATION_RULES.md
└── 其他项目文件...
```

### 8.2 权限说明
- 配置文件：600 (kamakomawu:staff)
- 脚本文件：755 (kamakomawu:staff)
- 目录权限：700 (kamakomawu:staff)
- Token文件：600 (kamakomawu:staff)

## 9. 环境变量

### 9.1 必要变量
```bash
export PATH="/Users/kamakomawu/.cursor/bin:$PATH"
export GITHUB_API_URL="https://api.github.com"
export GITHUB_API_IP="20.205.243.168"
export CURSOR_HOME="/Users/kamakomawu/.cursor"
```

### 9.2 可选变量
```bash
export CURSOR_LOG_LEVEL="INFO"
export CURSOR_BACKUP_DAYS="28"
export CURSOR_TOKEN_CHECK_INTERVAL="daily"
export GITHUB_DEFAULT_BRANCH="master"
```

## 10. 测试规范

### 10.1 基本测试
- Token格式测试
- 权限验证测试
- 配置完整性测试
- IP连接测试

### 10.2 集成测试
- GitHub API 集成测试
- Git操作集成测试
- 通知系统测试
- 文件推送测试

### 10.3 自动化测试
```bash
# 运行所有测试
~/.cursor/scripts/test_scenarios.sh

# 运行特定测试
~/.cursor/scripts/test_token.sh
~/.cursor/scripts/test_warning.sh
~/.cursor/scripts/github_api_test.sh

# 测试推送功能
~/.cursor/scripts/push_file.sh test.txt test.txt "测试推送"
```

## 11. 更新记录

### 11.1 2025年6月21日更新
- ✅ 新增token本地保存方法（.github_token文件）
- ✅ 更新IP调用方法，验证IP `20.205.243.168` 有效
- ✅ 新增完整的文件推送流程和脚本
- ✅ 添加批量推送功能
- ✅ 完善错误处理和故障排除指南
- ✅ 验证token `ghp_YOUR_TOKEN_HERE` 有效
- ✅ 成功推送示例：PRD文档和Swift代码文件

### 11.2 验证状态
- ✅ GitHub API IP地址：20.205.243.168（可用）
- ✅ Token格式：ghp_YOUR_TOKEN_HERE开头36字符（正确）
- ✅ 推送功能：curl API方式（正常）
- ✅ 权限配置：repo权限（充足）
- ✅ 分支名称：master（确认） 