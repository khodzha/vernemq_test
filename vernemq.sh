#!/usr/bin/env sh
/vernemq/bin/vernemq console -noshell -noinput $@
pid=$(ps aux | grep '[b]eam.smp' | awk '{print $2}')
wait $pid
