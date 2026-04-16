# Laser-Induced Acoustic Injection (Software Module)

This repository contains the **software component** of the system described in:

Lupeng Zhang, Minhao Cui, Wenwei Li, Xuefu Dong, Qing Wang, Lei Wang, Daqing Zhang, Lili Qiu, and Jie Xiong. 2026.  
From One Form of Energy to Another: Laser-Induced Injection Attacks on Acoustic Sensing.  
Proc. ACM Interact. Mob. Wearable Ubiquitous Technol. 10, 2, Article 72 (June 2026), 30 pages.  
https://doi.org/10.1145/3810215

This code focuses on the **signal generation and transmission pipeline** on the software side.  
Hardware setup (e.g., laser driver and physical configuration) is described in the paper.

---

## Overview

This project is built on top of the **libAS framework**:

Y.-C. Tung, D. Bui, and K. G. Shin.  
Cross-platform support for rapid development of mobile acoustic sensing applications.  
MobiSys 2018.

It provides a lightweight pipeline for:

- generating time-varying acoustic signals
- transmitting them from a computer to a smartphone for playback

---

## Repository Structure

.
├── FakeGestureGenerator.m
├── SendAttackSignal.m
├── PreambleSyncTuningMain.m
├── corr_timefreq.m
├── correlation.m
├── Setup.m
├── traces/
├── LocalHelpers/
└── README.md

---

## Functionality

### Signal Generation

FakeGestureGenerator.m generates time-varying acoustic signals based on predefined patterns or traces.

### Signal Transmission

SendAttackSignal.m sends the generated signal to a smartphone via libAS for playback.

### Utilities

Includes synchronization and correlation helpers for signal processing.

---

## How to Run

1. Setup environment:
   Setup;

2. Generate signal (optional):
   FakeGestureGenerator;

3. Send signal:
   SendAttackSignal;

Make sure:

- Smartphone client is running
- PC and phone are connected

---

## Notes

- This repository provides the core software pipeline only.
- Hardware setup is described in the paper.
- The system is modular: signals can be replaced (e.g., chirp or custom traces).
- For research and academic use only.

---

## Acknowledgment

Built upon the libAS framework.