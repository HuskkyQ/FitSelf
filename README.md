# FitSelf

一款 iOS 原生健身数据追踪与饮食管理应用。

## 功能概览

### 📊 今日首页
- 三环进度展示（卡路里 / 运动 / 饮水）
- 快捷操作按钮（记录运动、记录饮食、称体重）
- 步数和卡路里统计卡片
- 每日建议提示

### 🏋️ 运动记录
- 支持力量训练、有氧运动、柔韧拉伸、球类运动、水上运动、户外运动 6 大分类
- 力量训练详情：动作 → 组数两级结构，支持重量/次数/RPE/休息时间记录
- 55+ 预置运动类型（含 MET 值）
- 训练中实时计时、组数统计、总容量计算
- 训练历史记录

### 🍽️ 饮食管理
- 四餐记录（早餐 / 午餐 / 晚餐 / 加餐）
- 50+ 预置常见食物（含每 100g 营养数据）
- 食物搜索与自定义录入
- 每日宏量营养素追踪（碳水 / 蛋白质 / 脂肪）
- 卡路里剩余摄入环形进度

### 📈 趋势分析
- 体重趋势折线图
- 热量趋势柱状图
- 支持周 / 月 / 3 月 / 年时间范围切换

### ⚙️ 设置
- 个人信息管理（昵称、性别、生日、身高、目标体重）
- 每日目标设置（卡路里 / 运动时长 / 饮水量）— 垂直卡片布局 + 进度条
- 宏量营养素比例调节
- 通知提醒开关
- 单位与主题设置

## 技术栈

| 技术 | 说明 |
|------|------|
| Swift | 主要开发语言 |
| SwiftUI | 声明式 UI 框架 |
| SwiftData | 本地数据持久化 + iCloud 同步 |
| Swift Charts | 趋势图表 |
| MVVM + Repository | 架构模式 |

## 设计规范

- **深色模式** 默认，背景 `#0A0A0A`，卡片 `#1A1A1A`
- **主色** 能量橙 `#F97316`，**强调色** 成功绿 `#22C55E`
- **字体层级** Hero (34) → Title1 (28) → Title2 (22) → Title3 (17) → Body (17) → Callout (16) → Subhead (15) → Footnote (13) → Caption (11)

## 项目结构

```
FitSelf/
├── App/                    # 入口与导航
│   ├── FitSelfApp.swift
│   ├── ContentView.swift
│   └── MainTabView.swift
├── Models/                 # SwiftData 数据模型
│   ├── UserProfile.swift
│   ├── Workout.swift
│   ├── Food.swift
│   ├── BodyMeasurement.swift
│   └── WaterEntry.swift
├── Repositories/           # 数据访问层
├── ViewModels/             # 视图模型层
├── Views/                  # SwiftUI 视图
│   ├── Today/
│   ├── Workout/
│   ├── Nutrition/
│   ├── Trends/
│   ├── Settings/
│   └── Onboarding/
├── Components/             # 可复用组件
├── Extensions/             # Swift 扩展
└── Stores/                 # 数据种子与常量
```

## 开发环境

- Xcode 16+
- iOS 17.0+
- Swift 5.9+

## 构建与运行

```bash
# 使用 xcodegen 生成项目
xcodegen generate

# 或直接打开已生成的 .xcodeproj
open FitSelf.xcodeproj
```