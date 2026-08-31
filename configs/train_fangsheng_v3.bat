@echo off
chcp 65001 >nul
echo ============================================
echo   方胜纹 LoRA v3 训练 (GPU: RTX 5060) - 单独/连续 两类
echo   数据: 34源图(single 26 + continuous 8)
echo         single x repeats2 = 52, continuous x repeats3 = 24
echo   每epoch 76步, Epoch: 8, 总步数=608
echo   触发词: ichpattern_fangsheng_single / ichpattern_fangsheng_continuous
echo   配置: dim=16/alpha=8, lr=2e-5, bf16, sdpa, flip_aug, cosine
echo   保存: 每epoch 保存 checkpoint 和 state
echo ============================================
echo.

REM 创建输出目录
if not exist "C:\LoraTraining\geometric\output\fangsheng_v3\logs" mkdir "C:\LoraTraining\geometric\output\fangsheng_v3\logs"

cd /d C:\LoraTraining\kohya_ss\sd-scripts

REM 自动检测最新 state 目录用于断点续训
set RESUME_ARG=
for /f "delims=" %%d in ('dir /b /ad "C:\LoraTraining\geometric\output\fangsheng_v3\ICH_fangsheng_pattern_lora_v3-state-*" 2^>nul') do set "LAST_STATE=%%d"
if defined LAST_STATE (
    set "RESUME_ARG=--resume=C:\LoraTraining\geometric\output\fangsheng_v3\%LAST_STATE%"
    echo [恢复] 检测到上次训练状态: %LAST_STATE%
    echo [恢复] 将从断点继续训练...
) else (
    echo [新训] 未检测到历史状态，开始全新训练
)
echo.

C:\LoraTraining\kohya_ss\venv\Scripts\python.exe train_network.py --config_file="C:/LoraTraining/geometric/configs/fangsheng_lora_config_v3.toml" %RESUME_ARG%

echo.
echo ============================================
echo   方胜纹 v3 训练完成/中断！
echo   输出目录: C:\LoraTraining\geometric\output\fangsheng_v3
echo   预览图: C:\LoraTraining\geometric\output\fangsheng_v3\sample
echo ============================================
