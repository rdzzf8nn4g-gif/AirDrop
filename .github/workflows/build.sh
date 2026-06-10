name: Build AirDrop

on:
  # 当代码推送到 main 或 master 分支时自动触发编译
  push:
    branches:
      - main
      - master
  # 允许在 GitHub Actions 页面手动点击运行
  workflow_dispatch:

jobs:
  build:
    name: Build iOS Tweak
    runs-on: macos-latest 
    env:
      THEOS: ${{ github.workspace }}/theos 

    steps:
      - name: 📥 检出代码 (Checkout Repository)
        uses: actions/checkout@v4

      - name: ⚙️ 安装依赖 (Install Dependencies)
        run: |
          brew install ldid dpkg

      - name: 🛠️ 配置 Theos 环境 (Setup Roothide Theos)
        run: |
          echo "Cloning Roothide Theos fork..."
          git clone --recursive https://github.com/roothide/theos.git $THEOS

      - name: 📦 下载 iOS SDK (Setup iOS SDKs)
        run: |
          echo "Cloning iOS SDKs..."
          rm -rf $THEOS/sdks
          git clone https://github.com/theos/sdks.git $THEOS/sdks

      - name: 🚀 运行编译脚本 (Run build.sh)
        run: |
          # 赋予执行权限并直接运行（去掉了 sudo 以防文件权限错乱导致打包失败）
          chmod +x build.sh
          ./build.sh

      - name: 📤 上传编译产物 (Upload Artifacts)
        uses: actions/upload-artifact@v4
        with:
          name: AirDrop-Packages
          path: packages/*.deb
