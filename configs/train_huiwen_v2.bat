@echo off
chcp 65001 >nul
echo ============================================
echo   回纹 LoRA 训练 (v2 - GPU模式: RTX 5060)
echo   数据: 66张 (40筛选源图: 26边框/条带flip + 14辅助)
echo   repeats=3, Epoch: 6, 总步数≈1188
echo   触发词: ichpattern_huiwen
echo   配置: dim=16/alpha=8, lr=4e-5, bf16, sdpa
echo   保存: 每100步 + 每epoch 保存 checkpoint 和 state
echo ============================================
echo.

REM 创建输出目录
if not exist "C:\LoraTraining\geometric\output\huiwen_v2\logs" mkdir "C:\LoraTraining\geometric\output\huiwen_v2\logs"

cd /d C:\LoraTraining\kohya_ss\sd-scripts

REM 自动检测最新 state 目录用于断点续训
set RESUME_ARG=
for /f "delims=" %%d in ('dir /b /ad "C:\LoraTraining\geometric\output\huiwen_v2\ICH_huiwen_pattern_lora_v2-state-*" 2^>nul') do set "LAST_STATE=%%d"
if defined LAST_STATE (
    set "RESUME_ARG=--resume=C:\LoraTraining\geometric\output\huiwen_v2\%LAST_STATE%"
    echo [恢复] 检测到上次训练状态: %LAST_STATE%
    echo [恢复] 将从断点继续训练...
) else (
    echo [新训] 未检测到历史状态，开始全新训练
)
echo.

C:\LoraTraining\kohya_ss\venv\Scripts\python.exe train_network.py --config_file="C:/LoraTraining/geometric/configs/huiwen_lora_config_v2.toml" %RESUME_ARG%

echo.
echo ============================================
echo   训练完成！
echo   输出目录: C:\LoraTraining\geometric\output\huiwen_v2
echo   预览图: C:\LoraTraining\geometric\output\huiwen_v2\sample
echo ============================================
