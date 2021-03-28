-module(testp_checker).
-behaviour(gen_server).

-export([init/1, handle_cast/2, handle_call/3, handle_info/2]).

-export([start_link/0, loop/1]).


start_link() -> gen_server:start_link({local, ?MODULE}, ?MODULE, [], []).

loop(SubscriberId) ->
    gen_server:cast(
        ?MODULE,
        {start_loop, SubscriberId}
    ).

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

init([]) ->
    {ok, ok}.

handle_cast({start_loop, SubscriberId}, State) ->
    %% Repeat this every 5s cause race conditions can be hard to catch in one go
    timer:send_interval(5000, {loop, SubscriberId}),
    {noreply, State};
handle_cast(Msg, State) ->
    error_logger:error_msg("undefined cast msg: ~p", [Msg]),
    {noreply, State}.


handle_info({loop, SubscriberId}, State) ->
    %% Create two subs concurrently
    testp_gs:create_sub(a, SubscriberId),
    testp_gs:create_sub(b, SubscriberId),
    %% And wait some time for vmq_subscriber_db to update
    timer:sleep(500),
    %% Should be 3 topics total
    {_Node, _, Topics0} = hd(vmq_subscriber_db:read(SubscriberId)),
    case length(Topics0) of
        3 ->
            error_logger:info_msg("Total topics len is 3 and should be 3, everything ok, topics = ~p", [topics_names(Topics0)]);
        N ->
            error_logger:error_msg("ERROR!!! Total topics should be 3, got = ~p, topics = ~p", [N, topics_names(Topics0)])
    end,
    %% Lets clear subs for next loop iteration
    vmq_reg:unsubscribe(false, SubscriberId, [[<<"a">>, <<"events">>]]),
    vmq_reg:unsubscribe(false, SubscriberId, [[<<"b">>, <<"events">>]]),

    timer:sleep(250),
    %% Lets make sure we actually deleted the subs
    {_Node, _, Topics1} = hd(vmq_subscriber_db:read(SubscriberId)),
    case length(Topics1) of
        1 -> ok;
        Nd ->
            error_logger:error_msg("ERROR!!! Failed to delete topics, topics left = ~p, topics = ~p", [Nd, topics_names(Topics1)])
    end,
    {noreply, State};
handle_info(Msg, State) ->
    error_logger:error_msg("undefined info msg: ~p", [Msg]),
    {noreply, State}.

handle_call(Msg, _ , State) ->
    error_logger:error_msg("undefined call msg: ~p", [Msg]),
    {noreply, State}.

topics_names(Topics) ->
    lists:map(fun({Name, _}) -> Name end, Topics).
