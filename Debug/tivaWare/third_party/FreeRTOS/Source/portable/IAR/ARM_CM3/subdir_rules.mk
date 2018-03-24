################################################################################
# Automatically-generated file. Do not edit!
################################################################################

SHELL = cmd.exe

# Each subdirectory must supply rules for building sources it contributes
tivaWare/third_party/FreeRTOS/Source/portable/IAR/ARM_CM3/port.obj: ../tivaWare/third_party/FreeRTOS/Source/portable/IAR/ARM_CM3/port.c $(GEN_OPTS) | $(GEN_HDRS)
	@echo 'Building file: $<'
	@echo 'Invoking: ARM Compiler'
	"C:/ti/ccsv7/tools/compiler/ti-cgt-arm_16.9.6.LTS/bin/armcl" -mv7M4 --code_state=16 --float_support=FPv4SPD16 -me --include_path="C:/Users/Yigit/Desktop/workspace_v7/hapticPedal_tm4c124xl" --include_path="C:/Users/Yigit/Desktop/workspace_v7/hapticPedal_tm4c124xl/tivaWare/" --include_path="C:/ti/ccsv7/tools/compiler/ti-cgt-arm_16.9.6.LTS/include" --advice:power="12.1,12.2" --define=ccs="ccs" --define=TARGET_IS_TM4C129_RA2 --define=PART_TM4C1294NCPDT -g --gcc --diag_warning=225 --diag_wrap=off --display_error_number --abi=eabi --preproc_with_compile --preproc_dependency="tivaWare/third_party/FreeRTOS/Source/portable/IAR/ARM_CM3/port.d_raw" --obj_directory="tivaWare/third_party/FreeRTOS/Source/portable/IAR/ARM_CM3" $(GEN_OPTS__FLAG) "$<"
	@echo 'Finished building: $<'
	@echo ' '

tivaWare/third_party/FreeRTOS/Source/portable/IAR/ARM_CM3/portasm.obj: ../tivaWare/third_party/FreeRTOS/Source/portable/IAR/ARM_CM3/portasm.s $(GEN_OPTS) | $(GEN_HDRS)
	@echo 'Building file: $<'
	@echo 'Invoking: ARM Compiler'
	"C:/ti/ccsv7/tools/compiler/ti-cgt-arm_16.9.6.LTS/bin/armcl" -mv7M4 --code_state=16 --float_support=FPv4SPD16 -me --include_path="C:/Users/Yigit/Desktop/workspace_v7/hapticPedal_tm4c124xl" --include_path="C:/Users/Yigit/Desktop/workspace_v7/hapticPedal_tm4c124xl/tivaWare/" --include_path="C:/ti/ccsv7/tools/compiler/ti-cgt-arm_16.9.6.LTS/include" --advice:power="12.1,12.2" --define=ccs="ccs" --define=TARGET_IS_TM4C129_RA2 --define=PART_TM4C1294NCPDT -g --gcc --diag_warning=225 --diag_wrap=off --display_error_number --abi=eabi --preproc_with_compile --preproc_dependency="tivaWare/third_party/FreeRTOS/Source/portable/IAR/ARM_CM3/portasm.d_raw" --obj_directory="tivaWare/third_party/FreeRTOS/Source/portable/IAR/ARM_CM3" $(GEN_OPTS__FLAG) "$<"
	@echo 'Finished building: $<'
	@echo ' '


