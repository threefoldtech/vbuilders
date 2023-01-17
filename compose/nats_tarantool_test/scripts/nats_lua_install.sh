apk add gcc make lua-dev musl-dev
apk add lua-sec

# tarantoolctl rocks install lua-sec
# luarocks make rockspec/nats-0.0.3-1.rockspec

cd /tmp
git clone https://github.com/dawnangel/lua-nats
cd lua-nats
tarantoolctl rocks install luasocket
tarantoolctl rocks install lua-cjson
tarantoolctl rocks install uuid
tarantoolctl rocks install lua-nats
tarantoolctl rocks make rockspec/nats-0.0.3-1.rockspec

