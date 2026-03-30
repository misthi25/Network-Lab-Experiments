from scapy.all import *
import matplotlib.pyplot as plt
pkts = rdpcap("stats.pcap")
times = [pkt.time for pkt in pkts]
start_time = times[0]
rel_times = [t - start_time for t in times]
duration = int(rel_times[-1]) + 1
bins = list(range(duration))
tcp_counts = [0] * duration
udp_counts = [0] * duration
dns_counts = [0] * duration
icmp_counts = [0] * duration
arp_counts = [0] * duration
for pkt in pkts:
    idx = int(pkt.time - start_time)
    if idx < duration:
        if TCP in pkt:
            tcp_counts[idx] += 1
        if UDP in pkt:
            udp_counts[idx] += 1
            if DNS in pkt:
                dns_counts[idx] += 1
        if ICMP in pkt:
            icmp_counts[idx] += 1
        if ARP in pkt:
            arp_counts[idx] += 1

plt.figure(figsize=(15, 10))
plt.subplot(3, 2, 1)
plt.plot(bins, tcp_counts, 'b-', linewidth=1.5)
plt.title("TCP Traffic Over Time")
plt.xlabel("Time (s)")
plt.ylabel("Packets")
plt.xlim(0, 80)
plt.ylim(0, 250)
plt.grid(True)
plt.subplot(3, 2, 2)
plt.plot(bins, udp_counts, 'g-', linewidth=1.5)
plt.title("UDP Traffic Over Time")
plt.xlabel("Time (s)")
plt.ylabel("Packets")
plt.xlim(0, 80)
plt.ylim(0, 40)
plt.grid(True)
plt.subplot(3, 2, 3)
plt.plot(bins, dns_counts, 'r-', linewidth=1.5)
plt.title("DNS Traffic Over Time")
plt.xlabel("Time (s)")
plt.ylabel("Packets")
plt.xlim(0, 50)
plt.ylim(0, 6)
plt.grid(True)
plt.subplot(3, 2, 4)
plt.plot(bins, icmp_counts, 'c-', linewidth=1.5)
plt.title("ICMP Traffic Over Time (Bytes)")
plt.xlabel("Time (s)")
plt.ylabel("Bytes")
plt.xlim(0, 80)
plt.grid(True)
plt.subplot(3, 2, 5)
plt.plot(bins, arp_counts, 'm-', linewidth=1.5)
plt.title("ARP Traffic Over Time")
plt.xlabel("Time (s)")
plt.ylabel("Packets/sec")
plt.xlim(0, 50)
plt.grid(True)
plt.tight_layout()
plt.savefig("all_graphs.png")
plt.show()
