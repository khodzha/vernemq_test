PROJECT = testp
PROJECT_DESCRIPTION = Authentication and authorization plugin for VerneMQ

define PROJECT_ENV
	[
		{vmq_plugin_hooks, [
			{testp, auth_on_register, 5, []},
			{testp, auth_on_register_m5, 6, []},
			{testp, auth_on_publish, 6, []},
			{testp, auth_on_publish_m5, 7, []},
			{testp, on_deliver, 6, []},
			{testp, on_deliver_m5, 7, []},
			{testp, auth_on_subscribe, 3, []},
			{testp, auth_on_subscribe_m5, 4, []},
			{testp, on_topic_unsubscribed, 2, []},
			{testp, on_client_offline, 1, []},
			{testp, on_client_gone, 1, []}
		]}
	]
endef

DEPS = vernemq_dev

dep_vernemq_dev = git https://github.com/erlio/vernemq_dev.git 6d622aa8c901ae7777433aef2bd049e380c474a6

DEP_PLUGINS = version.mk
BUILD_DEPS = version.mk
dep_version.mk = git https://github.com/manifest/version.mk.git v0.2.0

TEST_DEPS = proper

SHELL_DEPS = tddreloader
SHELL_OPTS = \
	-eval 'application:ensure_all_started($(PROJECT), permanent)' \
	-s tddreloader start \
	-config rel/sys

include erlang.mk
