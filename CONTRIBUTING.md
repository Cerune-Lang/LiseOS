# コントリビューション

日本語 | [English](CONTRIBUTING.en.md)

LiseOSへのバグ報告、テスト、ドキュメント修正、小さな機能改善を歓迎します。LiseOSは開発中の実験的なOSで、構成や実装方針は変更されることがあります。

## はじめに

- [README](README.md)と[実装の説明](docs/design/implementation.md)で現在の構成を確認してください。
- 作業前に[既存のIssue](https://github.com/Cerune-Lang/LiseOS/issues)とPull Requestを確認してください。
- 大きな機能追加や設計変更は、実装前にIssueで相談してください。

## バグ報告・提案

Issueには可能な範囲で、実行コマンド、期待結果と実際の結果、利用OS、QEMU・Limineのバージョン、LiseOSのコミット、再現に必要な最小限のソースやログを添えてください。

セキュリティ上の問題は公開Issueに書かず、[SECURITY.md](SECURITY.md)に従って非公開で報告してください。

## 実装方針

- カーネルの実行時コードは **Cerune** で実装します。`kernel/`には`.ceru`ソースだけを置き、C/Assembly/Rustをカーネルに混在させないでください。
- Rust、Python、Bash、リンカなどはホスト側の開発ツールとして使用できます。
- ビルド成功と起動成功を区別してください。現在のQEMUスモークテストは、カーネルの`main`への到達を確認するもので、画面表示やシリアル出力の完成を証明しません。
- LimineやCeruneの固定リビジョンを変更するときは、変更理由と影響、再現した検証結果を記載してください。

## 開発・確認

Linux / WSL2でRust、Python 3、LLVM lld、Git、Make、xorriso、QEMU、GDBを用意してください。

```sh
git clone https://github.com/Cerune-Lang/LiseOS.git
cd LiseOS
python3 scripts/check-source.py
cargo test --manifest-path tools/object-builder/Cargo.toml
bash scripts/build.sh
bash scripts/iso.sh
bash scripts/smoke-qemu.sh
```

一部の検査には外部ツールと時間が必要です。実行できない場合は、その理由をPRに明記してください。CIでもこれらを検査します。

## Pull Request

- 目的を絞ったPRを作り、変更内容と理由を説明してください。
- 関連Issueがあればリンクし、実行した検証と結果を記載してください。
- 実行結果に影響する変更には、可能な限り関連する検査を追加してください。
- ドキュメントを変更するときは必要に応じて日本語版と英語版を両方更新してください。
- 既知の制限や未検証事項は隠さず記載してください。

小さな修正や質問からでも歓迎です。
