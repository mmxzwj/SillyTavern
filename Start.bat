@echo off
chcp 65001 >nul
setlocal EnableDelayedExpansion

:: 颜色代码 (使用PowerShell支持的颜色)
set "CYAN=Cyan"
set "GREEN=Green"
set "YELLOW=Yellow"
set "RED=Red"

:: 输出带颜色的文本函数
call :print_color %CYAN% "=== 开始执行脚本 ==="
set "start_time=%time%"

:: 检查yarn是否安装
where yarn >nul 2>nul
if %ERRORLEVEL% neq 0 (
    call :print_color %RED% "错误: 未找到yarn。请先安装yarn。"
    call :print_color %YELLOW% "可以使用 'npm install -g yarn' 安装"
    pause
    exit /b 1
)

:: 还原项目到初始状态
call :print_color %YELLOW% "正在还原项目到初始状态..."
set "reset_start_time=%time%"
:: 清理构建产物
rmdir /s /q dist 2>nul
rmdir /s /q build 2>nul
:: 清理依赖
rmdir /s /q node_modules 2>nul
del /f /q yarn.lock 2>nul
:: 清理缓存
call yarn cache clean
:: 清理其他可能的临时文件
rmdir /s /q .temp 2>nul
rmdir /s /q .cache 2>nul
set "reset_end_time=%time%"
call :calculate_duration "!reset_start_time!" "!reset_end_time!"
call :print_color %GREEN% "项目还原完成! 耗时: !duration! 秒"
set "reset_duration=!duration!"

:: 安装依赖
call :print_color %YELLOW% "正在安装依赖..."
set "install_start_time=%time%"
call yarn install
set "install_end_time=%time%"
call :calculate_duration "!install_start_time!" "!install_end_time!"
call :print_color %GREEN% "依赖安装完成! 耗时: !duration! 秒"
set "install_duration=!duration!"

:: 编译项目
call :print_color %YELLOW% "正在编译项目..."
set "build_start_time=%time%"
call yarn build
set "build_end_time=%time%"
call :calculate_duration "!build_start_time!" "!build_end_time!"
call :print_color %GREEN% "编译完成! 耗时: !duration! 秒"
set "build_duration=!duration!"

:: 启动服务器
call :print_color %YELLOW% "正在启动服务器..."
call yarn start

:: 计算总时间
set "end_time=%time%"
call :calculate_duration "!start_time!" "!end_time!"
set "total_duration=!duration!"

call :print_color %CYAN% "=== 脚本执行完成 ==="
call :print_color %GREEN% "总耗时: !total_duration! 秒"
call :print_color %GREEN% "还原耗时: !reset_duration! 秒"
call :print_color %GREEN% "安装耗时: !install_duration! 秒"
call :print_color %GREEN% "编译耗时: !build_duration! 秒"

pause
exit /b 0

:: 函数定义
:print_color
set "color=%~1"
set "text=%~2"
powershell -Command "Write-Host '%text%' -ForegroundColor %color%"
exit /b

:calculate_duration
set "start=%~1"
set "end=%~2"

:: 转换时间为秒
for /f "tokens=1-4 delims=:." %%a in ("%start%") do (
    set /a "start_seconds=(((%%a*60)+1%%b%%100)*60+1%%c%%100)*100+1%%d%%100"
)
for /f "tokens=1-4 delims=:." %%a in ("%end%") do (
    set /a "end_seconds=(((%%a*60)+1%%b%%100)*60+1%%c%%100)*100+1%%d%%100"
)

:: 计算时间差（秒）
set /a "duration=(!end_seconds!-!start_seconds!)/100"
if !duration! lss 0 set /a "duration+=8640000"
exit /b
