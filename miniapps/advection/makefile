# Copyright (c) 2017, Lawrence Livermore National Security, LLC. Produced at
# the Lawrence Livermore National Laboratory. LLNL-CODE-734707. All Rights
# reserved. See files LICENSE and NOTICE for details.
#
# This file is part of CEED, a collection of benchmarks, miniapps, software
# libraries and APIs for efficient high-order finite element and spectral
# element discretizations for exascale applications. For more information and
# source code availability see http://github.com/ceed.
#
# The CEED research is supported by the Exascale Computing Project 17-SC-20-SC,
# a collaborative effort of two U.S. Department of Energy organizations (Office
# of Science and the National Nuclear Security Administration) responsible for
# the planning and preparation of a capable exascale ecosystem, including
# software, applications, hardware, advanced system engineering and early
# testbed platforms, in support of the nation's exascale computing imperative.

NV_ARCH ?= -arch=sm_60
CUDA_DIR ?= /usr/tce/packages/cuda/cuda-9.2.148

#MPI_HOME ?= /usr/local/mpi
#MPI_INCFLAGS = -I$(MPI_HOME)/include

NVCC_CXXFLAGS = -x=cu -std=c++11 -m64 -Xptxas=-v -lineinfo --expt-extended-lambda --restrict -Xcompiler -Wall $(NV_ARCH)
#NVCC_LIBS = -Wl,-rpath -Wl,$(CUDA_DIR)/lib64 -L$(CUDA_DIR)/lib64 \
            -lcuda -lcudart -lcudadevrt -lnvToolsExt -ldl

define ADV_HELP_MSG

Adv makefile targets:

   make
   make status/info
   make install
   make clean
   make distclean
   make style

Examples:

make -j 4
   Build Adv using the current configuration options from MFEM.
   (Adv requires the MFEM finite element library, and uses its compiler and
    linker options in its build process.)
make status
   Display information about the current configuration.
make install PREFIX=<dir>
   Install the Adv executable in <dir>.
make clean
   Clean the Adv executable, library and object files.
make distclean
   In addition to "make clean", remove the local installation directory and some
   run-time generated files.
make style
   Format the Adv C++ source files using the Artistic Style (astyle) settings
   from MFEM.

endef

# Default installation location
PREFIX = ./bin
INSTALL = /usr/bin/install

# Use the MFEM build directory
MFEM_DIR = ../..
CONFIG_MK = $(MFEM_DIR)/config/config.mk
TEST_MK = $(MFEM_DIR)/config/test.mk
# Use the MFEM install directory
# MFEM_DIR = ../mfem/mfem
# CONFIG_MK = $(MFEM_DIR)/config.mk
# TEST_MK = $(MFEM_DIR)/test.mk

# Use two relative paths to MFEM: first one for compilation in '.' and second
# one for compilation in 'lib'.
MFEM_DIR1 := $(MFEM_DIR)
MFEM_DIR2 := $(realpath $(MFEM_DIR))

# Use the compiler used by MFEM. Get the compiler and the options for compiling
# and linking from MFEM's config.mk. (Skip this if the target does not require
# building.)
MFEM_LIB_FILE = mfem_is_not_built
ifeq (,$(filter help clean distclean style,$(MAKECMDGOALS)))
   -include $(CONFIG_MK)
endif

CXX = nvcc
CPPFLAGS = $(MFEM_CPPFLAGS)
CXXFLAGS = $(MFEM_CXXFLAGS)

# MFEM config does not define C compiler
CC     = gcc
CFLAGS = -O3

# Optional link flags
LDFLAGS =

OPTIM_OPTS = -O3
DEBUG_OPTS = -g -Xcompiler -Wall #-Xcompiler -g -Xcompiler -Wall
ADV_DEBUG = $(MFEM_DEBUG) 
ifneq ($(ADV_DEBUG),$(MFEM_DEBUG))
   ifeq ($(ADV_DEBUG),YES)
      CXXFLAGS = $(DEBUG_OPTS)
   else
      CXXFLAGS = $(OPTIM_OPTS)
   endif
