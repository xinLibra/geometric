@echo off
chcp 65001 >nul
echo ============================================
echo   方胜纹 · 单独 LoRA v2 训练 (防连续/强居中)
echo   数据: 25源图(自动筛选居中留白) x repeats3 = 75步/epoch
echo   Epoch: 8, 总步数=600
echo   触发词: ichpattern_fangsheng_single
echo   配置: dim=16/alpha=8, lr=1e-5 cosine, bf16, sdpa, flip
echo   验收: 单个居中徽章、双菱交叠清楚、四周留白、换色稳定
echo   负向: seamless, tileable, continuous pattern, repeating pattern,
echo         full background pattern, all-over pattern, multiple motifs,
echo         grid of motifs, borderless repeat, messy, blurry, floral,
echo         wave, cloud, thick lines, asymmetric, broken lines, 3d,
echo         photorealistic, text, watermark, signature
echo ============================================
echo.

if not exist "C:\LoraTraining\geometric\output\fangsheng_single_v2\logs" mkdir "C:\LoraTraining\geometric\output\fangsheng_single_v2\logs"

cd /d C:\LoraTraining\kohya_ss\sd-scripts

set RESUME_ARG=
for /f "delims=" %%d in ('dir /b /ad "C:\LoraTraining\geometric\output\fangsheng_single_v2\ICH_fangsheng_single_lora_v2-state-*" 2^>nul') do set "LAST_STATE=%%d"
if defined LAST_STATE (
    set "RESUME_ARG=--resume=C:\LoraTraining\geometric\output\fangsheng_single_v2\%LAST_STATE%"
    echo [恢复] 检测到上次训练状态: %LAST_STATE%
) else (
    echo [新训] 开始全新训练
)
echo.

C:\LoraTraining\kohya_ss\venv\Scripts\python.exe train_network.py --config_file="C:/LoraTraining/geometric/configs/fangsheng_single_lora_v2.toml" %RESUME_ARG%

echo.
echo ============================================
echo   单独 LoRA v2 训练结束
echo   输出: C:\LoraTraining\geometric\output\fangsheng_single_v2
echo ============================================
