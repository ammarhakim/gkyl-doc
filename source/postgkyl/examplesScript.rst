.. _pg_scriptModeExamples:

Script mode examples
++++++++++++++++++++

Examples of using the script mode of postgkyl.

Simple loading of data in grids:

import postgkyl as pg

def func_data(ionDensityData):
	ionDensityInterp = pg.data.GInterpModal(ionDensityData, 1, 'ms')
	interpGrid, ionDensityValues = ionDensityInterp.interpolate()

	# get cell center coordinates
	CCC = []
	for j in range(0,len(interpGrid)):
	    CCC.append((interpGrid[j][1:] + interpGrid[j][:-1])/2)

	x_vals = CCC[0]
	y_vals = CCC[1]
 	z_vals = CCC[2]
	X, Y = np.meshgrid(x_vals, y_vals)
	ionDensityGrid = np.transpose(ionDensityValues[:,:,z_slice,0])
	return x_vals,y_vals,X,Y,ionDensityGrid
  
ionDensity=DIR+'<filename>_ion_GkM0_%d'%data_num[i]+'.bp'
ionDensityData = pg.data.GData(ionDensity)

x_vals,y_vals,X,Y,ionDensityGrid = func_data(ionDensityData)

Evaluating derivative of data on grids: 

def func_data(phiData):
	phiInterp = pg.data.GInterpModal(phiData, 1, 'ms')
	interpGrid, phiValues = phiInterp.interpolate()

	exValues = - np.gradient(phiValues,dx,axis = 0)
	dexdxValues = np.gradient(exValues,dx,axis = 0)
	eyValues = - np.gradient(phiValues,dy,axis = 1)

	# get cell center coordinates
	CCC = []
	for j in range(0,len(interpGrid)):
	    CCC.append((interpGrid[j][1:] + interpGrid[j][:-1])/2)

	x_vals = CCC[0]
	y_vals = CCC[1]
	z_vals = CCC[2]
	X, Y = np.meshgrid(x_vals, y_vals)
	exGrid = np.transpose(exValues[:,:,z_slice,0])  
	eyGrid = np.transpose(eyValues[:,:,z_slice,0])
	dexdxGrid = np.transpose(dexdxValues[:,:,z_slice,0])

	return x_vals,y_vals,X,Y,exGrid,eyGrid,dexdxGrid
  
phi=DIR+'<filename>_phi_%d'%data_num[i]+'.bp'
phiData = pg.data.GData(phi)

x_vals,y_vals,X,Y,exGrid,eyGrid,dexdxGrid = func_data(phiData)
  
