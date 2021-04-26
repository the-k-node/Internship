* We have to send Operating System and Aerospike metrics from all 3 AS nodes to the `reimann-server` that we configured before.

* We can select various languages and tools available to create a `riemann client` and send the required events.

* I use `python` language and `borntyping`'s `riemann-client` python package to send events, and `psutil` python package to collect OS metrics like `cpu`, `memory`, `disk` details. Commands to install are (ensure you're using python 2.7 version)
    ```bash
    $ pip install protobuf  # requirement
    $ pip install riemann-client
    $ pip install psutil
    ```

* Final Script - [riemann-client.py](https://github.com/alwaysiamkk/Internship/blob/main/Week%208/riemann-client.py)

* I am collecting and sending event every 10 seconds to make sure metrics are as accurate as possible at any point in time.
