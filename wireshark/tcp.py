from scapy.all import *
import struct
import socket
def calculate_tcp_checksum(ip_pkt):
    tcp_pkt = ip_pkt[TCP]
    src_ip = socket.inet_aton(ip_pkt.src)
    dst_ip = socket.inet_aton(ip_pkt.dst)
    tcp_length = len(tcp_pkt)
    pseudo_header = src_ip + dst_ip + struct.pack('!BBH', 0, 6, tcp_length)
    tcp_raw = raw(tcp_pkt)
    tcp_raw = tcp_raw[:16] + b'\x00\x00' + tcp_raw[18:]
    checksum_data = pseudo_header + tcp_raw
    if len(checksum_data) % 2 != 0:
        checksum_data += b'\x00'
    checksum = 0
    for i in range(0, len(checksum_data), 2):
        word = (checksum_data[i] << 8) + checksum_data[i+1]
        checksum += word
        checksum = (checksum & 0xffff) + (checksum >> 16)
    checksum = ~checksum & 0xffff
    return checksum
packets = rdpcap("mm.pcap")
for i, pkt in enumerate(packets):
    if IP in pkt and TCP in pkt:
        original_checksum = pkt[TCP].chksum
        calculated_checksum = calculate_tcp_checksum(pkt[IP])
        print(f"\nPacket {i+1}")
        print(f"Original  : {hex(original_checksum)}")
        print(f"Calculated: {hex(calculated_checksum)}")
        if original_checksum == 0:
            print("Result    : Checksum Offloading (0x0000)")
        elif original_checksum == calculated_checksum:
            print("Result    : VALID")
        else:
            print("Result    : INVALID")
