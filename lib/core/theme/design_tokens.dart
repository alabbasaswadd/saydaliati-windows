/// صيدليتي — Design Tokens (Desktop Edition)
///
/// Single source of truth for the brand's visual identity.
/// The actual runtime values live in app_colors.dart, app_typography.dart, and
/// app_spacing.dart. This file is a human-readable catalog used as a reference
/// when building new screens or components.
///
/// Rule: Every new element must use a token from this catalog. If a value does
/// not exist here, add the token here first, then implement it.
library design_tokens;

// ─── COLOR TOKENS ──────────────────────────────────────────────────────────
//
// Brand — Emerald pharmacy green
//   primary:       #0FA06A  (main interactive elements, sidebar active state)
//   primaryDark:   #0B7A50  (pressed states, dark mode primary)
//   primaryLight:  #45C295  (light accents, dark mode primary)
//   secondary:     #2F80ED  (medical blue, secondary actions)
//
// Semantic
//   success:  #16A34A
//   warning:  #E0A400
//   error:    #DC2626
//   info:     #2563EB
//
// Light surface
//   background: #F4F8F6  (mint-tinted scaffold, sidebar bg)
//   surface:    #FFFFFF  (cards, title bar, dialog backgrounds)
//   card:       #FFFFFF
//   textPrimary:    #12261E
//   textSecondary:  #5E7469
//   border:     #E1EAE5
//   divider:    #EDF3EF
//   disabled:   #BAC7C0
//
// Dark surface
//   backgroundDark: #0E1613
//   surfaceDark:    #14201B
//   cardDark:       #192720
//   textPrimaryDark:    #E6F0EB
//   textSecondaryDark:  #93A89F
//   borderDark:     #263831
//   dividerDark:    #21322B

// ─── TYPOGRAPHY TOKENS ─────────────────────────────────────────────────────
//
// Family: Cairo (Arabic-first variable weight, loaded from assets/fonts/Cairo-Variable.ttf)
//
// Scale (size / weight / line-height):
//   displaySmall:    30 / 700 / 1.25
//   headlineMedium:  24 / 700 / 1.30
//   headlineSmall:   20 / 700 / 1.30
//   titleLarge:      18 / 600 / 1.35
//   titleMedium:     16 / 600 / 1.40
//   titleSmall:      14 / 600 / 1.40  (textSecondary color)
//   bodyLarge:       16 / 400 / 1.50
//   bodyMedium:      14 / 400 / 1.50
//   bodySmall:       12 / 400 / 1.45  (textSecondary color)
//   labelLarge:      14 / 600 / 1.20
//   labelMedium:     12 / 500 / 1.20  (textSecondary color)
//   labelSmall:      11 / 500 / 1.20  (textSecondary color)

// ─── SPACING TOKENS ────────────────────────────────────────────────────────
//
// 4-pt base scale:
//   xs:  4
//   sm:  8
//   md:  12
//   lg:  16
//   xl:  24
//   xxl: 32
//
// Border radius:
//   xs:   6
//   sm:   8
//   md:   12
//   lg:   16
//   pill: 999

// ─── DESKTOP LAYOUT TOKENS ─────────────────────────────────────────────────
//
// Title bar:    height 40px
// Sidebar:      expanded 240px / collapsed 64px
// Sidebar item: height 40px
// Section header: height 28px
// Min window:   1280px wide
// Target:       1366px wide (laptop) / 1920px wide (desktop)

// ─── COMPONENT TOKENS ──────────────────────────────────────────────────────
//
// Button:       height 50px (normal), 40px (small)
// Input:        height 54px
// Toolbar field: height 48px  (invoice top bar: date / currency / customer /
//               account / payment method / prescription — one shared height so
//               every control sits on the same baseline)
//               radius=xs(6), border=1px neutral (textSecondary@40% on surface), label=labelMedium,
//               value=bodyMedium in black, leading/trailing icon=16 muted
//               hover: border=primary@45%, leading icon=primary
//               focus: border=primary 1.4px, label=primary
// Icon:         16 (xs) / 18 (sm) / 22 (md) / 28 (lg)
// Card:         bg=surface, elevation=0, border=1px border-color, radius=lg(16)
// Dialog:       bg=card, radius=lg(16), title=titleLarge
// Sidebar item active:  bg=primary@12%, icon+text=primary
// Sidebar item hover:   bg=primary@6%, icon+text=onSurface
// Window controls hover (close): bg=#C42B1C, icon=white
// Window controls hover (other): bg=onSurface@8%

// ─── ELEVATION / SHADOW ────────────────────────────────────────────────────
//
// Cards:        0 elevation (border-only)
// Sidebar:      right border 1px border-color
// Title bar:    bottom border 1px border-color
// Dialogs:      standard Material shadow (elevation 3)

// ─── DIRECTION ─────────────────────────────────────────────────────────────
//
// App locale: ar (Arabic) — full RTL layout via flutter_localizations
// Title bar: always LTR (logo left, window controls right = Windows convention)
// Sidebar: RTL-start (right side of screen in RTL layout)
// Content area: RTL-end (left side of screen in RTL layout)
