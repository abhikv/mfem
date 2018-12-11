#export LD_LIBRARY_PATH=$LD_LIBRARY_PATH:/usr/WS1/vargas45/Git-Repos/MFEM_BUILD/metis-5.1.0/lib
#
make config MFEM_USE_KERNELS=YES MFEM_CXX=nvcc   MFEM_CPPFLAGS=-g \
MFEM_CXXFLAGS="--restrict -x=cu -arch=sm_60 -std=c++11 -m64  --expt-extended-lambda --compiler-bindir=mpic++" \
MFEM_DEBUG=YES MFEM_USE_MPI=YES HYPRE_DIR=/usr/WS1/vargas45/Git-Repos/MFEM_BUILD/hypre-2.11.2/src/hypre \
MFEM_USE_METIS_5=YES METIS_DIR=/usr/WS1/vargas45/Git-Repos/MFEM_BUILD/metis-5.1.0 \
MFEM_TPLFLAGS=" \
-I/usr/WS1/vargas45/Git-Repos/MFEM_BUILD/hypre-2.11.2/src/hypre/include \
-I/usr/WS1/vargas45/Git-Repos/MFEM_BUILD/metis-5.1.0/include \
-I/usr/tce/packages/spectrum-mpi/ibm/spectrum-mpi-rolling-release/include \
-I/usr/local/cuda-9.2/samples/common/inc \
-I/usr/WS1/vargas45/Git-Repos/MFEM_BUILD/cub \
-I/usr/WS1/vargas45/Git-Repos/MFEM_BUILD/RAJA/build/include" \
LDFLAGS=-L/usr/WS1/vargas45/Git-Repos/MFEM_BUILD/RAJA/build/lib/libRAJA.a 
#MFEM_USE_BACKENDS=NO
#MFEM_EXT_LIBS+=-L/usr/tce/packages/spectrum-mpi/ibm/spectrum-mpi-rolling-release/lib \
#MFEM_EXT_LIBS+=-L/usr/WS1/vargas45/Git-Repos/MFEM_BUILD/metis-5.1.0/lib/libmetis.so


