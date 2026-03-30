from scapy.all import rdpcap, IP
from collections import Counter

# Load pcap file
packets = rdpcap("ss1.pcap")

# 1. Number of packets
print("Number of packets:", len(packets))

# Lists to store IPs and protocols
src_ips = set()
dst_ips = set()
protocols = []

# Loop through packets
for pkt in packets:
    if IP in pkt:
        src_ips.add(pkt[IP].src)
        dst_ips.add(pkt[IP].dst)
        protocols.append(pkt[IP].proto)

# 2. Number of source IPs
print("Number of source IPs:", len(src_ips))

# 3. Number of destination IPs
print("Number of destination IPs:", len(dst_ips))

# 4. Number of protocols used
proto_count = Counter(protocols)
print("Number of protocols used:", len(proto_count))

# 5. Number of packets under each protocol
print("Packets under each protocol:")
for proto, count in proto_count.items():
    print(f"Protocol {proto}: {count} packets")
