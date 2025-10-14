# 🎨 How to Change QuestLog App Icon

Follow these steps to customize your app icon!

---

## 📋 What You Need

1. **App Icon Image**: 1024x1024 pixels PNG (with transparency)
2. **Foreground Icon** (for Android adaptive icon): 1024x1024 pixels PNG

---

## 🎯 Step-by-Step Guide

### 1️⃣ **Create Your Icon**

**Option A: Design Your Own**
- Use tools like:
  - **Figma** (free, online)
  - **Canva** (free, easy)
  - **Adobe Illustrator**
  - **Photoshop**
- Size: **1024x1024 pixels**
- Format: **PNG with transparent background**
- Style: Match your app's theme (gaming, modern, colorful)

**Option B: Use Icon Generator**
- [App Icon Generator](https://appicon.co/)
- [Icon Kitchen](https://icon.kitchen/)
- Upload a base image and it generates all sizes

**Design Tips:**
- Keep it simple and recognizable
- Use bold colors (your accent color: `#00D9FF`)
- Make it stand out on both light and dark backgrounds
- Test at small sizes (it should be clear even at 48x48)

**Icon Ideas for QuestLog:**
- 🎮 Game controller icon
- 📚 Book with game controller
- ✓ Checkmark with game elements
- 🎯 Target/quest icon
- 📝 List with game symbols

---

### 2️⃣ **Prepare Your Icon Files**

Create a folder structure:
```
QuestLog/
└── assets/
    └── icon/
        ├── app_icon.png (1024x1024 - full icon)
        └── app_icon_foreground.png (1024x1024 - foreground only for Android)
```

**Create the folder:**
```bash
mkdir -p assets/icon
```

**Two files needed:**

1. **app_icon.png**
   - Your complete icon design
   - 1024x1024 pixels
   - PNG with transparency
   - This will be used for iOS and as fallback

2. **app_icon_foreground.png** (for Android adaptive icons)
   - Just the main icon element (no background)
   - 1024x1024 pixels
   - PNG with transparency
   - Should fit in the safe zone (center 66%)
   - Background color is set to `#1A1D29` (your app's dark color)

---

### 3️⃣ **Place Your Icons**

Copy your icon files to:
```
c:/Users/ebiso/StudioProjects/QuestLog/assets/icon/
```

Make sure you have:
- ✅ `app_icon.png`
- ✅ `app_icon_foreground.png`

---

### 4️⃣ **Install Dependencies**

Run in terminal:
```bash
flutter pub get
```

---

### 5️⃣ **Generate Icons**

Run the icon generator:
```bash
flutter pub run flutter_launcher_icons
```

This will automatically:
- ✅ Generate all required icon sizes for Android
- ✅ Generate all required icon sizes for iOS
- ✅ Update Android manifest
- ✅ Update iOS assets

You should see output like:
```
Creating icons for Android...
Creating icons for iOS...
✓ Successfully generated launcher icons
```

---

### 6️⃣ **Test Your New Icon**

**Full rebuild required:**
```bash
flutter clean
flutter pub get
flutter run
```

**Check:**
- Android: Look at your app drawer
- iOS: Look at your home screen
- The new icon should appear!

---

## 🎨 Current Configuration

Your `pubspec.yaml` is already configured:

```yaml
flutter_launcher_icons:
  android: true
  ios: true
  image_path: "assets/icon/app_icon.png"
  adaptive_icon_background: "#1A1D29"  # Your app's dark background
  adaptive_icon_foreground: "assets/icon/app_icon_foreground.png"
```

---

## 🔧 Customize Further

### Change Background Color (Android Adaptive Icon)
Edit `pubspec.yaml`:
```yaml
adaptive_icon_background: "#00D9FF"  # Use your accent color
```

### iOS Only
```yaml
flutter_launcher_icons:
  ios: true
  image_path: "assets/icon/app_icon.png"
```

### Android Only
```yaml
flutter_launcher_icons:
  android: true
  image_path: "assets/icon/app_icon.png"
  adaptive_icon_background: "#1A1D29"
  adaptive_icon_foreground: "assets/icon/app_icon_foreground.png"
```

---

## 📱 Icon Sizes Generated

**Android:**
- mipmap-mdpi: 48x48
- mipmap-hdpi: 72x72
- mipmap-xhdpi: 96x96
- mipmap-xxhdpi: 144x144
- mipmap-xxxhdpi: 192x192

**iOS:**
- 20x20 to 1024x1024 (all required sizes)

---

## 🎨 Quick Icon Template

If you want a simple QuestLog icon, here's a concept:

**Design:**
- Background: Circular gradient (dark blue to cyan)
- Icon: White game controller silhouette
- Style: Minimalist, modern
- Colors: Match your app theme

**Tools to create it:**
- Canva: Search "game controller icon"
- Figma: Use icon plugins
- Flaticon: Download game controller SVG

---

## ⚠️ Common Issues

### Icon not updating?
```bash
flutter clean
flutter pub get
flutter run
```

### Still old icon?
- Uninstall the app completely
- Reinstall: `flutter run`

### Android adaptive icon looks wrong?
- Check foreground icon has transparent background
- Ensure main content is in center 66% (safe zone)
- Test on different Android launchers

---

## 🎯 Example Icons

**Simple Gamepad:**
```
🎮 - Use a simple controller icon
Background: #1A1D29 (dark)
Foreground: #00D9FF (cyan) controller
```

**Quest Book:**
```
📚 - Book icon with checkmark
Background: Gradient dark to cyan
Foreground: White book outline
```

**Minimalist:**
```
✓ - Large checkmark
Background: Solid #1A1D29
Foreground: #00D9FF checkmark
```

---

## 🚀 Next Steps

1. Create your icon (1024x1024 PNG)
2. Save to `assets/icon/app_icon.png`
3. Create foreground version (optional but recommended)
4. Run: `flutter pub run flutter_launcher_icons`
5. Rebuild: `flutter clean && flutter run`
6. Enjoy your custom icon! 🎉

---

## 📚 Resources

- [App Icon Generator](https://appicon.co/)
- [Flutter Launcher Icons Package](https://pub.dev/packages/flutter_launcher_icons)
- [Android Adaptive Icons Guide](https://developer.android.com/guide/practices/ui_guidelines/icon_design_adaptive)
- [iOS App Icon Guidelines](https://developer.apple.com/design/human-interface-guidelines/app-icons)

---

**Need help? Check the package documentation or ask in Flutter community!** 🎮
