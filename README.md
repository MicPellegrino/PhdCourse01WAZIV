# Innovative modelling approaches for multi-scale heat and mass transfer - Molecular Dynamics simulations

## Content

- [Simulated systems](#simulated-systems)
- [How to create and test the virtual environment](#how-to-create-and-test-the-virtual-environment)
- [How to run exercise notebooks](#how-to-run-exercise-notebooks)
- [How to visualize the results](#how-to-visualize-the-results)
- [License](#license)

## Simulated systems

### Heat transfer in a carbon nanotube (`cnt`)

This first exercise will introduce you to the basics of Molecular Dynamics (creating configuration files, algorithms, force fields, topologies thermalization and post-processing). The final goal will be to evaluate the thermal conductivity of a carbon nanotube using a non-equilibrium method. Zero to hero.

### Water adsorption in zeolite (`zeolite`)

The second exercise will introduce liquid environments (solvation) and water models. You will be asked to simulate a zeolite matrix at different hydration levels in order to study its energy storage properties. You will also compute the self-diffusion coefficient of water, a typical observable obtainable from Molecular Dynamics.

### Liquid-liquid interfaces (`biphase`)

The third exercise moves toward multicomponent liquid systems and introduces pressure control (barostat). You will simulate the formation of the interface between water and hexane and compute its surface tension. In the final part, pentanol will be added to the mixture, and you will assess how it affects the surface properties.

### Wetting of flat and rough surfaces (`wetting`)

In the fourth exercise, you will simulate a water droplet spreading on an “aluminum” crystal. You will compute its contact angle and study how it changes as the strenght of liquid–solid interactions is increased. Finally, you will explore how wetting states are affected by the presence of surface nanostructures.

## How to create and test the virtual environment

**Step :zero: - Get a Linux distribution**:

- If you are a **Linux** user, then you are already good to go;
- If you are a **Windows** user, setup the Windows Subsystem for Linux: https://learn.microsoft.com/en-us/windows/wsl/install (recommended), or use a virtual machine (discouraged).
- If you are a **Mac** user, the environment and the notebooks have been also tested on the latest MacOS with m2 and m4 architecture. So you should also be good to go.

**Step :one: - Download and install Conda or one of its variants**:
- Conda: https://docs.conda.io/projects/conda/en/latest/user-guide/install/index.html;
- Miniconda: https://www.anaconda.com/docs/getting-started/miniconda/install;
- Mamba: https://mamba.readthedocs.io/en/latest/installation/mamba-installation.html;
- Micromamba: https://mamba.readthedocs.io/en/latest/installation/micromamba-installation.html.

Example installation of Miniconda (tested on `wsl`):

	wget https://repo.anaconda.com/miniconda/Miniconda3-latest-Linux-x86_64.sh
	./Miniconda3-latest-Linux-x86_64.sh
	# Follow the instructions

I will refer to Conda from now on, but mind that any variant should work just fine. In my personal experience, Mamba and Micromamba are significantly faster when it comes to environment creation and management. Micromamba should be the most lightweight. However, don't bother switching if you already have Conda installed. 

:warning: The installation instructions should mention how to setup and activate Conda after its installation. You may want (or need) to add some lines to `.bashrc` and/or `.profile` in order to automatically activate Conda when opening a new `bash` session.

**Step :two: - Create the virtual environment** by running:

	conda env create -f environment.yml --channel-priority strict

the `--channel-priority strict` may be necessary to force `conda` to install the required version of Jupyter Notebook. If the `--channel-priority strict` flag doesn't work, try:

	conda config --set channel_priority strict

instead.

**Step :three: - Test Gromacs installation**. Activate the virtual environment by running:

	conda activate inmod-md

and run: 

	gmx help mdrun
 
from the command line. The first line should be: `:-) GROMACS - gmx help, 2025.4-conda_forge (-:`.

:warning: If the command `gmx` is not found or you get something else other than `2025.4-conda_forge`, it means that either the Conda environment is not active or that the Gromacs dependency has not been installed.

## How to run exercise notebooks

With the exception of `cnt`, move to the any of the folders (e.g. `cd biphase`) and open the related notebook by running:

	jupyter-notebook <name-of-the-notebook>.ipynb

You can now run the notebook cell-by-cell. You may have to edit some simulation configuration file; in this case, open Jupyter Notebook in the folder, by just running:

	jupyter-notebook

and navigate to the file you want to edit.

Alternatively, you can open the file from `bash` (i.e. _outside the notebook_) using your favourite text editor (`vim`, `code`, `emacs`, `gedit`, `featherpad`, ...).

Sorry ladies and gentlemen, the notebook itself is the best, and only, GUI you’re going to get. :man_shrugging:

## How to visualize the results

In the notebooks, you will find `nglview` widgets allowing inline visualization of molecular simulation results. There are other (possibly better) solutions _outside the notebook_:
- VMD: https://www.ks.uiuc.edu/Development/Download/download.cgi?PackageName=VMD - free of charge, you just need to register your institutional email;
- OVITO: https://www.ovito.org/manual/installation.html - there's a free limited version and a full commercial version (the free version is more than enough for visualization purposes, plus you can use the complete Python API without having to pay);
- VEGA ZZ: https://www.ddl.unimi.it/cms/index.php?Software_projects:VEGA_ZZ:Download - an activation key must be purchased;
- PyMOL: https://www.pymol.org/ - an activation key must be purchased.

:film_projector: In terms of "Gromacs friendliness", **VMD** is definitely the best. I really suggest you install VMD.

## License

Provided by the Multi-Scale Modeling Lab of Politecnico di Torino (Italy). These resources are intended for pedagogical purposes, and were designed for the undergraduate and third-cycle courses at Politecnico di Torino (2023-2026).

Authors:
- Matteo Fasano (matteo.fasano@polito.it)
- Michele Pellegrino (michele.pellegrino@polito.it)




#### TODO (in order of importance)
- Add more instructions on Conda setup;
- Port the cnt exercise to Jupyter-Notebook;
- Finish commenting wetting notebook;
- Test xmgrace and gnuplot on wsl (local);
- Add the MATLAB scripts back to the zeolite postprocessing folder (for the students who want to use MATLAB instead of Python);
- Add figures notebooks (NB not embedded!);
- Add an actual license.
