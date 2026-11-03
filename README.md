# LiseOS

**LiseOS（リーサOS）** は、[Cerune](https://github.com/Cerune-Lang/Cerune)でカーネルを実装する実験的なオペレーティングシステムです。名前の読みは「リーサ」。

> **Status: M1a bootstrap implementation committed, boot not yet verified**  
> 対象は **x86-64 / QEMU**。Cerune製の最小エントリ、ELF生成・検査、Limine ISO生成、QEMU/GDB検証スクリプトを用意しました。**実際の起動成功やシリアル出力は未確認です。**

[English](README.en.md) · [Limineの説明](docs/boot/limine.md) · [ADR-0001: x86-64/QEMU](docs/decisions/0001-target-x86-64-qemu.md) · [ADR-0002: Cerune-only kernel](docs/decisions/0002-cerune-only-kernel.md)

## 基本方針

- **カーネルの実行時コードはCeruneで書く。** Cやアセンブリで別のカーネルを先に作らない。
- 不足する低レイヤー機能はCerune側の設計・実装課題として検証する。
- Rust製のホスト側ビルド補助、LLVMリンカ、Limine、QEMU、Python/Bashによる検査は利用する。それらはLiseOSカーネルのコードではない。
- Cisa移植は、x86-64側のカーネル基盤が安定してから検討する。

## M1a: エントリへの到達を確認する

```text
kernel/main.ceru
      ↓ Cerune object-builder (host Rust utility)
  ELF64 .o
      ↓ ld.lld + linker.ld
  liseos.elf
      ↓ Limine + QEMU
  x86-64 kernel entry: main
      ↓
  Ceruneの無限ループ（出力なし）
```

初期の`kernel/main.ceru`は無限ループだけです。シリアル文字列`LiseOS: boot ok`は、CeruneにハードウェアI/Oを導入する**M1bの目標**として残しています。既存の`print`はホストOS依存のため使いません。

`linker.ld`にはLimine向けのrequestマーカーとbase revisionをデータとして配置しています。Limineの役割やバージョンについては[ブート仕様の説明](docs/boot/limine.md)を参照してください。

## ビルド・QEMU検証（Linux / WSL2）

Rust/Cargo、Python 3、`ld.lld`、Git、GNU Make、xorriso、QEMU、GDBが必要です。

```sh
python3 scripts/check-source.py
cargo test --manifest-path tools/object-builder/Cargo.toml
bash scripts/build.sh
bash scripts/iso.sh
bash scripts/smoke-qemu.sh
```

- `build.sh`はCerune生成オブジェクトと高位アドレスELFを作り、未解決ホストライブラリ参照などを検査します。
- `iso.sh`は**固定版Limine v11.4.1**を使ってISOを生成します。
- `smoke-qemu.sh`はQEMUのGDBスタブでエントリへの制御移行を確認します。QEMUが無い環境では検証できません。
- `bash scripts/debug-qemu.sh`で手動GDBデバッグもできます。

`build.sh`の成功は**起動成功の証明ではありません**。QEMUへの到達を観測した時点でM1aの実行検証とします。

## マイルストーン

| 段階 | 内容 | 状態 |
| --- | --- | --- |
| M0 | x86-64/QEMU、Limine、Cerune製カーネル方針 | **決定済み** |
| M1a | Ceruneソース→ELF→Limine→QEMUのエントリ観測 | **初期実装あり・未検証** |
| M1b | CeruneのハードウェアI/Oでシリアル出力と停止 | **未実装** |
| M2 | 例外・メモリマップ・物理メモリ | **計画** |
| M3 | 割り込みとタスク | **計画** |
| 将来 | Cisaへの移植検討 | **対象外（当面）** |

## リポジトリ構成

- `kernel/main.ceru` — Cerune製の最小カーネル
- `tools/object-builder/` — CeruneコンパイラのネイティブObject APIを呼ぶ**ホスト専用**Rustユーティリティ
- `linker.ld` / `limine.conf` — ELFとブートローダーの設定
- `scripts/` — ビルド、ISO生成、ELF監査、QEMU/GDB検査
- `.github/workflows/bootstrap.yml` — 同じ手順をCIで検証する設定
- `docs/boot/limine.md` / `docs/decisions/` — ブートと設計判断

## 開発上の注意

「設計した」「実装した」「ビルドできた」「QEMUで起動した」「確認した」は異なる段階です。QEMUで動いたとしても実機対応の証明ではありません。

## 関連プロジェクト

- [Cerune](https://github.com/Cerune-Lang/Cerune) — 言語・コンパイラ
- [Sashimi](https://github.com/Cerune-Lang/Sashimi) — ネイティブObject生成に使うアセンブラ基盤
- [Cisa](https://github.com/Cerune-Lang/Cisa) — 将来の移植先候補

## ライセンス

未決定です。第三者からのコード提供を受け付ける前に、ライセンスと貢献方針を明確にします。
