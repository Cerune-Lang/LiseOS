# LiseOS の実装

## 使用するもの

- **Cerune:** `kernel/main.ceru` をコンパイルし、x86-64 ELFオブジェクトを生成する。
- **ld.lld:** オブジェクトを `linker.ld` に従ってリンクし、`liseos.elf` を作る。
- **Limine:** ISOからELFを読み込み、64ビットカーネルの `main` へ処理を渡す。
- **QEMU:** x86-64環境を実行する。
- **GDB:** QEMU上で `main` に到達したか調べる。

## ファイル

| ファイル | 内容 |
| --- | --- |
| `kernel/main.ceru` | カーネルの入口。現状は無限ループのみ |
| `tools/object-builder/` | ホストPC上で動くRust製ツール。CeruneのObject生成APIを呼ぶ |
| `linker.ld` | ELFの配置、エントリアドレス、Limine用のデータを指定する |
| `limine.conf` | Limineが読み込むカーネルファイル名を指定する |
| `scripts/build.sh` | ELFオブジェクト生成、リンク、検査 |
| `scripts/iso.sh` | Limine v11.4.1を取得してISOを生成 |
| `scripts/smoke-qemu.sh` | QEMUとGDBで `main` 到達を確認 |

## Ceruneの現状

`compile_to_native_object` はELF64オブジェクトを生成できる。現在のCLIによる通常ビルドにはホストOS向けの処理が含まれるので、LiseOSのホスト用ツールから直接このAPIを呼ぶ。

現在の `print` はホストOSの出力機能を使う。シリアル出力にはCerune側にポートI/O等の実装が必要。カーネルの実行時コードにはCやアセンブリを追加しない。Rust、Python、Bash、リンカはホスト側の開発ツールに使う。

Cisaは現在の実行先ではない。まずx86-64/QEMUでカーネルの処理を実装・確認する。

## 実行確認

`build.sh` はELFを作る。起動したことを確認するには、`iso.sh`で作ったISOをQEMUで読み込み、GDBで `main` への到達を確認する。CI結果は [GitHub Actions](https://github.com/Cerune-Lang/LiseOS/actions) を参照。

ブートローダーの具体的な働きは [Limine](../boot/limine.md) に記載。
