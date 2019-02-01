# CHARC-Framework
MATLAB source code for the CHAracterisation of Reservoir Computers (CHARC) framework.

See wiki for detailed more information and Tutorials.

Reservoirs to test:
- Echo State Networks
- Reservoir of Reservoirs (RoR) architecture
- "Deep"/pipeline reservoirs
- Ensemble of reservoirs
- Extreme Learning Machines (including multi-layer)
- Graph-based reservoirs (including some ensembles)
- Belousov–Zhabotinsky (BZ) reaction reservoir
- DNA (network of coupled deoxyribozyme oscillators) reservoir
- Boolean network reservoir 
- Cellular Automata (implemented with RBN) both 1- and 2-dimensional

....coming soon
* Liquid State Machine (Spiking Networks)
* Wave-based (e.g. bucket of water)
* Delay-line Reservoir (single non-linear node with delay line)
* Memristor Network
* Ising model 
* Nuclear Magnetic Resonance (NMR) reservoir

All these work with:
- CHARC Framework
- Evolve reservoir directly to task
- Multi-objective(task) evolution using NSGA-II

Tasks added recently (check out selectDataset.m):
- Pole balancing: inverted pendulum, doube-pole inverted pendulum, swinging pendulum
- Autoencoder
- n-bit adders
- evolved output layer

Plots:
- behaviourGUI: to visualise parameter-behaviour relationship and structure (in some cases)