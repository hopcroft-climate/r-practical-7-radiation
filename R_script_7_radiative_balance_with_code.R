#---
# title: "R Notebook 9 - the Earth's radiative balance"

# Peter Hopcroft
# 12.18, 12.19, 09.20, 11.20
#---

## 
# This week we're going to plot albedo and radiation balance using CMIP5 climate model simulation outputs.

# Load the ncdf4 library into R. (note, we installed this with install.packages() in Notebook 2)
#install.packages("ncdf4")
#install.packages("fields")
library("ncdf4")
library("fields")


# Open a file connection to the NetCDF file
setwd("~/shared/data/ESM_simulations/piControl/HadGEM2-ES/monthly_means/") 
ncfile <- nc_open("rsut_HadGEM2-ES_piControl_r1i1p1_ext1850-1879_mean_1deg.nc")

# Print the NetCDFs header
print(ncfile)

# Extract variables from the NetCDF file
lat = ncvar_get(ncfile, 'lat')
lon = ncvar_get(ncfile,'lon')
rsut = ncvar_get(ncfile, 'rsut')
# Close the NetCDF file connection
nc_close(ncfile)

# Open a file connection to the NetCDF file
setwd("~/shared/data/ESM_simulations/piControl/HadGEM2-ES/monthly_means/") 
ncfile <- nc_open("rsdt_HadGEM2-ES_piControl_r1i1p1_ext1850-1879_mean_1deg.nc")

# Print the NetCDFs header
print(ncfile)

# Extract variables from the NetCDF file
lat = ncvar_get(ncfile, 'lat')
lon = ncvar_get(ncfile,'lon')
rsdt = ncvar_get(ncfile, 'rsdt')
# Close the NetCDF file connection
nc_close(ncfile)


# Let's plot these 2 variables
library("fields")
image.plot(lon, lat, rsdt[,,1])

# This above won't work because the axis are decreasing. So we will need to flip as before:
image.plot(lon, lat[180:1], rsdt[,180:1,1])
image.plot(lon, lat[180:1], rsut[,180:1,1])

# The first plot 'rsdt' is Radiation, Short wave and it is Downwelling at the Top of the atmosphere. Hence rsdt.

# The second 'rsut' is the same but upwelling.


# What do you notice about these 2 plots? Make some notes here:
#  Notes ...

# In the lecture we looked at albedo, which is the ratio upwelling divided by downwelling radiation.
# Now let's have a go at calculating this (see we divide the up by the down):
albedo_toa<- rsut/rsdt

# and we'll now plot this also:
image.plot(lon, lat[180:1], albedo_toa[,180:1,1])

# What do you think - does this look as you'd expect? You can compare to slides from the lecture.
# Make some notes here;
# Notes ....

# So this is actually simulated January top-of-the atmosphere albedo. 
# Notice that there are no values in the North Polar area - why do you think this is?
# Your answer here: ....


# Now let's plot July 
image.plot(lon, lat[180:1], albedo_toa[,180:1,7])
# Notice how this is different and now there are no values in the Southern Polar area.


# These were all top-of-the-atmosphere fluxes. That integrates everything from the land surface and the whole atmospheric column (e.g. clouds etc.)

# Now let's read in the equivalent surface fields. That is the simulated shortwave radiation at the surface both downwelling (rsds) and upwelling (rsus), and make a similar plot:

# Open a file connection to the NetCDF file
ncfile <- nc_open("rsus_HadGEM2-ES_piControl_r1i1p1_ext1850-1879_mean_1deg.nc")

# Print the NetCDFs header
print(ncfile)

# Extract variables from the NetCDF file
lat = ncvar_get(ncfile, 'lat')
lon = ncvar_get(ncfile,'lon')
rsus = ncvar_get(ncfile, 'rsus')
# Close the NetCDF file connection
nc_close(ncfile)

# Open a file connection to the NetCDF file
ncfile <- nc_open("rsds_HadGEM2-ES_piControl_r1i1p1_ext1850-1879_mean_1deg.nc")

# Print the NetCDFs header
print(ncfile)

# Extract variables from the NetCDF file
lat = ncvar_get(ncfile, 'lat')
lon = ncvar_get(ncfile,'lon')
rsds = ncvar_get(ncfile, 'rsds')
# Close the NetCDF file connection
nc_close(ncfile)

