# Terraform モジュール構成 🚀

このTerraformプロジェクトは、以下の4つのモジュールに分かれています：

## 1. ネットワークモジュール (1-network) 🌐

- VPCエンドポイント（Cognito、SES、S3、DynamoDB用）の設定
- セキュリティグループの設定

```bash
cd terraform/1-network
terraform init -backend-config=backend.hcl
terraform plan
terraform apply
```

## 2. コンピューティングモジュール (2-compute) 💻

- EC2インスタンスの設定（必要な場合）
- IAMロールとポリシーの設定
- セキュリティグループの設定

```bash
cd ../2-compute
terraform init -backend-config=backend.hcl
terraform plan
terraform apply
```

## 3. サービスモジュール (3-services) 🛠️

- Cognitoユーザープールの設定
- SESメール設定の構成
- 各種認証・認可の設定

```bash
cd ../3-services
terraform init -backend-config=backend.hcl
terraform plan
terraform apply
```

## 4. アプリケーションモジュール (4-application) 📱

- デプロイ用S3バケットの設定（オプション）
- CloudFrontディストリビューションの設定（オプション）

```bash
cd ../4-application
terraform init -backend-config=backend.hcl
terraform plan
terraform apply
```

## モジュール間の依存関係 🔄

各モジュールは以下の順序で適用する必要があります：

1. ネットワーク → 基本的なネットワークインフラの構築
2. コンピュート → IAMロールとEC2インスタンスの設定
3. サービス → CognitoとSESの設定
4. アプリケーション → フロントエンド関連リソースの設定

## S3バックエンドの設定 📦

各モジュールで以下のような`backend.hcl`ファイルを作成してください：

```hcl
bucket         = "your-terraform-state-bucket"
key            = "環境名/モジュール名/terraform.tfstate"
region         = "ap-northeast-1"
encrypt        = true
dynamodb_table = "terraform-state-lock"
```

## 環境変数の設定 🔐

必要な環境変数を設定してください：

```bash
export AWS_ACCESS_KEY_ID="your-access-key"
export AWS_SECRET_ACCESS_KEY="your-secret-key"
export AWS_REGION="ap-northeast-1"
```

## 注意事項 ⚠️

- 各モジュールの適用前に、必ず`terraform plan`を実行して変更内容を確認してください
- 本番環境での適用前に、必ずステージング環境でテストしてください
- セキュリティグループやIAMポリシーは、最小権限の原則に従って設定してください

## トラブルシューティング 🔍

1. **状態ファイルの競合**
   - 複数人で作業する場合は、必ずstate lockingを使用してください
   - バックエンドにはDynamoDBのテーブルを使用することを推奨します

2. **依存関係エラー**
   - モジュールの適用順序を守ってください
   - リモートステートの参照が正しく設定されているか確認してください

3. **アクセス権限エラー**
   - IAMユーザー/ロールに適切な権限が付与されているか確認してください
   - VPCエンドポイントの設定を確認してください
