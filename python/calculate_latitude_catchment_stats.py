# -*- coding: utf-8 -*-
"""
James W. Heiss, April 2023

This script:
    - creates a feature class of polygons of 1 deg lat from a lat lon grid
    - computes runoff intercept area and submerged catchment area with latitude
"""
import arcpy
import os
import numpy as np
arcpy.env.overwriteOutput = True

current_project = arcpy.mp.ArcGISProject(r"C:\Users\Administrator\Documents\Arc_global\globalSGD_hydrosheds3.aprx")

#%% create a feature class of polygons with a vertical dimension of 1 degree latitude from a 1x1 degree lat lon grid

scratch = r"C:\Users\Administrator\Documents\Arc_global\scratch.gdb"

grids = r"C:\Users\Administrator\Documents\Arc_global\globalSGD_hydrosheds.gdb\WorldLatitudeandLongitudeGri" 

output_path = r"C:\Users\Administrator\Documents\Arc_global\latitude_polygons_1_deg.gdb" 

latitude_steps = np.arange(-90, 91, 1)

arcpy.env.workspace = (scratch)
for h in range(0, len(latitude_steps)-1 ):
    arcpy.ClearWorkspaceCache_management() 
    
    arcpy.SelectLayerByAttribute_management(grids, "CLEAR_SELECTION")
    
    expression = "lat > " + str(latitude_steps[h]) + " And lat < " + str(latitude_steps[h+1])
    print("Starting", expression)   
   

    arcpy.MakeFeatureLayer_management(grids, "grids_layer") 
    
    arcpy.management.SelectLayerByAttribute("grids_layer", "NEW_SELECTION", expression, None)
       
    arcpy.conversion.FeatureClassToFeatureClass("grids_layer", scratch, "grid_lat_temp")

    arcpy.management.Delete("grids_layer")
        
    #export selected grids to feature class
    ave = abs((latitude_steps[h] + latitude_steps[h+1])/2)
    ave = str(ave)
    ave = ave.replace('-', '')
    ave = ave.replace('.', '_')
    
    if "-" in expression:
        output_lat_name = "lat_" + ave + "_S"
    else:
        output_lat_name = "lat_" + ave + "_N"
    
    output_path_full = os.path.join(output_path, output_lat_name)
    arcpy.management.Dissolve("grid_lat_temp", output_path_full, None, None, "MULTI_PART", "DISSOLVE_LINES")
 
    
#merge latitude polygons into single feature class--------

#first get list of polygon features
arcpy.env.workspace = output_path #set workspace
lat_polygon_list = arcpy.ListFeatureClasses()    

#merge
output_path_full = os.path.join(output_path, "lat_polygons")
arcpy.management.Merge(lat_polygon_list, output_path_full)
    
#add field for calculating latitude of each polygon
arcpy.AddField_management(output_path_full, "lat", "DOUBLE")  

#calculate geometry - lat value of center of each polygon
arcpy.management.CalculateGeometryAttributes(output_path_full, "lat INSIDE_Y", '', '', None, "SAME_AS_INPUT")



#%% compute runoff intercept area and submerged catchment area with latitude

scratch = r"C:\Users\Administrator\Documents\Arc_global\scratch.gdb"
lat_polygons_path_full = r"C:\Users\Administrator\Documents\Arc_global\latitude_polygons_1_deg.gdb\lat_polygons" 

#path to shapefiles with submerged catchment areas
catchment_submerged_path = r"C:\Users\Administrator\Documents\Arc_global\SLR_catchment_submerged"
shapefile_list_submerged = ["r855002040_submerged_catch.shp", "r855002080_submerged_catch.shp", "r855002120_submerged_catch.shp"] # datasets to loop through

#path to shapefiles with runoff intercept area
catchment_intercept_path = r"C:\Users\Administrator\Documents\Arc_global\SLR_runoff_intercept_area"
shapefile_list_intercept = ["r855002040_catchments_intercept.shp", "r855002080_catchments_intercept.shp", "r855002120_catchments_intercept.shp"] # datasets to loop through

#output path
output_path = r"C:\Users\Administrator\Documents\Arc_global\latitude_polygons_1_deg.gdb" 

latitude_steps = np.arange(-89.5, 90.5, 1)

arcpy.env.workspace = (scratch)

#empty arrays for storing areas
results_array_submerged = np.zeros(shape=(180, len(shapefile_list_submerged)+1))
results_array_intercept = np.zeros(shape=(180, len(shapefile_list_submerged)+1))
for h in range(0, len(shapefile_list_submerged)): 
    
    arcpy.ClearWorkspaceCache_management() 
    print(shapefile_list_submerged[h] + ' and ' + shapefile_list_intercept[h])
    
    submerged_RCP = os.path.join(catchment_submerged_path, shapefile_list_submerged[h])
    intercept_RCP = os.path.join(catchment_intercept_path, shapefile_list_intercept[h])
    
    #convert polygons to points
    arcpy.management.FeatureToPoint(submerged_RCP, 'submerged_pt_temp', "CENTROID")
    arcpy.management.FeatureToPoint(intercept_RCP, 'intercept_pt_temp', "CENTROID")
    
    #sum submerged catchment area, and sum runoff intercept area inside each 1 degree lat. polygon
    #submerged areas
    submerged_name = shapefile_list_submerged[h]
    submerged_RCP_lat = os.path.join(output_path, 'lat_' + submerged_name[:-4]) #output path
    arcpy.analysis.SummarizeWithin(lat_polygons_path_full, "submerged_pt_temp", submerged_RCP_lat, "KEEP_ALL", "Area_Km2 Sum", "NO_SHAPE_SUM", '', None, "NO_MIN_MAJ", "NO_PERCENT", None)
    #runoff intercept areas
    intercept_name = shapefile_list_intercept[h]
    intercept_RCP_lat = os.path.join(output_path, 'lat_' + intercept_name[:-4])  #output path
    arcpy.analysis.SummarizeWithin(lat_polygons_path_full, "intercept_pt_temp", intercept_RCP_lat, "KEEP_ALL", "AreaKm2Geo Sum", "NO_SHAPE_SUM", '', None, "NO_MIN_MAJ", "NO_PERCENT", None)
     
    submerged_RCP_lat_array = arcpy.da.TableToNumPyArray(submerged_RCP_lat, 'SUM_Area_km2')
    intercept_RCP_lat_array = arcpy.da.TableToNumPyArray(intercept_RCP_lat, 'SUM_AreaKm2Geo')
    
    results_array_submerged[:,h+1] = submerged_RCP_lat_array.astype(np.float32)
    results_array_intercept[:,h+1] = intercept_RCP_lat_array.astype(np.float32)
   
#insert latitude
results_array_submerged[:,0] = latitude_steps
results_array_intercept[:,0] = latitude_steps