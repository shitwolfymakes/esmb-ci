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
        g++ build-essential \
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

RUN apt update && \
    apt install --no-install-recommends -y \
        libboost-all-dev && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*
ENV BOOST_ROOT=/usr/include/boost

#########################
# print version numbers #
#########################

RUN echo "for TOOL in g++ clang++-15 cppcheck cmake ninja valgrind lcov boost; do echo $TOOL; $TOOL --version; echo \"\"; done" > print_versions.sh && \
    chmod +x print_versions.sh && \
    ./print_versions.sh && \
    rm print_versions.sh

FROM base AS esmb-ci

RUN aqt install-qt linux desktop 5.15.2
RUN aqt install-qt linux desktop 6.2.4
