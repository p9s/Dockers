FROM perl:5.22.0
MAINTAINER Arthur Axel fREW Schmidt <frew-perl@afoolishmanifesto.com>

RUN cpanm -nq DBI                                                  && \
    wget ftp://ftp.unixodbc.org/pub/unixODBC/unixODBC-2.3.2.tar.gz && \
    tar xf unixODBC-2.3.2.tar.gz                                   && \
    cd /root/unixODBC-2.3.2                                        && \
    ./configure --disable-gui --disable-drivers --enable-stats=no --enable-iconv --with-iconv-char-enc=UTF8 --with-iconv-ucode-enc=UTF16LE && \
    make                                                           && \
    make install                                                   && \
    echo "include /usr/local/lib" >> /etc/ld.so.conf               && \
    ldconfig                                                       && \
    cd /root                                                       && \
    rm -rf unixODBC-2.3.2.tar.gz unixODBC-2.3.2                    && \
    ln -s /usr/local/lib/libodbc.so.2 /usr/lib/libodbc.so.1          && \
    ln -s /usr/local/lib/libodbccr.so.2 /usr/lib/libodbccr.so.1      && \
    ln -s /usr/local/lib/libodbcinst.so.2 /usr/lib/libodbcinst.so.1  && \
    ln -s /usr/lib/x86_64-linux-gnu/libssl.so.1.0.0 /usr/lib/libssl.so.10                        && \
    ln -s /usr/lib/x86_64-linux-gnu/libcrypto.so.1.0.0 /usr/lib/libcrypto.so.10 && \
    wget http://download.microsoft.com/download/B/C/D/BCDD264C-7517-4B7D-8159-C99FC5535680/RedHat6/msodbcsql-11.0.2270.0.tar.gz && \
    tar xf msodbcsql-11.0.2270.0.tar.gz && \
    cd /root/msodbcsql-11.0.2270.0      && \
    bash install.sh install --force --accept-license && \
    cd /root                            && \
    rm -rf msodbcsql-11.0.2270.0.tar.gz /root/msodbcsql-11.0.2270.0 && \
    wget https://cpan.metacpan.org/authors/id/M/MJ/MJEVANS/DBD-ODBC-1.50.tar.gz && \
    tar xf DBD-ODBC-1.50.tar.gz && \
    cd /root/DBD-ODBC-1.50      && \
    perl Makefile.PL -u         && \
    cpanm --installdeps .       && \
    make                        && \
    make test                   && \
    make install                && \
    cd /root                    && \
    rm -rf DBD-ODBC-1.50.tar.gz DBD-ODBC-1.50 && \
    env DEBIAN_FRONTEND=noninteractive apt-get update && \
    apt-get install -y locales unzip libgmp-dev xvfb && \
    echo "en_US.UTF-8 UTF-8" > /etc/locale.gen && \
    locale-gen && \
    cpanm -nq --installdeps . || (cat ~/.cpanm/build.log; exit 1) 

RUN apt-get autoremove -y 
RUN apt-get clean && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/* ~/.cpanm

ENV LC_ALL en_US.utf8
