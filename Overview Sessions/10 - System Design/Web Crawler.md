# System Design
## Web Crawler

<img src="https://i.ibb.co/258sZmG/spider.jpg" alt="spider" border="0" width="800">
<br/>
<br/>

### What is a **Web Crawler** ?

- A Web Crawler is a **software program** which browses the **World Wide Web** in a **methodical** and **automated** manner.
- It collects documents by **recursively fetching links** from a set of starting pages.
- Particularly **search engines**, use web crawling as a means of providing **up-to-date** data.
- Search engines download all the pages to create an **index** on them to perform **faster searches**.
<br/>

### **Uses** of Web Crawler

- To **test** web pages and links for **valid syntax** and **structure**.
- To **monitor** sites to see when their structure or contents change.
- To maintain **mirror sites** for popular Web sites.
- To **search** for copyright infringements.
- To build a **special-purpose** index, e.g., one that has some understanding of the content stored in multimedia files on the Web.

### **Essential Requirements** of Web Crawler

1. **Scalability**: Our service needs to be scalable such that it can crawl the entire Web and can be used to fetch hundreds of millions of Web documents.
2. **Extensibility**: Our service should be designed in a modular way with the expectation that new functionality will be added to it. There could be newer document types that needs to be downloaded and processed in the future.
3. **Robustness**: The Web contains servers that create spider traps, which are generators of web pages that mislead crawlers into getting stuck fetching an infinite number of pages in a particular domain. Crawlers must be designed to be resilient to such traps. Not all such traps are malicious; some are the inadvertent side-effect of faulty website development.
4. **Politeness**: Web servers have both implicit and explicit policies regulating the rate at which a crawler can visit them. These politeness policies must be respected.

### **Important Requirements** of Web Crawler

1. **Distributed**: The crawler should have the ability to execute in a distributed fashion across multiple machines.
2. **Scalable**: The crawler architecture should permit scaling up the crawl rate by adding extra machines and bandwidth.
3. **Performance and efficiency**: The crawl system should make efficient use of various system resources including processor, storage and network bandwidth.
4. **Quality**: Given that a significant fraction of all web pages are of poor utility for serving user query needs, the crawler should be biased towards fetching “useful” pages first.
5. **Freshness**: In many applications, the crawler should operate in continuous mode: it should obtain fresh copies of previously fetched pages. A search engine crawler, for instance, can thus ensure that the search engine’s index contains a fairly current representation of each indexed web page. For
such continuous crawling, a crawler should be able to crawl a page with a frequency that approximates the rate of change of that page.
6. **Extensible**: Crawlers should be designed to be extensible in many ways – to cope with new data formats, new fetch protocols, and so on. This demands that the crawler architecture be modular.

### **Necessary Features**

1. **Crawling Frequency**: Also known as crawl rate, or crawl frequency refers to how often you want to crawl a website. You can have different crawl rates for different websites. For example, news websites might need to be crawled more often.
2. **Dedup**: Where multiple crawlers are used, they may add duplicate links to the same URL pool. Dedup or duplicate detection involves the use of a space-efficient system, like Bloom Filter, to detect duplicate links, so your design isn’t crawling the same sites.
3. **Protocols**: Think about the protocols that your crawler will cater to. A basic crawler can handle HTTP links, but you can also modify the application to work over STMP or FTP.
4. **Capacity**:
    - Each page that is **crawled** will carry several **URLs to index**.
    - Assume an estimate of around `50 billion` pages.
    - Assuming an average page size of `100kb`:
        `50 B x 100 KBytes = 5 petabytes`
    - You would need around `5 petabytes` of storage.
    - We can **compress** the documents to save storage since you’ll not need to refer to it every time.
    - For certain applications, such as search engines, you may only need to extract the **metadata** information before compressing it.
    - When you do need the entire content of the page, you can access it through the **cached file**.


### **Algorithm Execution**

The **basic algorithm** executed by any Web crawler is to take a list of **seed URLs** as its **input** and **repeatedly execute** the following steps.

1. Pick a **URL** from the **unvisited URL list**.
2. Determine the **IP Address** of its **host-name**.
3. Establish a connection to the **host** to **download the corresponding document**.
4. Parse the document contents to look for **new** URLs.
5. Add the new URLs to the list of **unvisited URLs**.
6. Process the downloaded document, eg: store it or index its contents.
7. Go back to step 1.

### **High-Level** Design

<img src="https://i.ibb.co/yVrwc7V/crawler-1.png" alt="crawler-1" border="0" width="1000">

### **Detailed Component** Design

<img src="https://i.ibb.co/DDpw5fY/c-design-1.png" alt="c-design-1" border="0" width="1000">

### **URL Frontier** Design

<img src="https://i.ibb.co/YZ8m3R1/url-frontier-des.png" alt="url-frontier-des" border="0">