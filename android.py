#!/usr/bin/env python3
import subprocess
import time
import sys
from datetime import datetime

LOG = "/tmp/airplane_root.log"
AIRPLANE_WAIT = 5
ADB_SERIAL = None


# ---------- UTIL ----------

def log(msg):
    with open(LOG, "a") as f:
        f.write("[%s] %s\n" %
                (datetime.now().strftime("%Y-%m-%d %H:%M:%S"), msg))


def run(cmd):
    return subprocess.run(
        cmd,
        stdout=subprocess.PIPE,
        stderr=subprocess.PIPE,
        text=True
    )


def fatal(msg):
    log("FATAL: " + msg)
    print("ERROR:", msg)
    sys.exit(1)


def adb_cmd(cmd):
    if ADB_SERIAL:
        return ["adb", "-s", ADB_SERIAL] + cmd
    return ["adb"] + cmd


# ---------- CHECKS ----------

def check_adb():
    if run(["which", "adb"]).returncode != 0:
        fatal("adb not installed")


def select_device():
    global ADB_SERIAL
    r = run(["adb", "devices"])
    for line in r.stdout.splitlines():
        if "\tdevice" in line:
            ADB_SERIAL = line.split()[0]
            log(f"Using device: {ADB_SERIAL}")
            return
    fatal("no authorized android device detected")


def check_root():
    r = run(adb_cmd(["shell", "su", "-c", "id"]))
    if "uid=0" not in r.stdout:
        fatal("android not rooted or su denied")


# ---------- AIRPLANE MODE ----------

def airplane_on():
    log("Airplane ON")
    run(adb_cmd(["shell", "su", "-c",
                 "settings put global airplane_mode_on 1"]))
    run(adb_cmd(["shell", "su", "-c",
                 "am broadcast -a android.intent.action.AIRPLANE_MODE --ez state true"]))


def airplane_off():
    log("Airplane OFF")
    run(adb_cmd(["shell", "su", "-c",
                 "settings put global airplane_mode_on 0"]))
    run(adb_cmd(["shell", "su", "-c",
                 "am broadcast -a android.intent.action.AIRPLANE_MODE --ez state false"]))


# ---------- MAIN ----------

def main():
    log("===== AIRPLANE SINGLE TOGGLE START =====")

    check_adb()
    select_device()
    check_root()

    airplane_on()
    time.sleep(AIRPLANE_WAIT)
    airplane_off()

    log("DONE\n")
    print("Airplane mode toggled successfully")


if __name__ == "__main__":
    try:
        main()
    except Exception as e:
        log("UNHANDLED EXCEPTION: " + str(e))
        print("Runtime error, see log:", LOG)
        sys.exit(1)
