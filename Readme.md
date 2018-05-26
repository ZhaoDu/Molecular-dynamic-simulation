# MD simulation of construction materials

This project is mainly about molecular dynamic simulation of asphalt binder and asphalt aggregate interface properties. Codes within this project were firstly divided by softwares. Since most of present simulations were conducted by Lammps, details about lammps codes ware mainly listed in this README.md. Those about Material Studio Script will be added in the future while it is necessary, and most importantly, the author get a vacant period.

Considering the simulation models and methods, lammps codes were roughly sorted into following parts. Details will be added in the future.

* Modeling of asphalt and aggregate
* Dynamic relaxation of simulation models
* Pull-off simulation of asphalt/aggregate interface
* AFM/Nanoindentation simulation
## Modeling
### Modeling of asphalt
1. Asphalt model was firstly generated with forcefield added by a commercial software Material Studio
2. Export asphalt model to Insight form
3. Transfer Insight form to lammps data with *msi2lmp* or *EMC Insight2lammps.pl* package
4. Further edition might be needed 
### Modeling of quartz
As far as I know, there are two ways to model quartz. The Lammps method and "Lammps + MS" method. The latter is similar to that of asphalt modeling. The Lammps method can be seen in file *modeling_quartz.in*. Key steps are listed in the following:  
1. Modeling atomic style quartz by *modeling_quartz.in*
2. Transfer atomic style to full style with VMD if it is necessary. Following codes might be useful in VMD.  

    $ topo readlammpsdata *filename.data*  ##read your lammps data  
    $ set a [atomselect top all]  ## part selection and name it *a*  
    $ topo writelammpsdata full *export-file-name.data* -sel $a  ## export your selection by full style
3. Edit *export-file-name.data* (change pair-style and some parameters et al)  

It should be **noticed** that quartz modeling method with lammps in *modeling_quartz.in* negelected the bond and charge distribution information of quartz model. Further boost is needed if you are gonna to do researches on quartz simulation.
### Modeling of asphalt-aggregte interface
Asphalt-aggregate interface model is some kind of assembly of asphalt and aggregate components.Details can be found in *modeling asp-agg interface.in*

<figure class="third">
    <img src="https://raw.githubusercontent.com/ZhaoDu/Molecular-dynamic-simulation/master/Image/asphalt.png"width = "100" alt="asp_agg interface">
    <img src="https://raw.githubusercontent.com/ZhaoDu/Molecular-dynamic-simulation/master/Image/quartz.png"width = "100" alt="asp_agg interface">
    <img src="https://raw.githubusercontent.com/ZhaoDu/Molecular-dynamic-simulation/master/Image/asp-agg%20interface.png"width = "100" alt="asp_agg interface">
</figure>