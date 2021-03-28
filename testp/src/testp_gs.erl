-module(testp_gs).
-behaviour(gen_server).

-export([init/1, handle_cast/2, handle_call/3]).

-export([start_link/1, create_sub/2]).


start_link(Name) -> gen_server:start_link({local, Name}, ?MODULE, [Name], []).

create_sub(Name, SubscriberId) ->
    gen_server:cast(
        Name,
        {create_sub, SubscriberId}
    ).


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

init([Name]) ->
    {ok, erlang:atom_to_binary(Name, utf8)}.

handle_cast({create_sub, SubscriberId}, Name) ->
    vmq_reg:subscribe(false, SubscriberId, [{[Name, <<"events">>], {0, #{no_local => false,rap => false,retain_handling => send_retain}}}]),
    {noreply, Name}.

handle_call(_, _ , _) -> ok.
