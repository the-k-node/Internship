# TCP :handshake:

- The **Transmission Control Protocol (TCP)** is a transport protocol that is used **on top of IP** to **ensure reliable transmission of packets**.
- TCP includes **mechanisms** to solve many of the problems that arise from packet-based messaging, such as **lost** packets, **out of order** packets, **duplicate** packets, and **corrupted** packets.
- Since TCP is the protocol used most commonly on top of IP, the Internet protocol stack is sometimes referred to as **TCP/IP**.

### Packet Format

- When sending packets using TCP/IP, the **data portion** of each IP packet is formatted as a **TCP segment**.
- Diagram of a **TCP segment within an IP packet**. The IP packet contains **header** and **data** sections.
![packer_format](https://github.com/alwaysiamkk/Internship/blob/main/Overview%20Sessions/9%20-%20Various%20Concepts/tcp1%20-%20packet%20format.svg)
- The **IP data** section is the TCP segment, which itself contains **header** and **data** sections.
- Each TCP segment contains a **header** and **data**.
- The TCP header contains many **more fields** than a **UDP header** and can range in size from **202020** to **606060 bytes**, depending on the size of the **options** field.
- The TCP header shares some fields with the UDP header: **source port** number, **destination port** number, and **checksum**.

### How TCP Works?
---

- Let's step through the process of transmitting a packet with TCP/IP.

#### Step 1: Establish connection

- When two computers want to send data to each other over TCP, they first need to establish a connection using a **three-way handshake**.

