# Track across project with EVM
プロジェクト横断でEVMを計算します。

* ログインユーザーがメンバーとなっているプロジェクトが計算対象です
* オプションでプロジェクトのステータスを選択できます

プロジェクト単位の詳細なEVMの計算は下記プラグインで可能です。

https://github.com/momibun926/redmine_issue_evm

## Current Version
1.0.0

## Compatibility
Redmine 3.4.0 and above

# View option

### 報告日

報告日（EVMを計算する基準日）を過去日にしてEVMを計算する事ができます。

### 1日の作業時間

EVMは時間で計算されています。人日でEVMを計算したい場合には、1日の基準時間を入れてください。
1日の作業時間は7.0-8.0時間を許可しています。この範囲以外は1.0として計算され、人日で計算されませんので注意してください。

### プロジェクトのステータス

デフォルトは有効（Active）なプロジェクトのみ計算しています。クローズしてしまったプロジェクトを計算したいときは適宜選択してください。ステータスは複数選択することが可能です。

# EVM値の計算
プロジェクト毎の以下のすべての項目に入力があるチケットを対象にして、EVM値を計算しています。（子プロジェクト以下を含めていて計算していません）

* 開始日
* 期日
* 予定工数(0でも構いませんがPV,EVが計算できないため意味がありません)

Redmine3.1から親チケットの予定工数が入力可能になったので、チケットの親子関係に関係なくチケット毎にPV,EVを算出しています。

* PV : 開始日、期日、予定工数を利用して、PVを計算します。日毎の工数を計算しています。
* EV : チケットをCLOSEした日に、予定工数をEVとして計算しています。進捗率が設定されている場合は、進捗率をセットした日に、予定工数に進捗率をかけて計算しています。
* AC : PVの計算に使われているチケットの作業時間を使って、ACを計算しています。

__計算例__
開始日:2015/08/01,期日:2015/08/03,予定工数:24.0時間のチケットを作成。この時点では、PVのみが有効。PVは日毎のPVから累積値を計算しています。チケットが完了していないので、EVは計算されません。

* PV -> 8/1:8.0時間 8/2:8.0時間 8/3:8.0時間　(24時間を3日で割って日毎のPVを計算)
* EV -> 0
* AC -> 0

| EVM | 8/1 | 8/2 | 8/3 |
| --- | --- | --- | --- |
| PV  | 8   | 16  | 24  |
| EV  | 0   | 0   | 0   |
| AC  | 0   | 0   | 0   |

チケットの作業時間を8/1,8/2,8/3に10.0時間、6.0時間、7.0時間入力する。日毎のPVに対して、ACの累積値が計算されます。
* PV -> 8/1:8.0時間 8/2:8.0時間 8/3:8.0時間
* EV -> 0
* AC -> 8/1:10.0時間 8/2:6.0時間 8/3:8.0時間

| EVM | 8/1 | 8/2 | 8/3 |
| --- | --- | --- | --- |
| PV  | 8   | 16  | 24  |
| EV  | 0   | 0   | 0   |
| AC  | 10  | 16  | 24  |

チケットを8/3にCLOSEする。チケットのクローズした日がEVの計上日になります。
* PV -> 8/1:8.0時間 8/2:8.0時間 8/3:8.0時間
* EV -> 8/3:24.0時間
* AC -> 8/1:10.0時間 8/2:6.0時間 8/3:8.0時間

| EVM | 8/1 | 8/2 | 8/3 |
| --- | --- | --- | --- |
| PV  | 8   | 16  | 24  |
| EV  | 0   | 0   | 24  |
| AC  | 10  | 16  | 24  |

## 週末・祝日の扱い
週末、祝日はEVMの計算対象となっています。

# インストール
(1) ソースの取得

**ZIPファイルの場合**

* ZIPファイルをダウンロードします
* [redmine_root]/plugins/へ移動して、redmine_across_project_evmフォルダを作成してください
* 作成したフォルダにZIPファイルを解凍します

**クローンでソースを取得**

```
git clone https://github.com/momibun926/redmine_across_project_evm [redmine_root]/plugins/redmine_across_project_evm
```

(2) Redmineを再起動します (e.g. mongrel, thin, mod_rails).

(3) トップメニューの"Project"をクリック

![sample screenshot](./images/screenshot01.png "topmenu")

(4) "Across project EVM"タブをクリック

![sample screenshot](./images/screenshot02.png "Application menu")

# アンインストール
```
rake redmine:plugins:migrate NAME=redmine_across_project_evm VERSION=0
```

# Contributing
1. Fork it
2. Create your feature branch (git checkout -b my-new-feature)
3. Commit your changes (git commit -am 'Add some feature')
4. Push to the branch (git push origin my-new-feature)
5. Create new Pull Request

# My Environment
*  Redmine version                4.1.1.stable.19730
*  Ruby version                   2.6.0-p0 (2018-12-25) [x86_64-linux]
*  Rails version                  5.2.4.2
*  Environment                    production
*  Database adapter               PostgreSQL
*  Mailer queue                   ActiveJob::QueueAdapters::AsyncAdapter
*  Mailer delivery                smtp
