## VerneMQ race condition test

This plugin illustrates race condition in `vmq_reg:subscribe()`

### How to run

To build and run vernemq with plugin enabled:

```bash
make
```

You must also connect a client like this (plugin only starts spitting output after a client subcribes to any topic):

```bash
mosquitto_sub -V 5 -q 0 -h 0.0.0.0 -p 1883 -i debugclient -t 'sometopic'
```

After a client subscribes plugin every 5 seconds performs [this sequence](testp/src/testp_checker.erl#L31-L57) of events:
* issue concurrent subscribes to topics `a/events` and `b/events`
* check if client total topics is 3 (which is correct) or less
* cleanup before next loop iteration

### Example output

```bash
14:14:08.627 [info] auth_on_subscribe_m5 hook for SubscriberId: {[],<<"debug-x-26.devops.svc.example.org">>}, starting testp_checker loop
14:14:14.130 [error] ERROR!!! Total topics should be 3, got = 2, topics = [[<<"b">>,<<"events">>],[<<"sometopic">>]]
14:14:19.129 [error] ERROR!!! Total topics should be 3, got = 2, topics = [[<<"a">>,<<"events">>],[<<"sometopic">>]]
14:14:24.130 [error] ERROR!!! Total topics should be 3, got = 2, topics = [[<<"a">>,<<"events">>],[<<"sometopic">>]]
14:14:29.130 [error] ERROR!!! Total topics should be 3, got = 2, topics = [[<<"b">>,<<"events">>],[<<"sometopic">>]]
14:14:34.130 [error] ERROR!!! Total topics should be 3, got = 2, topics = [[<<"b">>,<<"events">>],[<<"sometopic">>]]
14:14:39.130 [error] ERROR!!! Total topics should be 3, got = 2, topics = [[<<"b">>,<<"events">>],[<<"sometopic">>]]
```

As you can see, sometimes there is no `b/events` and sometimes there is no `a/events`.


This happens in concurrent environment since `vmq_reg:subscribe` first queries existings subs and then updates them, but [_NOT_](https://github.com/vernemq/vernemq/blob/8c498e46fe4e017d8656cfa0533d5951ef391f09/apps/vmq_server/src/vmq_reg.erl#L83-L85) in atomic fashion.

