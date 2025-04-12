#!/bin/bash

function install_node() {
    echo "📦 安装 Rust..."
    curl https://sh.rustup.rs -sSf | sh -s -- -y
    source $HOME/.cargo/env

    echo "🔧 安装 Solana CLI..."
    sh -c "$(curl -sSfL https://release.solana.com/v1.18.4/install)"
    export PATH="$HOME/.local/share/solana/install/active_release/bin:$PATH"

    echo "🔐 生成钱包地址..."
    solana-keygen new --no-passphrase --outfile ~/.config/solana/id.json

    echo "🌐 设置 RPC 节点..."
    solana config set --url https://mainnetbeta-rpc.eclipse.xyz/

    echo "🔨 安装 bitz CLI 工具..."
    cargo install bitz

    echo "✅ 安装完成！你现在可以查看地址或启动节点。"
}

function show_wallet() {
    echo "📄 当前钱包地址："
    solana address
    echo "📄 助记词（请妥善保存）："
    cat ~/.config/solana/id.json
}

function run_node() {
    export SOLANA_KEYPAIR=~/.config/solana/id.json
    echo "🚀 启动 ePOW 节点并在后台运行中 (screen 会话)..."
    screen -S eclipse -dm bash -c "export SOLANA_KEYPAIR=$SOLANA_KEYPAIR && bitz collect"
    echo "✅ 节点已在后台运行"
    echo "👉 输入以下命令查看节点运行情况："
    echo "   screen -r eclipse"
}

function check_balance() {
    echo "💰 正在查询 Bitz 账户余额..."
    export SOLANA_KEYPAIR=~/.config/solana/id.json
    bitz account
}

function claim_bitz() {
    echo "🎁 正在领取 Bitz 奖励..."
    export SOLANA_KEYPAIR=~/.config/solana/id.json
    bitz claim
}

while true; do
    echo "=================================================="
    echo "🧠 ePOW 一键脚本 | by ChatGPT"
    echo "=================================================="
    echo "1. 安装节点"
    echo "2. 查看地址与助记词"
    echo "3. 启动节点挖矿（后台运行）"
    echo "4. 查看 Bitz 余额"
    echo "5. 领取 Bitz 奖励"
    echo "=================================================="
    read -p "请输入操作编号 (1/2/3/4/5): " choice

    case $choice in
        1)
            install_node
            ;;
        2)
            show_wallet
            ;;
        3)
            run_node
            ;;
        4)
            check_balance
            ;;
        5)
            claim_bitz
            ;;
        *)
            echo "❗ 无效选项，请重新输入 1-5。"
            ;;
    esac
done
