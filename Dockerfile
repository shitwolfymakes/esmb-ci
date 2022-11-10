FROM ubuntu:focal AS base

####################
# install packages #
####################

ENV DEBIAN_FRONTEND=noninteractive

RUN apt update && \
    apt install --no-install-recommends -y \
        git ninja-build make valgrind \
        lsb-release wget software-properties-common lcov gpg-agent \
        gcc-multilib g++-multilib \
        g++ \
        clang-12 \
        python3 python3-pip && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

RUN pip install -U pip && pip install aqtinstall
    
####################
# get latest CMake #
####################

RUN CMAKE_VERSION=3.23.2 && \
    wget https://github.com/Kitware/CMake/releases/download/v$CMAKE_VERSION/cmake-$CMAKE_VERSION-Linux-x86_64.sh && \
    chmod a+x cmake-$CMAKE_VERSION-Linux-x86_64.sh && \
    ./cmake-$CMAKE_VERSION-Linux-x86_64.sh --skip-license --prefix=/usr/local && \
    rm cmake-$CMAKE_VERSION-Linux-x86_64.sh

####################
# get latest Clang #
####################

# see https://apt.llvm.org
RUN wget https://apt.llvm.org/llvm.sh && chmod +x llvm.sh && ./llvm.sh 15 && rm llvm.sh
RUN apt-get update && \
    apt-get install --no-install-recommends -y clang-tools-15 clang-tidy-15 && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

##################
# get latest GCC #
##################

RUN wget http://kayari.org/gcc-latest/gcc-latest.deb && \
    dpkg -i gcc-latest.deb && \
    rm -rf gcc-latest.deb && \
    ln -s /opt/gcc-latest/bin/g++ /opt/gcc-latest/bin/g++-latest && \
    ln -s /opt/gcc-latest/bin/gcc /opt/gcc-latest/bin/gcc-latest

ENV PATH=${PATH}:/opt/gcc-latest/bin

#######################
# get latest cppcheck #
#######################

RUN git clone --depth 1 https://github.com/danmar/cppcheck.git && \
    cmake -S cppcheck -B cppcheck/build -G Ninja -DCMAKE_BUILD_TYPE=Release && \
    cmake --build cppcheck/build --target install && \
    rm -rf cppcheck

#############
# get boost #
#############

RUN run apt update && \
    apt install --no-install-recommends -y \
        libboost-all-dev && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*
RUN echo ${BOOST_ROOT}

FROM base AS esmb-ci

RUN aqt install-qt linux desktop 5.15.2
RUN aqt install-qt linux desktop 6.2.4
