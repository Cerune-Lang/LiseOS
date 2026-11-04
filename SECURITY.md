# セキュリティポリシー / Security Policy

LiseOSは、Ceruneでカーネルを実装する開発中の実験的なOSです。セキュリティが重要な用途や、本番環境での使用は想定していません。正式なサポート対象リリースや、修正期限の保証はありません。

LiseOS is an experimental operating system with a kernel written in Cerune. It is not intended for production use or security-critical environments. There are no formally supported releases or guaranteed response times.

## 脆弱性の報告

脆弱性の可能性がある内容は、**公開IssueやPull Requestへ詳細を書かず**、GitHubの[Security Advisories](https://github.com/Cerune-Lang/LiseOS/security/advisories)からPrivate Vulnerability Reporting（有効な場合）を利用して非公開で報告してください。

報告フォームが表示されない場合は、脆弱性の詳細、再現コード、攻撃手順などを公開せず、[Issue](https://github.com/Cerune-Lang/LiseOS/issues)で**非公開の連絡方法を案内してほしい**旨のみを問い合わせてください。

可能な範囲で、影響するコミットまたはバージョン、実行環境（QEMU・アーキテクチャ等）、再現手順、想定される影響を含めてください。

クラッシュや未実装機能は必ずしも脆弱性とは限りません。判断に迷う場合は非公開で報告してください。

## Reporting a vulnerability

**Do not disclose potential vulnerabilities in public issues or pull requests.** Use [GitHub Security Advisories](https://github.com/Cerune-Lang/LiseOS/security/advisories) and its private vulnerability reporting form, if enabled.

If private reporting is unavailable, open an [issue](https://github.com/Cerune-Lang/LiseOS/issues) **requesting a private contact method only**; do not include the vulnerability details, proof of concept, or exploit steps.

Please include the affected commit or version, environment (for example, QEMU and architecture), reproduction steps, and potential impact where possible.

Crashes and unfinished features are not necessarily security vulnerabilities. If unsure, report privately.

## 管理者向け / Maintainer setup

Private Vulnerability Reportingは、このファイルを追加するだけでは有効になりません。管理者がGitHubのリポジトリ設定から有効化してください。設定手順は[管理設定ガイド](docs/maintenance/github-settings.md)を参照してください。

Adding this file does not enable private vulnerability reporting. Repository administrators must enable it separately; see the [maintenance guide](docs/maintenance/github-settings.md).
