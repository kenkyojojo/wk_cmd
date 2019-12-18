#!/bin/sh

# date_tz.sh - 以指定的時區來顯示時間

# 巴黎現在是幾點?
TZ=Europe/Paris date

# 現在在世界標準時間是幾點?
TZ=GMT date
