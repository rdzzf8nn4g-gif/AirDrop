#!/bin/bash
# 终端执行: chmod +x build.sh

echo ">>> 正在修复维护者脚本换行符与权限 (防止静默失效)..."
# 强制将 CRLF(Windows) 转换为 LF(Unix)，macOS runner 完美兼容
perl -pi -e 's/\r$//' postinst postrm 2>/dev/null || true
# 赋予标准的 rwxr-xr-x 权限
chmod 0755 postinst postrm 2>/dev/null || true

echo ">>> 清理旧文件..."
make clean

echo ">>> 正在编译 Rootful (有根) 版本..."
make package

echo ">>> 正在编译 Rootless (无根) 版本..."
make package THEOS_PACKAGE_SCHEME=rootless

echo ">>> 正在编译 Roothide (隐藏越狱) 版本..."
make package THEOS_PACKAGE_SCHEME=roothide

echo ">>> 编译完成！所有版本已生成。"
