# Limineを使用する理由と境界

## Limineとは

[Limine](https://github.com/Limine-Bootloader/Limine)は、OSを起動するための既存の**ブートローダー**であり、[Limine Boot Protocol](https://github.com/Limine-Bootloader/limine-protocol)の参照実装です。

LiseOSが一からファームウェアやディスクブートを実装せずに、QEMU上でx86-64カーネルの実行に集中するために利用します。

**LimineはC言語ランタイムではありません。** カーネルはCeruneで生成された機械語を使い、Limineは初期ロードと制御移行を受け持ちます。Limine自身が何語で実装されているかは、LiseOSカーネルの実装言語の制約とは別です。

## M1aの境界

```text
QEMU x86-64
  → Limine (ISOから起動)
    → liseos.elf をメモリへロード
      → ELFのエントリシンボル main
        → Ceruneで書いた無限ループ
```

- **実装済みのソース:** `kernel/main.ceru`、Ceruneライブラリによるオブジェクト生成用ホストビルダー、リンカスクリプト、Limine設定、ビルド／ISO生成スクリプト。
- **未確認:** 生成したELFのリンク成功、Limineでのロード成功、QEMUでの`main`到達。各環境での実行検証が必要。
- **未実装:** シリアル、画面出力、`hlt`、割り込み、物理メモリマネージャー、Limine応答の読み取り。
- **注意:** 無限ループはCPUを消費し続ける。停止命令`hlt`はCerune側のハードウェア操作を追加してから採用する。

## ブートプロトコル

Limine Boot Protocolは、カーネル内の**リクエスト構造**をスキャンし、対応する起動情報を返す方式です。現在はリクエスト開始・終了マーカーとbase revisionだけをリンカスクリプト`linker.ld`で配置しています。

- **base revision:** 3（M1aで利用する機能要求はなし）。
- **配置:** 高位仮想アドレス（`0xffffffff80000000`から）のELF64イメージ。
- **ブート情報:** この初期段階では読み込まない。将来メモリマップやframebuffer要求を追加する場合は、Limine定義の形式、アラインメント、メモリの有効範囲、応答の存在確認を実装してから利用する。
- **Ceruneとの関係:** リンカスクリプトの`QUAD`はバイナリレイアウトを記述するビルド用の指定で、C／アセンブリのカーネル実装ではない。最終的にはCerune自身でセクション／リンク可能なデータ配置を表現できるようにすることを検討する。

現行マーカーは[公式`limine.h`](https://github.com/Limine-Bootloader/limine-protocol/blob/trunk/include/limine.h)と照合した。プロトコルには互換性境界があるため、バージョンを上げる場合は再検証する。

## Limineの固定版

- GitHub: `Limine-Bootloader/Limine`
- バイナリ版: **v11.4.1**、commit `5be26a73d7b7b4d4477d18be94e1d16e615adf56`
- `scripts/iso.sh`ではこのタグを取得し、commitをチェックする。
- 使用する外部ツール: Rust/Cargo（Ceruneコンパイラライブラリをホスト実行）、`ld.lld`、`git`、`xorriso`、QEMU（確認時）。Limineのホスト側補助プログラムは必要に応じて`make`で生成する。

## ビルド・検証

LinuxまたはWSL2で、Rust/Cargo、Python3、`ld.lld`、`git`、`xorriso`、`qemu-system-x86_64`、`gdb`を事前に用意する。

```sh
# リポジトリルートで
python3 scripts/check-source.py
bash scripts/build.sh
bash scripts/iso.sh
bash scripts/debug-qemu.sh
```

`debug-qemu.sh`はQEMUを**停止状態**で起動し、ポート1234でGDBを待ち受ける（`-S -s`）。別ターミナルで：

```sh
gdb -q build/liseos.elf \
  -ex 'set pagination off' \
  -ex 'target remote :1234' \
  -ex 'hbreak main' \
  -ex 'continue'
```

**GDBが`main`で停止し、命令ポインタが`main`の範囲を指した場合に限り、M1aのエントリ到達が観測できた**と記録する。この場合もシリアル出力まで確認したことにはならない。

なお、`scripts/audit_elf.py`は符号形式・定義済み`main`・未解決外部シンボル・動的ローダー不使用・高位アドレスなどを確認する静的検査であり、起動検査の代わりにはならない。

## 次の実装: M1b

Ceruneがサポートする最小のOS用能力として、明示されたハードウェアI/O（x86-64ポートI/O、MMIOなど）と、戻らない`halt`経路を設計する。その後、**LiseOS: boot ok** をQEMUシリアルへ出力する。

`print`は現在のWindows/Linuxホストランタイムへ依存するため使わない。低レベル操作には検証可能な制約（型、範囲、サポートターゲット、権限境界）を付ける。

## 参照

- [Limineのソースとバイナリ](https://github.com/Limine-Bootloader/Limine)
- [Limine Boot Protocol](https://github.com/Limine-Bootloader/limine-protocol)
- [公式のx86-64 Cテンプレート](https://github.com/Limine-Bootloader/limine-c-template-x86-64)（**仕様の比較用**。CコードをLiseOSへ導入するわけではない）
