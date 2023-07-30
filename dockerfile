FROM debian
RUN set -x; buildDeps='gcc libc6-dev make wget' \
   && apt-get update \
   && apt-get install -y $buildDeps \
   && apt-get install -y xz-utils \
   && cd /usr/local \
   && wget https://nodejs.org/dist/v14.16.0/node-v14.16.0-linux-x64.tar.xz \
   && tar xf node-v14.16.0-linux-x64.tar.xz \
   && ln -sf /usr/local/node-v14.16.0-linux-x64/bin/npm   /usr/local/bin/npm \
   && ln -sf /usr/local/node-v14.16.0-linux-x64/bin/node   /usr/local/bin/node


COPY  gdal-2.3.1.tar.gz /usr/local/
COPY  geos-3.6.2.tar.bz2 /usr/local/
COPY  json-c-0.13.1.tar.gz /usr/local/
COPY  postgis-3.0.1.tar.gz /usr/local/
COPY  postgresql-12.0.tar.gz /usr/local/
COPY  proj-5.1.0.tar.gz /usr/local/
COPY  protobuf-c-1.3.3.tar.gz /usr/local/
COPY  protobuf-v3.5.0.tar.gz /usr/local/

RUN cd /usr/local \
    && tar -zxvf postgresql-12.0.tar.gz \
    && cd postgresql-12.0 \
    && apt-get install -y  libreadline-dev \  ## centos为：yum -y install readline-devel
    && apt-get install zlib1g.dev \
    && ./configure --prefix=/usr/local/pgsql \  
    && make \
    && make install \

RUN cd /usr/local \
    && apt-get install -y bzip2 \
    && apt-get install g++
    && tar -jxvf geos-3.6.2.tar.bz2  \
    && cd geos-3.6.2 \
    && ./configure --prefix=/usr/local/geos \  
    && make \
    && make install \

RUN cd /usr/local \
    && tar -zxvf proj-5.1.0.tar.gz   \
    && cd proj-5.1.0 \
    && ./configure --prefix=/usr/local/proj \  
    && make \
    && make install \

RUN cd /usr/local \
    && tar -zxvf json-c-0.13.1.tar.gz   \
    && cd json-c-0.13.1 \
    && apt-get install -y autoconf automake libtool \
    && ./configure --prefix=/usr/local/json-c \  
    && make \
    && make install \   

RUN cd /usr/local \
    && tar -zxvf gdal-2.3.1.tar.gz   \
    && cd gdal-2.3.1 \
    && ./configure --prefix=/usr/local/gdal \  
    && make \
    && make install \   


RUN cd /usr/local \
    && tar -zxvf protobuf-v3.5.0.tar.gz   \
    && cd protobuf-3.5.0 \
    && apt-get install -y autoconf automake libtool \
    && apt-get install -y curl \
    && apt-get install -y unzip \
    && sh ./autogen.sh \
    && ./configure --prefix=/usr/local/protobuf \  
    && make \
    && make install \   



RUN cd /usr/local \
    && tar -zxvf protobuf-c-1.3.3.tar.gz   \
    && cd protobuf-c-1.3.3 \
    && apt-get install -y  pkg-config \
    && export PKG_CONFIG_PATH=/usr/local/protobuf/lib/pkgconfig \
    && ./configure --prefix=/usr/local/protobuf-c \
    && make \
    && make install \
    
 

RUN cd /usr/local \
    && tar -zxvf postgis-3.0.1.tar.gz   \
    && cd postgis-3.0.1 \
    && apt-get install -y libxml2-dev \
    && ./configure --with-pgconfig=/usr/local/pgsql/bin/pg_config --with-geosconfig=/usr/local/geos/bin/geos-config --with-projdir=/usr/local/proj --with-gdalconfig=/usr/local/gdal/bin/gdal-config --with-protobufdir=/usr/local/protobuf-c --with-jsondir=/usr/local/json-c \
    && make \
    && make install \
    /usr/local/pgsql/bin

RUN ln -sf /usr/local/pgsql/bin/initdb /usr/bin/initdb \
    && ln -sf /usr/local/geos/lib/libgeos_c.so.1 /usr/local/pgsql/lib/ \
    && adduser postgres \
    && mkdir /usr/local/pgsql/data \
    && chown postgres /usr/local/pgsql/data 
                            