endif

CPPFLAGS += -g
ADV_FLAGS = $(CPPFLAGS) $(CXXFLAGS) $(MFEM_INCFLAGS) \
      $(MPI_INCFLAGS) $(NVCC_CXXFLAGS) $(NVCC_INCFLAGS)
ADV_LIBS = $(MFEM_LIBS) $(NVCC_LIBS)

ifeq ($(ADV_DEBUG),YES)
   ADV_FLAGS += -DADV_DEBUG
endif

#Add Lua related flags
#LUA = /g/g17/vargas45/lua-5.1.5
#ADV_FLAGS += -I$(LUA)/include
#ADV_LIBS += -L$(LUA)/lib -llua

#Add RAJA related flags
RAJA_DIR  = /usr/WS1/vargas45/Git-Repos/MFEM_BUILD/RAJA/build
ADV_FLAGS += -I$(RAJA_DIR)/include
ADV_LIBS  += $(RAJA_DIR)/lib/libRAJA.a


LIBS = $(strip $(ADV_LIBS) $(LDFLAGS))
CCC  = $(strip $(CXX) $(ADV_FLAGS))
Ccc  = $(strip $(CC) $(CFLAGS) $(GL_OPTS))

SOURCE_FILES = adv.cpp

OBJECT_FILES1 = $(SOURCE_FILES:.cpp=.o)
OBJECT_FILES = $(OBJECT_FILES1:.c=.o)
HEADER_FILES =

# Targets

.PHONY: all clean distclean install status info opt debug test style clean-build clean-exec

.SUFFIXES: .c .cpp .o
.cpp.o:
	cd $(<D); $(CCC) -c $(<F)
.c.o:
	cd $(<D); $(Ccc) -c $(<F)

adv: override MFEM_DIR = $(MFEM_DIR1)
adv:	$(OBJECT_FILES) $(CONFIG_MK) $(MFEM_LIB_FILE)
	$(MFEM_CXX) -o adv $(OBJECT_FILES) $(LIBS)

all: adv

opt:
	$(MAKE) "ADV_DEBUG=NO"

debug:
	$(MAKE) "ADV_DEBUG=YES"

$(OBJECT_FILES): override MFEM_DIR = $(MFEM_DIR2)
$(OBJECT_FILES): $(HEADER_FILES) $(CONFIG_MK)

#MFEM_TESTS = adv
#include $(TEST_MK)
# Testing: Specific execution options
#RUN_MPI = $(MFEM_MPIEXEC) $(MFEM_MPIEXEC_NP) 4
#test: adv
#	@$(call mfem-test,$<, $(RUN_MPI), Adv miniapp,\
#	-p 0 -m data/square01_quad.mesh -rs 3 -tf 0.1)
# Testing: "test" target and mfem-test* variables are defined in MFEM's
# config/test.mk

# Generate an error message if the MFEM library is not built and exit
$(CONFIG_MK) $(MFEM_LIB_FILE):
	$(error The MFEM library is not built)

clean: clean-build clean-exec

clean-build:
	rm -rf adv $(OBJECT_FILES) *~ *.dSYM
clean-exec:
	rm -rf ./results

distclean: clean
	rm -rf bin/

install: adv
	mkdir -p $(PREFIX)
	$(INSTALL) -m 750 adv $(PREFIX)

help:
	$(info $(value ADV_HELP_MSG))
	@true

status info:
	$(info MFEM_DIR    = $(MFEM_DIR))
	$(info ADV_FLAGS = $(ADV_FLAGS))
	$(info ADV_LIBS  = $(value ADV_LIBS))
	$(info PREFIX      = $(PREFIX))
	@true

ASTYLE = astyle --options=$(MFEM_DIR1)/config/mfem.astylerc
FORMAT_FILES := $(SOURCE_FILES) $(HEADER_FILES)

style:
	@if ! $(ASTYLE) $(FORMAT_FILES) | grep Formatted; then\
	   echo "No source files were changed.";\
	fi
