@echo off
chcp 65001 >nul
echo ============================================
echo   回纹 LoRA v3 训练 (开窗/边框优先)
echo   数据: 36源图精选 -> 72张训练图
echo   4_huiwen_border(22×flip, repeats=4) + 3_huiwen_band(8×flip) + 3_huiwen_aux(6×flip)
echo   每epoch 260步, Epoch: 5, 总步数=1300
echo   触发词: ichpattern_huiwen
echo   配置: dim=16/alpha=8, lr=3e-5, bf16, sdpa
echo   保存: 每epoch 保存 checkpoint 和 state
echo ============================================
echo.

REM 创建输出目录
if not exist "C:\LoraTraining\geometric\output\huiwen_v3\logs" mkdir "C:\LoraTraining\geometric\output\huiwen_v3\logs"

cd /d C:\LoraTraining\kohya_ss\sd-scripts

REM 自动检测最新 state 目录用于断点续训
set RESUME_ARG=
for /f "delims=" %%d in ('dir /b /ad "C:\LoraTraining\geometric\output\huiwen_v3\ICH_huiwen_pattern_lora_v3-state-*" 2^>nul') do set "LAST_STATE=%%d"
if defined LAST_STATE (
    set "RESUME_ARG=--resume=C:\LoraTraining\geometric\output\huiwen_v3\%LAST_STATE%"
    echo [恢复] 检测到上次训练状态: %LAST_STATE%
    echo [恢复] 将从断点继续训练...
) else (
    echo [新训] 未检测到历史状态，开始全新训练
)
echo.

C:\LoraTraining\kohya_ss\venv\Scripts\python.exe train_network.py --config_file="C:/LoraTraining/geometric/configs/huiwen_lora_config_v3.toml" %RESUME_ARG%

echo.
echo ============================================
echo   v3 训练完成/中断！
echo   输出目录: C:\LoraTraining\geometric\output\huiwen_v3
echo   预览图: C:\LoraTraining\geometric\output\huiwen_v3\sample
echo ============================================
