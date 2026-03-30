from scapy.all import *
def calculate_icmp_checksum(icmp_pkt):
    icmp_raw = raw(icmp_pkt)
    icmp_raw = icmp_raw[:2] + b'\x00\x00' + icmp_raw[4:]
    if len(icmp_raw) % 2 != 0:
        icmp_raw += b'\x00'
    checksum = 0
    for i in range(0, len(icmp_raw), 2):
        word = (icmp_raw[i] << 8) + icmp_raw[i+1]
        checksum += word
        checksum = (checksum & 0xffff) + (checksum >> 16)
    checksum = ~checksum & 0xffff
    return checksum
packets = rdpcap("mm.pcap")
for i, pkt in enumerate(packets):
    if IP in pkt and ICMP in pkt:
        original_checksum = pkt[ICMP].chksum
        calculated_checksum = calculate_icmp_checksum(pkt[ICMP])
        print(f"\nPacket {i+1}")
        print(f"Original  : {hex(original_checksum)}")
        print(f"Calculated: {hex(calculated_checksum)}")
        if original_checksum == calculated_checksum:
            print("Result    : VALID")
        else:
            print("Result    : INVALID")