# now calculate the albedo at the surface and make a plot of the top of the atmosphere and surface fields:
albedo_srf<- rsus/rsds

image.plot(lon, lat[180:1], albedo_toa[,180:1,1])
image.plot(lon, lat[180:1], albedo_srf[,180:1,1])



# Let's make the scale equivalent between the two plots, and let's label them to make it easier:
image.plot(lon, lat[180:1], albedo_toa[,180:1,1],zlim=c(0.0,1.0),main="TOA albedo")
image.plot(lon, lat[180:1], albedo_srf[,180:1,1],zlim=c(0.0,1.0),main="Surf. albedo")


# What do you notice about the 2 fields? What areas stand out, and why do you think this is?

# How and why are they different?
# Notes here ....


# Finally we can look at the difference between 2 simulations. Here, we will choose piControl which we have just been looking at, and the RCP 8.5 simulation.
setwd("~/shared/data/ESM_simulations/rcp85/HadGEM2-ES/monthly_means/") 

# We will need 4 files for RCP85:  rsut, rsdt & rsus, rsds.

# Open the NetCDF file for rsut
ncfile <- nc_open("rsut_HadGEM2-ES_rcp85_r1i1p1_ext2070-2099_mean_1deg.nc")
# Print the NetCDFs header
print(ncfile)
rsut_rcp85_2099 = ncvar_get(ncfile, 'rsut')
nc_close(ncfile)

# Open the NetCDF file for rsdt
ncfile <- nc_open("rsdt_HadGEM2-ES_rcp85_r1i1p1_ext2070-2099_mean_1deg.nc")
print(ncfile)
rsdt_rcp85_2099 = ncvar_get(ncfile, 'rsdt')
nc_close(ncfile)

# Open the NetCDF file for rsus
ncfile <- nc_open("rsus_HadGEM2-ES_rcp85_r1i1p1_ext2070-2099_mean_1deg.nc")
print(ncfile)
rsus_rcp85_2099 = ncvar_get(ncfile, 'rsus')
nc_close(ncfile)

# Open the NetCDF file rsds
ncfile <- nc_open("rsds_HadGEM2-ES_rcp85_r1i1p1_ext2070-2099_mean_1deg.nc")
print(ncfile)
rsds_rcp85_2099 = ncvar_get(ncfile, 'rsds')
nc_close(ncfile)


# Now calculate the albedo for the top and surface:
albedo_toa_rcp85_2099 <-rsut_rcp85_2099/rsdt_rcp85_2099
albedo_srf_rcp85_2099 <-rsus_rcp85_2099/rsds_rcp85_2099

# Now subtract the piControl fields that we calculated in the first part of the practical:
albedo_toa_rcp85_picontrol_diff<-albedo_toa_rcp85_2099-albedo_toa
albedo_srf_rcp85_picontrol_diff<-albedo_srf_rcp85_2099-albedo_srf

# Now plot the change in albedo for RCP85 minus piControl:
image.plot(lon, lat[180:1], albedo_toa_rcp85_picontrol_diff[,180:1,1],zlim=c(-0.5,0.5),main="TOA albedo",sub="RCP85-piControl")
image.plot(lon, lat[180:1], albedo_srf_rcp85_picontrol_diff[,180:1,1],zlim=c(-0.5,0.5),main="Surf. albedo",sub="RCP85-piControl")

# Let's improve this anomaly plot:

# Install the RColorBrewer package, to give us access to lots of extra colour paletts. Uncomment and run the line below the first time on a computer.  You may not need to install this in which case comment it out with a #
install.packages("RColorBrewer")
# Load the RColorBrewer into R with the library() function. 
library("RColorBrewer")
# The same plot and map commands as before, but with the prewer.pal(10,'RdBu) function, which gives us a Red to Blue color ramp with 10 levels. This is then enclosed with the rev() function, which reverses the order of the red-blue color ramp to give us a blue-red color ramp, which is more normal for Environmental sciences
install.packages("rworldmap")
library(rworldmap)
data(coastsCoarse)

# this is the TOA change for January (hence the 1 in [,180:1,1]):
image.plot(lon, lat[180:1], albedo_toa_rcp85_picontrol_diff[,180:1,1],zlim=c(-0.25,0.25),main="TOA albedo",sub="RCP85-piControl", col = rev(brewer.pal(10, "RdBu")))
plot(coastsCoarse,add=T)

