from scapy.all import *
from collections import defaultdict
packets = rdpcap("stats.pcap")
conversations = defaultdict(lambda: {
    "bytes": 0,
    "times": [],
    "protocols": defaultdict(int)
})
for pkt in packets:
    if IP in pkt:
        src = pkt[IP].src
        dst = pkt[IP].dst
    elif IPv6 in pkt:
        src = pkt[IPv6].src
        dst = pkt[IPv6].dst
    else:
        continue
    pair = tuple(sorted([src, dst]))
    conversations[pair]["bytes"] += len(pkt)
    conversations[pair]["times"].append(pkt.time)
    if TCP in pkt:
        conversations[pair]["protocols"]["TCP"] += 1
    elif UDP in pkt:
        conversations[pair]["protocols"]["UDP"] += 1
    else:
        conversations[pair]["protocols"]["OTHER"] += 1
max_pair = max(conversations.items(), key=lambda x: x[1]["bytes"])
print("Pair communicating maximum bytes:", max_pair[0])
print("Maximum bytes transferred:", max_pair[1]["bytes"])
print()
for pair, data in conversations.items():
    times = sorted(data["times"])
    if len(times) > 1:
        diffs = [times[i+1] - times[i] for i in range(len(times)-1)]
        avg_diff = sum(diffs) / len(diffs)
    else:
        avg_diff = 0
    print("Pair:", pair)
    print("Average Inter-Packet Time:", avg_diff)
    print("Protocol-wise Packet Count:")
    for proto, count in data["protocols"].items():
        print(proto, ":", count)
    print("Total Packets:", sum(data["protocols"].values()))
    print("------")

