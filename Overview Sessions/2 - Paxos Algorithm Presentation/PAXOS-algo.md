# PAXOS
> Consensus Algorithm

## 1.Consensus
**The consensus problem can be stated in a basic, generic manner: One or more systems may propose some value. How do we get a collection of computers to agree on exactly one of those proposed values?**
Collection of computers and want them all to agree on something. This is what consensus is about; consensus means agreement.
* Frequently in distributed systems design
* Replication may be the most common use of consensus , among(clusters) of servers, all of which will have replicated content.
* This provides fault tolerance: if any server dies, others are still running.
* First case, we need consensus to elect that coordinator.
* Second case, we need to run a consensus algorithm for each update to ensure that everyone agrees on the order.

## 2. Consensus Properties
**The network is unreliable and asynchronous: messages may get lost or arbitrarily delayed.**
- **Validity:** only the proposed values can be decided. If a process decides on some value, v, then some process must have proposed v.
- **Uniform Agreement**: no two correct processes (those that do not crash) can decide on different values.
- **Integrity:** each process can decide a value at most once.
- **Termination:** all processes will eventually decide on a result.

## 3.Paxos Algorithm
**Paxos is an algorithm that is used to achieve consensus among a distributed set of computers that communicate via an asynchronous network.**

- One or more clients proposes a value to Paxos and we have consensus when a majority of systems running Paxos agrees on one of the proposed values. Paxos is widely used and is legendary in computer science since it is the first consensus algorithm that has been rigorously proved to be correct.

**Paxos simply selects a single value from one or more values that are proposed to it and lets everyone know what that value is. A run of the Paxos protocol results in the selection of single proposed value.**

- If you need to use Paxos to create a replicated log (for a replicated state machine), then you need to run Paxos repeatedly. This is called multi-Paxos.

**Paxos provides abortable consensus. This means that some processes abort the consensus if there is contention while others decide on the value.**

- Aborting allows a process to terminate rather than be blocked indefinitely. When a client proposes a value to Paxos, it is possible that the proposed value might fail if there was a competing concurrent proposal that won. The client will then have to propose the value again to another run of the Paxos algorithm.

## 4.Assumptions for the algorithm

1. Concurrent proposals: One or more systems may propose a value concurrently. If only one system would propose a value then it is clear what the consensus would be. With multiple systems, we need to select one from among those values.

2. Validity: The chosen value that is agreed upon must be one of the proposed values. The servers cannot just choose a random number.

3. Majority rule: Once a majority of Paxos servers agrees on one of the proposed values, we have consensus on that value. This also implies that a majority of servers need to be functioning for the algorithm to run. To survive m failures, we will need 2m+1 systems.

4. Unicasts: Communication is point-to-point. There is no mechanism to multicast a message atomically to the set of Paxos servers.

5. Announcement: Once consensus is reached, the results can be made known to everyone.

## 5.Entities of Paxos

Paxos has three entities:

1.  **Proposers:** Receive requests (values) from clients and try to convince acceptors to accept their proposed values.

2.  **Acceptors:** Accept certain proposed values from proposers and let proposers know if something else was accepted. A response from an acceptor represents a vote for a particular proposal.

3.  **Learners:** Announce the outcome.


A single node may run proposer, acceptor, and learner roles. It is common for Paxos to coexist with the service that requires consensus on a set of replicated servers, with each server taking on all three roles rather than using separate servers dedicated to Paxos.

**We need a protocol to choose exactly one value in cases where multiple competing values may be proposed.**

## 6.Distributed Consensus Protocol Architectures

> **Multiple proposers, single acceptor**

The simplest attempt to design a consensus protocol will use a single acceptor. We can elect one of our systems to take on this role. Multiple proposers will concurrently propose various values to a single acceptor. The acceptor chooses one of these proposed values.

Unfortunately, this does not handle the case where the acceptor crashes.

If it crashes after choosing a value, we will not know what value has been chosen and will have to wait for the acceptor to restart. We want to design a system that will be functional if the majority of nodes are running.

## 7.Fault Tolerant

> **Multiple proposers, Multiple acceptors**
To achieve fault tolerance, we will use a collection of acceptors.

- Each proposal will be sent to at least a majority of these acceptors.

