################################################################################
# Automatically-generated file. Do not edit!
################################################################################

SHELL = cmd.exe

# Add inputs and outputs from these tool invocations to the build variables 
CMD_SRCS += \
../tivaWare/examples/boards/dk-tm4c129x/freertos_demo/freertos_demo_ccs.cmd 

S_UPPER_SRCS += \
../tivaWare/examples/boards/dk-tm4c129x/freertos_demo/startup_rvmdk.S 

LD_SRCS += \
../tivaWare/examples/boards/dk-tm4c129x/freertos_demo/freertos_demo.ld 

C_SRCS += \
../tivaWare/examples/boards/dk-tm4c129x/freertos_demo/cgifuncs.c \
../tivaWare/examples/boards/dk-tm4c129x/freertos_demo/display_task.c \
../tivaWare/examples/boards/dk-tm4c129x/freertos_demo/freertos_demo.c \
../tivaWare/examples/boards/dk-tm4c129x/freertos_demo/fs.c \
../tivaWare/examples/boards/dk-tm4c129x/freertos_demo/idle_task.c \
../tivaWare/examples/boards/dk-tm4c129x/freertos_demo/images.c \
../tivaWare/examples/boards/dk-tm4c129x/freertos_demo/led_task.c \
../tivaWare/examples/boards/dk-tm4c129x/freertos_demo/lwip_task.c \
../tivaWare/examples/boards/dk-tm4c129x/freertos_demo/random.c \
../tivaWare/examples/boards/dk-tm4c129x/freertos_demo/spider_task.c \
../tivaWare/examples/boards/dk-tm4c129x/freertos_demo/startup_ccs.c \
../tivaWare/examples/boards/dk-tm4c129x/freertos_demo/startup_ewarm.c \
../tivaWare/examples/boards/dk-tm4c129x/freertos_demo/startup_gcc.c 

C_DEPS += \
./tivaWare/examples/boards/dk-tm4c129x/freertos_demo/cgifuncs.d \
./tivaWare/examples/boards/dk-tm4c129x/freertos_demo/display_task.d \
./tivaWare/examples/boards/dk-tm4c129x/freertos_demo/freertos_demo.d \
./tivaWare/examples/boards/dk-tm4c129x/freertos_demo/fs.d \
./tivaWare/examples/boards/dk-tm4c129x/freertos_demo/idle_task.d \
./tivaWare/examples/boards/dk-tm4c129x/freertos_demo/images.d \
./tivaWare/examples/boards/dk-tm4c129x/freertos_demo/led_task.d \
./tivaWare/examples/boards/dk-tm4c129x/freertos_demo/lwip_task.d \
./tivaWare/examples/boards/dk-tm4c129x/freertos_demo/random.d \
./tivaWare/examples/boards/dk-tm4c129x/freertos_demo/spider_task.d \
./tivaWare/examples/boards/dk-tm4c129x/freertos_demo/startup_ccs.d \
./tivaWare/examples/boards/dk-tm4c129x/freertos_demo/startup_ewarm.d \
./tivaWare/examples/boards/dk-tm4c129x/freertos_demo/startup_gcc.d 

OBJS += \
./tivaWare/examples/boards/dk-tm4c129x/freertos_demo/cgifuncs.obj \
./tivaWare/examples/boards/dk-tm4c129x/freertos_demo/display_task.obj \
./tivaWare/examples/boards/dk-tm4c129x/freertos_demo/freertos_demo.obj \
./tivaWare/examples/boards/dk-tm4c129x/freertos_demo/fs.obj \
./tivaWare/examples/boards/dk-tm4c129x/freertos_demo/idle_task.obj \
./tivaWare/examples/boards/dk-tm4c129x/freertos_demo/images.obj \
./tivaWare/examples/boards/dk-tm4c129x/freertos_demo/led_task.obj \
./tivaWare/examples/boards/dk-tm4c129x/freertos_demo/lwip_task.obj \
./tivaWare/examples/boards/dk-tm4c129x/freertos_demo/random.obj \
./tivaWare/examples/boards/dk-tm4c129x/freertos_demo/spider_task.obj \
./tivaWare/examples/boards/dk-tm4c129x/freertos_demo/startup_ccs.obj \
./tivaWare/examples/boards/dk-tm4c129x/freertos_demo/startup_ewarm.obj \
./tivaWare/examples/boards/dk-tm4c129x/freertos_demo/startup_gcc.obj \
./tivaWare/examples/boards/dk-tm4c129x/freertos_demo/startup_rvmdk.obj 

