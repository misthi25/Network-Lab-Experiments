from scapy.all import *
def calculate_ip_checksum(ip_pkt):
    ip_raw = raw(ip_pkt)
    header_length = ip_pkt.ihl * 4
    ip_header = ip_raw[:header_length]
    ip_header = ip_header[:10] + b'\x00\x00' + ip_header[12:]
    if len(ip_header) % 2 != 0:
        ip_header += b'\x00'
    checksum = 0
    for i in range(0, len(ip_header), 2):
        word = (ip_header[i] << 8) + ip_header[i+1]
        checksum += word
        checksum = (checksum & 0xffff) + (checksum >> 16)
    checksum = ~checksum & 0xffff
    return checksum
packets = rdpcap("mm.pcap")
for i, pkt in enumerate(packets):
    if IP in pkt:
        original_checksum = pkt[IP].chksum
        calculated_checksum = calculate_ip_checksum(pkt[IP])
        print(f"\nPacket {i+1}")
        print(f"Original  : {hex(original_checksum)}")
        print(f"Calculated: {hex(calculated_checksum)}")
        if original_checksum == calculated_checksum:
            print("Result    : VALID")
        else:
            print("Result    : INVALID")
