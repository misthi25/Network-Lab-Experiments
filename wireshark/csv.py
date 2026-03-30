from scapy.all import *
packets = rdpcap("stats.pcap")
total_packets = len(packets)
total_size = sum(len(pkt) for pkt in packets)
header_size = 0
for pkt in packets:
    if Ether in pkt:
        header_size += 14
    if IP in pkt:
        header_size += pkt[IP].ihl * 4
    if IPv6 in pkt:
        header_size += 40
    if TCP in pkt:
        header_size += pkt[TCP].dataofs * 4
    if UDP in pkt:
        header_size += 8
data_size = total_size - header_size
print("Total number of packets:", total_packets)
print("Total size (bytes):", total_size)
print("Total header size (bytes):", header_size)
print("Total data size (bytes):", data_size)