S_UPPER_DEPS += \
./tivaWare/examples/boards/dk-tm4c129x/freertos_demo/startup_rvmdk.d 

S_UPPER_DEPS__QUOTED += \
"tivaWare\examples\boards\dk-tm4c129x\freertos_demo\startup_rvmdk.d" 

OBJS__QUOTED += \
"tivaWare\examples\boards\dk-tm4c129x\freertos_demo\cgifuncs.obj" \
"tivaWare\examples\boards\dk-tm4c129x\freertos_demo\display_task.obj" \
"tivaWare\examples\boards\dk-tm4c129x\freertos_demo\freertos_demo.obj" \
"tivaWare\examples\boards\dk-tm4c129x\freertos_demo\fs.obj" \
"tivaWare\examples\boards\dk-tm4c129x\freertos_demo\idle_task.obj" \
"tivaWare\examples\boards\dk-tm4c129x\freertos_demo\images.obj" \
"tivaWare\examples\boards\dk-tm4c129x\freertos_demo\led_task.obj" \
"tivaWare\examples\boards\dk-tm4c129x\freertos_demo\lwip_task.obj" \
"tivaWare\examples\boards\dk-tm4c129x\freertos_demo\random.obj" \
"tivaWare\examples\boards\dk-tm4c129x\freertos_demo\spider_task.obj" \
"tivaWare\examples\boards\dk-tm4c129x\freertos_demo\startup_ccs.obj" \
"tivaWare\examples\boards\dk-tm4c129x\freertos_demo\startup_ewarm.obj" \
"tivaWare\examples\boards\dk-tm4c129x\freertos_demo\startup_gcc.obj" \
"tivaWare\examples\boards\dk-tm4c129x\freertos_demo\startup_rvmdk.obj" 

C_DEPS__QUOTED += \
"tivaWare\examples\boards\dk-tm4c129x\freertos_demo\cgifuncs.d" \
"tivaWare\examples\boards\dk-tm4c129x\freertos_demo\display_task.d" \
"tivaWare\examples\boards\dk-tm4c129x\freertos_demo\freertos_demo.d" \
"tivaWare\examples\boards\dk-tm4c129x\freertos_demo\fs.d" \
"tivaWare\examples\boards\dk-tm4c129x\freertos_demo\idle_task.d" \
"tivaWare\examples\boards\dk-tm4c129x\freertos_demo\images.d" \
"tivaWare\examples\boards\dk-tm4c129x\freertos_demo\led_task.d" \
"tivaWare\examples\boards\dk-tm4c129x\freertos_demo\lwip_task.d" \
"tivaWare\examples\boards\dk-tm4c129x\freertos_demo\random.d" \
"tivaWare\examples\boards\dk-tm4c129x\freertos_demo\spider_task.d" \
"tivaWare\examples\boards\dk-tm4c129x\freertos_demo\startup_ccs.d" \
"tivaWare\examples\boards\dk-tm4c129x\freertos_demo\startup_ewarm.d" \
"tivaWare\examples\boards\dk-tm4c129x\freertos_demo\startup_gcc.d" 

C_SRCS__QUOTED += \
"../tivaWare/examples/boards/dk-tm4c129x/freertos_demo/cgifuncs.c" \
"../tivaWare/examples/boards/dk-tm4c129x/freertos_demo/display_task.c" \
"../tivaWare/examples/boards/dk-tm4c129x/freertos_demo/freertos_demo.c" \
"../tivaWare/examples/boards/dk-tm4c129x/freertos_demo/fs.c" \
"../tivaWare/examples/boards/dk-tm4c129x/freertos_demo/idle_task.c" \
"../tivaWare/examples/boards/dk-tm4c129x/freertos_demo/images.c" \
"../tivaWare/examples/boards/dk-tm4c129x/freertos_demo/led_task.c" \
"../tivaWare/examples/boards/dk-tm4c129x/freertos_demo/lwip_task.c" \
"../tivaWare/examples/boards/dk-tm4c129x/freertos_demo/random.c" \
"../tivaWare/examples/boards/dk-tm4c129x/freertos_demo/spider_task.c" \
"../tivaWare/examples/boards/dk-tm4c129x/freertos_demo/startup_ccs.c" \
"../tivaWare/examples/boards/dk-tm4c129x/freertos_demo/startup_ewarm.c" \
"../tivaWare/examples/boards/dk-tm4c129x/freertos_demo/startup_gcc.c" 

S_UPPER_SRCS__QUOTED += \
"../tivaWare/examples/boards/dk-tm4c129x/freertos_demo/startup_rvmdk.S" 


