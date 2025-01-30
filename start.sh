#!/bin/bash

# 输出带颜色的文本函数
print_color() {
    local color=$1
    local text=$2
    echo -e "\033[${color}m${text}\033[0m"
}

# 记录开始时间
print_color "36" "=== 开始执行脚本 ==="
total_start_time=$(date +%s)

# 检查yarn是否安装
if ! command -v yarn &> /dev/null; then
    print_color "31" "错误: 未找到yarn。请先安装yarn。"
    print_color "33" "可以使用 'npm install -g yarn' 安装"
    exit 1
fi

# 编译项目
print_color "33" "\n正在编译项目..."
build_start_time=$(date +%s)
yarn build
build_end_time=$(date +%s)
build_duration=$((build_end_time - build_start_time))
print_color "32" "编译完成! 耗时: ${build_duration} 秒"

# 启动服务器
print_color "33" "\n正在启动服务器..."
yarn start

# 计算总时间
total_end_time=$(date +%s)
total_duration=$((total_end_time - total_start_time))

print_color "36" "\n=== 脚本执行完成 ==="
print_color "32" "总耗时: ${total_duration} 秒"
print_color "32" "编译耗时: ${build_duration} 秒"
