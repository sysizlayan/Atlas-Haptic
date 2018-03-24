################################################################################
# Automatically-generated file. Do not edit!
################################################################################

SHELL = cmd.exe

# Each subdirectory must supply rules for building sources it contributes
tivaWare/examples/boards/ek-tm4c1294xl/usb_dev_keyboard/startup_ccs.obj: ../tivaWare/examples/boards/ek-tm4c1294xl/usb_dev_keyboard/startup_ccs.c $(GEN_OPTS) | $(GEN_HDRS)
	@echo 'Building file: $<'
	@echo 'Invoking: ARM Compiler'
	"C:/ti/ccsv7/tools/compiler/ti-cgt-arm_16.9.6.LTS/bin/armcl" -mv7M4 --code_state=16 --float_support=FPv4SPD16 -me --include_path="C:/Users/Yigit/Desktop/workspace_v7/hapticPedal_tm4c124xl" --include_path="C:/Users/Yigit/Desktop/workspace_v7/hapticPedal_tm4c124xl/tivaWare/" --include_path="C:/ti/ccsv7/tools/compiler/ti-cgt-arm_16.9.6.LTS/include" --advice:power="12.1,12.2" --define=ccs="ccs" --define=TARGET_IS_TM4C129_RA2 --define=PART_TM4C1294NCPDT -g --gcc --diag_warning=225 --diag_wrap=off --display_error_number --abi=eabi --preproc_with_compile --preproc_dependency="tivaWare/examples/boards/ek-tm4c1294xl/usb_dev_keyboard/startup_ccs.d_raw" --obj_directory="tivaWare/examples/boards/ek-tm4c1294xl/usb_dev_keyboard" $(GEN_OPTS__FLAG) "$<"
	@echo 'Finished building: $<'
	@echo ' '

tivaWare/examples/boards/ek-tm4c1294xl/usb_dev_keyboard/startup_ewarm.obj: ../tivaWare/examples/boards/ek-tm4c1294xl/usb_dev_keyboard/startup_ewarm.c $(GEN_OPTS) | $(GEN_HDRS)
	@echo 'Building file: $<'
	@echo 'Invoking: ARM Compiler'
	"C:/ti/ccsv7/tools/compiler/ti-cgt-arm_16.9.6.LTS/bin/armcl" -mv7M4 --code_state=16 --float_support=FPv4SPD16 -me --include_path="C:/Users/Yigit/Desktop/workspace_v7/hapticPedal_tm4c124xl" --include_path="C:/Users/Yigit/Desktop/workspace_v7/hapticPedal_tm4c124xl/tivaWare/" --include_path="C:/ti/ccsv7/tools/compiler/ti-cgt-arm_16.9.6.LTS/include" --advice:power="12.1,12.2" --define=ccs="ccs" --define=TARGET_IS_TM4C129_RA2 --define=PART_TM4C1294NCPDT -g --gcc --diag_warning=225 --diag_wrap=off --display_error_number --abi=eabi --preproc_with_compile --preproc_dependency="tivaWare/examples/boards/ek-tm4c1294xl/usb_dev_keyboard/startup_ewarm.d_raw" --obj_directory="tivaWare/examples/boards/ek-tm4c1294xl/usb_dev_keyboard" $(GEN_OPTS__FLAG) "$<"
	@echo 'Finished building: $<'
	@echo ' '

tivaWare/examples/boards/ek-tm4c1294xl/usb_dev_keyboard/startup_gcc.obj: ../tivaWare/examples/boards/ek-tm4c1294xl/usb_dev_keyboard/startup_gcc.c $(GEN_OPTS) | $(GEN_HDRS)
	@echo 'Building file: $<'
	@echo 'Invoking: ARM Compiler'
	"C:/ti/ccsv7/tools/compiler/ti-cgt-arm_16.9.6.LTS/bin/armcl" -mv7M4 --code_state=16 --float_support=FPv4SPD16 -me --include_path="C:/Users/Yigit/Desktop/workspace_v7/hapticPedal_tm4c124xl" --include_path="C:/Users/Yigit/Desktop/workspace_v7/hapticPedal_tm4c124xl/tivaWare/" --include_path="C:/ti/ccsv7/tools/compiler/ti-cgt-arm_16.9.6.LTS/include" --advice:power="12.1,12.2" --define=ccs="ccs" --define=TARGET_IS_TM4C129_RA2 --define=PART_TM4C1294NCPDT -g --gcc --diag_warning=225 --diag_wrap=off --display_error_number --abi=eabi --preproc_with_compile --preproc_dependency="tivaWare/examples/boards/ek-tm4c1294xl/usb_dev_keyboard/startup_gcc.d_raw" --obj_directory="tivaWare/examples/boards/ek-tm4c1294xl/usb_dev_keyboard" $(GEN_OPTS__FLAG) "$<"
	@echo 'Finished building: $<'
	@echo ' '

