# Salesforce World Tour Tokyo 2019 Minihack Challenge 
Salesforce World Tour Tokyo 2019🗼で出題された、Minihack Challenge の解答例です。もっと良い解答がある、エラーが出たなどあれば、お気軽に Issue や Pull Request でお知らせください

## 問題 
[PDF](https://s3-ap-northeast-1.amazonaws.com/static.jpdscblog/jpblogs/wp-content/uploads/2019/09/18100330/1b12347050aa0b17d456e566af36ec3d.pdf)

## 解答例
Challenge 1 を除き、各フォルダが [Salesforce DX プロジェクト](https://developer.salesforce.com/docs/atlas.ja-jp.sfdx_dev.meta/sfdx_dev/sfdx_dev_ws_create_new.htm) となっています。各手順に従ってメタデータをデプロイするには、Salesforce CLI と DevHub が有効化された組織が必要です。初めての方は [Trailhead](https://trailhead.salesforce.com/ja/content/learn/modules/sfdx_app_dev) を参考にしてください。

### Challenge 1 - 新しい部門のオンボーディング
🚀 [Challenge 1 の解答例](challenge1/)

* Trail Tracker のインストール用URLは以下です。
    * https://login.salesforce.com/packagingSetupUI/ipLanding.app?apvId=04t1Q000000s2uCQAQ

### Challenge 2 - Salesforce 内でのプロジェクト管理
📊 [Challenge 2 の解答例](challenge2/)

### Challenge 3 - 公園管理アプリの作成
🏞 [Challenge 3 の解答例](challenge3/)

* プロセスビルダーについては、**ある公園内で絶滅危惧動物が見つかった場合に** とあるので、目撃情報オブジェクトをトリガとすれば良いでしょう。なお、既に目撃されている動物を更新した場合に連結オブジェクトで紐付いている公園を更新する場合は、プロセスビルダーだけでは実装できません。
* カスタムのLightning Web Component で利用できるオブジェクトやページを制限するには、`<component>.js-meta.xml` ファイル内の `targetConfig` でオブジェクトを指定します。
    * 参考: [Configure a Component for Lightning App Builder](https://developer.salesforce.com/docs/component-library/documentation/lwc/lwc.use_config_for_app_builder)

### Challenge 4 - 冷蔵庫の門番 
🔌 [Challenge 4 の解答例](challenge4/)

* 同性同名の取引先責任者レコードが存在する場合は考慮していません。(要件に何も書いていないので…😂)
* 解答例は Bulkify していますが、簡便のため[バッチサイズをガバナ制限に抵触しないように小さく](https://developer.salesforce.com/docs/atlas.ja-jp.platform_events.meta/platform_events/platform_events_subscribe_batch_resume.htm)してしまっても良いと思います。

### Challenge 5 - サードパーティサービスとプロセスビルダーおよび Lightning Web Component との連携
🤝 [Challenge 5 の解答例](challenge5/)
* `@InvocableMethod` を実装したクラス と `Queueable` インタフェースを実装したクラスを作成する必要があります。
    * `Queueable` インタフェースを実装するクラスではコールアウトを行うため、`Database.AllowsCallouts` の implements をお忘れなく。
* 指定ログイン情報(Named Credential) は Apex 内で、`request.setEndpoint('callout:API_NAME');` のように利用できます。リモートサイト設定は不要です。
* 要件に **カスタムのLightning Web Componentは、もとになるレコードの情報が変更されたら自動的に更新されるようにします** とありますが、`lightning/uiRecordApi` は aura の reloadRecord のようなメソッドが提供されておらず、画面の外からレコードを更新した場合は再読み込みされないため上手く使えません。そこで、`lightning-emp-api` で取引先の変更データキャプチャを Subscribe し、レコードは Apex から呼び出すようにし、更新された取引先のレコード Id と現在開いているレコードの Id が一致する場合に `refreshApex` を呼び出すと良いでしょう。
    * 参考: [refreshApex の例 (lwc-recipes)](https://github.com/trailheadapps/lwc-recipes/blob/master/force-app/main/default/lwc/ldsDeleteRecord/ldsDeleteRecord.js)

### Challenge 6 - サンプルギャラリーの表示
🚲 [Challenge 6 の解答例](https://github.com/shunkosa/swtt2019-minihack/commit/22ddbf234b3540d713a4d0ab6b63bd144cecc0ed#diff-a24b74cbe40670f8f6d6df7dc7d94c97)
* 一から作っても良いですが、既存の `similarProducts` コンポーネントをコピーして修正すると簡単です。