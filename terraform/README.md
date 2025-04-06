# Terraform による Cognito と SES のセットアップ

このディレクトリには、AWS Cognito と Amazon SES をTerraformを使って構築するためのコードが含まれています。

## 概要

このTerraformコードは、以下のAWSリソースを作成します：

- Amazon Cognito ユーザープール
- Cognito アプリケーションクライアント
- Cognito ドメイン (オプション)
- Amazon SES 設定 (メール送信元として使用)
- IAMポリシー (EC2からCognitoとSESへのアクセス用)

## 使い方

1. **前提条件**:
   - AWS CLIがインストールされ、適切に設定されていること
   - Terraformがインストールされていること（バージョン1.0以上推奨）

2. **terraform.tfvarsの編集**:
   ファイル内の変数を環境に合わせて変更します。特に以下の点に注意してください：
   - `callback_urls`と`logout_urls`をEC2のプライベートIPまたはドメイン名に更新
   - `ses_from_email`を検証済みのメールアドレスに変更
   - `ec2_role_name`にEC2のIAMロール名を指定（既存の場合）

3. **実行**:
   ```bash
   # Terraformの初期化
   terraform init

   # 計画の確認
   terraform plan

   # リソースの作成
   terraform apply
   ```

4. **出力の使用**:
   Terraformの実行後、以下の出力値を取得できます：
   - `cognito_user_pool_id`
   - `cognito_client_id`
   - `cognito_domain` (ドメインを作成した場合)
   - `ses_email_identity_arn`

   これらの値をReactアプリケーションの設定ファイル（src/config/aws-config.js）に設定してください。

## 注意事項

- SESは初期状態でサンドボックス環境にあります。本番環境で使用する場合は、AWSサポートに制限解除を依頼してください。
- Cognitoのドメイン名はグローバルに一意である必要があります。重複した場合はエラーが発生します。
- プライベートサブネットからAWSサービスへのアクセスには、NAT GatewayまたはVPCエンドポイントが必要です。
