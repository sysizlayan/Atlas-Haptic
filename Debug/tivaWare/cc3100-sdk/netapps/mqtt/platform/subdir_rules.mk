################################################################################
# Automatically-generated file. Do not edit!
################################################################################

SHELL = cmd.exe

# Each subdirectory must supply rules for building sources it contributes
tivaWare/cc3100-sdk/netapps/mqtt/platform/cc31xx_sl_net.obj: ../tivaWare/cc3100-sdk/netapps/mqtt/platform/cc31xx_sl_net.c $(GEN_OPTS) | $(GEN_HDRS)
	@echo 'Building file: $<'
	@echo 'Invoking: ARM Compiler'
	"C:/ti/ccsv7/tools/compiler/ti-cgt-arm_16.9.6.LTS/bin/armcl" -mv7M4 --code_state=16 --float_support=FPv4SPD16 -me --include_path="C:/Users/Yigit/Desktop/workspace_v7/hapticPedal_tm4c124xl" --include_path="C:/Users/Yigit/Desktop/workspace_v7/hapticPedal_tm4c124xl/tivaWare/" --include_path="C:/ti/ccsv7/tools/compiler/ti-cgt-arm_16.9.6.LTS/include" --advice:power="12.1,12.2" --define=ccs="ccs" --define=TARGET_IS_TM4C129_RA2 --define=PART_TM4C1294NCPDT -g --gcc --diag_warning=225 --diag_wrap=off --display_error_number --abi=eabi --preproc_with_compile --preproc_dependency="tivaWare/cc3100-sdk/netapps/mqtt/platform/cc31xx_sl_net.d_raw" --obj_directory="tivaWare/cc3100-sdk/netapps/mqtt/platform" $(GEN_OPTS__FLAG) "$<"
	@echo 'Finished building: $<'
	@echo ' '

tivaWare/cc3100-sdk/netapps/mqtt/platform/cc3200_platform.obj: ../tivaWare/cc3100-sdk/netapps/mqtt/platform/cc3200_platform.c $(GEN_OPTS) | $(GEN_HDRS)
	@echo 'Building file: $<'
	@echo 'Invoking: ARM Compiler'
	"C:/ti/ccsv7/tools/compiler/ti-cgt-arm_16.9.6.LTS/bin/armcl" -mv7M4 --code_state=16 --float_support=FPv4SPD16 -me --include_path="C:/Users/Yigit/Desktop/workspace_v7/hapticPedal_tm4c124xl" --include_path="C:/Users/Yigit/Desktop/workspace_v7/hapticPedal_tm4c124xl/tivaWare/" --include_path="C:/ti/ccsv7/tools/compiler/ti-cgt-arm_16.9.6.LTS/include" --advice:power="12.1,12.2" --define=ccs="ccs" --define=TARGET_IS_TM4C129_RA2 --define=PART_TM4C1294NCPDT -g --gcc --diag_warning=225 --diag_wrap=off --display_error_number --abi=eabi --preproc_with_compile --preproc_dependency="tivaWare/cc3100-sdk/netapps/mqtt/platform/cc3200_platform.d_raw" --obj_directory="tivaWare/cc3100-sdk/netapps/mqtt/platform" $(GEN_OPTS__FLAG) "$<"
	@echo 'Finished building: $<'
	@echo ' '


