# LiseOS

**LiseOS（リーサOS）** は、Ceruneエコシステムとともに育てる実験的なオペレーティングシステムです。

> **Status: bootstrap / 初期実装前**  
> 最初のターゲットは **x86-64 / QEMU** に決定しました。起動可能なカーネルやOS機能が完成したという意味ではありません。

[English](README.en.md) · [設計判断: ADR-0001](docs/decisions/0001-target-x86-64-qemu.md)

## 最初の目標

**QEMU上でLiseOSカーネルを起動し、シリアルへメッセージを出し、意図した方法で停止する。**

初期の想定構成：

```text
QEMU (x86-64)
  -> Limine bootloader
     -> freestanding LiseOS kernel
        -> serial output: "LiseOS: boot ok"
        -> deliberate halt / QEMU exit
```

M1の完了条件は「ソースがビルドできた」ことではなく、**実際にQEMUで起動して観測できた**ことです。具体的な検証条件は [ADR-0001](docs/decisions/0001-target-x86-64-qemu.md) を参照してください。

## ターゲットと移植方針

| 対象 | 位置付け | 状態 |
| --- | --- | --- |
| **x86-64 / QEMU** | 最初の正式ターゲット。Limineで起動し、カーネルの基盤を作る | **選定済み / 未実装** |
| **Cisa** | 基盤が安定してから評価する移植先候補 | **将来構想** |
| **実機x86-64** | QEMUと別に互換性・ドライバ等の検証が必要 | **対象外（当面）** |

初期起動のためのC / 最小アセンブリは許容します。**Ceruneでカーネル全体を書けるとは現時点で主張しません。** Ceruneのfreestanding出力、ABI、リンカ、メモリアクセスなどは、独立した検証を経て導入します。

## マイルストーン

1. **M0 — 方針:** x86-64 / QEMUを最初の対象とし、ブート方針を記録する。**決定済み**
2. **M1 — Boot / Hello / Halt:** 再現可能なビルド、Limine経由の起動、シリアル出力、意図した停止を検証する。**未実装**
3. **M2 — Exceptions / Memory:** 例外の観測、メモリマップの確認、物理ページ管理の最小実装を検討する。**計画**
4. **M3 — Interrupts / Tasks:** タイマー割り込みとタスク実行を段階的に追加する。**計画**
5. **M4以降:** user mode / system callなどを必要性と検証結果に応じて検討する。Cisa移植は基盤完成後に評価する。

## 開発方針

- 小さく作り、実際に動かして検証する。
- 「設計した」「実装した」「起動した」「テストした」を混同しない。
- QEMUでの成功を実機対応や安全性の保証と混同しない。
- 変更点と根拠を残し、Ceruneへの段階的な置き換えを可能にする。

## 関連プロジェクト

- [Cerune](https://github.com/Cerune-Lang/Cerune) — プログラミング言語・コンパイラ・実行基盤
- [Cisa](https://github.com/Cerune-Lang/Cisa) — Ceruneで実装された実験的な仮想CPU（当面は移植対象外）
- [Sashimi](https://github.com/Cerune-Lang/Sashimi) — Rust製x86-64アセンブラ／Object生成ライブラリ

## ライセンス

未決定です。第三者からのコード提供を受け付ける前に、ライセンスと貢献方針を明確にします。
