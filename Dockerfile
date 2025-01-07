FROM openresty/openresty:latest

# Install dependencies
RUN apt-get update && apt-get install -y \
    curl git build-essential unzip wget \
    && apt-get clean && rm -rf /var/lib/apt/lists/*

# Download and install the latest LuaRocks
ENV LUAROCKS_VERSION=3.9.2
RUN wget https://luarocks.org/releases/luarocks-${LUAROCKS_VERSION}.tar.gz \
    && tar zxpf luarocks-${LUAROCKS_VERSION}.tar.gz \
    && cd luarocks-${LUAROCKS_VERSION} \
    && ./configure --with-lua-include=/usr/local/openresty/luajit/include/luajit-2.1 \
    && make && make install \
    && cd .. && rm -rf luarocks-${LUAROCKS_VERSION} luarocks-${LUAROCKS_VERSION}.tar.gz

# Install lua-resty-jwt
RUN luarocks install lua-resty-jwt
RUN luarocks install lua-cjson