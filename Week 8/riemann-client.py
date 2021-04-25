'''
Riemann client - Python Script using
package by "borntyping"
(https://github.com/borntyping/python-riemann-client)

collects Operating System(using "psutil" package) & Aerospike data store metrics
sends them to riemann server (IP: 192.168.100.126)
'''
import psutil
import os, popen2, sys
from time import sleep
import subprocess

from riemann_client.transport import TCPTransport
from riemann_client.client import QueuedClient

event_queue = []
stats_op = subprocess.check_output(["asinfo","-v","'statistics'"])
orders_stats = subprocess.check_output(["asinfo","-v","'namespace/orders'"])

# helper methods
def cpu_report():
    r, w, e = popen2.popen3('ps -eo pcpu,pid,args | sort -nrb -k1 | head -10')
    return r.readlines()

def cores():
    return psutil.cpu_count(logical=False)

def memory_report():
    r, w, e = popen2.popen3('ps -eo pmem,pid,args | sort -nrb -k1 | head -10')
    return r.readlines()

# main os functions
def cpu(warning, critical):
    c = psutil.cpu_times(percpu=False)
    used = c.user + c.system + c.nice
    total = used + c.idle
    f = used/total
    state = "ok"
    if f > warning: state="warning"
    if f > critical: state="critical"
    event_queue.append((
        "cpu", 
        state, 
        f, 
        "%.2f %% user+nice+sytem\n\n%s" % (f * 100, cpu_report()),
        "1-cpu"
    ))

def load(warning, critical):
    l = os.getloadavg()
    f = l[2]/cores()
    state = "ok"
    if f > critical: state="critical"
    if f > warning: state="warning"
    event_queue.append((
        "load", 
        state, 
        l[2], 
        "15-minute load average/core is %f" % l[2],
        "1-load"
    ))

def memory(warning, critical):
    m = psutil.virtual_memory()
    state = "ok"
    f = m.percent / 100.0
    if f > warning: state = "warning"
    if f > critical: state = "critical"
    event_queue.append((
        "memory", 
        state, 
        f, 
        "%.2f%% used\n\n%s" % (f * 100, memory_report()),
        "1-memory"
    ))

def disk(warning, critical):
    for p in psutil.disk_partitions():
        u = psutil.disk_usage(p.mountpoint)
        perc = u.percent
        f = perc/100
        state = "ok"
        if f > warning: state="warning"
        if f > critical: state="critical"
        event_queue.append((
            "disk %s" % p.mountpoint, 
            state, 
            f, 
            "%s used" % perc,
            "1-disc"
        ))

#as methods
def as_cluster_size(warning, critical):
    cluster_size = stats_op[13]
    cluster_size = int(cluster_size)
    state = "ok"
    if cluster_size <= warning: state="warning"
    if cluster_size <= critical: state="critical"
    event_queue.append((
        "as_cluster_size", 
        state, 
        cluster_size, 
        "aerospike cluster size are %f" % cluster_size,
        "1-as-cluster"
    ))

def as_client_connections(warning, critical):
    client_conns = stats_op[stats_op.find('client_connections')+19]
    client_conns = int(client_conns)
    state = "ok"
    if client_conns > warning: state="warning"
    if client_conns > critical: state="critical"
    event_queue.append((
        "as_client_connections", 
        state, 
        client_conns, 
        "aerospike client connections are %f" % client_conns,
        "1-as-connections" 
    ))

def as_hwm_breach(warning):
    hwm = orders_stats[orders_stats.find('high-water-memory-pct')+22]+orders_stats[orders_stats.find('high-water-memory-pct')+23]
    mem_free = orders_stats[orders_stats.find('memory_free_pct')+16]+orders_stats[ orders_stats.find('memory_free_pct')+17]
    hwm = int(hwm)
    mem_free = int(mem_free)
    state = "ok"
    if mem_free < warning: state="warning"
    if mem_free < 100-hwm: state="critical"
    event_queue.append((
        "as_hwm_perc", 
        state, 
        hwm, 
        "aerospike hwm is %f and memory free is %f" % (hwm, mem_free),
        "1-as-hwm"
    ))
    event_queue.append((
        "as_hwm_mem_perc", 
        state, 
        100-mem_free,
        "aerospike hwm is %f and memory free is %f" % (hwm, mem_free),
        "1-as-hwm-mem"
    ))


def collect_send():
    cpu(0.6,0.8)
    load(3,8)
    memory(0.6,0.8)
    disk(0.6,0.8)
    as_cluster_size(2,1)
    as_client_connections(2,1)
    as_hwm_breach(40)
    send_data()

def run():
    while True:
        collect_send()
        sleep(10)

def send_data():
    with QueuedClient(TCPTransport("192.168.100.126", 5555)) as client:
        for evt in event_queue:
            client.event(
                service=evt[0], 
                state=evt[1], 
                metric_f=evt[2], 
                description=evt[3],
                tags=[evt[4]],
                ttl=20)
        client.flush()

if __name__ == "__main__":
    run()