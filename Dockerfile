# Use the same base image
FROM ubuntu:22.04

# Labels (optional but good for metadata)
LABEL author="A. Tolosa-Delgado, CERN, 2025"
LABEL version="Geant4-minimal-gdml"

# Set environment variables (from %environment section)
ENV G4INSTALL=/opt/geant4
ENV G4DATA_DIR=$G4INSTALL/share/Geant4/data
ENV G4LIB_DIR=$G4INSTALL/lib
ENV PATH=$G4INSTALL/bin:$PATH
ENV LD_LIBRARY_PATH=$G4INSTALL/lib:$LD_LIBRARY_PATH
ENV G4GDMLROOT=$G4INSTALL

# Install dependencies and build Geant4 (from %post)
RUN apt-get update && apt-get install -y \
        build-essential \
        cmake \
        wget \
        libxerces-c-dev \
        libexpat1-dev \
        qtbase5-dev \
        mesa-utils \
        libglu1-mesa-dev \
        freeglut3-dev \
        mesa-common-dev && \
    cd /opt && \
    G4_VERSION=11.2.2 && \
    wget https://github.com/Geant4/geant4/archive/refs/tags/v${G4_VERSION}.tar.gz && \
    tar -xf v${G4_VERSION}.tar.gz && \
    mv geant4-${G4_VERSION} geant4-source && \
    mkdir -p geant4-build geant4-install && \
    cd geant4-build && \
    cmake ../geant4-source \
        -DCMAKE_INSTALL_PREFIX=/opt/geant4 \
        -DGEANT4_BUILD_MULTITHREADED=ON \
        -DGEANT4_USE_GDML=ON \
        -DGEANT4_USE_SYSTEM_EXPAT=ON \
        -DGEANT4_USE_SYSTEM_XERCESC=ON \
        -DGEANT4_INSTALL_DATA=ON \
        -DGEANT4_INSTALL_EXAMPLES=OFF \
        -DGEANT4_USE_OPENGL_X11=OFF \
        -DGEANT4_USE_QT=ON \
        -DGEANT4_USE_XM=OFF \
        -DGEANT4_USE_RAYTRACER_X11=OFF && \
    make -j$(nproc) && \
    make install && \
    apt-get clean && rm -rf /var/lib/apt/lists/* /opt/v${G4_VERSION}.tar.gz /opt/geant4-source /opt/geant4-build

# Set default command / entrypoint (similar to %runscript)
CMD ["bash"]

