@echo off
chcp 65001 >nul
echo ========================================================
echo   人教版高中英语听说训练 - 安卓 APK 一键打包脚本
echo ========================================================
echo.

echo [1/4] 检查 Flutter 与运行环境...
where flutter >nul 2>nul
if %errorlevel% neq 0 (
    echo [错误] 未在系统 PATH 中找到 Flutter。
    echo 请先安装 Flutter SDK，或使用 GitHub Actions 云端自动构建工作流。
    pause
    exit /b 1
)

echo [2/4] 获取依赖包...
call flutter pub get
if %errorlevel% neq 0 (
    echo [错误] 获取依赖失败，请检查网络设置。
    pause
    exit /b 1
)

echo [3/4] 执行单元测试...
call flutter test
if %errorlevel% neq 0 (
    echo [错误] 单元测试未通过，终止打包。
    pause
    exit /b 1
)

echo [4/4] 正在编译生成 Release APK...
call flutter build apk --release

if %errorlevel% equ 0 (
    echo.
    echo ========================================================
    echo   [成功] APK 打包完成！
    echo   安装包路径: build\app\outputs\flutter-apk\app-release.apk
    echo ========================================================
    explorer.exe build\app\outputs\flutter-apk
) else (
    echo.
    echo [错误] APK 编译失败，请检查上方控制台日志。
)

pause
