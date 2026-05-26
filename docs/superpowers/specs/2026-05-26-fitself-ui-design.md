# FitSelf — iOS UI/UX 设计规范文档

## 1. 设计系统概览

### 1.1 设计理念

FitSelf 以「数据驱动、清晰轻量」为核心设计理念。用户打开App的第一眼就能看到关键数据，操作路径最短化，视觉层次分明。整体风格采用 **Flat Design（扁平设计）**，搭配运动感的橙色主色调，传递活力与专业感。

### 1.2 设计风格：Flat Design

| 属性 | 说明 |
|------|------|
| 风格 | Flat Design（扁平设计） |
| 模式支持 | ✅ 浅色模式（完整）· ✅ 深色模式（完整） |
| 关键词 | 2D、极简、鲜明色块、无阴影、干净线条、简洁图形、排版优先、现代 |
| 适用场景 | 移动App、数据仪表盘、健康管理、初创MVP |
| 性能 | ⚡ 优秀 |
| 无障碍 | ✅ WCAG AAA |

**设计原则：**
- 不使用渐变和投影（保持扁平纯粹）
- 动效使用颜色/透明度变化（150-200ms ease）
- 图标简洁线性，统一stroke宽度
- 大量留白，信息层次靠字号和颜色区分
- 圆角统一 12pt（卡片）/ 8pt（按钮/输入框）

---

## 2. 色彩系统

### 2.1 主色板

采用适配健身场景的「能量橙+成功绿」配色方案，深色背景优先（适合运动场景的暗光环境），同时提供完整浅色模式。

#### 深色模式（默认）

| Token | 色值 | 用途 |
|-------|------|------|
| `--color-primary` | #F97316 | 主色：Tab选中、CTA按钮、进度环 |
| `--color-on-primary` | #0F172A | 主色上的文字 |
| `--color-secondary` | #FB923C | 次色：辅助高亮、次要标签 |
| `--color-accent` | #22C55E | 强调色：达成目标、成功状态、正变化 |
| `--color-on-accent` | #0F172A | 强调色上的文字 |
| `--color-background` | #1F2937 | 页面背景 |
| `--color-foreground` | #F8FAFC | 主文字 |
| `--color-card` | #313742 | 卡片背景 |
| `--color-card-foreground` | #F8FAFC | 卡片内文字 |
| `--color-muted` | #37414F | 次要背景、分割线 |
| `--color-muted-foreground` | #94A3B8 | 次要文字 |
| `--color-border` | #374151 | 边框 |
| `--color-destructive` | #EF4444 | 错误/删除 |
| `--color-on-destructive` | #FFFFFF | 错误色上的文字 |
| `--color-ring` | #F97316 | 焦点环 |

#### 浅色模式

| Token | 色值 | 用途 |
|-------|------|------|
| `--color-primary` | #EA580C | 主色（深色版适配浅底） |
| `--color-on-primary` | #FFFFFF | 主色上的文字 |
| `--color-secondary` | #F97316 | 次色 |
| `--color-accent` | #16A34A | 强调色（深色版适配浅底） |
| `--color-on-accent` | #FFFFFF | 强调色上的文字 |
| `--color-background` | #F8FAFC | 页面背景 |
| `--color-foreground` | #0F172A | 主文字 |
| `--color-card` | #FFFFFF | 卡片背景 |
| `--color-card-foreground` | #0F172A | 卡片内文字 |
| `--color-muted` | #F1F5F9 | 次要背景 |
| `--color-muted-foreground` | #64748B | 次要文字 |
| `--color-border` | #E2E8F0 | 边框 |
| `--color-destructive` | #DC2626 | 错误/删除 |
| `--color-on-destructive` | #FFFFFF | 错误色上的文字 |

### 2.2 语义色彩

| 语义 | 深色模式 | 浅色模式 | 用途 |
|------|----------|----------|------|
| 成功 | #22C55E / #16A34A | #16A34A / #22C55E | 目标达成、正变化 |
| 警告 | #F59E0B | #D97706 | 提醒、接近目标 |
| 错误 | #EF4444 | #DC2626 | 超标、数据异常 |
| 信息 | #3B82F6 | #2563EB | 提示、说明 |

