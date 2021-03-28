-module(testp).

-behaviour(auth_on_register_hook).
-behaviour(auth_on_register_m5_hook).
-behaviour(auth_on_publish_hook).
-behaviour(auth_on_publish_m5_hook).
-behaviour(on_deliver_hook).
-behaviour(on_deliver_m5_hook).
-behaviour(auth_on_subscribe_hook).
-behaviour(auth_on_subscribe_m5_hook).
-behaviour(on_topic_unsubscribed_hook).
-behaviour(on_client_offline_hook).
-behaviour(on_client_gone_hook).


-export([
    start/0,
    stop/0,
    auth_on_register/5,
    auth_on_register_m5/6,
    auth_on_publish/6,
    auth_on_publish_m5/7,
    on_deliver/6,
    on_deliver_m5/7,
    auth_on_subscribe/3,
    auth_on_subscribe_m5/4,
    on_topic_unsubscribed/2,
    on_client_offline/1,
    on_client_gone/1
]).

%% =============================================================================
%% Plugin Callbacks
%% =============================================================================

start() ->
    application:ensure_all_started(?MODULE),
    ok.

stop() ->
    ok.

auth_on_register(
    _Peer, _SubscriberId, _Username,
    _Password, _CleanSession) ->
        ok.

auth_on_register_m5(
    _Peer, _SubscriberId, _Username,
    _Password, _CleanSession, _Properties0) ->
    ok.

auth_on_publish(
    _Username, _SubscriberId,
    _QoS, _Topic, _Payload, _IsRetain) ->
    ok.

auth_on_publish_m5(
    _Username, _SubscriberId,
    _QoS, _Topic, _Payload, _IsRetain, _Properties) ->
    ok.

on_deliver(
    _Username, _SubscriberId,
    _QoS, _Topic, _Payload, _IsRetain) ->
    ok.

on_deliver_m5(
    _Username, _SubscriberId,
    _QoS, _Topic, _Payload, _IsRetain, _Properties) ->
    ok.

auth_on_subscribe(
    _Username, _SubscriberId,
    _Subscriptions) ->
    ok.

auth_on_subscribe_m5(
    _Username, SubscriberId,
    _Subscriptions, _Properties) ->
    error_logger:info_msg("auth_on_subscribe_m5 hook for SubscriberId: ~p, starting testp_checker loop", [SubscriberId]),
    testp_checker:loop(SubscriberId),
    ok.

on_topic_unsubscribed(
    _SubscriberId,
    _Topics) ->
    ok.

on_client_offline(_SubscriberId) ->
    ok.

on_client_gone(_SubscriberId) ->
    ok.
