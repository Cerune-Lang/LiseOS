# Limine

[Limine](https://github.com/Limine-Bootloader/Limine)はブートローダーです。LiseOSでは、起動ISOから`liseos.elf`をメモリへ読み込み、x86-64カーネルの`main`へ処理を渡すために使います。

ブートローダーを自作する必要がなく、Ceruneで書いたカーネルの動作確認に集中できます。Limineはカーネル内のCランタイムではありません。

## 起動に使うファイル

- `limine.conf` — 読み込むELFファイルを指定
- `linker.ld` — カーネルのアドレスとLimineのリクエストデータを指定
- `scripts/iso.sh` — Limine **v11.4.1**（commit `5be26a73d7b7b4d4477d18be94e1d16e615adf56`）でISOを生成
- `scripts/smoke-qemu.sh` — QEMUとGDBでCerune製`main`への到達を確認

## 起動の確認

```sh
bash scripts/iso.sh
bash scripts/smoke-qemu.sh
```

手動で確認する場合：

```sh
bash scripts/debug-qemu.sh
```

別ターミナルで：

```sh
gdb -q build/liseos.elf -ex 'target remote :1234' -ex 'hbreak main' -ex 'continue'
```

`main`で停止すれば、QEMUがCerune製カーネルの入口へ到達したことを確認できます。これは画面表示やシリアル出力の確認ではありません。

## Limine Boot Protocol

Limineはカーネルに配置したリクエストデータを読み取り、要求された起動情報を渡します。現状の`linker.ld`は開始・終了マーカーとbase revision 3のみを記録しています。メモリマップなどの情報はまだ要求していません。

仕様: [Limine Boot Protocol](https://github.com/Limine-Bootloader/limine-protocol)

## ライセンスと再配布

LiseOS本体のライセンスはリポジトリの[`LICENSE-MIT`](../../LICENSE-MIT)と[`LICENSE-APACHE`](../../LICENSE-APACHE)を参照してください。Limineのライセンスは別管理です。

LiseOSはLimine v11.4.1の固定バイナリ版をISOに組み込むため、同バージョンの[Limineのライセンス](../../licenses/limine/LICENSE)と[第三者ソフトウェアの表示](../../licenses/limine/3RDPARTY.md)を保存しています。`scripts/iso.sh`はこれらを生成ISOの`licenses/limine/`へ、LiseOSのライセンスを`licenses/liseos/`へコピーします。

Limineのバイナリや依存コンポーネントにLiseOSの`MIT OR Apache-2.0`が適用されるわけではありません。