tivaWare/examples/boards/ek-tm4c1294xl/usb_dev_keyboard/startup_rvmdk.obj: ../tivaWare/examples/boards/ek-tm4c1294xl/usb_dev_keyboard/startup_rvmdk.S $(GEN_OPTS) | $(GEN_HDRS)
	@echo 'Building file: $<'
	@echo 'Invoking: ARM Compiler'
	"C:/ti/ccsv7/tools/compiler/ti-cgt-arm_16.9.6.LTS/bin/armcl" -mv7M4 --code_state=16 --float_support=FPv4SPD16 -me --include_path="C:/Users/Yigit/Desktop/workspace_v7/hapticPedal_tm4c124xl" --include_path="C:/Users/Yigit/Desktop/workspace_v7/hapticPedal_tm4c124xl/tivaWare/" --include_path="C:/ti/ccsv7/tools/compiler/ti-cgt-arm_16.9.6.LTS/include" --advice:power="12.1,12.2" --define=ccs="ccs" --define=TARGET_IS_TM4C129_RA2 --define=PART_TM4C1294NCPDT -g --gcc --diag_warning=225 --diag_wrap=off --display_error_number --abi=eabi --preproc_with_compile --preproc_dependency="tivaWare/examples/boards/ek-tm4c1294xl/usb_dev_keyboard/startup_rvmdk.d_raw" --obj_directory="tivaWare/examples/boards/ek-tm4c1294xl/usb_dev_keyboard" $(GEN_OPTS__FLAG) "$<"
	@echo 'Finished building: $<'
	@echo ' '

tivaWare/examples/boards/ek-tm4c1294xl/usb_dev_keyboard/usb_dev_keyboard.obj: ../tivaWare/examples/boards/ek-tm4c1294xl/usb_dev_keyboard/usb_dev_keyboard.c $(GEN_OPTS) | $(GEN_HDRS)
	@echo 'Building file: $<'
	@echo 'Invoking: ARM Compiler'
	"C:/ti/ccsv7/tools/compiler/ti-cgt-arm_16.9.6.LTS/bin/armcl" -mv7M4 --code_state=16 --float_support=FPv4SPD16 -me --include_path="C:/Users/Yigit/Desktop/workspace_v7/hapticPedal_tm4c124xl" --include_path="C:/Users/Yigit/Desktop/workspace_v7/hapticPedal_tm4c124xl/tivaWare/" --include_path="C:/ti/ccsv7/tools/compiler/ti-cgt-arm_16.9.6.LTS/include" --advice:power="12.1,12.2" --define=ccs="ccs" --define=TARGET_IS_TM4C129_RA2 --define=PART_TM4C1294NCPDT -g --gcc --diag_warning=225 --diag_wrap=off --display_error_number --abi=eabi --preproc_with_compile --preproc_dependency="tivaWare/examples/boards/ek-tm4c1294xl/usb_dev_keyboard/usb_dev_keyboard.d_raw" --obj_directory="tivaWare/examples/boards/ek-tm4c1294xl/usb_dev_keyboard" $(GEN_OPTS__FLAG) "$<"
	@echo 'Finished building: $<'
	@echo ' '

tivaWare/examples/boards/ek-tm4c1294xl/usb_dev_keyboard/usb_keyb_structs.obj: ../tivaWare/examples/boards/ek-tm4c1294xl/usb_dev_keyboard/usb_keyb_structs.c $(GEN_OPTS) | $(GEN_HDRS)
	@echo 'Building file: $<'
	@echo 'Invoking: ARM Compiler'
	"C:/ti/ccsv7/tools/compiler/ti-cgt-arm_16.9.6.LTS/bin/armcl" -mv7M4 --code_state=16 --float_support=FPv4SPD16 -me --include_path="C:/Users/Yigit/Desktop/workspace_v7/hapticPedal_tm4c124xl" --include_path="C:/Users/Yigit/Desktop/workspace_v7/hapticPedal_tm4c124xl/tivaWare/" --include_path="C:/ti/ccsv7/tools/compiler/ti-cgt-arm_16.9.6.LTS/include" --advice:power="12.1,12.2" --define=ccs="ccs" --define=TARGET_IS_TM4C129_RA2 --define=PART_TM4C1294NCPDT -g --gcc --diag_warning=225 --diag_wrap=off --display_error_number --abi=eabi --preproc_with_compile --preproc_dependency="tivaWare/examples/boards/ek-tm4c1294xl/usb_dev_keyboard/usb_keyb_structs.d_raw" --obj_directory="tivaWare/examples/boards/ek-tm4c1294xl/usb_dev_keyboard" $(GEN_OPTS__FLAG) "$<"
	@echo 'Finished building: $<'
	@echo ' '


