# -*- coding: utf-8 -*-
"""
James W. Heiss, April 2023

This script calculates the area of catchments within a 30 km radius of points spaced 30 km along the global ocast

"""
import arcpy
import os
arcpy.env.overwriteOutput = True
arcpy.env.parallelProcessingFactor = 17

current_project = arcpy.mp.ArcGISProject(r"C:\Users\Administrator\Documents\Arc_global\globalSGD_hydrosheds.aprx")

#%% compute coastal catchment area for single scenario
scratch = r"C:\Users\Administrator\Documents\Arc_global\scratch.gdb"
arcpy.env.workspace = scratch

#path to catchments
catchment_features_to_summarize = r"C:\Users\Administrator\Documents\Arc_global\SLR_catchment\01mmSLR_catchments_v21.shp"

input_polygons = r"C:\Users\Administrator\Documents\Arc_global\SGD_averaging.gdb\coastline_pts30km_r455002080_30kmbuf"

#output full path
coastline_pts_summarized = r"C:\Users\Administrator\Documents\Arc_global\SGD_averaging.gdb\BC_01mmSLR_catchments_v21_centroid_30kmSum" 

print('summarizing within')
arcpy.analysis.SummarizeWithin(input_polygons, catchment_features_to_summarize, "temp_summarize", "KEEP_ALL", "Area_km2 Sum", "NO_SHAPE_SUM", "SQUAREKILOMETERS", None, "NO_MIN_MAJ", "NO_PERCENT", None)

print('converting summarized areas to points')
arcpy.management.FeatureToPoint("temp_summarize", coastline_pts_summarized, "CENTROID")

#%%compute spatial % change
scratch = r"C:\Users\Administrator\Documents\Arc_global\scratch.gdb"

catchment_averaging = r"C:\Users\Administrator\Documents\Arc_global\SGD_averaging.gdb" 

catchment_feature_class_path = r"C:\Users\Administrator\Documents\Arc_global\SLR_catchment" 
catchment_feature_classes = ["r855002040_catchments.shp", "r855002080_catchments.shp", "r855002120_catchments.shp"] #subset

input_polygons = r"C:\Users\Administrator\Documents\Arc_global\SGD_averaging.gdb\coastline_pts30km_r455002080_30kmbuf"

catchment_basecase_pts_sum = r"C:\Users\Administrator\Documents\Arc_global\SGD_averaging.gdb\BC_01mmSLR_catchments_v21_centroid_30kmSum"

arcpy.env.workspace = scratch
for h in range(0, len(catchment_feature_classes) ): 
    print(h)
    arcpy.env.workspace = scratch
    arcpy.ClearWorkspaceCache_management() 
  
    catchment_features_to_summarize = catchment_feature_classes[h]
    print("Starting", catchment_features_to_summarize)   
    
    catchment_features_to_summarize_full_path = os.path.join(catchment_feature_class_path, catchment_features_to_summarize) #input

    print('summarizing within')
    arcpy.analysis.SummarizeWithin(input_polygons, catchment_features_to_summarize_full_path, "temp_summarize", "KEEP_ALL", "Area_km2 Sum", "NO_SHAPE_SUM", "SQUAREKILOMETERS", None, "NO_MIN_MAJ", "NO_PERCENT", None)

    coastline_pts_summarized = catchment_features_to_summarize[:21] + "_30kmSum_pts"
    coastline_pts_summarized_full_path = os.path.join(catchment_averaging, coastline_pts_summarized) #input

    arcpy.management.FeatureToPoint("temp_summarize", coastline_pts_summarized_full_path, "CENTROID")
   
    fieldList = "SUM_Area_km2_BC" 
    arcpy.management.JoinField(coastline_pts_summarized_full_path, "OBJECTID", catchment_basecase_pts_sum, "OBJECTID", fieldList) 
    
    #delete unused fields
    drop_field_list = "Id", "SLR_cm", "Length_km", "BUFF_DIST", "ORIG_FID", "Area_km2_geod"
    arcpy.management.DeleteField(coastline_pts_summarized_full_path, drop_field_list)
    
    arcpy.AddField_management(coastline_pts_summarized_full_path, "perc_chng_sum", "DOUBLE")  

    field_expression = "percent_change(!SUM_Area_km2_BC!, !SUM_Area_km2!)" 
    codeblock = """def percent_change(SUM_Area_km2_BC, SUM_Area_km2):
                      result = []
                      result = ((SUM_Area_km2 - SUM_Area_km2_BC) / SUM_Area_km2_BC) * 100
                      return result"""
    arcpy.management.CalculateField(coastline_pts_summarized_full_path, "perc_chng_sum", field_expression, "PYTHON3", codeblock)
      
    print("done", catchment_features_to_summarize)  
        
print("finished all") 