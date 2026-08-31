@echo off
chcp 65001 >nul
echo ============================================
echo   方胜纹 · 连续 LoRA v1 训练 (GPU: RTX 5060)
echo   数据: 18源图(20-37, 纯菱格+少量团花) x repeats4 = 72步/epoch
echo   Epoch: 8, 总步数=576
echo   触发词: ichpattern_fangsheng_continuous
echo   配置: dim=8/alpha=4, lr=1e-5 cosine, bf16, sdpa, flip
echo   验收: 嵌套/交叠菱格清晰、可平铺、不乱成网
echo   负向: text, watermark, blurry, messy, single motif, centered medallion,
echo         floral, ruyi, wave, cloud, thick lines, asymmetric, broken lattice, 3d
echo ============================================
echo.

if not exist "C:\LoraTraining\geometric\output\fangsheng_continuous_v1\logs" mkdir "C:\LoraTraining\geometric\output\fangsheng_continuous_v1\logs"

cd /d C:\LoraTraining\kohya_ss\sd-scripts

set RESUME_ARG=
for /f "delims=" %%d in ('dir /b /ad "C:\LoraTraining\geometric\output\fangsheng_continuous_v1\ICH_fangsheng_continuous_lora_v1-state-*" 2^>nul') do set "LAST_STATE=%%d"
if defined LAST_STATE (
    set "RESUME_ARG=--resume=C:\LoraTraining\geometric\output\fangsheng_continuous_v1\%LAST_STATE%"
    echo [恢复] 检测到上次训练状态: %LAST_STATE%
) else (
    echo [新训] 开始全新训练
)
echo.

C:\LoraTraining\kohya_ss\venv\Scripts\python.exe train_network.py --config_file="C:/LoraTraining/geometric/configs/fangsheng_continuous_lora_v1.toml" %RESUME_ARG%

echo.
echo ============================================
echo   连续 LoRA v1 训练完成/中断！
echo   输出: C:\LoraTraining\geometric\output\fangsheng_continuous_v1
echo ============================================
