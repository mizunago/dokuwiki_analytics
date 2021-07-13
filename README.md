# dokuwiki のログ解析

nginx で dokuwiki のログを集計してアクセスランキングと検索ワードランキングを表示する

## 注意点

ログのフォーマットは以下を使っている想定です。

```
        log_format main '$remote_addr - $remote_user [$time_local] '
                            '"$request" $status $body_bytes_sent '
                            '"$http_referer" "$http_user_agent" '
                            '$request_time $upstream_response_time';

        access_log /var/log/nginx/access.log main;

```

もしデフォルトの COMBINED を使っている場合は `format = ServerLogParser::COMBINED` を指定してください

そのほか、数分で作ったので適当な所が多いので何かあっても保証できません
