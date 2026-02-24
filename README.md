# DOA_Beamforming

In real recordings (meetings, call centers, smart devices), multiple people often talk at the same time, so each microphone captures a **mixture** rather than a clean voice.  
This project tackles the **source separation** problem in a simple but realistic setup: **3 microphones** record **3 static speakers**, and the goal is to make **one target speaker** dominant and suppress the others.

From a data-science perspective, you can think of this as:  
- estimating a latent variable (**direction/angle of each speaker**) from multichannel signals, then  
- applying a constrained optimization filter (**MVDR beamformer**) that preserves the target while minimizing interference power.


# Time Difference of Arrival (TDOA) + MVDR Beamforming for Multi-Speaker Audio Enhancement

**Niloofar Jazaeri** — University of Ottawa (Fall 2024)  
[Paper (PDF)](paper/report/report.pdf) · [Notebook](notebook/MVDR_Beamforming_Beampattern_ImpuleResponse.ipynb) · [Results](results/) · [MATLAB denoising](matlab/)

<p align="center">
  <img src="paper/figures/Fig1 TDOA analysis between mixture1 and 3.png" width="48%" />
  <img src="paper/figures/Fig3 beampattern set1 angles 60 and 150 and gain 1 and  0.png" width="48%" />
  <img src="paper/figures/Fig 4 Rectangular beampattern, first for set2.png" width="48%" />
</p>

>  **Goal:** Given 3 microphone recordings containing 3 speakers, estimate each speaker’s **direction of arrival (DOA)** via **TDOA** (cross-correlation + GCC-PHAT), then apply an **MVDR beamformer** to preserve the target direction while minimizing output power (interference + noise), followed by denoising (MMSE-STSA 85, V_SpecSub).

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
<img src="https://render.githubusercontent.com/render/math?math=a(%5Ctheta)%20%3D%20%5B%20e%5E%7B-j%5Comega%5Ctau_1(%5Ctheta)%7D%2C%20e%5E%7B-j%5Comega%5Ctau_2(%5Ctheta)%7D%2C%20e%5E%7B-j%5Comega%5Ctau_3(%5Ctheta)%7D%20%5D%5ET">

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

## References
- Chao Pan, Jingdong Chen, Jacob Benesty, **“Performance Study of the MVDR Beamformer as a Function of the Source Incidence Angle,”**
  *IEEE/ACM Transactions on Audio, Speech, and Language Processing*, 22(1):67–79, 2014. DOI: 10.1109/TASL.2013.2283104. :contentReference[oaicite:0]{index=0}