# this is the surface change for January (again, hence the 1 in [,180:1,1]):
image.plot(lon, lat[180:1], albedo_srf_rcp85_picontrol_diff[,180:1,1],zlim=c(-0.25,0.25),main="Surf. albedo",sub="RCP85-piControl", col = rev(brewer.pal(10, "RdBu")))
plot(coastsCoarse,add=T)

# So we're seeing that in a warmer climate like RCP85, the surface albedo shows quite big changes. The surface albedo values are lower (more blue).

# Why is this? 
# Your notes here ...

# What differences do you notice for the top of the atmosphere plot? What do you think is behind these?
# Your notes here ...

# Now try the same plot for July (hence the 7 in [,180:1,7])
image.plot(lon, lat[180:1], albedo_toa_rcp85_picontrol_diff[,180:1,7],zlim=c(-0.25,0.25),main="TOA albedo",sub="RCP85-piControl", col = rev(brewer.pal(10, "RdBu")))
plot(coastsCoarse,add=T)

image.plot(lon, lat[180:1], albedo_srf_rcp85_picontrol_diff[,180:1,7],zlim=c(-0.25,0.25),main="Surf. albedo",sub="RCP85-piControl", col = rev(brewer.pal(10, "RdBu")))
plot(coastsCoarse,add=T)


# Well done! You've reached the end of the structured part of this practical. 

# ------------------------------------------------
# ------------------------------------------------
# The following are 3 sets of suggestions for further work.

# ------------------------------------------------
# 1. Policy scenario
# Now it is time for you to explore the impacts of your Policy Scenario with these simulations and other observations.
# To do this you need read in the rsdt/rudt and rsds/rsus for the G3/G4 simulations based on lines 133-161 above.

# e.g. setwd:
# Finally we can look at the difference between 2 simulations. Here, we will choose piControl which we have just been looking at, and the RCP 8.5 simulation.
setwd("~/shared/data/Policy_scenarios/SO2_injection/G3/HadGEM2-ES/monthly_means/") 

# We will need 4 files for RCP85:  rsut, rsdt & rsus, rsds.
ncfile <- nc_open("rsut_Amon_HadGEM2-ES_G3_r1i1p1_201912_208912_ext2070-2099_monmean_1deg.nc")
# Print the NetCDFs header
print(ncfile)
rsut_g3_2099 = ncvar_get(ncfile, 'rsut')
nc_close(ncfile)
# etc.

# ------------------------------------------------
# 2. Clear-sky fluxes
# You may also wish to look at the clear-sky versions.
# The clear-sky gives you the fluxes that would occur with no clouds.
# Note there is no rsdt for clear-sky because the incoming solar radiation at the top-of-the-atmosphere is not going to hit any clouds (:-)
# e.g. to get the clear-sky upward short-wave for RCP 85:
setwd("~/shared/data/ESM_simulations/rcp85/HadGEM2-ES/monthly_means/") 
# Open the NetCDF file for rsut
ncfile <- nc_open("rsutcs_HadGEM2-ES_rcp85_r1i1p1_ext2070-2099_mean_1deg.nc")
# Print the NetCDFs header
print(ncfile)
rsutcs_rcp85_2099 = ncvar_get(ncfile, 'rsutcs')
nc_close(ncfile)

# ------------------------------------------------
# 3. Long-wave fluxes.
# If you want to look at long-wave, make sure you *don't* try to calculate albedo as it does not make physical sense.
# Long-wave radiation is not scattered like short-wave radiaition. (e.g. think of heat from a radiator - it is not reflected like light form a torch.)
# Therefore you can plot the long-wave fields as anomalies *without* calculating the ratios as we did above.
# e.g. to read in the long-wave emitted upwards at the surface (rlus):
# I would read annual-means in for this:
setwd("~/shared/data/ESM_simulations/rcp85/HadGEM2-ES/annual_means/") 
ncfile <- nc_open("rlus_HadGEM2-ES_rcp85_r1i1p1_ext2020-2049_ann_mean_1deg.nc")
# Print the NetCDFs header
print(ncfile)
rlus_rcp85_2099 = ncvar_get(ncfile, 'rlus')
nc_close(ncfile)
