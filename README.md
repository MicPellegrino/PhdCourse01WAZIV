# Innovative modelling approaches for multi-scale heat and mass transfer - Molecular Dynamics simulations

## Content

- [Simulated systems](#simulated-systems)
- [How to create and test the virtual environment](#how-to-create-and-test-the-virtual-environment)
- [How to run exercise notebooks](#how-to-run-exercise-notebooks)
- [How to visualize the results](#how-to-visualize-the-results)
- [License](#license)

## Simulated systems

### Heat transfer in a carbon nanotube (`cnt`)

...

### Water adsorption in zeolite (`zeolite`)

...

### Liquid-liquid interfaces (`biphase`)

...

### Wetting of flat and rough surfaces (`wetting`)

...

## How to create and test the virtual environment

**Step 1 - Download and install Conda or one of its variants**:
- Conda: https://docs.conda.io/projects/conda/en/latest/user-guide/install/index.html;
- Miniconda: https://www.anaconda.com/docs/getting-started/miniconda/install;
- Mamba: https://mamba.readthedocs.io/en/latest/installation/mamba-installation.html;
- Micromamba: https://mamba.readthedocs.io/en/latest/installation/micromamba-installation.html.

I will refer to Conda from now on, but mind that any variant should work just fine. In my personal experience, Mamba and Micromamba are significantly faster in terms of environment creation. If you already have Conda installed, don't bother switching. The installation pages should contain instructions on how to setup and activate Conda after its installation (you may need/want to add some lines to `.bashrc` and/or `.profile`).

**Step 2 - Create the virtual environment** by running:

	conda env create -f environment.yml --channel-priority strict

the `--channel-priority strict` may be necessary to force `conda` to install the required version of Jupyter Notebook.

**Step 3 - Test Gromacs installation**. Activate the virtual environment by running:

	conda activate inmod-md

and run: 

	gmx help mdrun
 
from the command line. The first line should be: `:-) GROMACS - gmx help, 2025.4-conda_forge (-:`.

If the command `gmx` is not found or you get something else other than `2025.4-conda_forge`, it means that either the Conda environment is not active or that the Gromacs dependency has not been installed.

## How to run exercise notebooks

With the exception of `cnt`, move to the any of the folders (e.g. `cd biphase`) and open the related notebook by running:

	jupyter-notebook <name-of-the-notebook>.ipynb

You can now run the notebook cell-by-cell. You may have to edit some simulation configuration file; in this case open the file from `bash` (i.e. _outside the notebook_) using your favourite text editor (`vim`, `code`, `emacs`, `featherpad`, ...).

Sorry ladies and gentlemen, the notebook itself is the best, and only, GUI you’re going to get :-)

## How to visualize the results

In the notebooks, you will find `nglview` widgets allowing inline visualization of molecular simulation results. There are other (possibly better) solutions _outside the notebook_:
- VMD: https://www.ks.uiuc.edu/Development/Download/download.cgi?PackageName=VMD - free of charge, you just need to register your institutional email;
- OVITO: https://www.ovito.org/manual/installation.html - there's a free limited version and a full commercial version (the free version is more than enough for visualization purposes, plus you can use the complete Python API from the free version);
- VEGA ZZ: https://www.ddl.unimi.it/cms/index.php?Software_projects:VEGA_ZZ:Download - an activation key must be purchased;
- PyMOL: https://www.pymol.org/ - an activation key must be purchased.

In terms of "Gromacs friendliness", **VMD** is definitely the best.

## License

...


#### TODO
- Add description of exercises
- Add more instructions on Conda setup;
- Add the MATLAB scripts back to the zeolite postprocessing folder (for the students who want to use MATLAB instead of Python);
- Add figures notebooks (NB not embedded!);
- Add license
