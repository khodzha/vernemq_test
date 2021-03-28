-module(testp_sup).
-behaviour(supervisor).

-export([
    start_link/0
]).

-export([
    init/1
]).

start_link() ->
    supervisor:start_link({local, ?MODULE}, ?MODULE, []).

init([]) ->
    Flags = #{},
    Procs = [
        #{
        id => testp_gs_a,
        start => {testp_gs, start_link, [a]}
    }, #{
        id => testp_gs_b,
        start => {testp_gs, start_link, [b]}
    }, #{
        id => testp_checker,
        start => {testp_checker, start_link, []}
    }],

    {ok, {Flags, Procs}}.
