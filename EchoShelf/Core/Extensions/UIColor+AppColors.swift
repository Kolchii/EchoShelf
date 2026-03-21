//
//  UIColor+AppColors.swift
//  EchoShelf
//
//  Rənglər Assets.xcassets-dən; fallback yalnız catalog tapılmadıqda.
//

import UIKit

enum AppColor {

    // MARK: - Screen & surfaces

    static var screenBackground: UIColor { named("SettingsBackground", fallback: UIColor(red: 13 / 255, green: 17 / 255, blue: 23 / 255, alpha: 1)) }
    static var elevatedSurface: UIColor { named("ElevatedSurface", fallback: UIColor(red: 22 / 255, green: 27 / 255, blue: 34 / 255, alpha: 1)) }
    static var profileAvatarBackground: UIColor { named("ProfileAvatarBackground", fallback: UIColor(red: 30 / 255, green: 58 / 255, blue: 95 / 255, alpha: 1)) }

    // MARK: - Brand / accent

    static var accentBlue: UIColor { named("PrimaryAccent", fallback: UIColor(red: 74 / 255, green: 144 / 255, blue: 226 / 255, alpha: 1)) }
    /// Segment, tab, oynadıcı — bənövşəyi aksent
    static var accentPurple: UIColor { named("PrimaryGradientStart", fallback: .systemPurple) }
    /// Slider maksimum iz (ağ 0.2)
    static var sliderTrackMaximum: UIColor { named("SliderTrackMaximum", fallback: UIColor.white.withAlphaComponent(0.2)) }

    // MARK: - Library shelf

    static var libraryShelfGradientStart: UIColor { named("LibraryShelfGradientStart", fallback: UIColor(red: 26 / 255, green: 14 / 255, blue: 6 / 255, alpha: 1)) }
    static var libraryShelfGradientMid: UIColor { named("LibraryShelfGradientMid", fallback: UIColor(red: 36 / 255, green: 21 / 255, blue: 8 / 255, alpha: 1)) }
    static var libraryTitleGold: UIColor { named("LibraryTitleGold", fallback: UIColor(red: 232 / 255, green: 213 / 255, blue: 176 / 255, alpha: 1)) }
    static var libraryAccentOrange: UIColor { named("LibraryAccentOrange", fallback: UIColor(red: 245 / 255, green: 166 / 255, blue: 35 / 255, alpha: 1)) }

    // MARK: - Player

    static var playerGradientTop: UIColor { named("PlayerGradientTop", fallback: UIColor(red: 20 / 255, green: 18 / 255, blue: 60 / 255, alpha: 1)) }
    static var playerGradientBottom: UIColor { named("PlayerGradientBottom", fallback: UIColor(red: 10 / 255, green: 10 / 255, blue: 35 / 255, alpha: 1)) }

    // MARK: - Storage chart

    static var storageChartOther: UIColor { named("StorageChartOther", fallback: UIColor(red: 170 / 255, green: 170 / 255, blue: 170 / 255, alpha: 1)) }
    static var storageChartEmpty: UIColor { named("StorageChartEmpty", fallback: UIColor(red: 51 / 255, green: 51 / 255, blue: 51 / 255, alpha: 1)) }
    /// Yaddaş diaqramında "digər" seqmenti (ağ 0.25)
    static var storageSecondaryBar: UIColor { named("StorageSecondaryBar", fallback: UIColor.white.withAlphaComponent(0.25)) }

    // MARK: - Detail / badges

    static var inLibraryBadgeGreen: UIColor { named("InLibraryBadgeGreen", fallback: UIColor(red: 45 / 255, green: 90 / 255, blue: 39 / 255, alpha: 1)) }
    static var successGreen: UIColor { named("SuccessGreen", fallback: UIColor(red: 76 / 255, green: 175 / 255, blue: 80 / 255, alpha: 1)) }
    static var favoriteActivePink: UIColor { named("FavoriteActivePink", fallback: UIColor.systemPink) }
    static var ratingStarYellow: UIColor { named("RatingStarYellow", fallback: UIColor.systemYellow) }
    static var languageIconBlue: UIColor { named("LanguageIconBlue", fallback: UIColor.systemBlue) }

    // MARK: - On-dark text (ağ + alpha)