### 2.3 数据可视化色板

用于图表和多数据系列场景：

| 系列 | 色值 | 用途 |
|------|------|------|
| Series 1 | #F97316 | 卡路里/主数据 |
| Series 2 | #22C55E | 运动/达成 |
| Series 3 | #3B82F6 | 饮水/蓝色 |
| Series 4 | #F59E0B | 碳水/黄色 |
| Series 5 | #EC4899 | 脂肪/粉色 |
| Series 6 | #8B5CF6 | 蛋白质/紫色 |

### 2.4 SwiftUI 颜色扩展

```swift
import SwiftUI

extension Color {
    // MARK: - 语义颜色 (支持浅色/深色自动切换)
    static let appPrimary = Color("AppPrimary")
    static let appOnPrimary = Color("AppOnPrimary")
    static let appSecondary = Color("AppSecondary")
    static let appAccent = Color("AppAccent")
    static let appOnAccent = Color("AppOnAccent")
    static let appBackground = Color("AppBackground")
    static let appForeground = Color("AppForeground")
    static let appCard = Color("AppCard")
    static let appCardForeground = Color("AppCardForeground")
    static let appMuted = Color("AppMuted")
    static let appMutedForeground = Color("AppMutedForeground")
    static let appBorder = Color("AppBorder")
    static let appDestructive = Color("AppDestructive")
    static let appOnDestructive = Color("AppOnDestructive")
    static let appRing = Color("AppRing")

    // MARK: - 语义色
    static let appSuccess = Color("AppSuccess")
    static let appWarning = Color("AppWarning")
    static let appError = Color("AppError")
    static let appInfo = Color("AppInfo")

    // MARK: - 图表色
    static let chartCalories = Color(hex: "F97316")
    static let chartExercise = Color(hex: "22C55E")
    static let chartWater = Color(hex: "3B82F6")
    static let chartCarbs = Color(hex: "F59E0B")
    static let chartFat = Color(hex: "EC4899")
    static let chartProtein = Color(hex: "8B5CF6")
}
```

在 Asset Catalog 中为每个语义颜色创建 Light/Dark 两个变体。

---

## 3. 字体系统

### 3.1 字体选择

采用 **SF Pro**（Apple 系统字体）作为主字体，兼顾中文显示和动态字体支持。

| 角色 | 字体 | 字重 | 说明 |
|------|------|------|------|
| 大标题 | SF Pro Display | Bold (700) | 数据大数字、页面标题 |
| 标题 | SF Pro Display | Semibold (600) | Section标题、卡片标题 |
| 副标题 | SF Pro Text | Medium (500) | Tab标题、列表项标题 |
| 正文 | SF Pro Text | Regular (400) | 正文内容、描述 |
| 辅助文字 | SF Pro Text | Light (300) | 时间戳、注释 |

> **为什么不选Barlow Condensed？** Barlow Condensed是优秀的运动风字体，但作为iOS原生App，使用SF Pro可获得：1) 完美的中文支持 2) Dynamic Type动态字体 3) 系统级优化 4) 零额外下载体积。品牌个性通过排版层级和色彩传达。

### 3.2 字号层级（iOS Points）

| 层级 | Token | 字号 | 字重 | 行高 | 用途 |
|------|-------|------|------|------|------|
| Hero | `--text-hero` | 34pt | Bold | 41pt | 首页大数字（如 1,847 kcal） |
| Title 1 | `--text-title1` | 28pt | Bold | 34pt | 页面主标题 |
| Title 2 | `--text-title2` | 22pt | Semibold | 28pt | Section标题 |
| Title 3 | `--text-title3` | 17pt | Semibold | 22pt | 卡片标题 |
| Body | `--text-body` | 17pt | Regular | 24pt | 正文 |
| Callout | `--text-callout` | 16pt | Regular | 21pt | 次要正文 |
| Subhead | `--text-subhead` | 15pt | Regular | 20pt | 列表辅助文字 |
| Footnote | `--text-footnote` | 13pt | Regular | 18pt | 时间戳、注释 |
| Caption | `--text-caption` | 11pt | Regular | 13pt | 最小辅助文字 |

