import 'package:flutter/material.dart';

// ============================================================================
// アプリケーション全体のテーマ設定
// ============================================================================
//
// このクラスは、アプリケーション全体で使用する色、サイズ、スタイルを
// 一元管理します。これにより、以下のメリットがあります:
//
// 1. デザインの一貫性: 全画面で同じスタイルを使用
// 2. 保守性: 色やサイズを変更する際、ここを修正するだけで全体に反映
// 3. 可読性: マジックナンバー（16, 24などの直接記述）を避ける
//
// Material Design 3 (マテリアルデザイン3) の原則に従っています。
class AppTheme {
  // ==========================================================================
  // カラーパレット
  // ==========================================================================
  //
  // 16進数カラーコード（0xAARRGGBB形式）で定義:
  // - AA: アルファ値（透明度）、FFは不透明
  // - RR: 赤成分
  // - GG: 緑成分
  // - BB: 青成分

  // プライマリーカラー（メインカラー）
  // アプリの主要な色で、ボタンやタブなど重要な要素に使用
  static const Color primaryColor = Color(0xFF5E35B1); // ディープパープル

  // プライマリーカラーの明るいバリエーション
  // グラデーションやホバー状態などに使用
  static const Color primaryLightColor = Color(0xFF9162E4);

  // プライマリーカラーの暗いバリエーション
  // 影や強調表示に使用
  static const Color primaryDarkColor = Color(0xFF311B92);

  // アクセントカラー（補助的な強調色）
  // プライマリーカラーと組み合わせて使用
  static const Color accentColor = Color(0xFF00ACC1); // シアン

  // 背景色（画面全体の背景）
  static const Color backgroundColor = Color(0xFFF5F5F7);

  // サーフェスカラー（カードやボックスの背景）
  static const Color surfaceColor = Color(0xFFFFFFFF);

  // エラーカラー（エラーメッセージなど）
  static const Color errorColor = Color(0xFFE53935);

  // 成功カラー（成功メッセージなど）
  static const Color successColor = Color(0xFF43A047);

  // ==========================================================================
  // テキストカラー
  // ==========================================================================
  //
  // 読みやすさを確保するため、背景色とのコントラスト比を考慮しています

  // プライマリーテキスト（見出しや本文）
  static const Color textPrimaryColor = Color(0xFF212121);

  // セカンダリーテキスト（説明文や補足情報）
  static const Color textSecondaryColor = Color(0xFF757575);

  // 無効化されたテキスト
  static const Color textDisabledColor = Color(0xFFBDBDBD);

  // ==========================================================================
  // グリッドシステム（8pxベース）
  // ==========================================================================
  //
  // Material Designでは、全ての間隔を8の倍数にすることが推奨されています。
  // これにより、視覚的に整ったレイアウトが実現できます。
  //
  // 命名規則: spacing + 倍数
  // - spacing1 = 4px (8pxの半分、非常に狭い間隔)
  // - spacing2 = 8px (基本単位)
  // - spacing3 = 12px
  // - spacing4 = 16px (よく使う標準的な間隔)
  // - spacing5 = 24px
  // - spacing6 = 32px
  // - spacing8 = 48px (大きな間隔)

  static const double spacing1 = 4.0;
  static const double spacing2 = 8.0;
  static const double spacing3 = 12.0;
  static const double spacing4 = 16.0;
  static const double spacing5 = 24.0;
  static const double spacing6 = 32.0;
  static const double spacing8 = 48.0;

  // ==========================================================================
  // ボーダー半径（角丸の大きさ）
  // ==========================================================================
  //
  // 角を丸くする際の半径を定義します。
  // 統一することで、アプリ全体で一貫したデザインになります。

  static const double radiusSmall = 4.0; // 小さい角丸
  static const double radiusMedium = 8.0; // 標準的な角丸
  static const double radiusLarge = 12.0; // 大きい角丸
  static const double radiusXLarge = 16.0; // 非常に大きい角丸

  // ==========================================================================
  // シャドウ（影）
  // ==========================================================================
  //
  // BoxShadowは、要素に影を付けるためのクラスです。
  // 影により、要素の階層（手前・奥）を視覚的に表現できます。
  //
  // 主なプロパティ:
  // - color: 影の色（通常は黒を半透明にする）
  // - blurRadius: ぼかしの半径（大きいほどぼやける）
  // - offset: 影の位置（x, y方向のずれ）

