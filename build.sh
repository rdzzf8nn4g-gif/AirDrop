#!/bin/bash
# 终端执行: chmod +x build.sh

echo ">>> 正在检查并赋予维护者脚本执行权限..."
# 加上 || true 是为了防止万一哪天你删了这两个文件，脚本也不会报错中断
chmod +x postinst postrm || true

echo ">>> 清理旧文件..."
make clean

echo ">>> 正在编译 Rootful (有根) 版本..."
make package

echo ">>> 正在编译 Rootless (无根) 版本..."
make package THEOS_PACKAGE_SCHEME=rootless

echo ">>> 正在编译 Roothide (隐藏越狱) 版本..."
make package THEOS_PACKAGE_SCHEME=roothide

echo ">>> 编译完成！所有版本已生成。"