### 3.3 SwiftUI Typography

```swift
import SwiftUI

extension Font {
    static let appHero = Font.system(size: 34, weight: .bold)
    static let appTitle1 = Font.system(size: 28, weight: .bold)
    static let appTitle2 = Font.system(size: 22, weight: .semibold)
    static let appTitle3 = Font.system(size: 17, weight: .semibold)
    static let appBody = Font.system(size: 17, weight: .regular)
    static let appCallout = Font.system(size: 16, weight: .regular)
    static let appSubhead = Font.system(size: 15, weight: .regular)
    static let appFootnote = Font.system(size: 13, weight: .regular)
    static let appCaption = Font.system(size: 11, weight: .regular)
}
```

> **Dynamic Type 支持**：所有字号应使用 `.scaledToFill()` 和 `relativeTo:` 参数支持系统字体缩放。Hero数字使用 `Font.system(.largeTitle, design: .rounded)` 作为动态字体备选。

---

## 4. 间距与布局系统

### 4.1 间距规范（基于4pt网格）

| Token | 值 | 用途 |
|-------|-----|------|
| `--space-1` | 4pt | 内联小间距 |
| `--space-2` | 8pt | 元素内间距 |
| `--space-3` | 12pt | 紧凑组间距 |
| `--space-4` | 16pt | 标准内边距 |
| `--space-5` | 20pt | 卡片内边距 |
| `--space-6` | 24pt | Section间距 |
| `--space-7` | 32pt | 大Section间距 |
| `--space-8` | 48pt | 页面级间距 |

### 4.2 圆角规范

| Token | 值 | 用途 |
|-------|-----|------|
| `--radius-sm` | 8pt | 按钮、输入框、小卡片 |
| `--radius-md` | 12pt | 标准卡片 |
| `--radius-lg` | 16pt | 大卡片、Sheet |
| `--radius-xl` | 20pt | 模态框、全宽卡片 |
| `--radius-full` | 999pt | 胶囊按钮、圆形头像 |

### 4.3 Safe Area

- 顶部：状态栏 + Navigation Bar 区域
- 底部：Home Indicator 区域
- 使用 `SafeAreaView` 或 `.safeAreaInset()` 包裹所有页面
- Tab Bar 高度：49pt + Home Indicator区域
- 固定底部操作栏需额外 bottom inset

### 4.4 页面布局

```
┌─────────────────────────────────┐
│        状态栏 (系统)             │
│─────────────────────────────────│
│  Navigation Bar (44pt)          │
│  ┌───────────────────────────┐  │
│  │  内容区域                  │  │
│  │  水平内边距: 16pt          │  │
│  │  卡片间距: 12pt            │  │
│  │  Section间距: 24pt         │  │
│  │                            │  │
│  └───────────────────────────┘  │
│─────────────────────────────────│
│  Tab Bar (49pt + Home Indicator)│
└─────────────────────────────────┘
```

---

## 5. 组件规范

### 5.1 Tab Bar

