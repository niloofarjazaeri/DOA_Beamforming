# DOA_Beamforming
In this Project I try to find the direction of arrival of static speakers and michrophone array of 3, to solitude one source and make it audible.



# Time Difference of Arrival (TDOA) + MVDR Beamforming for Multi-Speaker Audio Enhancement

**Niloofar Jazaeri** — University of Ottawa (Fall 2024)  
[Paper (PDF)](paper/report.pdf) · [Notebook](notebooks/tdoa_mvdr_beamforming.ipynb) · [Results](results/) · [MATLAB denoising](matlab/)

<p align="center">
  <img src="paper/figures/beam_pattern_polar_set2.png" width="48%" />
  <img src="paper/figures/beam_pattern_rect_set2.png" width="48%" />
</p>

> **Goal:** Isolate a target speaker in a **3-microphone / 3-speaker** mixture using **TDOA/DOA estimation** (GCC-PHAT + cross-correlation) and **MVDR beamforming**, followed by **post-denoising** (MMSE-STSA 85, V_SpecSub).

---

## Highlights
- **TDOA/DOA estimation:** cross-correlation peak picking + **GCC-PHAT** validation  
- **Beamforming:** **MVDR** weights with steering vectors derived from estimated DOA  
- **Visualization:** polar + rectangular beampatterns, impulse responses, magnitude responses  
- **Post-processing:** noise estimated from first 1s frame; denoise via **MMSE-STSA 85** and **spectral subtraction**
- **Key result:** for Set 1, denoised output achieved **SIR = 11.7** (Twice V_SpecSub)

---

## Method Overview

### 1) TDOA → DOA
Given microphone spacing \(d\) and speed of sound \(c\), estimate time delay \(\Delta t\) via cross-correlation or GCC-PHAT peak:
- Cross-correlation / `scipy.signal.correlate`
- GCC-PHAT (phase transform improves robustness)

Then convert \(\Delta t\) to angle \(\theta\) (array geometry dependent).

### 2) MVDR Beamforming
Steering vector for DOA \(\theta\):
\[
a(\theta) = [e^{-j\omega\tau_1(\theta)},\; e^{-j\omega\tau_2(\theta)},\; e^{-j\omega\tau_3(\theta)}]^T
\]

MVDR weights:
\[
w_{\text{MVDR}} = \frac{R^{-1} a(\theta_0)}{a(\theta_0)^H R^{-1} a(\theta_0)}
\]

Beamformed output:
\[
y(t) = w^H x(t)
\]

---

## Results (from report)
| Method | Set 1 SIR | Set 2 SIR | Comment |
|---|---:|---:|---|
| MMSE | 0.99 | 0.99 | Audible but noisy |
| V_SpecSub | 1.7 | 1.7 | Less noisy |
| Twice V_SpecSub | **11.7** | 11.7 | Improved |
| Twice MMSE | 7.5 | 8.9 | A bit improved |

**Beam patterns:** unwanted angles show up to ~-80 dB attenuation; desired angle ~0 dB gain (see figures above).

---

## Quickstart

### Option A — Run the notebook
```bash
conda env create -f environment.yml
conda activate tdoa-mvdr
jupyter notebook notebooks/tdoa_mvdr_beamforming.ipynb
