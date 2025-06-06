Geant4 singularity image
=======================

This guide shows how to build a minimal Singularity image with Geant4 (GDML support, no visualization) and use it to compile and run a Geant4-based project.

1. Build image

```
singularity build G4_gdml_novis.sif G4_gdml_novis.def
```

In a 64 core machine it takes 6 min total (2 min OS, 4 min Geant4). Size of sif image: 1.6 GB

2. Use it to build custom project

Clone the Project Repository
```
git clone -b silent_simulation git@github.com:atolosadelgado/HGCALTB.git
```

Configure and Build
```
singularity exec G4_gdml_novis.sif cmake -S HGCALTB/ -B build -D CMAKE_INSTALL_PREFIX=work
singularity exec G4_gdml_novis.sif cmake --build build -- -j install
```

Create Directories for Inputs and Outputs
```
mkdir -p work/input
mkdir -p work/output
```

Copy Input Files (GDML and Macro)
```
cp HGCALTB/TBHGCal181Oct.gdml HGCALTB/HGCALTBrun.mac work/input/
```

Run the Application
```
singularity exec --bind ./work:/work G4_gdml_novis.sif /work/bin/HGCALTB -m /work/input/HGCALTBrun.mac -g /work/input/TBHGCal181Oct.gdml  -f /work/output/kk.root
```

The `--bind ./work:/work` option mounts your local `work/` directory into the container at `/work`.
Ensure that all file paths passed to the application reflect their location inside the container.