  // 小さい影（軽い要素用）
  static List<BoxShadow> shadowSmall = [
    BoxShadow(
      color: Colors.black.withOpacity(0.08), // 黒を8%の透明度で
      blurRadius: 4, // 4pxぼかす
      offset: const Offset(0, 2), // 下に2pxずらす
    ),
  ];

  // 中くらいの影（カードや重要な要素用）
  static List<BoxShadow> shadowMedium = [
    BoxShadow(
      color: Colors.black.withOpacity(0.12), // 黒を12%の透明度で
      blurRadius: 8, // 8pxぼかす
      offset: const Offset(0, 4), // 下に4pxずらす
    ),
  ];

  // ==========================================================================
  // テーマデータ
  // ==========================================================================
  //
  // ThemeDataは、Flutterアプリ全体のテーマを定義するクラスです。
  // MaterialAppのthemeプロパティに渡すことで、全Widgetに適用されます。
  static ThemeData lightTheme = ThemeData(
    // Material Design 3を使用
    // これにより、最新のデザインガイドラインに準拠します
    useMaterial3: true,

    // カラースキーム
    // ColorScheme.fromSeed()は、1つの色から調和の取れた配色を自動生成します
    colorScheme: ColorScheme.fromSeed(
      seedColor: primaryColor, // 基準となる色
      primary: primaryColor, // プライマリーカラー
      secondary: accentColor, // セカンダリーカラー
      background: backgroundColor, // 背景色
      surface: surfaceColor, // サーフェス色
      error: errorColor, // エラー色
    ),

    // Scaffoldの背景色
    // Scaffoldは、Material Designの基本レイアウト構造です
    scaffoldBackgroundColor: backgroundColor,

    // AppBarのテーマ
    appBarTheme: const AppBarTheme(
      elevation: 0, // 影の高さ（0で影なし）
      centerTitle: false, // タイトルを左寄せ
      backgroundColor: surfaceColor, // 背景色
      foregroundColor: textPrimaryColor, // 文字色
      titleTextStyle: TextStyle(
        color: textPrimaryColor,
        fontSize: 20,
        fontWeight: FontWeight.w600, // セミボールド
      ),
    ),

    // Chipのテーマ
    // Chipは、選択された項目を表示する小さなボックスです
    chipTheme: ChipThemeData(
      backgroundColor: primaryColor.withOpacity(0.1),  // 薄い背景色
      selectedColor: primaryColor,                     // 選択時の色
      deleteIconColor: primaryColor,                   // 削除アイコンの色
      labelStyle: const TextStyle(
        color: primaryColor,
        fontWeight: FontWeight.w500,                   // ミディアムウェイト
      ),
      padding: const EdgeInsets.symmetric(
        horizontal: spacing3,
        vertical: spacing2,
      ),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(radiusLarge),
      ),
    ),

    // 入力フィールドのテーマ
    // TextField、TextFormFieldなどに適用されます
    inputDecorationTheme: InputDecorationTheme(
      filled: true, // 背景色を塗りつぶす
      fillColor: surfaceColor, // 背景色
      contentPadding: const EdgeInsets.symmetric(
        horizontal: spacing4,
        vertical: spacing3,
      ),

      // ボーダーの設定（状態ごとに定義）

      // 通常時のボーダー
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(radiusMedium),
        borderSide: BorderSide(color: Colors.grey.shade300),
      ),

      // 有効だが未フォーカス時のボーダー
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(radiusMedium),
        borderSide: BorderSide(color: Colors.grey.shade300),
      ),

      // フォーカス時のボーダー（太くする）
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(radiusMedium),
        borderSide: const BorderSide(color: primaryColor, width: 2),
      ),
    ),

    // ElevatedButtonのテーマ
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        elevation: 0, // 影なし（フラットデザイン）
        padding: const EdgeInsets.symmetric(
          horizontal: spacing5,
          vertical: spacing3,
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(radiusMedium),
        ),
      ),
    ),

    // TextButtonのテーマ
    textButtonTheme: TextButtonThemeData(
      style: TextButton.styleFrom(
        padding: const EdgeInsets.symmetric(
          horizontal: spacing4,
          vertical: spacing2,
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(radiusMedium),
        ),
      ),
    ),
  );
}