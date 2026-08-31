@echo off
chcp 65001 >nul
echo ============================================
echo   方胜纹 两个独立 LoRA 顺序训练
echo   顺序: 1) 连续(结构难先验证菱格)  2) 单独
echo ============================================
echo.

echo [STEP 1/2] 训练连续 LoRA ...
call C:\LoraTraining\geometric\configs\train_fangsheng_continuous_v1.bat > C:\LoraTraining\geometric\output\fangsheng_continuous_v1\train.log 2>&1
echo [STEP 1/2] 连续 LoRA 完成，退出码 %errorlevel%
echo.

echo [STEP 2/2] 训练单独 LoRA ...
call C:\LoraTraining\geometric\configs\train_fangsheng_single_v1.bat > C:\LoraTraining\geometric\output\fangsheng_single_v1\train.log 2>&1
echo [STEP 2/2] 单独 LoRA 完成，退出码 %errorlevel%
echo.

echo ============================================
echo   全部训练结束！
echo   连续: geometric\output\fangsheng_continuous_v1
echo   单独: geometric\output\fangsheng_single_v1
echo ============================================