- If a quorum, or majority, of these acceptors chooses a particular proposed value (proposal) then that value will be considered chosen.

- Even if some acceptors crash, others are up so we will still know the outcome. If an acceptor crashes after it accepted a proposal, other acceptors know that a value was chosen.



- If an acceptor simply accepts the first proposed value it receives and cannot change its mind .it is possible that we may have no majority of accepted values.

- Depending on the order in which messages arrive at various acceptors, each acceptor may choose a different value or small groups of acceptors may choose different values such that there is no majority of acceptors that chose the same proposed values.

- This tells us that acceptors may need to change their mind about which accepted value to choose.

- We want a value to be chosen only when a majority of acceptors accept that value

- we know that an acceptor may need to change its mind, we might consider just having an acceptor accept any value given by any proposer.

To fix this, instead of just having a proposer propose a value, we will first ask it to contact a majority of acceptors and check whether a value has already been chosen. If it has, then the proposer must propose that chosen value to the other acceptors.**

To implement this, we will need a **two phase protocol: check first and then provide a value**

- Asking a proposer to check is not sufficient. Another proposer may come along after the checking phase and propose a different value. What if that second value is accepted by a majority and then the acceptors receive requests from the first proposer to accept its value?
- We again end up with two chosen values. The protocol needs to be modified to ensure that once we accept a value, we will abort competing proposals.
- To do this, Paxos will impose an ordering on proposals.
- Newer proposals will take precedence over older ones. If that first proposer tries to finish its protocol, its requests will fail.

## 8.Two-phase protocol
> Phase 1  
* A proposer asks all the working acceptors whether anyone already received a proposal. If the answer is no, propose a value.>Phase 2  
* If a majority of acceptors agree to this value then that is our consensus.When a proposer receives a client request to reach consensus on a value, the proposer must create a proposal number. This number must have two properties:  
1. It must be unique. No two proposers can come up with the same number. An easy way of doing this is to use a global process identifier for the least significant bits of the number. For example, instead of an ID=12, node 3 will generate ID=12.3 and node 2 will generate 12.2.  
2. It must be bigger than any previously used identifier used in the cluster. A proposer may use an incrementing counter to achieve this. If the number is not bigger than one previously used, the proposer will find out by having its proposal rejected and will have to try again.

### Phase 1  
* A proposer receives a consensus request for a VALUE from a client. It creates a unique proposal number, ID, and sends a PREPARE(ID) message to at least a majority of acceptors.* Each acceptor that receives the PREPARE message looks at the ID in the message and decides:  
```  
Is this ID bigger than any round I have previously received?  
If yes  
store the ID number, max_id = ID  
respond with a PROMISE message  
If no  
do not respond (or respond with a “fail” message)  
```  
* If the proposer receives a PROMISE response from a majority of acceptors, it now knows that a majority of them are willing to participate in this proposal. The proposer can now proceed with getting consensus. Each of these acceptors made a promise that no other proposal with a smaller number can make it to consensus.

>summary

* in short,
    * In the first phase,
        * the proposer finds out that no promises have been made to higher numbered proposals.
    * In the second phase,
        * the proposer asks the acceptors to accept the proposal with a specific value.
        * As long as no higher numbered proposals have arrived during this time, the acceptor responds back that the proposal has been accepted.


##Engineering Paxos

* Group management
    * The cluster of systems that are running Paxos needs to be administered.
    * able to add systems to the group, remove them, and detect if any processes, entire systems, or network links are dead.
    * Each proposer needs to know the set of acceptors so it can communicate with them and needs to know the learners.

* Byzantine failures
    * We assumed that none of the systems running Paxos suffer Byzantine failures.
    * That is, either they run and communicate correctly or they stay silent.
    * In real life, however, Byzantine failures do exist.
    * We can guard against network problems with mechanisms such as checksums or, if we fear malicious interference, digital signatures.
    * However, we do need to worry about a misbehaving proposer that may inadvertantly set its proposal ID to infinity (e.g., INFINITY in math.h in C or math.inf in Python if using floats; otherwise INT_MAX in C or sys.maxint in Python).
    * This puts the Paxos protocol into a state where acceptors will have to reject any other proposal.
