# canonical Makefile for smala applications
# 1. copy stand_alone directory somwhere: cp -r cookbook/stand_alone /some/where/else
# 2. edit configuration part (executable name, srcs, djnn_libs, path to djnn-cpp and smalac)
# 3. make test

redirect: default
.PHONY: redirect

#--
# configuration

#relative path
src_dir := src
build_dir := build
smala_lib_dir := $(build_dir)/lib
res_dir := res
exe_dir := .

# cpp example
exe := map

srcs_sma :=	src/Slider.sma \
			src/Map/widgets/Menu.sma \
			src/Map/widgets/DronePatatoidal.sma \
			src/Map/Communications/IvyComms.sma \
			src/Map/utils/tile/ParserMapPath.sma src/Map/utils/tile/Coords2Tile.sma src/Map/utils/tile/Tile2Coords.sma src/Map/utils/computation/DistanceGps.sma src/Map/utils/computation/TrajectoryDistanceGps.sma src/Map/utils/computation/TravelTimeGps.sma src/Map/utils/computation/TrajectoryTravelTimeGps.sma src/Map/utils/computation/BearingGps.sma src/Map/utils/computation/TrajectoryBearingGps.sma src/Map/utils/conversion/Gps2Screen.sma src/Map/utils/conversion/Screen2Gps.sma \
			src/Map/models/point/PointGps.sma src/Map/models/area/AreaPoints.sma src/Map/models/area/AreaAround.sma src/Map/models/area/MapArea.sma src/Map/models/object/MobileObject.sma src/Map/models/object/FixedObject.sma src/Map/models/object/FixedPoint.sma  src/Map/models/object/MyPlaneLabelObject.sma src/Map/models/object/MyPlaneObject.sma src/Map/models/object/MyCircleGraph.sma src/Map/models/trajectory/TrajectoryStep.sma src/Map/models/trajectory/TrajectorySteps.sma src/Map/models/trajectory/MapTrajectoryDraw.sma src/Map/models/trajectory/MapJourney.sma src/Map/models/trajectory/engine/ManualMovement.sma src/Map/models/trajectory/engine/FixedTimerMovement.sma src/Map/models/trajectory/engine/SpeedTimerMovement.sma src/Map/models/trajectory/engine/TimedMovement.sma src/Map/models/trajectory/PolygonAround.sma\
			src/Map/models/profile/MyFlightProfile.sma src/Map/models/trajectory/DynamicJourney.sma src/Map/models/trajectory/MapTrajectory.sma src/Map/models/stream/SimuStream.sma src/Map/models/stream/InteractionStream.sma src/Map/models/stream/RejeuStream.sma src/Map/models/trajectory/RejeuTrajectories.sma\
			src/Map/widgets/Button.sma src/Map/widgets/Drone.sma src/Map/widgets/Block.sma src/Map/widgets/FlightPlan.sma src/Map/widgets/ConstraintBox.sma src/Map/widgets/MapController.sma src/Map/widgets/AccelerationTimeWidget.sma \
			src/Map/kernel/Tile.sma src/Map/kernel/PanAndZoom.sma \
			src/Map/utils/sketching/MyCircle.sma src/Map/utils/sketching/NewRectHandler.sma src/Map/utils/sketching/NewCircHandler.sma src/Map/utils/sketching/MyRectangle.sma \
			src/Map/widgets/Link.sma \
			src/Map/widgets/GridPannel.sma\
			src/cookbook/MarkerAdd.sma \
			src/Map/Map.sma \
			src/Map/widgets/PanAndZoomWidget.sma \
			src/Map/widgets/MapVoliere.sma \
			src/testPannel/TestPannel.sma \
			src/Map/widgets/ControlPannel.sma \
			src/main.sma
# srcs_sma := $(shell find $(src_dir) -name "*.sma")
# srcs_other :=
srcs_other := $(shell find $(src_dir) -name "*.cpp")



#---- new system -- 
# 	- make install in djnn-cpp and smala
#   - or with package system : brew, apt, pacman ... 

# # djnn devel
# djnn_pkgconf = djnn-cpp-dev
# # djnn install (github)
# #djnn_pkgconf = djnn-cpp
# djnn_cflags := $(shell pkg-config $(djnn_pkgconf) --cflags)
# djnn_ldflags := $(shell pkg-config $(djnn_pkgconf) --libs)
# djnn_lib_path := $(shell pkg-config $(djnn_pkgconf) --libs-only-L)
# djnn_lib_path := $(subst -L, , $(djnn_lib_path))

