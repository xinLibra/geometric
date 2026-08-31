@echo off
chcp 65001 >nul
echo ============================================
echo   锦地纹 LoRA v2 训练 (GPU: RTX 5060)
echo   数据: 58源图(4类结构) x repeats2 = 116图/epoch
echo   2_jindi_huiwen(15) + 2_jindi_hex(13,含6生成) + 2_jindi_diamond(15,含6生成) + 2_jindi_coin(15)
echo   每epoch 116步, Epoch: 8, 总步数=928
echo   触发词: ichpattern_jindi_huiwen / _hex / _diamond / _coin
echo   配置: dim=16/alpha=8, lr=2.5e-5, bf16, sdpa, flip_aug
echo   保存: 每100步 + 每epoch 保存 checkpoint 和 state
echo ============================================
echo.

REM 创建输出目录
if not exist "C:\LoraTraining\geometric\output\jindi_v2\logs" mkdir "C:\LoraTraining\geometric\output\jindi_v2\logs"

cd /d C:\LoraTraining\kohya_ss\sd-scripts

REM 自动检测最新 state 目录用于断点续训
set RESUME_ARG=
for /f "delims=" %%d in ('dir /b /ad "C:\LoraTraining\geometric\output\jindi_v2\ICH_jindi_pattern_lora_v2-state-*" 2^>nul') do set "LAST_STATE=%%d"
if defined LAST_STATE (
    set "RESUME_ARG=--resume=C:\LoraTraining\geometric\output\jindi_v2\%LAST_STATE%"
    echo [恢复] 检测到上次训练状态: %LAST_STATE%
    echo [恢复] 将从断点继续训练...
) else (
    echo [新训] 未检测到历史状态，开始全新训练
)
echo.

C:\LoraTraining\kohya_ss\venv\Scripts\python.exe train_network.py --config_file="C:/LoraTraining/geometric/configs/jindi_v2_lora_config.toml" %RESUME_ARG%

echo.
echo ============================================
echo   锦地纹 v2 训练完成/中断！
echo   输出目录: C:\LoraTraining\geometric\output\jindi_v2
echo   预览图: C:\LoraTraining\geometric\output\jindi_v2\sample
echo ============================================
