* For notifying on reaching thresholds, we need to check the metrics before sending as events in script itself using normal `if` statements - see example [here](https://github.com/alwaysiamkk/Internship/blob/d54b807802e098eacc4b4fc1fc1de0ab5adeff95/Week%208/riemann-client.py#L40) for `warning`, and the next line for `critical`.

* These states are fed into events for `state` option which if is `critical` where `critical` will be `80%`, then it would be like
    ```py
    client.event(..., state="critical",...)
    ```

* Now we can see riemann dashboard and the colors on each grid box depends on its state,

    state | color
    :--: | :--:
    <not_specified> | gray
    ok | green
    warning | yellow
    critical | orange or red

* We can change `riemann.config` of riemann server to see the logs for not just `expired` events and also `warning` & `critical` alerts, by adding
    ```clj
    (let [index (index)]
        ...
        (streams
            (default :ttl 20
                ...
                riemann-to-influxdb
                ...
                ; Log warning & critical events.
                (match :state #{"warning" "critical"} 
                    (fn [event] (info "critical" event))
                )
            )
        )
    )
    ```
    `match` can be used to match the option `state` with value we specify in `#{}`, here they were `warning` & `critical` and then pass the events to its child stream, here `[event]` to log them onto the riemann server screen.
