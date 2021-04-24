import psutil
import os, popen2, sys
from time import sleep
sys.path.append("..")

from riemann_client.transport import TCPTransport
from riemann_client.client import QueuedClient

event_queue = []

# helper methods
def cpu_report():
    r, w, e = popen2.popen3('ps -eo pcpu,pid,args | sort -nrb -k1 | head -10')
    return r.readlines()

def cores():
    return psutil.cpu_count(logical=False)

def memory_report():
    r, w, e = popen2.popen3('ps -eo pmem,pid,args | sort -nrb -k1 | head -10')
    return r.readlines()

# main functions
def cpu(warning=0.6, critical=0.8):
    c = psutil.cpu_times(percpu=False)
    used = c.user + c.system + c.nice
    total = used + c.idle
    f = used/total
    state = "ok"
    if f > warning: state="warning"
    if f > critical: state="critical"
    event_queue.append(("cpu", state, f, "%.2f %% user+nice+sytem\n\n%s" % (f * 100, cpu_report())))

def load(warning=3, critical=8):
    l = os.getloadavg()
    f = l[2]/cores()
    state = "ok"
    if f > critical: state="critical"
    if f > warning: state="warning"
    event_queue.append(("load", state, l[2], "15-minute load average/core is %f" % l[2]))

def memory(warning = 0.6, critical=0.8):
    m = psutil.virtual_memory()
    state = "ok"
    f = m.percent / 100.0
    if f > warning: state = "warning"
    if f > critical: state = "critical"
    event_queue.append(("memory", state, f, "%.2f%% used\n\n%s" % (f * 100, memory_report())))

def disk(warning=0.6, critical=0.8):
    for p in psutil.disk_partitions():
        u = psutil.disk_usage(p.mountpoint)
        perc = u.percent
        f = perc/100
        state = "ok"
        if f > warning: state="warning"
        if f > critical: state="critical"
        event_queue.append(("disk %s" % p.mountpoint, state, f, "%s used" % perc))

def run():
    cpu()
    load()
    memory()
    disk()
    send_data()

def send_data():
    with QueuedClient(TCPTransport("192.168.100.126", 5555)) as client:
        for evt in event_queue:
            client.event(service=evt[0], state=evt[1], metric_f=evt[2], description=evt[3])
        client.flush()

if __name__ == "__main__":
    run()