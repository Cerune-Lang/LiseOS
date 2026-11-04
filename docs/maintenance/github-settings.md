# GitHubリポジトリ設定（管理者向け）

この文書はLiseOSのGitHub運用における**推奨設定**です。ここに記載しただけでは設定は有効になりません。管理者がGitHubのリポジトリ設定から反映してください。

## `main`の保護

[Repository Settings > Rules](https://github.com/Cerune-Lang/LiseOS/settings/rules)から、`main`を対象とする**Branch ruleset**を作成し、Enforcementを`Active`にします。あるいはBranch protection ruleで同等の設定を行います。

推奨設定：

- 対象ブランチ：`main`（完全一致）
- Require a pull request before merging：有効
- Required approving reviews：当面`0`（少人数でのセルフPRを妨げない）
- Require status checks to pass：有効
  - 必須チェック：既存の`LiseOS Bootstrap`ワークフローに含まれる`x86_64-cerune-limine`ジョブのチェック（GitHubの選択画面で**実際のチェック名**を確認）
  - Require branches to be up to date：最初は無効でも可。複数人開発になれば有効化を検討
- Require conversation resolution before merging：有効
- Block force pushes：有効
- Restrict deletions：有効
- Bypass：通常の開発では使わない方針。管理者権限を含めて厳格化する場合は、復旧手順を確保してから設定

**適用前に既存PRでCIが成功し、該当チェックが候補に表示されることを確認してください。** 誤ったチェック名を必須にするとPRをマージできなくなる可能性があります。

このルールではレビュー承認数を0とし、PRとCIを必須にすることで、単独開発でも安全性と作業速度のバランスを取ります。レビュー担当者が増えたら、承認を1件以上に引き上げることを検討してください。

## 非公開の脆弱性報告

[Repository Settings](https://github.com/Cerune-Lang/LiseOS/settings)を開き、**Security and quality > Advanced Security > Private vulnerability reporting** を`Enable`にします（GitHubの表示名は変更される場合があります）。

有効化後、[Security Advisories](https://github.com/Cerune-Lang/LiseOS/security/advisories)に非公開報告の導線があることを確認してください。リポジトリの[SECURITY.md](../../SECURITY.md)は報告方針を説明するものであり、Private Vulnerability Reportingを有効化する設定ではありません。

参考：

- [GitHub: Creating rulesets for a repository](https://docs.github.com/en/repositories/configuring-branches-and-merges-in-your-repository/managing-rulesets/creating-rulesets-for-a-repository)
- [GitHub: Configuring private vulnerability reporting](https://docs.github.com/en/code-security/how-tos/report-and-fix-vulnerabilities/configure-vulnerability-reporting/configure-for-a-repository)
