# MathCanvas — UI/UX Design System

**Version:** 1.0
**Status:** Approved
**Last Updated:** 2026-06-12
**Owner:** Design
**Audience:** AI Coding Agents, Engineering
**References:** [PRD.md](file:///d:/MathCanvas/PRD.md), [AppFlow.md](file:///d:/MathCanvas/AppFlow.md), [Rules.md](file:///d:/MathCanvas/Rules.md)

---

## 1. Design Philosophy

MathCanvas is a tool for mathematical thinking. The interface must **disappear** — becoming invisible so that the user's focus remains entirely on the mathematics. Every design decision is evaluated against this principle: *Does this help the user think about math, or does it distract from math?*

### Core Philosophy Statements

1. **The canvas is the product.** Everything else is in service of the canvas experience.
2. **Content over chrome.** Minimize UI elements. Maximize workspace.
3. **Immediate feedback.** Every action produces visible, immediate response.
4. **Calm confidence.** The interface should feel reliable, stable, and trustworthy.
5. **Natural mathematics.** Visual output should look like textbook mathematics, not software.

---

## 2. Design Principles

| Principle | Meaning | Implementation |
|-----------|---------|----------------|
| **Minimal** | Show only what's needed | Floating toolbar, no sidebars, no tab bars |
| **Contextual** | Information appears where relevant | Results appear near their source expression |
| **Responsive** | Immediate visual feedback | Strokes render in real-time; results animate in |
| **Consistent** | Same patterns everywhere | Unified card style for results, graphs, errors |
| **Accessible** | Usable by everyone | High contrast, large touch targets, screen reader labels |
| **Delightful** | Subtle moments of joy | Smooth animations, satisfying transitions |

---

## 3. Color System

### 3.1 Light Theme Colors

| Token | Hex | RGB | Usage |
|-------|-----|-----|-------|
| `colorPrimary` | `#6366F1` | 99, 102, 241 | Primary actions, active states, links |
| `colorPrimaryVariant` | `#4F46E5` | 79, 70, 229 | Pressed primary, headers |
| `colorSecondary` | `#8B5CF6` | 139, 92, 246 | Secondary actions, accents |
| `colorSecondaryVariant` | `#7C3AED` | 124, 58, 237 | Pressed secondary |
| `colorSurface` | `#FFFFFF` | 255, 255, 255 | Cards, sheets, dialogs |
| `colorBackground` | `#F8FAFC` | 248, 250, 252 | App background |
| `colorCanvasBackground` | `#FFFFFF` | 255, 255, 255 | Canvas drawing area |
| `colorCanvasGrid` | `#E2E8F0` | 226, 232, 240 | Canvas grid dots/lines |
| `colorStrokeDefault` | `#1E293B` | 30, 41, 59 | Default ink color |
| `colorError` | `#EF4444` | 239, 68, 68 | Error states, destructive actions |
| `colorErrorSurface` | `#FEF2F2` | 254, 242, 242 | Error card background |
| `colorSuccess` | `#22C55E` | 34, 197, 94 | Success states, save confirmed |
| `colorSuccessSurface` | `#F0FDF4` | 240, 253, 244 | Success card background |
| `colorWarning` | `#F59E0B` | 245, 158, 11 | Warning states, low confidence |
| `colorWarningSurface` | `#FFFBEB` | 255, 251, 235 | Warning card background |
| `colorOnPrimary` | `#FFFFFF` | 255, 255, 255 | Text/icons on primary |
| `colorOnSecondary` | `#FFFFFF` | 255, 255, 255 | Text/icons on secondary |
| `colorOnSurface` | `#1E293B` | 30, 41, 59 | Primary text |
| `colorOnSurfaceVariant` | `#64748B` | 100, 116, 139 | Secondary text, captions |
| `colorOnBackground` | `#0F172A` | 15, 23, 42 | Text on background |
| `colorDivider` | `#E2E8F0` | 226, 232, 240 | Dividers, borders |
| `colorOverlay` | `#0F172A` (50% alpha) | — | Modal overlays |

### 3.2 Dark Theme Colors

| Token | Hex | RGB | Usage |
|-------|-----|-----|-------|
| `colorPrimary` | `#818CF8` | 129, 140, 248 | Primary actions (lighter for dark bg) |
| `colorPrimaryVariant` | `#6366F1` | 99, 102, 241 | Pressed primary |
| `colorSecondary` | `#A78BFA` | 167, 139, 250 | Secondary actions |
| `colorSecondaryVariant` | `#8B5CF6` | 139, 92, 246 | Pressed secondary |
| `colorSurface` | `#1E293B` | 30, 41, 59 | Cards, sheets, dialogs |
| `colorBackground` | `#0F172A` | 15, 23, 42 | App background |
| `colorCanvasBackground` | `#1A1A2E` | 26, 26, 46 | Canvas drawing area |
| `colorCanvasGrid` | `#334155` | 51, 65, 85 | Canvas grid dots/lines |
| `colorStrokeDefault` | `#E2E8F0` | 226, 232, 240 | Default ink color (light on dark) |
| `colorError` | `#F87171` | 248, 113, 113 | Error states |
| `colorErrorSurface` | `#450A0A` | 69, 10, 10 | Error card background |
| `colorSuccess` | `#4ADE80` | 74, 222, 128 | Success states |
| `colorSuccessSurface` | `#052E16` | 5, 46, 22 | Success card background |
| `colorWarning` | `#FBBF24` | 251, 191, 36 | Warning states |
| `colorWarningSurface` | `#451A03` | 69, 26, 3 | Warning card background |
| `colorOnPrimary` | `#0F172A` | 15, 23, 42 | Text/icons on primary |
| `colorOnSecondary` | `#0F172A` | 15, 23, 42 | Text/icons on secondary |
| `colorOnSurface` | `#F1F5F9` | 241, 245, 249 | Primary text |
| `colorOnSurfaceVariant` | `#94A3B8` | 148, 163, 184 | Secondary text, captions |
| `colorOnBackground` | `#F8FAFC` | 248, 250, 252 | Text on background |
| `colorDivider` | `#334155` | 51, 65, 85 | Dividers, borders |
| `colorOverlay` | `#000000` (60% alpha) | — | Modal overlays |

### 3.3 Graph Colors

Used for graph plot lines. Must be distinguishable in both light and dark modes.

| Token | Light Hex | Dark Hex | Usage |
|-------|-----------|----------|-------|
| `graphColor1` | `#6366F1` | `#818CF8` | First function |
| `graphColor2` | `#EC4899` | `#F472B6` | Second function |
| `graphColor3` | `#14B8A6` | `#2DD4BF` | Third function |
| `graphColor4` | `#F59E0B` | `#FBBF24` | Fourth function |
| `graphColor5` | `#8B5CF6` | `#A78BFA` | Fifth function |
| `graphAxisColor` | `#64748B` | `#94A3B8` | Graph axes |
| `graphGridColor` | `#E2E8F0` | `#334155` | Graph grid lines |

### 3.4 Color Implementation

```dart
// lib/app/theme/app_colors.dart

class AppColors {
  // Light theme
  static const light = AppColorScheme(
    primary: Color(0xFF6366F1),
    primaryVariant: Color(0xFF4F46E5),
    secondary: Color(0xFF8B5CF6),
    // ... all tokens above
  );

  // Dark theme
  static const dark = AppColorScheme(
    primary: Color(0xFF818CF8),
    primaryVariant: Color(0xFF6366F1),
    secondary: Color(0xFFA78BFA),
    // ... all tokens above
  );
}
```

---

## 4. Dark Mode

### 4.1 Dark Mode Specification

| Attribute | Specification |
|-----------|--------------|
| Default | Off (light mode) |
| User control | Settings bottom sheet toggle |
| Options | Light, Dark, System |
| Persistence | SharedPreferences (`theme_mode` key) |
| Transition | Immediate (no animation) |
| Canvas ink | Auto-inverts: dark → light stroke on dark canvas |

### 4.2 Dark Mode Rules

1. **Never use pure black (#000000) as background.** Use `#0F172A` (dark slate) for depth.
2. **Reduce contrast slightly** compared to light mode to reduce eye strain.
3. **Elevate surfaces** using lighter shades of the background, not shadows.
4. **Canvas ink color** inverts automatically: default stroke is light on dark canvas.
5. **Graph colors** are adjusted for legibility on dark backgrounds (lighter variants).
6. **Colored surfaces** (error, success, warning) use deep, muted backgrounds.

---

## 5. Typography System

### 5.1 Font Family

| Usage | Font | Fallback |
|-------|------|----------|
| UI text | Inter | system sans-serif |
| Math display (recognized expressions, results) | STIX Two Math or KaTeX font | serif |
| Monospace (debug, technical) | JetBrains Mono | monospace |

### 5.2 Type Scale

| Token | Size (sp) | Weight | Line Height | Letter Spacing | Usage |
|-------|-----------|--------|-------------|----------------|-------|
| `displayLarge` | 32 | Bold (700) | 1.25 | -0.5px | Splash screen title |
| `displayMedium` | 28 | Bold (700) | 1.3 | -0.25px | — (reserved) |
| `headlineLarge` | 24 | SemiBold (600) | 1.33 | 0px | Screen titles |
| `headlineMedium` | 20 | SemiBold (600) | 1.4 | 0px | Section headers |
| `titleLarge` | 18 | Medium (500) | 1.44 | 0px | Card titles, dialog titles |
| `titleMedium` | 16 | Medium (500) | 1.5 | 0.15px | Notebook card name |
| `bodyLarge` | 16 | Regular (400) | 1.5 | 0.5px | Primary body text |
| `bodyMedium` | 14 | Regular (400) | 1.43 | 0.25px | Secondary body text |
| `bodySmall` | 12 | Regular (400) | 1.33 | 0.4px | Captions, timestamps |
| `labelLarge` | 14 | Medium (500) | 1.43 | 0.1px | Buttons, labels |
| `labelMedium` | 12 | Medium (500) | 1.33 | 0.5px | Small buttons, chips |
| `labelSmall` | 10 | Medium (500) | 1.6 | 0.5px | Overlines, tiny labels |
| `mathDisplay` | 18 | Regular (400) | 1.5 | 0px | Recognized expression display |
| `mathResult` | 20 | Medium (500) | 1.4 | 0px | Solution/result display |

### 5.3 Typography Rules

1. **Use the type scale tokens.** Never use arbitrary font sizes.
2. **Maximum 2 font weights per screen** to maintain visual hierarchy.
3. **Left-align all text** (except centered empty states and splash).
4. **Minimum text size is 10sp** for accessibility.
5. **Math display uses serif font** to match textbook conventions.
6. **UI text uses Inter** for modern, clean readability.

---

## 6. Spacing System

### 6.1 Spacing Scale

All spacing values are multiples of the base unit: **4px**.

| Token | Value | Usage |
|-------|-------|-------|
| `space2` | 2px | Hairline spacing, icon-to-text micro gap |
| `space4` | 4px | Tight spacing, compact elements |
| `space8` | 8px | Default inner padding, small gaps |
| `space12` | 12px | Between related elements |
| `space16` | 16px | Standard padding, card padding |
| `space20` | 20px | Section gaps |
| `space24` | 24px | Large padding, screen edge margins |
| `space32` | 32px | Section separators |
| `space48` | 48px | Major section gaps |
| `space64` | 64px | Screen-level spacing |

### 6.2 Spacing Rules

1. **All spacing values must use tokens.** No arbitrary values (e.g., no `13px`, `17px`).
2. **Screen edge padding:** `space24` (24px) on left/right.
3. **Card internal padding:** `space16` (16px).
4. **List item spacing:** `space12` (12px) between items.
5. **Section spacing:** `space32` (32px) between major sections.
6. **Touch target minimum:** 44×44px (includes padding).

### 6.3 Spacing Implementation

```dart
// lib/app/theme/app_spacing.dart

class AppSpacing {
  static const double space2 = 2.0;
  static const double space4 = 4.0;
  static const double space8 = 8.0;
  static const double space12 = 12.0;
  static const double space16 = 16.0;
  static const double space20 = 20.0;
  static const double space24 = 24.0;
  static const double space32 = 32.0;
  static const double space48 = 48.0;
  static const double space64 = 64.0;
}
```

---

## 7. Component Library

### 7.1 Notebook Card

| Property | Specification |
|----------|--------------|
| Shape | Rounded rectangle, `borderRadius: 16px` |
| Elevation | 0 (use border instead of shadow) |
| Border | 1px solid `colorDivider` |
| Padding | `space16` all sides |
| Background | `colorSurface` |
| Height | 120px (minimum) |
| Content | Notebook name (`titleMedium`), last modified date (`bodySmall`), stroke count (`bodySmall`, secondary color) |
| Thumbnail | Mini canvas preview in top portion (if available) |
| Tap | Navigate to canvas |
| Long-press | Show context menu (Rename, Delete) |
| Hover/Press | Background shifts to `colorPrimary` at 8% opacity |
| Animation | Scale down to 0.97 on press, spring back on release |

### 7.2 Floating Action Button (FAB)

| Property | Specification |
|----------|--------------|
| Shape | Circle, 56px diameter |
| Color | `colorPrimary` |
| Icon | `+` (add), white, 24px |
| Position | Bottom-right, `space24` from edges |
| Elevation | 6 (subtle shadow) |
| Tap | Create new notebook |
| Animation | Scale spring on press |

### 7.3 Canvas Toolbar

| Property | Specification |
|----------|--------------|
| Position | Floating, bottom-center, 24px from bottom edge |
| Shape | Rounded rectangle, `borderRadius: 24px` |
| Background | `colorSurface` with 95% opacity (glassmorphism) |
| Border | 1px solid `colorDivider` |
| Shadow | Subtle (`elevation: 4`) |
| Content | Color indicator (circle), stroke width slider |
| Height | 48px |
| Width | Auto (content-based, max 240px) |
| Visibility | Semi-transparent when not interacted with; full opacity on touch |

### 7.4 Result Card

| Property | Specification |
|----------|--------------|
| Position | Floating on canvas, anchored near source expression |
| Shape | Rounded rectangle, `borderRadius: 12px` |
| Background | `colorSurface` |
| Border | 1px solid `colorPrimary` at 20% opacity |
| Padding | `space12` |
| Shadow | Subtle (`elevation: 2`) |
| Content | Result in math display font (`mathResult` style) |
| Max width | 300px |
| Animation | Fade in (200ms) + slide up (8px) on appear |

### 7.5 Graph Card

| Property | Specification |
|----------|--------------|
| Position | Floating on canvas, below source expression |
| Shape | Rounded rectangle, `borderRadius: 16px` |
| Background | `colorSurface` |
| Border | 1px solid `colorDivider` |
| Padding | `space8` (chart area edge-to-edge, padding around controls) |
| Shadow | Subtle (`elevation: 2`) |
| Size | 280×220px (default, resizable in future) |
| Content | Interactive chart with axes, grid, and plot line |
| Header | Expression title (`bodySmall`), close button (×) |
| Interaction | Pan and zoom within graph area |
| Animation | Fade in (200ms) + scale from 0.95 to 1.0 |

### 7.6 Error Card

| Property | Specification |
|----------|--------------|
| Position | Floating on canvas, near source expression |
| Shape | Rounded rectangle, `borderRadius: 12px` |
| Background | `colorErrorSurface` |
| Border | 1px solid `colorError` at 30% opacity |
| Padding | `space12` |
| Content | Error icon (⚠) + message (`bodyMedium`, `colorError`) |
| Max width | 250px |
| Animation | Fade in (200ms) |
| Dismissal | Tap to dismiss, auto-dismiss after 10 seconds |

### 7.7 Confidence Indicator

| Property | Specification |
|----------|--------------|
| Trigger | Recognition confidence < 0.6 |
| Display | "?" character in a small circle badge |
| Position | Top-right corner of unrecognized expression bounding box |
| Size | 20px circle |
| Color | `colorWarning` background, white text |
| Tap | Dismiss indicator (keep strokes as drawing) |

### 7.8 Save Indicator

| Property | Specification |
|----------|--------------|
| Position | Top-right corner of canvas screen, in app bar |
| Idle state | Small green dot (4px, `colorSuccess`) |
| Saving state | Pulsing animation (opacity 0.4 → 1.0, 800ms cycle) |
| Error state | Red dot (4px, `colorError`), persists until next successful save |

### 7.9 Backend Status Indicator

| Property | Specification |
|----------|--------------|
| Position | Top-right corner of canvas screen, near save indicator |
| Ready | Green dot, no label |
| Loading | Yellow dot, "Starting..." label (visible during startup) |
| Error | Red dot, "Offline" label |
| Size | 8px dot + optional label (`labelSmall`) |

### 7.10 Context Menu

| Property | Specification |
|----------|--------------|
| Trigger | Long-press on notebook card |
| Style | Material 3 popup menu |
| Items | Rename (edit icon), Delete (trash icon, `colorError`) |
| Animation | Scale in from touch point (150ms) |
| Dismissal | Tap outside, or tap item |

### 7.11 Confirmation Dialog

| Property | Specification |
|----------|--------------|
| Style | Material 3 AlertDialog |
| Title | `headlineMedium` |
| Body | `bodyLarge` |
| Actions | Cancel (text button, secondary), Confirm (filled button, primary or error) |
| Delete confirm | Confirm button uses `colorError` |
| Shape | Rounded rectangle, `borderRadius: 28px` |
| Animation | Fade in + scale from 0.9 (200ms) |

### 7.12 Rename Dialog

| Property | Specification |
|----------|--------------|
| Style | Material 3 AlertDialog with TextField |
| Title | "Rename Notebook" (`headlineMedium`) |
| Input | Single-line TextField, prefilled with current name, auto-selected |
| Validation | 1–100 characters, non-empty after trim |
| Actions | Cancel, Save |
| Shape | Rounded rectangle, `borderRadius: 28px` |

### 7.13 Settings Bottom Sheet

| Property | Specification |
|----------|--------------|
| Trigger | Tap gear icon in Home app bar |
| Style | Material 3 Modal Bottom Sheet |
| Shape | Top corners rounded, `borderRadius: 28px` |
| Handle | Drag handle indicator at top (32×4px, centered) |
| Content | "Appearance" section header, theme toggle (Light/Dark/System) |
| Theme toggle | Segmented button or radio list tiles |
| Dismissal | Drag down, tap outside |

---

## 8. Canvas UX Rules

### 8.1 Canvas Behavior

| Rule | Specification |
|------|--------------|
| Default viewport | Centered at origin (0, 0), zoom 1.0 |
| Zoom range | 0.1 (10%) to 10.0 (1000%) |
| Zoom steps | Continuous (pinch gesture) |
| Pan | Continuous (two-finger drag) |
| Grid | Dot grid at 20px intervals (world coordinates) |
| Grid visibility | Grid fades out below zoom 0.3, fades in above 0.3 |
| Ghost hint | "Start writing math here..." centered, disappears on first stroke |
| Background | `colorCanvasBackground` (theme-aware) |

### 8.2 Stroke Rendering Rules

| Rule | Specification |
|------|--------------|
| Stroke smoothing | Catmull-Rom spline interpolation between points |
| Minimum stroke width | 0.5px |
| Maximum stroke width | 20px |
| Default stroke width | 2.0px |
| Pressure multiplier | Width = baseWidth × (0.5 + pressure × 0.5) |
| Stroke cap | Round (`StrokeCap.round`) |
| Stroke join | Round (`StrokeJoin.round`) |
| Anti-aliasing | Enabled |
| Default color (light) | `#1E293B` (dark slate) |
| Default color (dark) | `#E2E8F0` (light slate) |

### 8.3 Viewport Culling Rules

| Rule | Specification |
|------|--------------|
| Culling margin | Viewport + 100px margin on each side |
| Culling check | Stroke bounding box intersects expanded viewport |
| Update frequency | Every frame during pan/zoom |
| Index | Spatial index (R-tree or grid) for fast queries |

---

## 9. Graph UX Rules

### 9.1 Graph Display

| Rule | Specification |
|------|--------------|
| Default X range | [-10, 10] |
| Default Y range | Auto-fit to function values in X range |
| Axes | Always visible, labeled (x, y) |
| Grid | Light grid lines at major intervals |
| Plot line width | 2px |
| Plot line color | From graph color palette |
| Background | `colorSurface` (matches card) |
| Padding | 8px within the chart area |

### 9.2 Graph Interaction

| Rule | Specification |
|------|--------------|
| Pan | Single-finger drag within graph card |
| Zoom | Pinch within graph card |
| Value inspection | Tap shows crosshair + (x, y) tooltip |
| Tooltip style | Small rounded card, `bodySmall`, auto-dismiss on release |
| Interaction isolation | Graph gestures do not affect canvas pan/zoom |

### 9.3 Graph Positioning

| Rule | Specification |
|------|--------------|
| Initial position | Centered below the source expression, offset 20px down |
| Overlap avoidance | If position overlaps another graph, offset further down |
| Anchoring | Graph card maintains relative position to source expression |
| Movement | In V1, graph cards are not user-movable (planned for V1.1) |

---

## 10. Gesture System

### 10.1 Gesture Priority

```
Priority (highest to lowest):
1. Graph card interaction (if pointer is within a graph card)
2. Single-finger draw stroke
3. Two-finger pan canvas
4. Pinch zoom canvas
5. Tap to select expression (if on recognized content)
```

### 10.2 Gesture Detection

| Gesture | Detection | Threshold |
|---------|-----------|-----------|
| Draw | Single pointer down + move | Move > 2px from down point |
| Pan | Two pointers down + move | Move > 5px from initial center |
| Zoom | Two pointers with changing distance | Distance change > 10px |
| Tap | Pointer down + up, no move | Within 10px, duration < 300ms |
| Long-press | Pointer down, no move, hold | Hold > 500ms, within 10px |

### 10.3 Gesture Conflict Resolution

1. **Draw vs Pan:** Count active pointers. 1 pointer = draw, 2 pointers = pan. If second finger touches during draw, cancel draw and switch to pan.
2. **Pan vs Zoom:** Both use 2 fingers. If distance between fingers changes > 10px, switch to zoom. Pan and zoom can be simultaneous.
3. **Graph vs Canvas:** If pointer down is within a graph card's bounds, the graph card captures all gestures. Canvas does not receive them.
4. **Stylus vs Palm:** If a stylus pointer is detected, all non-stylus pointers are ignored (palm rejection).

---

## 11. Accessibility Standards

### 11.1 Requirements (V1)

| Category | Requirement | Target |
|----------|-------------|--------|
| Touch targets | Minimum size | 44×44 logical pixels |
| Color contrast | Text on background | WCAG 2.1 AA (4.5:1 minimum) |
| Color contrast | Large text on background | WCAG 2.1 AA (3:1 minimum) |
| Screen reader | Navigation elements | Semantic labels for all buttons, tabs |
| Screen reader | Canvas content | Not applicable (drawing canvas) |
| Text scaling | System font scale | Support 1.0x to 2.0x |
| Motion | Reduce motion | Respect `MediaQuery.disableAnimations` |
| Color blindness | Information not conveyed by color alone | Use icons + text alongside color |

### 11.2 Semantic Labels

| Element | Semantic Label |
|---------|---------------|
| FAB (create) | "Create new notebook" |
| Back button | "Go back to notebook list" |
| Settings icon | "Open settings" |
| Rename menu item | "Rename notebook" |
| Delete menu item | "Delete notebook" |
| Theme toggle | "Switch theme: [current]" |
| Save indicator (saving) | "Saving..." |
| Save indicator (saved) | "All changes saved" |
| Backend indicator (ready) | "Math engine ready" |
| Backend indicator (error) | "Math engine unavailable" |

---

## 12. Animation Guidelines

### 12.1 Animation Durations

| Category | Duration | Easing |
|----------|----------|--------|
| Micro-interaction (press, toggle) | 100–150ms | `Curves.easeOut` |
| Element transition (fade, slide) | 200–300ms | `Curves.easeInOut` |
| Screen transition | 300ms | `Curves.easeInOut` |
| Loading pulse | 800ms (loop) | `Curves.easeInOut` |
| Spring (press bounce) | 200ms | `Curves.elasticOut` |

### 12.2 Standard Animations

| Animation | Specification |
|-----------|--------------|
| Result card appear | Fade in (0→1, 200ms) + slide up (8px→0, 200ms) |
| Graph card appear | Fade in (0→1, 200ms) + scale (0.95→1.0, 200ms) |
| Error card appear | Fade in (0→1, 200ms) |
| Card press | Scale (1.0→0.97, 100ms), spring back (0.97→1.0, 200ms) |
| Dialog appear | Fade in (0→1, 200ms) + scale (0.9→1.0, 200ms) |
| Screen transition | Slide left/right (300ms) |
| Save indicator pulse | Opacity (0.4→1.0→0.4, 800ms loop) |
| Toast/snackbar | Slide up from bottom (200ms), slide down after 3s |

### 12.3 Animation Rules

1. **Never block interaction** with animations. All animations must be non-blocking.
2. **Respect reduced motion** preference. When `disableAnimations` is true, replace animations with instant transitions.
3. **No gratuitous animation.** Every animation must serve a purpose (feedback, orientation, or delight).
4. **Canvas rendering is not animated.** Strokes appear instantly. No "drawing" animation.
5. **Maximum 2 concurrent animations** on screen to prevent visual noise.

---

## 13. Responsive Design Rules

### 13.1 Breakpoints

| Breakpoint | Width | Device Type | Layout Adaptation |
|-----------|-------|-------------|-------------------|
| Compact | < 600px | Phone | Single column, full-width cards |
| Medium | 600–840px | Small tablet, landscape phone | 2-column grid for notebooks |
| Expanded | > 840px | Tablet | 3-column grid for notebooks |

### 13.2 Responsive Rules

| Rule | Specification |
|------|--------------|
| Canvas | Always full-screen regardless of device size |
| Notebook grid | 1 column (compact), 2 columns (medium), 3 columns (expanded) |
| Card width | Fill available width with `space12` gap between cards |
| Toolbar | Fixed at bottom-center, same size on all devices |
| Dialog width | Max 400px, centered |
| Bottom sheet | Full width on compact, max 600px on larger |
| Font scaling | Respect system font size preference |
| Orientation | Support both portrait and landscape |
| Safe areas | Respect notch, rounded corners, home indicator |

### 13.3 Canvas Responsiveness

The canvas is always full-screen. Responsive behavior:

1. **Phone portrait:** Toolbar at bottom, compact app bar.
2. **Phone landscape:** Toolbar at bottom, app bar may hide on scroll (future).
3. **Tablet portrait/landscape:** Toolbar at bottom, standard app bar.
4. **Zoomed-in writing:** Canvas content is in world coordinates — no responsive adjustment needed.

---

## 14. Design Tokens

### 14.1 Token Summary

All design tokens are implemented as Dart constants and referenced through the theme system.

```dart
// Design token access patterns:

// Colors
Theme.of(context).colorScheme.primary
AppColors.light.canvasBackground // or AppColors.dark
context.colorScheme.primary // via extension

// Typography
Theme.of(context).textTheme.headlineLarge
AppTypography.mathResult

// Spacing
AppSpacing.space16

// Borders
AppBorders.cardBorderRadius // BorderRadius.circular(16)
AppBorders.dialogBorderRadius // BorderRadius.circular(28)
AppBorders.toolbarBorderRadius // BorderRadius.circular(24)

// Shadows
AppShadows.card // BoxShadow for elevation 2
AppShadows.toolbar // BoxShadow for elevation 4
AppShadows.fab // BoxShadow for elevation 6
```

### 14.2 Border Radius Tokens

| Token | Value | Usage |
|-------|-------|-------|
| `radiusSmall` | 8px | Small elements, chips |
| `radiusMedium` | 12px | Result cards, error cards |
| `radiusLarge` | 16px | Notebook cards, graph cards |
| `radiusXLarge` | 24px | Toolbar |
| `radiusXXLarge` | 28px | Dialogs, bottom sheets |
| `radiusFull` | 9999px | Circular elements (FAB, dots) |

### 14.3 Shadow Tokens

| Token | Specification | Usage |
|-------|--------------|-------|
| `shadowNone` | No shadow | Flat cards with border |
| `shadowSmall` | `offset(0,1), blur(3), color(black 10%)` | Subtle elevation |
| `shadowMedium` | `offset(0,2), blur(8), color(black 12%)` | Cards, result overlays |
| `shadowLarge` | `offset(0,4), blur(16), color(black 15%)` | Toolbar, FAB |

### 14.4 Icon Sizes

| Token | Value | Usage |
|-------|-------|-------|
| `iconSmall` | 16px | Inline icons, indicators |
| `iconMedium` | 20px | List item icons |
| `iconLarge` | 24px | Action icons, toolbar, app bar |
| `iconXLarge` | 32px | Empty state illustrations |

---

## 15. UI Acceptance Criteria

### 15.1 Home Screen

- [ ] App bar shows "MathCanvas" title.
- [ ] Settings gear icon is in the app bar.
- [ ] FAB is visible at bottom-right with "+" icon.
- [ ] Notebooks display in a grid (responsive columns).
- [ ] Each notebook card shows name, last modified date, and stroke count.
- [ ] Long-press on a card shows context menu (Rename, Delete).
- [ ] Empty state shows illustration + message + create button.
- [ ] Theme toggle works in settings bottom sheet.
- [ ] All colors match design tokens.
- [ ] All text uses typography tokens.
- [ ] All spacing uses spacing tokens.
- [ ] Touch targets ≥ 44×44px.
- [ ] Dark mode renders correctly.

### 15.2 Canvas Screen

- [ ] App bar shows notebook name (editable on tap).
- [ ] Back button navigates to Home.
- [ ] Canvas fills entire screen below app bar.
- [ ] Grid background renders and transforms with pan/zoom.
- [ ] Floating toolbar visible at bottom-center.
- [ ] Save indicator visible in app bar area.
- [ ] Backend status indicator visible.
- [ ] Strokes render with pressure sensitivity.
- [ ] Stroke color matches theme default.
- [ ] Result cards appear near recognized expressions.
- [ ] Graph cards appear below function expressions.
- [ ] Error cards display for failed operations.
- [ ] All overlays use consistent card styling.
- [ ] Ghost hint text appears on empty canvas.
- [ ] Dark mode renders correctly.

### 15.3 General UI

- [ ] No hardcoded colors — all from theme.
- [ ] No hardcoded text sizes — all from typography scale.
- [ ] No arbitrary spacing — all from spacing scale.
- [ ] Animations follow guidelines (duration, easing).
- [ ] Reduced motion preference is respected.
- [ ] Dialogs follow Material 3 guidelines.
- [ ] Bottom sheets follow Material 3 guidelines.
- [ ] All interactive elements have semantic labels.
- [ ] Color contrast meets WCAG 2.1 AA.

---

*End of UI_UX.md*
