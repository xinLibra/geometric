@echo off
chcp 65001 >nul
echo ============================================
echo   锦地纹 LoRA v4 训练 (GPU: RTX 5060) - 两类
echo   数据: 22源图(hex 11 + floral 11) x repeats2 = 44图/epoch
echo   caption: 每类 40%%疏 / 50%%中 / 10%%密, 配色按图实际
echo   每epoch 44步, Epoch: 6, 总步数=264
echo   触发词: ichpattern_jindi_hex / ichpattern_jindi_floral
echo   配置: dim=16/alpha=8, lr=1.8e-5, bf16, sdpa, flip_aug, cosine
echo   保存: 每epoch 保存 checkpoint 和 state
echo ============================================
echo.

REM 创建输出目录
if not exist "C:\LoraTraining\geometric\output\jindi_v4\logs" mkdir "C:\LoraTraining\geometric\output\jindi_v4\logs"

cd /d C:\LoraTraining\kohya_ss\sd-scripts

REM 自动检测最新 state 目录用于断点续训
set RESUME_ARG=
for /f "delims=" %%d in ('dir /b /ad "C:\LoraTraining\geometric\output\jindi_v4\ICH_jindi_pattern_lora_v4-state-*" 2^>nul') do set "LAST_STATE=%%d"
if defined LAST_STATE (
    set "RESUME_ARG=--resume=C:\LoraTraining\geometric\output\jindi_v4\%LAST_STATE%"
    echo [恢复] 检测到上次训练状态: %LAST_STATE%
    echo [恢复] 将从断点继续训练...
) else (
    echo [新训] 未检测到历史状态，开始全新训练
)
echo.

C:\LoraTraining\kohya_ss\venv\Scripts\python.exe train_network.py --config_file="C:/LoraTraining/geometric/configs/jindi_v4_lora_config.toml" %RESUME_ARG%

echo.
echo ============================================
echo   锦地纹 v4 训练完成/中断！
echo   输出目录: C:\LoraTraining\geometric\output\jindi_v4
echo   预览图: C:\LoraTraining\geometric\output\jindi_v4\sample
echo ============================================
