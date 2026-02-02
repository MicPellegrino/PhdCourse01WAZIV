1. Create the virtual environment by running:

	conda env create -f environment.yml --channel-priority strict

(you can use miniconda, mamba or micromamba, it should not matter).

2. Activate the virtual environment:

	conda activate inmod-md

 and run 'gmx help mdrun' from the command line. The first line should be:

	:-) GROMACS - gmx help, 2025.4-conda_forge (-:

3. Move to the 'biphase' folder and open 'biphase.ipynb' with 'jupyter-notebook'.

4. You can now run the notebook cell-by-cell.


TODO
- Add the MATLAB scripts back to the zeolite postprocessing folder (for those who want to use MATLAB instead of Python);
- Add figures to the zeolite notebook (NB not embedded!);
- ...
