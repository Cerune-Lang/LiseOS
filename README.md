# LiseOS

日本語 | [English](README.en.md)

LiseOS（リーサOS）は、[Cerune](https://github.com/Cerune-Lang/Cerune)でカーネルを実装する実験的なオペレーティングシステムです。x86-64/QEMU上で[Limine](https://github.com/Limine-Bootloader/Limine)を使って起動します。

現在はCerune製の最小カーネルとビルド・起動検査用のツールを実装しています。シリアル出力やメモリ管理は未実装です。

[![License: MIT OR Apache-2.0](https://img.shields.io/badge/license-MIT%20OR%20Apache--2.0-blue)](#ライセンス)

## ビルドと実行

Linux / WSL2でRust、Python 3、LLVM lld、Git、Make、xorriso、QEMU、GDBを用意してください。

```sh
git clone https://github.com/Cerune-Lang/LiseOS.git
cd LiseOS
bash scripts/iso.sh
bash scripts/smoke-qemu.sh
```

`iso.sh`はCeruneソースからELFと起動ISOを作ります。`smoke-qemu.sh`はQEMUとGDBでカーネルの`main`への到達を確認します。

検査結果は[GitHub Actions](https://github.com/Cerune-Lang/LiseOS/actions)で確認できます。

## ソースと資料

- [kernel/main.ceru](kernel/main.ceru) — カーネル本体
- [実装の説明](docs/design/implementation.md) — 使用するツールと各ファイルの役割
- [Limineについて](docs/boot/limine.md) — ブートローダーと起動方法

## 関連リポジトリ

[Cerune](https://github.com/Cerune-Lang/Cerune) · [Sashimi](https://github.com/Cerune-Lang/Sashimi) · [Cisa](https://github.com/Cerune-Lang/Cisa)

## ライセンス

LiseOSは、以下のいずれかのライセンスを選択して利用できます。

- [MIT License](LICENSE-MIT)
- [Apache License 2.0](LICENSE-APACHE)
