#!/bin/sh

# date_add_bsd.sh - BSD date底下的時間運算

# 2004年1月1日是星期幾?
date -v2004y -v1m -v1d +'%A'

# 2004年1月1日的第100天後是幾月幾日?
date -v2004y -v1m -v1d -v+100d +'%F'

# 上午10時的第1000秒前是幾時幾分幾秒?
date -v10H -v0M -v0S -v-1000S +'%T'