| 属性 | 规范 |
|------|------|
| 项目数 | 5个（今日/运动/饮食/趋势/设置） |
| 图标 | SF Symbols (outlined未选中, filled选中) |
| 标签 | 始终显示文字标签 |
| 选中色 | `--color-primary` (#F97316) |
| 未选中色 | `--color-muted-foreground` |
| 最低触控区 | 44×44pt |
| 背景 | 毛玻璃效果 `.ultraThinMaterial` |

**Tab图标映射：**
| Tab | 未选中图标 | 选中图标 |
|-----|-----------|---------|
| 今日 | `house` | `house.fill` |
| 运动 | `figure.run` | `figure.run` |
| 饮食 | `fork.knife` | `fork.knife` |
| 趋势 | `chart.line.uptrend.xyaxis` | `chart.line.uptrend.xyaxis` |
| 设置 | `gearshape` | `gearshape.fill` |

### 5.2 进度环（Ring Progress）

用于首页三环展示（卡路里/运动/饮水）。

| 属性 | 规范 |
|------|------|
| 线宽 | 12pt |
| 尺寸 | 大环80pt / 中环60pt / 小环40pt |
| 未完成轨道色 | `--color-muted` (20% opacity) |
| 动画 | `easeOut`, 600ms |
| 达成动效 | 环变绿 + 轻微脉冲缩放(1.0→1.05→1.0) |
| 达成触觉 | Haptic `.success` |

**SwiftUI实现参考：**
```swift
struct RingProgressView: View {
    let progress: Double // 0.0 ~ 1.0
    let color: Color
    let lineWidth: CGFloat = 12

    var body: some View {
        ZStack {
            Circle()
                .stroke(Color.appMuted.opacity(0.2), lineWidth: lineWidth)
            Circle()
                .trim(from: 0, to: progress)
                .stroke(color, style: StrokeStyle(lineWidth: lineWidth, lineCap: .round))
                .rotationEffect(.degrees(-90))
                .animation(.easeOut(duration: 0.6), value: progress)
        }
    }
}
```

### 5.3 卡片

| 类型 | 圆角 | 内边距 | 用途 |
|------|------|--------|------|
| 标准卡片 | 12pt | 16pt | 数据卡片、概览卡片 |
| 大卡片 | 16pt | 20pt | 今日概览、图表卡片 |
| 紧凑卡片 | 8pt | 12pt | 食物列表项 |
| 模态卡片 | 20pt | 20pt | Bottom Sheet |

**卡片状态：**
- 默认：`background: --color-card`
- 按下：`opacity: 0.85` + `scale(0.98)` + `haptic .light`
- 禁用：`opacity: 0.4`

### 5.4 按钮

| 类型 | 背景 | 文字色 | 字号 | 圆角 | 高度 |
|------|------|--------|------|------|------|
| Primary | `--color-primary` | `--color-on-primary` | 17pt/Bold | 12pt | 50pt |
| Secondary | `--color-card` | `--color-primary` | 17pt/Medium | 12pt | 50pt |
| Ghost | transparent | `--color-primary` | 17pt/Medium | 12pt | 50pt |
| Destructive | `--color-destructive` | `--color-on-destructive` | 17pt/Bold | 12pt | 50pt |
| 小按钮 | `--color-primary` | `--color-on-primary` | 15pt/Medium | 8pt | 36pt |

**按钮触控反馈：**
- 按下：`scale(0.96)` + `haptic .light`
- 加载中：显示 `ProgressView()` + 禁用交互
- 最小触控区：44×44pt

### 5.5 输入框

| 属性 | 规范 |
|------|------|
| 高度 | 50pt |
| 圆角 | 12pt |
| 边框 | 1pt `--color-border` |
| 内边距 | 16pt 水平 |
| 聚焦态 | 边框色变 `--color-ring`, 2pt |
| 错误态 | 边框色变 `--color-destructive`, 2pt |
| 键盘类型 | `.numberPad`（数值输入）、`.decimalPad`（体重等） |
| 辅助文字 | `--text-footnote` 放在输入框下方 |

### 5.6 Bottom Sheet

用于快捷录入（记录运动/饮食/体重）。

| 属性 | 规范 |
|------|------|
| 高度 | 约60%屏幕高度 |
| 圆角 | 顶部 20pt |
| 背景 | `--color-card` |
| 遮罩 | 40% opacity 黑色 |
| 拖拽指示 | 系统标准 grab indicator |
| 下滑手势 | 支持下滑关闭 |
| 触觉 | 出现时 `.medium` |

### 5.7 列表项

用于运动历史、食物搜索结果等。

| 属性 | 规范 |
|------|------|
| 高度 | 最小 60pt |
| 内边距 | 水平 16pt, 垂直 12pt |
| 分割线 | 1pt `--color-border`, 左边距 56pt（图标后） |
| 左滑操作 | 删除（红色）/ 编辑（橙色） |
| 选中态 | `background: --color-muted.opacity(0.3)` |

### 5.7.1 力量训练组数据展开

力量训练列表项支持展开/折叠，展开后显示组级详细数据。

**列表项主行（折叠态）**
- 图标（力量分类背景色）+ 运动名称 + 摘要（X个动作·时长·卡路里）+ 展开箭头 ›
- 点击主行或箭头展开/折叠
- 箭头展开时旋转90°，动画 `easeOut 200ms`

**展开态 - 动作区**
- 每个动作独立区域，包含：动作名称行 + 组表格
- 动作名称行：名称（左）+ 标签（如「个人纪录 80kg 🏆」或「3组」右）
- 组表格列：组号 | 上次 | 重量 | 次数 | 休息
- 已完成组：重量和次数文字变绿 `--color-accent`
- 个人纪录组：组号文字变为主色 `--color-primary` + 🏆 emoji
- 动作底部：总容量行（重量×次数累计，如「总容量 2,150 kg」）

**RPE体感强度选择器**
- 10个圆点，1-10
- 默认未填（全灰），已填用 `--color-primary`，当前选中用 `--color-accent`
- 触控区 44×44pt（圆点24pt + padding 10pt）
- 辅助文字显示当前数值

**重量/次数计数器**
- − 按钮（36×36pt, `--color-muted` 背景）| 数值（48pt宽, 20pt Bold）| + 按钮
- 重量步长：2.5kg / 5lb（根据单位设置）
- 次数步长：1
- 点击数字可弹出键盘直接输入
- 按钮按下反馈：`scale(0.94)` + `haptic .light`

**组间休息**
- 预设选项：60s / 90s（默认）/ 120s / 180s
- 水平选择器，当前选中高亮
- 可自定义输入秒数

**添加组按钮**
- 居中，文字「+ 添加一组」
- 颜色 `--color-primary`
- 点击后追加新组行，预填上次组的数据

### 5.8 图标规范

使用 **SF Symbols**（系统原生），保持一致性：

| 场景 | 字重 | 大小 |
|------|------|------|
| Tab Bar | Regular/Bold | 24pt |
| 导航按钮 | Regular | 20pt |
| 列表图标 | Regular | 20pt |
| 数据卡片图标 | Regular | 16pt |
| 内联图标 | Regular | 14pt |

**禁止**：使用emoji作为图标。所有图标使用SF Symbols或自定SVG。

---

## 6. 页面设计规范

### 6.1 今日（Dashboard）

```
┌─────────────────────────────────┐
│  今日                    ⚙️      │ ← Navigation Bar
│─────────────────────────────────│
│  ┌─────────┐  ┌─────────────┐  │
│  │ 👋 早上好 │  │ 5月26日 周一 │  │ ← 问候 + 日期
│  │ 小明     │  │             │  │
│  └─────────┘  └─────────────┘  │
│                                 │
│  ┌─────── 三环进度 ──────────┐  │
│  │  ○ 卡路里  ○ 运动  ○ 饮水  │  │ ← RingProgressView
│  │  1,430    45min  1,800ml   │  │
│  │  /2,000   /60min /2,000ml  │  │
│  └────────────────────────────┘  │
│                                 │
│  ┌─── 快捷操作 ──────────────┐  │
│  │ [+ 运动] [+ 饮食] [+ 体重] │  │ ← 三个快捷按钮
│  └────────────────────────────┘  │
│                                 │
│  ┌─── 智能建议 ──────────────┐  │
│  │ 💡 本周蛋白质偏低，建议...  │  │ ← 建议卡片
│  └────────────────────────────┘  │
│                                 │
│  ┌─── 7天体重趋势 ───────────┐  │
│  │  📈 迷你折线图             │  │ ← 可点击跳转趋势页
│  └────────────────────────────┘  │
│                                 │
│  ┌──── 数据卡片网格 ─────────┐  │
│  │ ┌──步数──┐ ┌──卡路里──┐   │  │
│  │ │ 8,432  │ │ 1,430   │   │  │ ← 2列网格
│  │ │  /10k  │ │ /2,000  │   │  │
│  │ └────────┘ └─────────┘   │  │
│  └────────────────────────────┘  │
│                                 │
│─────────────────────────────────│
│  🏠  🏃  🍴  📈  ⚙️            │ ← Tab Bar
└─────────────────────────────────┘
```

**关键设计点：**
- 问候语根据时间变化（早上好/下午好/晚上好）
- 三环是视觉焦点，放在首屏最显眼位置
- 快捷操作使用Primary/Secondary/Ghost三色区分
- 数据卡片使用 `LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible())])`

### 6.2 运动记录页

```
┌─────────────────────────────────┐
│  运动                    ＋     │
│─────────────────────────────────│
│  📅 ◀ 5月26日 周一 ▶           │ ← 日期选择器
│─────────────────────────────────│
│  ┌─── 今日汇总 ─────────────┐  │
│  │ 3项运动 · 45min · 320kcal │  │
│  └────────────────────────────┘  │
│                                 │
│  运动列表                        │
│  ┌───────────────────────────┐  │
│  │ 🏃 跑步    30min  250kcal │  │
│  │ 🏋️ 力量训练  15min   70kcal│  │
│  │ 🧘 瑜伽    10min    0kcal  │  │
│  └───────────────────────────┘  │
│                                 │
│  ◼ ◼ ◼                          │ ← 分页点（日历/列表切换）
│─────────────────────────────────│
│  🏠  🏃  🍴  📈  ⚙️            │
└─────────────────────────────────┘
```

### 6.3 饮食管理页

```
┌─────────────────────────────────┐
│  饮食                    ＋     │
│─────────────────────────────────│
│  ┌──── 卡路里概览 ───────────┐  │
│  │  1,430 / 2,000 kcal       │  │ ← 进度条
│  │  █████████░░░░            │  │
│  │  碳水 45% · 蛋白质 30% · 脂肪 25% │ ← 三大营养素饼图
│  └────────────────────────────┘  │
│                                 │
│  早餐                            │
│  ┌───────────────────────────┐  │
│  │ 🍞 全麦面包  x2  180kcal │  │
│  │ 🥚 水煮蛋    x2  140kcal │  │
│  │ 🥛 牛奶      1杯  150kcal │  │
│  └───────────────────────────┘  │
│  午餐                            │
│  ┌───────────────────────────┐  │
│  │ 🍚 白米饭    1碗  230kcal │  │
│  │ 🥩 鸡胸肉   150g  240kcal│  │
│  └───────────────────────────┘  │
│  加餐 · 晚餐                     │ ← 折叠区
│─────────────────────────────────│
│  🏠  🏃  🍴  📈  ⚙️            │
└─────────────────────────────────┘
```

### 6.4 快捷录入Bottom Sheet

点击「+」按钮触发：

```
┌─────────── 录入方式 ────────────┐
│  ┌─────────────────────────────┐│
│  │  📷 拍照识别               ││ ← AI食物识别
│  └─────────────────────────────┘│
│  ┌─────────────────────────────┐│
│  │  📊 扫条码                 ││ ← 条码扫描
│  └─────────────────────────────┘│
│  ┌─────────────────────────────┐│
│  │  🔍 搜索食物               ││ ← 数据库搜索
│  └─────────────────────────────┘│
│  ┌─────────────────────────────┐│
│  │  ⏰ 最近记录               ││ ← 最近常吃
│  └─────────────────────────────┘│
│                                  │
│  ═══ (拖拽指示)                  │
└──────────────────────────────────┘
```

---

## 7. 动效规范

### 7.1 时长与缓动

| 场景 | 时长 | 缓动曲线 |
|------|------|----------|
| 按钮按下 | 100ms | `easeOut` |
| 页面转场 | 350ms | `.spring(duration: 0.35, bounce: 0.1)` |
| 进度环动画 | 600ms | `.easeOut` |
| 列表项出现 | 50ms stagger × index | `.easeOut` |
| Bottom Sheet 出现 | 400ms | `.spring(dampingFraction: 0.85)` |
| Tab切换 | 250ms | `.easeInOut` |
| 卡片按下缩放 | 100ms | `.easeOut` scale 0.98 |
| 数字变化 | 300ms | `.easeOut` + 内容过渡 |

### 7.2 触觉反馈

| 场景 | 触觉类型 |
|------|----------|
| 按钮按下 | `.light` |
| Tab切换 | `.light` |
| 目标达成 | `.success` |
| 删除确认 | `.heavy` |
| 错误提示 | `.error` |
| 滑动操作起始 | `.medium` |
| Picker滚动 | `.selectionChanged` |

### 7.3 Reduced Motion 支持

```swift
@Environment(\.accessibilityReduceMotion) var reduceMotion

// 在动画中检查
if reduceMotion {
    // 直接设置值，不使用动画
} else {
    withAnimation(.easeOut(duration: 0.3)) {
        // 带动画的值变化
    }
}
```

---

## 8. 无障碍规范

### 8.1 VoiceOver

- 所有交互元素设置 `accessibilityLabel`
- 进度环提供 `accessibilityValue("已达成 70%")` 和 `accessibilityHint("双击查看详情")`
- 图表提供文字摘要：`"7天体重趋势：从72kg降至70.5kg，下降1.5kg"`
- Tab Bar 使用系统标准实现，自动支持VoiceOver
- 列表项使用 `accessibilityElement(children: .combine)` 组合信息

### 8.2 动态字体

- 所有关键文字支持 Dynamic Type
- Hero大数字使用 `.contentShape(Rectangle())` 确保触控区域
- 进度环和图表缩放跟随文字大小调整

### 8.3 对比度

- 正文文字与背景：≥ 4.5:1 ✅
- 大标题与背景：≥ 3:1 ✅
- 数据可视化色板：每对相邻色值对比度 ≥ 3:1
- 进度环未完成轨道与背景：≥ 3:1

### 8.4 触控区域

- 所有点击目标最小 44×44pt
- 小图标使用 `.contentShape(Rectangle())` 扩展触控区
- 列表项左滑操作按钮最小 44pt 宽

---

## 9. 深色/浅色模式适配

### 9.1 策略

- **深色模式为默认**（运动场景多用暗光环境）
- 系统跟随设置（用户可在App内切换）
- 使用 Asset Catalog Color Set 管理 Light/Dark 变体
- 所有语义颜色通过 `Color("SemanticName")` 引用

### 9.2 关键适配点

| 元素 | 深色模式 | 浅色模式 |
|------|----------|----------|
| 进度环轨道 | `--color-muted` 20% opacity | `--color-muted` 30% opacity |
| 卡片阴影 | 无阴影 | 微阴影 `shadow(color: .black.opacity(0.08), radius: 8)` |
| 分割线 | `--color-border` 1pt | `--color-border` 1pt |
| 状态栏 | 白色文字 | 深色文字 |
| 底部Sheet遮罩 | 黑色40% | 黑色30% |

---

## 10. 图表规范

### 10.1 图表类型映射

| 数据场景 | 图表类型 | 交互 |
|----------|----------|------|
| 7/30/90天体重趋势 | 折线图 | 拖拽查看数据点 |
| 每日卡路里摄入vs目标 | 进度条 + 折线 | 拖拽 |
| 三大营养素比例 | 环形图 | 点击展开详情 |
| 运动类型分布 | 环形图 | 点击高亮 |
| 周/月运动频率 | 柱状图 | 点击查看数据 |
| 卡路里摄入vs消耗叠加 | 双折线图 | 拖拽 |
| 饮水量 | 柱状图 | 点击 |

### 10.2 图表设计规范

- 使用 **Swift Charts** 原生框架
- 图表背景透明（继承卡片背景色）
- 网格线使用 `--color-border` 20% opacity
- 数据线使用语义色板颜色
- 数据点最小触控区 44×44pt
- 空数据状态：显示引导文字 + 插图（非空白图表）
- 加载状态：`redacted(reason: .placeholder)` 骨架屏

### 10.3 数据可访问性

- 每个图表搭配 `accessibilityLabel` 和 `accessibilityValue`
- 进度环提供语音摘要："卡路里目标完成71%，剩余570千卡"
- 色盲支持：不依赖颜色唯一区分，搭配图案/标签

---

## 11. 新手引导设计

### 11.1 Onboarding 流程

```
┌─────────────────────────────────┐
│          Step 1/5                │
│                                 │
│     ┌───────────────────────┐   │
│     │                       │   │
│     │    👋 欢迎插图        │   │
│     │                       │   │
│     └───────────────────────┘   │
│                                 │
│     开始你的健康之旅            │
│     了解你的身体，看见变化      │
│                                 │
│  ┌─────────────────────────────┐│
│  │        下一步                ││
│  └─────────────────────────────┘│
│     ● ○ ○ ○ ○                  │ ← 进度指示
│                                 │
│           跳过                  │ ← 可跳过
└─────────────────────────────────┘
```

- 5步引导，每步一屏
- 进度点指示当前步骤
- 支持跳过（但需要至少完成性别和身高输入以计算BMR）
- 滑动或按钮前进
- 过渡动画：`.slide` 横向切换

---

## 12. Apple Watch 设计规范

### 12.1 Watch App 布局

```
┌─────────────────┐
│                  │
│   三环进度       │
│  ○  ○  ○        │
│                  │
│  卡路里 1,430    │
│  运动  45min     │
│  饮水  1,800ml   │
│                  │
│  [+ 水] [+ 运动] │ ← 快捷按钮
│                  │
└─────────────────┘
```

- 使用 WatchKit (SwiftUI)
- 数字使用 `.system(.title2)` 确保在手表上可读
- 按钮最小触控区保持 44×44pt
- Digital Crown 用于调节数值
- 侧边按钮快速切换录入类型

---

## 13. 设计资产清单

### 13.1 需要创建的 Asset Catalog 内容

| 类目 | 内容 |
|------|------|
| 颜色 | 15个语义颜色 × 2 (Light/Dark) |
| 图标 | SF Symbols 系统图标（无需自建） |
| Tab图标 | 5组 (outline/fill) |
| Onboarding插图 | 5张 (欢迎/信息/目标/活动/完成) |
| 空状态插图 | 4张 (无运动/无饮食/无数据/无体重) |
| App图标 | 1套 (所有尺寸) |

### 13.2 App 图标

| 属性 | 规范 |
|------|------|
| 主色 | #F97316 (能量橙) |
| 图形 | 简化的哑铃/环形图标 |
| 风格 | 扁平、无渐变、单色 |
| 圆角 | 系统自动应用 Superellipse |

---

## 14. 设计交付检查清单

### 视觉品质
- [ ] 无emoji作为图标（全部使用SF Symbols）
- [ ] 图标来自同一风格系统
- [ ] 按下状态不引起布局偏移
- [ ] 语义主题Token统一使用（无硬编码色值）

### 交互
- [ ] 所有点击元素提供按下反馈（透明度变化 + 触觉）
- [ ] 触控区域 ≥ 44×44pt
- [ ] 微交互动效在150-300ms范围
- [ ] 禁用状态清晰可见且不可交互
- [ ] VoiceOver标签完整且准确
- [ ] 无手势冲突（滑动返回等系统手势不受阻）

### 浅色/深色模式
- [ ] 主文字对比度 ≥ 4.5:1（两种模式）
- [ ] 次要文字对比度 ≥ 3:1（两种模式）
- [ ] 分割线和交互状态在两种模式下可见
- [ ] 模态遮罩足够强（通常40-60%黑色）
- [ ] 两种模式均已测试

### 布局
- [ ] Safe Area已正确处理（刘海/底部）
- [ ] 滚动内容不被固定栏遮挡
- [ ] 在小屏(SE)/大屏(Max)上均已验证
- [ ] 横竖屏均可用（数据不会裁切）
- [ ] 4/8pt间距节奏一致

### 无障碍
- [ ] 所有有意义图片/图标有 accessibilityLabel
- [ ] 表单有标签、提示、错误信息
- [ ] 不仅依赖颜色传达信息
- [ ] Reduce Motion支持正常
- [ ] Dynamic Type支持正常（最大字号不裁切）