# # smala devel
# smala_pkgconf = smala-dev
# smalac := ../smala/build/smalac
# # smala install (github)
# #smala_pkgconf = smala
# #smalac := "should be in /usr/(local)/bin"
# smala_cflags := $(shell pkg-config $(smala_pkgconf) --cflags)
# smala_ldflags := $(shell pkg-config $(smala_pkgconf) --libs)
# smala_lib_path := $(shell pkg-config $(smala_pkgconf) --libs-only-L)
# smala_lib_path := $(subst -L, , $(smala_lib_path))

#---- old system or in cookbook

# in cookbook
#djnn_cpp_path := ../../../djnn-cpp

#------ OLD VERSION OF GCC OR OSX --------#
#if mac mojave (possibly under use libboost for filesystem instead of fs) use #-lboost_filesystem
#if linux gcc under v 9.0 use -lstdc++fs
#------ OLD VERSION OF GCC OR OSX --------#

# standalone
djnn_cpp_path := ../djnn-cpp
djnn_cflags := -I$(djnn_cpp_path)/src -I$(djnn_cpp_path)/src -I../../build/lib
djnn_ldflags := -L$(djnn_cpp_path)/build/lib -ldjnn-core -ldjnn-base -ldjnn-animation -ldjnn-audio \
				-ldjnn-comms -ldjnn-display -ldjnn-exec_env -ldjnn-files -ldjnn-gui \
				-ldjnn-input -ldjnn-utils -lcurl #-lstdc++fs # add later if linux
djnn_lib_path := $(djnn_cpp_path)/build/lib

# in cookbook
#smala_path := ../..
# standalone
smala_path := ../smala
smalac := $(smala_path)/build/smalac
smala_cflags := -I$(smala_path)/build/src_lib
#smala_ldflags := -L$(smala_path)/build/lib -lsmala
smala_lib_path := $(smala_path)/build/lib

# for emscripten
em_ext_libs_path := ../../../djnn-emscripten-ext-libs

#CXXFLAGS += -fsanitize=thread -O1
#LDFLAGS += -fsanitize=thread

#CFLAGS += -fsanitize=address -O1
#LDFLAGS += -fsanitize=address

#CFLAGS += -fsanitize=memory -O1
#LDFLAGS += -fsanitize=memory

# -------------------------------------------------------------------
# hopefully no need to tweak the lines below

# remove builtin rules: speed up build process and help debug
MAKEFLAGS += --no-builtin-rules
.SUFFIXES:

ifndef os
os := $(shell uname -s)

ifeq ($(findstring MINGW,$(os)),MINGW)
os := MinGW
endif
endif

ifeq ($(os),Linux)
djnn_ldflags += -lstdc++fs
endif

# cross-compile support
ifndef cross_prefix
cross_prefix :=
#cross_prefix := g
#cross_prefix := em
#options: g llvm-g i686-w64-mingw32- arm-none-eabi- em
#/Applications/Arduino.app/Contents/Java/hardware/tools/avr/bin/avr-c
#/usr/local/Cellar/android-ndk/r14/toolchains/arm-linux-androideabi-4.9/prebuilt/darwin-x86_64/bin/arm-linux-androideabi-g
endif

#CC := $(cross_prefix)cc
#CXX := $(cross_prefix)++

ifeq ($(cross_prefix),em)
os := em
EXE := .html
launch_cmd := emrun

EMFLAGS := -Wall -Wno-unused-variable -Oz \
-s USE_BOOST_HEADERS -s USE_SDL=2 -s USE_SDL_IMAGE=2 -s USE_FREETYPE=1 -s USE_WEBGL2=1 \
-DSDL_DISABLE_IMMINTRIN_H \
-s EXPORT_ALL=1 -s DISABLE_EXCEPTION_CATCHING=0 \
-s DISABLE_DEPRECATED_FIND_EVENT_TARGET_BEHAVIOR=1 \
-s ASSERTIONS=2 \
-s ERROR_ON_UNDEFINED_SYMBOLS=0

em_ext_libs_path ?= ../djnn-emscripten-ext-libs

#idn2 expat curl fontconfig unistring psl 
ext_libs := expat curl
ext_libs := $(addprefix $(em_ext_libs_path)/lib/lib,$(addsuffix .a, $(ext_libs))) -lopenal

