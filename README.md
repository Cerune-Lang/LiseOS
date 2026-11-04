# LiseOS

日本語 | [English](README.en.md)

LiseOS（リーサOS）は、[Cerune](https://github.com/Cerune-Lang/Cerune)でカーネルを実装する実験的なオペレーティングシステムです。x86-64/QEMU上で[Limine](https://github.com/Limine-Bootloader/Limine)を使って起動します。

現在はCerune製の最小カーネルとビルド・起動検査用のツールを実装しています。シリアル出力やメモリ管理は未実装です。

[![CI](https://github.com/Cerune-Lang/LiseOS/actions/workflows/bootstrap.yml/badge.svg)](https://github.com/Cerune-Lang/LiseOS/actions/workflows/bootstrap.yml)
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

## リポジトリ構成

| パス | 役割 |
| --- | --- |
| `kernel/` | Ceruneで記述したカーネル本体 |
| `tools/object-builder/` | CeruneからELFオブジェクトを生成するホスト側Rustツール |
| `scripts/` | ビルド、ELF検査、ISO生成、QEMU起動検査 |
| `docs/` | 実装方針とLimineの起動仕様 |
| `licenses/limine/` | 同梱するLimineのライセンス・第三者ソフトウェア表示 |

## 開発時の確認

```sh
python3 scripts/check-source.py
cargo test --manifest-path tools/object-builder/Cargo.toml
bash scripts/build.sh
bash scripts/iso.sh
bash scripts/smoke-qemu.sh
```

これらの確認は[CI](.github/workflows/bootstrap.yml)でも実行しています。起動検査で確認するのは、QEMU上のカーネルがCerune製`main`に到達することまでです。画面表示やメモリ管理などの実装完了は意味しません。

## 関連リポジトリ

[Cerune](https://github.com/Cerune-Lang/Cerune) · [Sashimi](https://github.com/Cerune-Lang/Sashimi) · [Cisa](https://github.com/Cerune-Lang/Cisa)

## ライセンス

LiseOSは、以下のいずれかのライセンスを選択して利用できます。

- [MIT License](LICENSE-MIT)
- [Apache License 2.0](LICENSE-APACHE)