    static var onDarkPrimary: UIColor { named("OnDarkTextPrimary", fallback: .white) }
    static var onDarkSecondary: UIColor { named("OnDarkTextSecondary", fallback: UIColor.white.withAlphaComponent(0.6)) }
    static var onDarkText70: UIColor { named("OnDarkText70", fallback: UIColor.white.withAlphaComponent(0.7)) }
    static var onDarkText80: UIColor { named("OnDarkText80", fallback: UIColor.white.withAlphaComponent(0.8)) }
    static var onDarkTertiary: UIColor { named("OnDarkTextTertiary", fallback: UIColor.white.withAlphaComponent(0.45)) }
    static var onDarkCaption: UIColor { named("OnDarkTextCaption", fallback: UIColor.white.withAlphaComponent(0.35)) }
    static var onDarkFooter: UIColor { named("OnDarkTextFooter", fallback: UIColor.white.withAlphaComponent(0.3)) }
    static var onDarkText25: UIColor { named("OnDarkText25", fallback: UIColor.white.withAlphaComponent(0.25)) }
    static var onDarkChevron: UIColor { named("OnDarkChevron", fallback: UIColor.white.withAlphaComponent(0.3)) }
    static var onDarkDetail: UIColor { named("OnDarkTextDetail", fallback: UIColor.white.withAlphaComponent(0.4)) }
    /// Axtarış tab — seçilməmiş mətn (0.5 ağ)
    static var tabTextInactive: UIColor { named("TabTextInactive", fallback: UIColor.white.withAlphaComponent(0.5)) }

    // MARK: - Fills & borders

    static var fillGlass: UIColor { named("FillGlass", fallback: UIColor.white.withAlphaComponent(0.06)) }
    static var fillGlassMedium: UIColor { named("FillGlassMedium", fallback: UIColor.white.withAlphaComponent(0.08)) }
    static var fillGlassStrong: UIColor { named("FillGlassStrong", fallback: UIColor.white.withAlphaComponent(0.10)) }
    /// Auth ekranlarında separator panellər (ağ 0.15)
    static var glassPanel: UIColor { named("GlassPanel", fallback: UIColor.white.withAlphaComponent(0.15)) }
    static var borderHairline: UIColor { named("BorderHairline", fallback: UIColor.white.withAlphaComponent(0.07)) }
    static var dividerRow: UIColor { named("DividerRow", fallback: UIColor.white.withAlphaComponent(0.06)) }

    // MARK: - Settings / profile icon wells (mövcud catalog)

    static var iconBlue: UIColor { named("IconBlue", fallback: UIColor(red: 58 / 255, green: 107 / 255, blue: 196 / 255, alpha: 1)) }
    static var iconPurple: UIColor { named("IconPurple", fallback: UIColor(red: 92 / 255, green: 75 / 255, blue: 196 / 255, alpha: 1)) }
    static var iconGreen: UIColor { named("IconGreen", fallback: UIColor(red: 46 / 255, green: 125 / 255, blue: 82 / 255, alpha: 1)) }
    static var iconOrange: UIColor { named("IconOrange", fallback: UIColor(red: 196 / 255, green: 123 / 255, blue: 46 / 255, alpha: 1)) }
    static var iconOrangeSoft: UIColor { named("IconOrangeSoft", fallback: UIColor(red: 226 / 255, green: 114 / 255, blue: 74 / 255, alpha: 1)) }
    static var iconDarkRed: UIColor { named("IconDarkRed", fallback: UIColor(red: 142 / 255, green: 58 / 255, blue: 58 / 255, alpha: 1)) }
    static var iconRed: UIColor { named("IconRed", fallback: UIColor(red: 196 / 255, green: 58 / 255, blue: 58 / 255, alpha: 1)) }
    static var iconGray: UIColor { named("IconGray", fallback: UIColor(red: 85 / 255, green: 85 / 255, blue: 85 / 255, alpha: 1)) }

    // MARK: - Helpers

    static func named(_ name: String, fallback: UIColor) -> UIColor {
        UIColor(named: name) ?? fallback
    }

    /// İkon sətirləri üçün: `iconTintAsset` catalog adı (məs. `"IconBlue"`).
    static func iconWellBackground(for iconTintAsset: String) -> UIColor {
        named(iconTintAsset, fallback: .white).withAlphaComponent(0.2)
    }
}
