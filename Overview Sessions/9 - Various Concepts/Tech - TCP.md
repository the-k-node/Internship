# TCP :handshake:

### Overview

- The **Transmission Control Protocol (TCP)** is a transport protocol that is used **on top of IP** to **ensure reliable transmission of packets**.
- TCP includes **mechanisms** to solve many of the problems that arise from packet-based messaging, such as **lost** packets, **out of order** packets, **duplicate** packets, and **corrupted** packets.
- Since TCP is the protocol used most commonly on top of IP, the Internet protocol stack is sometimes referred to as **TCP/IP**.

### Packet Format

- When sending packets using TCP/IP, the **data portion** of each IP packet is formatted as a **TCP segment**.
- Diagram of a **TCP segment within an IP packet**. The IP packet contains **header** and **data** sections.
<br/>

![packer_format](https://github.com/alwaysiamkk/Internship/blob/main/Overview%20Sessions/9%20-%20Various%20Concepts/tcp1%20-%20packet%20format.svg)

<br/>

- The **IP data** section is the **TCP segment**, which itself contains **header** and **data** sections.
- The TCP header contains many **more fields** than a **UDP header** and can range in size from **202020** to **606060 bytes**, depending on the size of the **options** field.
- The TCP header shares some fields with the UDP header: **source port** number, **destination port** number, and **checksum**.

### How TCP Works?
---

- Let's step through the process of **transmitting a packet with TCP/IP**.

#### Step 1: Establish connection

- When two computers want to send data to each other over TCP, they first need to **establish a connection** using a **three-way handshake**.

<br/>

![3-way_handshake](https://github.com/alwaysiamkk/Internship/blob/main/Overview%20Sessions/9%20-%20Various%20Concepts/tcp2%20-%20tcp%20work.svg)

<br/>

- The *first* computer **sends** a packet with the **SYN bit** set to **111** where *SYN = "synchronize?"*.
- The *second* computer **sends back** a packet with the **ACK bit** set to **111** where *ACK = "acknowledge!"* plus the **SYN bit** set to **111**.
- The *first* computer **replies back** with an **ACK**.
- The **SYN** and **ACK** bits are both part of the TCP header:

  <br/>

  ![SYN_ACK_header](https://github.com/alwaysiamkk/Internship/blob/main/Overview%20Sessions/9%20-%20Various%20Concepts/tcp3%20-%20syn%20%26%20ack%20bits.svg)

  <br/>

- In fact, the three packets involved in the three-way handshake **do not** typically include any **data**.
- Once the computers are **done** with the handshake, they're ready to **receive packets containing actual data**.

#### Step 2: Send packets of data

- When a packet of data is sent over TCP, the *recipient* must always **acknowledge** what they received.

<br/>

![ACK_mech](https://github.com/alwaysiamkk/Internship/blob/main/Overview%20Sessions/9%20-%20Various%20Concepts/tcp4%20-%20send%20packets.svg)

<br/>

- The *first* computer **sends** a **packet with data** and a **sequence number**.
- The *second* computer **acknowledges** it by setting the **ACK** bit and increasing the acknowledgement number by the **length** of the received data.
- The sequence and acknowledgement numbers are part of the TCP header:

  <br/>

  ![SEQ_ACK_numbers](https://github.com/alwaysiamkk/Internship/blob/main/Overview%20Sessions/9%20-%20Various%20Concepts/tcp5%20-%2032bit%20seq%20%26%20ack.svg)

  <br/>

- Those two numbers help the computers to keep track of which data was **successfully** **received**, which data was **lost**, and which data was **accidentally sent twice**.

#### Step 3: Close the connection

- *Either* computer can **close** the connection when they **no longer** want to **send or receive data**.

<br/>

![close_conn](https://github.com/alwaysiamkk/Internship/blob/main/Overview%20Sessions/9%20-%20Various%20Concepts/tcp6%20-%20close%20conn.svg)

<br/>

- A *computer* initiates closing the connection by sending a packet with the **FIN bit** set to **1** where *FIN = finish*.
- The *other computer* replies with an **ACK** and **another FIN**.
- After one more **ACK** from the *initiating computer*, the connection is **closed**.

#### Detecting lost packets

- TCP connections **can detect lost packets** using a **timeout**.

<br/>

![detect_lost_packets](https://github.com/alwaysiamkk/Internship/blob/main/Overview%20Sessions/9%20-%20Various%20Concepts/tcp7%20-%20detect%20lost%20packets.svg)

<br/>

- After sending off a packet, the *sender* starts a **timer** and puts the packet in a **retransmission queue**.
- If the timer runs out and the sender has **not** yet received an **ACK** from the recipient, it **sends** the **packet** **again**.
- The retransmission may lead to the recipient receiving **duplicate** packets, if a packet was **not** actually lost but just very slow to arrive or be acknowledged.
- If so, the recipient can simply **discard duplicate packets**. It's better to have the data twice than not at all.

#### Handling out of order packets

- TCP connections **can detect out of order packets** by using the **sequence** and **acknowledgement** numbers.

<br/>

![ooo](https://github.com/alwaysiamkk/Internship/blob/main/Overview%20Sessions/9%20-%20Various%20Concepts/tcp8%20-%20out%20of%20order%20packets.svg)

<br/>

- When the *recipient* sees a **higher sequence number** than what they have acknowledged so far, they know that they are **missing** at least one packet in between.
- In the situation pictured above, the recipient sees a *sequence number* of **#73** but expected a sequence number of **#37**.
- The *recipient* lets the *sender* know there's something amiss by sending a packet with an **acknowledgement number set to the expected sequence number**.
- Sometimes the missing packet is simply taking a *slower route* through the Internet and it arrives soon after.

  <br/>

  ![slower_route](https://github.com/alwaysiamkk/Internship/blob/main/Overview%20Sessions/9%20-%20Various%20Concepts/tcp9%20-%20miss1.svg)

  <br/>

- Other times, the missing packet may actually be a **lost packet** and the sender must **retransmit** the packet.

  <br/>

  ![lost_and_retransmit](https://github.com/alwaysiamkk/Internship/blob/main/Overview%20Sessions/9%20-%20Various%20Concepts/tcp10%20-%20miss2.svg)

  <br/>

- In both situations, the *recipient* has to **deal** with out of order packets.
- The recipient can use the **sequence numbers** to **reassemble** the packet data in the **correct** order.

<br/>

![rec_deal_with_ooopackets](https://github.com/alwaysiamkk/Internship/blob/main/Overview%20Sessions/9%20-%20Various%20Concepts/tcp11%20-%20reassemble.svg)
