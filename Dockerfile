FROM erlang:21-alpine as verne-build-stage

RUN apk --update add ca-certificates libcrypto1.1 git wget snappy-dev make gcc g++ bsd-compat-headers openssl openssl-dev curl patch
RUN git clone -q --branch 1.11.0 --depth 1 https://github.com/vernemq/vernemq.git
WORKDIR /vernemq
RUN make rel

FROM erlang:21-alpine as plugin-build-stage

RUN apk --update add ca-certificates libcrypto1.1 git wget snappy-dev make gcc g++ bsd-compat-headers openssl openssl-dev curl
WORKDIR /plugin
ADD ./testp/ .
RUN make


FROM alpine:3.9

RUN apk --update add ncurses-libs snappy
COPY --from=verne-build-stage "/vernemq/_build/default/rel/vernemq/" "/vernemq/"
COPY --from=plugin-build-stage "/plugin/_rel/testp" "/app/testp/"
ENV PATH="/vernemq/bin:${PATH}"
COPY vernemq.conf vernemq/etc/vernemq.conf
COPY --chown=10000:10000 vernemq.sh /usr/sbin/start_vernemq
RUN chmod a+x /usr/sbin/start_vernemq
CMD ["start_vernemq"]
