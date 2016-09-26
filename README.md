About
---

Teratail (Japanese Q&A site for programer) command line viewer.

![](https://raw.githubusercontent.com/MaxMEllon/demos/master/teratail-cli/demo.gif)

Requirements
---

- interactive filter
  - [fzf](https://github.com/junegunn/fzf)

- json parser
  - [jq](https://github.com/stedolan/jq)

- browser opener
  - [opener](https://www.npmjs.com/package/opener)

Usage
---

```bash
$ teratail
  ...
  > _
    100/100
  > ApacheサーバーにおいてPHPでJSON化。そのデータを以下のswiftでクライアントに取得しようとしていますが、
    java.util.calenderで取得した情報をsqlにinsertするとnullになってしまいます
    データベースのテーブル設計について
    出来るプログラマーになるために
    Android StudioにおけるNotificationのIcon
    MYSQLで部分的なレコードを複数一括で更新したい
    phpmyadmin DBにはアクセスできるのにテーブルにはアクセスできない
    【Laravel】POSTで受け取ったファイルを取得したい
    カラム名の付け方
    PHPで変数に配列をカンマ区切りで格納したい

```

|mapping|behavior|
|---|---|
|`<C-o>`|open browser|
|`<Enter>`|view detail in command line|

Installation
---

- install with [zplug](https://github.com/zplug/zplug):

```bash
zplug "maxmellon/teratail-cli", \
    from:gh-r, \
    as:command, \
    use:teratail.sh, \
    on:"stedolan/jq", \
    on:"junegunn/fzf-bin", \
    hook-build:"
    {
        npm install -g opener
    } &>/dev/null
    "

zplug "stedolan/jq", \
    from:gh-r, \
    as:command, \
    rename-to:jq

zplug "junegunn/fzf-bin", \
    from:gh-r, \
    as:command, \
    rename-to:fzf, \
    use:"*darwin*amd64*"
```

Configurations
---

### `TERATAIL_API_TOKEN`

```bash
export TERATAIL_API_TOKEN="0123456789abcdef0123456789abcdef0123456789"
```

Please publication api token of teratail.

https://teratail.com/users/setting/tokens

LICENSE
---


- [MIT](./LICENSE.txt)

  (c) MaxMellonn (Kento TSUJI) <maxmellon1994@gmail.com>
