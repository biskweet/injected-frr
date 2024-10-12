sudo apt-get install -y git autoconf automake libtool make \
   libprotobuf-c-dev protobuf-c-compiler build-essential \
   python3-dev python3-pytest python3-sphinx libjson-c-dev \
   libelf-dev libreadline-dev cmake libcap-dev bison flex \
   pkg-config texinfo gdb libgrpc-dev python3-grpc-tools;


git clone https://github.com/PCRE2Project/pcre2;

cd pcre2;
./configure; make; make install;

git clone https://github.com/CESNET/libyang.git;
cd libyang;
git checkout v2.1.128;
mkdir build; cd build;
cmake --install-prefix /usr \
      -D CMAKE_BUILD_TYPE:String="Release" ..;
make;
sudo make install;

sudo addgroup --system --gid 92 frr;
sudo addgroup --system --gid 85 frrvty;
sudo adduser --system --ingroup frr --home /var/opt/frr/ \
   --gecos "FRR suite" --shell /bin/false frr;
sudo usermod -a -G frrvty frr;

git clone https://github.com/biskweet/injected-frr frr;
cd frr;

./bootstrap.sh
./configure \
    --sysconfdir=/etc \
    --localstatedir=/var \
    --sbindir=/usr/lib/frr \
    --enable-multipath=64 \
    --enable-user=frr \
    --enable-group=frr \
    --enable-vty-group=frrvty \
    --enable-configfile-mask=0640 \
    --enable-logfile-mask=0640 \
    --enable-fpm \
    --with-pkg-git-version \
    --with-pkg-extra-version=-MyOwnFRRVersion;
make;
make check;
sudo make install;

mkdir /etc/frr;
sudo install -m 640 -o frr -g frr /dev/null /etc/frr/frr.conf;
sudo install -m 640 -o frr -g frr tools/etc/frr/daemons /etc/frr/daemons;

python3 prepare_sys.py;
