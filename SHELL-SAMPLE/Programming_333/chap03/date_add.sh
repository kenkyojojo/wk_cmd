#!/bin/sh

# date_add.sh - Linux/GNU date中的日期時間運算

# 2004年1月1日是星期幾?
date -d '2004/1/1' +'%A'

# 2004年1月1日的第100天後是幾月幾日?
date -d '2004/1/1 100 days' +'%F'

# 上午10時的第1000秒前是幾時幾分幾秒?
date -d '10:00:00 1000 seconds ago' +'%T'
