# コントリビューション

日本語 | [English](CONTRIBUTING.en.md)

LiseOSへの関心と協力をありがとうございます。バグ報告、テスト、ドキュメント修正、小さな改善を歓迎します。LiseOSは開発中の実験的なOSで、設計と実装は変更されることがあります。

## はじめに

- [README](README.md)と[実装の説明](docs/design/implementation.md)、[Limineの起動仕様](docs/boot/limine.md)を確認してください。
- 作業前に[既存のIssue](https://github.com/Cerune-Lang/LiseOS/issues)を確認してください。大きな設計変更や依存バージョンの更新は、実装前にIssueで相談してください。
- カーネル本体は`kernel/`に置き、**Cerune（`.ceru`）のみ**で実装します。Rust、Python、Bashなどはホスト側のビルド・検査ツールで使用します。

## バグ報告と提案

公開Issueには、可能な範囲で以下を含めてください。

- 実行したコマンドと、再現に必要な最小限の変更
- 期待した結果と実際の結果・ログ
- LiseOSのコミット、ホストOS、QEMUなどのツールのバージョン
- ELF生成・ISO生成・QEMU起動検査のどの段階で起きたか

セキュリティ上の問題は**公開Issueに書かず**、[SECURITY.md](SECURITY.md)を参照してください。

## 開発と確認

LinuxまたはWSL2上で、READMEに記載のRust、Python 3、LLVM lld、Git、Make、xorriso、QEMU、GDBを用意してください。

```sh
git clone https://github.com/Cerune-Lang/LiseOS.git
cd LiseOS
python3 scripts/check-source.py
cargo test --manifest-path tools/object-builder/Cargo.toml
bash scripts/build.sh
bash scripts/iso.sh
bash scripts/smoke-qemu.sh
```

`build.sh`はELF生成の検査、`smoke-qemu.sh`はQEMU上でCeruneの`main`へ到達するかをGDBで観測する検査です。画面表示やメモリ管理の動作確認ではありません。環境の都合で実行できなかった検査はPRに明記してください。

LimineとCeruneコンパイラの依存バージョンは固定しています。更新時は、変更理由と起動検査への影響を説明してください。

## Pull Request

- 1つのPRでは目的をなるべく絞り、`main`へのPRを作成してください。
- 変更内容・理由、確認したコマンドや結果、関連Issueを記載してください。
- カーネル・ビルド・起動処理を変更したら、関連するテストとドキュメントも更新してください。
- READMEなど日英の対になる文書は、できる限り両方更新してください。
- 提出するコードを提供する権利があり、LiseOSの[MIT OR Apache-2.0](README.md#ライセンス)で提供できることを確認してください。

小さな修正や質問も歓迎します。
