# -*- coding: utf-8 -*-
"""
James W. Heiss, April 2023

This script computes the land area where runoff is intercepted by future shorelines. 
"""


import arcpy
import os
import numpy as np

arcpy.env.overwriteOutput = True

arcpy.CheckOutExtension("spatial")

arcpy.env.parallelProcessingFactor = 12

current_project = arcpy.mp.ArcGISProject(r"C:\Users\Administrator\Documents\Arc_global\globalSGD_hydrosheds3.aprx")

arcpy.env.snapRaster = r"C:\Users\Administrator\Documents\Arc_global\globalSGD_hydrosheds.gdb\world_dir_buf" 


#%%
#input path to present-day catchments
present_catchment_feature_class_path = r"C:\Users\Administrator\Documents\Arc_global\SLR_catchment\01mmSLR_catchments_v21.shp" 

catchment_shapefile_path = r"C:\Users\Administrator\Documents\Arc_global\SLR_catchment" 
arcpy.env.workspace = catchment_shapefile_path
shapefile_list = arcpy.ListFeatureClasses() 
shapefile_list = shapefile_list[3:] #start at first RCP in loop

#output path of runoff intercept areas
catchment_runoff_intercept_area_path = r"C:\Users\Administrator\Documents\Arc_global\SLR_runoff_intercept_area"

#empty array for storing areas
runoff_intercept_area = np.zeros(shape=(len(shapefile_list),1))
for h in range(0, len(shapefile_list) ):
    arcpy.ClearWorkspaceCache_management() 

    catchment_name = shapefile_list[h]
    catchment_name = catchment_name[:-4]
    print("computing " + catchment_name)
        
    catchment_shapefile_path_full = os.path.join(catchment_shapefile_path, catchment_name + '.shp')
    catchment_runoff_intercept_path_full = os.path.join(catchment_runoff_intercept_area_path, catchment_name + "_intercept" + ".shp" )

    arcpy.analysis.Erase(catchment_shapefile_path_full, present_catchment_feature_class_path, catchment_runoff_intercept_path_full, None)
    
    #calculate area in km2 of runoff intercept area
    arcpy.AddField_management(catchment_runoff_intercept_path_full, "AreaKm2Geo", "DOUBLE")
    arcpy.management.CalculateGeometryAttributes(catchment_runoff_intercept_path_full, "Areakm2Geo AREA_GEODESIC", '', "SQUARE_KILOMETERS", None, "SAME_AS_INPUT")
  
    runoff_intercept_array = arcpy.da.TableToNumPyArray(catchment_runoff_intercept_path_full, 'AreaKm2Geo')
    
    runoff_intercept_array = runoff_intercept_array.astype(np.float32)
    
    #calculate runoff intercept area for RCP
    runoff_intercept_area[h] = np.sum(runoff_intercept_array)
       
print("done")
