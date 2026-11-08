@echo off
setlocal
title Hiyori Dev

rem ============================================================
rem  Hiyori 源码开发模式启动器
rem  双击本文件即可，不需要在命令行里敲 npm run dev
rem  注意：本文件必须保存为 GBK/ANSI 编码，否则中文会被 cmd 解析错乱
rem ============================================================

rem 切到脚本所在目录，保证从桌面快捷方式启动也能找到项目
cd /d "%~dp0"

rem 清掉可能残留的环境变量，带着它 Electron 会被当成纯 Node 运行
set "ELECTRON_RUN_AS_NODE="

rem 依赖下载走国内镜像，只在需要重装依赖时起作用
set "ELECTRON_MIRROR=https://npmmirror.com/mirrors/electron/"
set "ELECTRON_CUSTOM_DIR={{ version }}"
set "npm_config_registry=https://registry.npmmirror.com"

echo ============================================
echo   Hiyori - 源码开发模式
echo   目录: %CD%
echo ============================================
echo.

where node >nul 2>nul
if errorlevel 1 (
  echo [错误] 没有找到 node 命令
  echo 请先安装 Node.js 22 或更高版本: https://nodejs.org/
  echo.
  pause
  exit /b 1
)

if not exist "node_modules\electron\dist\electron.exe" (
  echo [1/2] 依赖不完整，开始安装，首次需要几分钟...
  echo.
  call npm install
  if errorlevel 1 (
    echo.
    echo [错误] 依赖安装失败，请把上面的报错发给开发者
    pause
    exit /b 1
  )
  echo.
) else (
  echo [1/2] 依赖已就绪，跳过安装
)

echo [2/2] 启动 Electron 开发模式，稍等片刻窗口会弹出
echo     关闭窗口即退出，本窗口日志可用于排查问题
echo.

call npm run dev
set "EXITCODE=%errorlevel%"

echo.
if not "%EXITCODE%"=="0" (
  echo [异常退出] 退出码 %EXITCODE%，请查看上方日志
  pause
) else (
  echo 已退出
  timeout /t 2 >nul
)

exit /b %EXITCODE%
