#!/usr/bin/env python
import time

while True:
    print(time.strftime('%H:%M'), flush=True)
    time.sleep(60.0 - time.time() % 60)
