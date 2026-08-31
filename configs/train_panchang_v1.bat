@echo off
chcp 65001 >nul
echo ============================================
echo   盘长纹 LoRA v1 训练 (GPU: RTX 5060)
echo   数据: 66源图 -> 132训练图
echo   3_panchang_photo(20源图, repeats=3) + 1_panchang_schematic(46源图)
echo   每epoch 212步, Epoch: 8, 总步数=1696
echo   触发词: ichpattern_panchang
echo   配置: dim=16/alpha=8, lr=2.5e-5, bf16, sdpa
echo   保存: 每100步 + 每epoch 保存 checkpoint 和 state
echo ============================================
echo.

REM 创建输出目录
if not exist "C:\LoraTraining\geometric\output\panchang_v1\logs" mkdir "C:\LoraTraining\geometric\output\panchang_v1\logs"

cd /d C:\LoraTraining\kohya_ss\sd-scripts

REM 自动检测最新 state 目录用于断点续训
set RESUME_ARG=
for /f "delims=" %%d in ('dir /b /ad "C:\LoraTraining\geometric\output\panchang_v1\ICH_panchang_pattern_lora_v1-state-*" 2^>nul') do set "LAST_STATE=%%d"
if defined LAST_STATE (
    set "RESUME_ARG=--resume=C:\LoraTraining\geometric\output\panchang_v1\%LAST_STATE%"
    echo [恢复] 检测到上次训练状态: %LAST_STATE%
    echo [恢复] 将从断点继续训练...
) else (
    echo [新训] 未检测到历史状态，开始全新训练
)
echo.

C:\LoraTraining\kohya_ss\venv\Scripts\python.exe train_network.py --config_file="C:/LoraTraining/geometric/configs/panchang_lora_config_v1.toml" %RESUME_ARG%

echo.
echo ============================================
echo   盘长纹 v1 训练完成/中断！
echo   输出目录: C:\LoraTraining\geometric\output\panchang_v1
echo   预览图: C:\LoraTraining\geometric\output\panchang_v1\sample
echo ============================================