EMCFLAGS += $(EMFLAGS) -I$(em_ext_libs_path)/include -I/usr/local/include #glm
CFLAGS += $(EMCFLAGS)
CXXFLAGS += $(EMCFLAGS)
LDFLAGS += $(EMFLAGS) \
	$(ext_libs) \
	--emrun \
	--preload-file $(res_dir)@$(res_dir) \
	--preload-file /Library/Fonts/Arial.ttf@/usr/share/fonts/Arial.ttf

endif

CXXFLAGS += -MMD -g -std=c++17

ifeq ($(os),Linux)
LD_LIBRARY_PATH=LD_LIBRARY_PATH
debugger := gdb
endif

ifeq ($(os),Darwin)
LD_LIBRARY_PATH=DYLD_LIBRARY_PATH
# https://stackoverflow.com/a/33589760
debugger := PATH=/usr/bin /Applications/Xcode.app/Contents/Developer/usr/bin/lldb
endif

ifeq ($(os),MinGW)
LD_LIBRARY_PATH=PATH
debugger := gdb
endif

ifeq ($(os),em)
LD_LIBRARY_PATH=LD_LIBRARY_PATH
debugger := gdb
EXE := .html
endif

exe := $(exe)$(EXE)
exe := $(build_dir)/$(exe)

default: $(exe)
.PHONY: default

test: $(exe)
	(cd $(exe_dir); env $(LD_LIBRARY_PATH)="$(abspath $(djnn_lib_path))":"$(abspath $(smala_lib_path))":$$$(LD_LIBRARY_PATH) $(launch_cmd) "$(shell pwd)/$(exe)")
dbg: $(exe)
	(cd $(exe_dir); env $(LD_LIBRARY_PATH)="$(abspath $(djnn_lib_path))":"$(abspath $(smala_lib_path))":$$$(LD_LIBRARY_PATH) $(debugger) "$(shell pwd)/$(exe)")
.PHONY: test

LD  = $(CXX)

objs_sma := $(srcs_sma:.sma=.o)
objs_sma := $(addprefix $(build_dir)/,$(objs_sma))
objs_other := $(srcs_other:.cpp=.o)
objs_other := $(addprefix $(build_dir)/,$(objs_other))

objs := $(objs_sma) $(objs_other)

gensrcs := $(objs_sma:.o=.cpp)
#$(objs_sma): $(gensrcs) # this forces the right language to compile the generated sources, but it will rebuild all sma files


ifeq ($(cross_prefix),em)
app_libs := $(addsuffix .bc,$(addprefix $(djnn_lib_path)/libdjnn-,$(djnn_libs)))
else
app_libs := $(addprefix -ldjnn-,$(djnn_libs))
endif


$(objs): CXXFLAGS += $(djnn_cflags) $(smala_cflags) -I$(src_dir) -I$(build_dir)/$(src_dir) -I$(build_dir)/lib
$(exe): LDFLAGS += $(djnn_ldflags) $(smala_ldflags)
$(exe): LIBS += $(app_libs)

$(exe): $(objs)
	@mkdir -p $(dir $@)
	$(LD) $^ -o $@ $(LDFLAGS) $(LIBS)

# .sma to .cpp, .c etc
$(build_dir)/%.cpp $(build_dir)/%.h: %.sma
	@mkdir -p $(dir $@)
	@echo smalac $<
	@$(smalac) -cpp $<
	@mv $*.cpp $(build_dir)/$(*D)
	@if [ -f $*.h ]; then mv $*.h $(build_dir)/$(*D); fi;

#@if [ -f $*.h ] && ! cmp -s $*.h $(build_dir)/$*.h; then mv $*.h $(build_dir)/$(*D); fi;

# from .c user sources
$(build_dir)/%.o: %.c
	@mkdir -p $(dir $@)
	$(CC) $(CFLAGS) -c $< -o $@

# from .cpp user sources
$(build_dir)/%.o: %.cpp
	@mkdir -p $(dir $@)
	$(CXX) $(CXXFLAGS) -c $< -o $@

# for .c generated sources
$(build_dir)/%.o: $(build_dir)/%.c
	@mkdir -p $(dir $@)
	$(CC) $(CFLAGS) -c $< -o $@

# for .cpp generated sources
$(build_dir)/%.o: $(build_dir)/%.cpp
	@mkdir -p $(dir $@)
	$(CXX) $(CXXFLAGS) -c $< -o $@


# deps := $(objs:.o=.d)
# -include $(deps)

# --

distclean clear:
	rm -rf build
clean:
	rm -f $(gensrcs) $(objs) $(deps)
.PHONY: clean clear distclean

foo:
	echo $(objs_other)

