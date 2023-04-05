# -*- coding: utf-8 -*-
"""
James W. Heiss, April 2023

This script computes future coastal catchment boundaries.
The key input datasets are CoastalDEM (Kulp and Strauss, 2021),
HydroSHEDS flow direction raster (www.hydroshare.org), and gridded local sea level
rise projections from Kopp et al. (2014; 2017).                                                        
"""

import arcpy
import os
import numpy as np
import time

arcpy.env.parallelProcessingFactor = 17

arcpy.env.overwriteOutput = True

arcpy.CheckOutExtension("3D")
arcpy.CheckOutExtension("spatial")

#%%
coastline_world = r"C:\Users\Administrator\Documents\Arc_global\globalSGD_hydrosheds.gdb\coastline_world" 
coastline_world_polygon_interior_dis = r"C:\Users\Administrator\Documents\Arc_global\globalSGD_hydrosheds.gdb\coastline_world_polygon_interior_dis" 
coastline_world_polygon_Diss_final = r"C:\Users\Administrator\Documents\Arc_global\globalSGD_hydrosheds.gdb\coastline_world_polygon_Diss_final" 
coastal_buffer_1km = r"C:\Users\Administrator\Documents\Arc_global\globalSGD_hydrosheds.gdb\coastal_buffer_1km"
Kopp = r"C:\Users\Administrator\Documents\Arc_global\KoppPoints\c2014_trim_16-50-83.shp" #units are cm
ws_geodatabase = r"C:\Users\Administrator\Documents\Arc_global\globalSGD_hydrosheds.gdb" 

ws1 = r"C:\Users\Administrator\Documents\Arc_global\2x2_DEM" #coastalDEMv2.1 directory with 2x2 degree CoastalDEMs
arcpy.env.workspace = ws1 
DEM_grids = arcpy.ListRasters()

ws2 = r"C:\Users\Administrator\Documents\Arc_global\2x2_present_coastline_sea_2_1"  #2x2 degree present-day coastline
arcpy.env.workspace = ws2 
coastline_grid = arcpy.ListFeatureClasses() 

ws3 = r"C:\Users\Administrator\Documents\Arc_global\2x2_DEMpoly_sea_2_1" #coastalDEMv2.1 2x2 polygon tiles
arcpy.env.workspace = ws3 
DEMpoly2x2 = arcpy.ListFeatureClasses() 


#-----------------------------------------------------------------------------
#scratch directories for intermediate outputs
wsScratch1 = r"D:\James\SGD_global\scratch01"
wsScratch2 = r"D:\James\SGD_global\scratch02"
wsScratch3 = r"D:\James\SGD_global\scratch03"
wsScratch4 = r"D:\James\SGD_global\scratch04"
wsScratch5 = r"D:\James\SGD_global\scratch05"
wsScratch6 = r"D:\James\SGD_global\scratch06"
scratch = [wsScratch1, wsScratch2, wsScratch3, wsScratch4, wsScratch5, wsScratch6]


#final output directories
SLR_submerged_tile = r"C:\Users\Administrator\Documents\Arc_global\SLR_submerged_tile"
#future coastline polylines not submerged
SLR_coastline_present = r"C:\Users\Administrator\Documents\Arc_global\SLR_coastline_present"
#submerged polygons
SLR_submerged = r"C:\Users\Administrator\Documents\Arc_global\SLR_submerged"
#future global coastline
SLR_coastline = r"C:\Users\Administrator\Documents\Arc_global\SLR_coastline" 
#future coastal catchments
SLR_catchment = r"C:\Users\Administrator\Documents\Arc_global\SLR_catchment" 
#catchment coastline
SLR_catchment_coastline = r"C:\Users\Administrator\Documents\Arc_global\SLR_catchment_coastline"


# files = os.listdir(SLR_coastline_present)
# for file in files:
#     os.remove(os.path.join(SLR_coastline_present, file))
    
# files = os.listdir(SLR_submerged)
# for file in files:
#   os.remove(os.path.join(SLR_submerged, file))
    
# files = os.listdir(SLR_coastline)
# for file in files:
#     os.remove(os.path.join(SLR_coastline, file))

# files = os.listdir(SLR_catchment)
# for file in files:
#     os.remove(os.path.join(SLR_catchment, file))

# files = os.listdir(SLR_catchment_coastline)
# for file in files:
#     os.remove(os.path.join(SLR_catchment_coastline, file))

#-----------------------------------------------------------------------------

#coastal buffer for decreasing computation time
coastal_buffer_buffer = r"C:\Users\Administrator\Documents\Arc_global\globalSGD_hydrosheds.gdb\coastal_buffer_buffer" 
#flow direction raster
world_dir_buf = r"C:\Users\Administrator\Documents\Arc_global\globalSGD_hydrosheds.gdb\world_dir_buf" 

current_project = arcpy.mp.ArcGISProject(r"C:\Users\Administrator\Documents\Arc_global\globalSGD_hydrosheds.aprx")


#%%
#compute catchments for RCP4.5 and 8.5 for the 1/6 (16.7%), 50%, and 5/6 (83.3%) percentiles
RCPs = ["r451672010", "r455002010", "r458332010", "r851672010", "r855002010", "r858332010"] #subset
RCPruntime = [] 
catchment_all_stats = np.zeros(shape=(len(RCPs),4)) #empty storage array
for h in range(0, len(RCPs) ):  #loop through scenarios
    arcpy.ClearWorkspaceCache_management() 
    
    #set snap raster environment
    arcpy.env.snapRaster = r"C:\Users\Administrator\Documents\Arc_global\globalSGD_hydrosheds.gdb\world_dir" 
    
    #remove tiles in SLR_submerged_tile from earlier iterations
    files = os.listdir(SLR_submerged_tile)
    for file in files:
      os.remove(os.path.join(SLR_submerged_tile, file))
      
    #start stopwatch
    start_time = time.time()
    
    RCP = RCPs[h]
    print(RCP)

    for i in range(0, len(DEM_grids), 1) : #for each 2x2 degree DEM
        arcpy.env.workspace = r"memory"
        DEM_grid_nam = os.path.join(ws1, DEM_grids[i])
        tile = os.path.join(ws3, DEMpoly2x2[i])
        coastline_grid_nam = os.path.join(ws2, coastline_grid[i])
        
        #set processing extent to combined extent of all input data
        arcpy.env.extent = "MAXOF"
        
        #find tile centroid
        arcpy.FeatureToPoint_management(tile, "tile_centroid", "CENTROID")

        #join Kopp et al points to DEM tile centroids
        fieldMappings = arcpy.FieldMappings()
        #add all fields from both shapefiles to be joined
        fieldMappings.addTable("tile_centroid")
        fieldMappings.addTable(Kopp)
        #remove all output fields from the field mappings, except SLR scenario
        for field in fieldMappings.fields:
            if field.name not in RCP:
                fieldMappings.removeFieldMap(fieldMappings.findFieldMapIndex(field.name))
        #merge future coastline with sections of present-day subaerial coastline
        arcpy.analysis.SpatialJoin("tile_centroid", Kopp, "tile_centroid_joined", "JOIN_ONE_TO_ONE", "KEEP_COMMON", fieldMappings, "CLOSEST")
        
        #extract SLR height for contouring
        with arcpy.da.SearchCursor("tile_centroid_joined", RCP) as cursor:
            for row in cursor:
                SLR = row[0]/100 #cm to m
                SLR = np.round(float(SLR), decimals=3)
        
        arcpy.env.workspace = scratch[h] #switch out of memory workspace   
        #-----------------------------------------------------------------------
       
        grid_num = ''.join(filter(lambda j: j.isdigit(), coastline_grid[i])) 
        submerged_tile_out_path = SLR_submerged_tile + "\\" + grid_num + ".shp"
        if SLR <= 0:
                arcpy.analysis.Clip(coastline_world_polygon_interior_dis, tile, SLR_submerged_tile + "\\" + grid_num + ".shp")
                
                print(i, grid_num, int(SLR*100), "cm", "SLR <=0; saved as lagoon")

        else:     
            arcpy.analysis.Clip(coastline_world_polygon_interior_dis, tile, "contour1_1.shp")
           
            #-----------contour-----------
            arcpy.sa.Contour(DEM_grid_nam, "contour1.shp", 1000000, SLR, 1, "CONTOUR_POLYGON", None) 
                                                        
            arcpy.MakeFeatureLayer_management("contour1.shp", "contour1_layer") 
            
            arcpy.SelectLayerByAttribute_management("contour1_layer", 'NEW_SELECTION', '"FID" = 1')
            
            arcpy.DeleteFeatures_management("contour1_layer")
                        
            arcpy.Merge_management(["contour1_layer", "contour1_1.shp"], "contour2.shp")  
            
            grid_num = ''.join(filter(lambda j: j.isdigit(), coastline_grid[i])) #get just the grid value
            arcpy.management.Dissolve("contour2.shp", submerged_tile_out_path, None, None, "MULTI_PART", "DISSOLVE_LINES")
            
            print(i, grid_num, int(SLR*100), "cm")
    

    #merge tiles
    arcpy.env.workspace = SLR_submerged_tile
    tiles_submerged_list = arcpy.ListFeatureClasses()
     
    arcpy.Merge_management(tiles_submerged_list, scratch[h] + "\\" + "contour3.shp")  
     
    # #delete tiles
    # arcpy.env.workspace = SLR_submerged
    # arcpy.management.Delete(tiles_submerged_list)
    
    arcpy.env.workspace = scratch[h]
    
    fieldMappings = arcpy.FieldMappings()
    fieldMappings.addTable("contour3.shp") 
    fieldMappings.addTable(coastal_buffer_1km)
    for field in fieldMappings.fields:
        fieldMappings.removeFieldMap(fieldMappings.findFieldMapIndex(field.name))
    arcpy.Merge_management(["contour3.shp", coastal_buffer_1km], "contour3_0.shp", fieldMappings)
    
    #clip submerged areas with world polygon
    print("clipping submerged areas with world polygon", RCP)
    arcpy.analysis.Clip("contour3_0.shp", coastline_world_polygon_Diss_final, "contour3_00.shp", None)
    
    #dissolve boundaries of submerged ares between tiles
    print("dissolving global submerged areas", RCP)
    arcpy.management.Dissolve("contour3_00.shp", "contour3_1.shp", None, None, "MULTI_PART", "DISSOLVE_LINES")
    arcpy.management.MultipartToSinglepart("contour3_1.shp", "contour3_2.shp")
    arcpy.management.EliminatePolygonPart("contour3_2.shp", "contour4.shp", "AREA", "10 SquareKilometers", "", "CONTAINED_ONLY")
        
    arcpy.MakeFeatureLayer_management("contour4.shp", "contour4_layer") 

    arcpy.SelectLayerByLocation_management("contour4_layer", "INTERSECT", coastline_world, "", "NEW_SELECTION", "INVERT") 
         
    print("deleting features not connected to the coast", RCP)
    contour4_layer = arcpy.management.DeleteFeatures("contour4_Layer") 
        
         
    #future shoreline--------------------------------------------------
    RCP_coastline_present = SLR_coastline_present + "\\" + RCP + "_coastline_present.shp"
    arcpy.CopyFeatures_management(coastline_world, RCP_coastline_present)
        
    print("dissolving submerged polygons", RCP)
    arcpy.Dissolve_management("contour4_Layer", "contour4_2.shp", "", "", "SINGLE_PART", "DISSOLVE_LINES")
    
    arcpy.cartography.SimplifyPolygon("contour4_2.shp", "contour4_3.shp", "POINT_REMOVE", "60 Meters", "0 SquareMeters", "RESOLVE_ERRORS", "NO_KEEP", None)   
        
    RCP_submerged = SLR_submerged + "\\" + RCP + "_submerged.shp"
    arcpy.analysis.Clip("contour4_3.shp", coastline_world_polygon_Diss_final, RCP_submerged, None)
    print("OUTPUT - submerged areas", RCP)
       
    #clean up topology 
    integrateIn = RCP_coastline_present + " 1;" + RCP_submerged + " 2"
    with arcpy.EnvManager(XYTolerance="50 Meters"): 
        arcpy.management.Integrate(integrateIn, None)    
     
    arcpy.env.workspace = scratch[h]
    print("converting submerged polygon to line", RCP)
    arcpy.management.PolygonToLine(RCP_submerged, "contour5.shp", "IDENTIFY_NEIGHBORS")
        
    print("copying contour5 for clipping and erasing", RCP)
    arcpy.CopyFeatures_management("contour5.shp", "contour5_1.shp")
    
    print("appending RCP_coastline_present to contour5.shp", RCP)
    arcpy.Append_management(RCP_coastline_present, "contour5.shp", "NO_TEST", "", "")

    print("erasing contour5.shp, RCP_coastline_present, contour6.shp", RCP)
    arcpy.analysis.Erase("contour5.shp", RCP_coastline_present, "contour6.shp", None) 
        
    print("erasing coastlines that are submerged", RCP)
    arcpy.analysis.Erase(RCP_coastline_present, RCP_submerged, "contour7.shp", None) 
        
    #extrct lagoon boundaries that are shared with future coastline------------
    #make copy of present lagoon polygons
    arcpy.management.CopyFeatures(coastline_world_polygon_interior_dis, "contour7_1.shp", '', None, None, None)
    print("densifying lagoons to aid snapping")
    arcpy.edit.Densify("contour7_1.shp", "DISTANCE", "150 Meters") # 0.000225225 = 25 m
    print("snapping lagoons to RCP_coastline_present") 
    snapEnv1 = ["contour5_1.shp", "VERTEX", "75 Meters"]
    snapEnv2 = ["contour5_1.shp", "EDGE", "75 Meters"]
    arcpy.edit.Snap("contour7_1.shp", [snapEnv1, snapEnv2])
    arcpy.edit.Generalize("contour7_1.shp", "0.0000001 Meters")
    
    arcpy.Clip_analysis("contour5_1.shp", "contour7_1.shp", "contour8.shp")
    
    #merge submerged, present, and lagoon coastlines
    fieldMappings = arcpy.FieldMappings()
    fieldMappings.addTable("contour6.shp") 
    fieldMappings.addTable("contour7.shp")
    fieldMappings.addTable("contour8.shp")
    for field in fieldMappings.fields:
        fieldMappings.removeFieldMap(fieldMappings.findFieldMapIndex(field.name))
    #future coastline
    arcpy.Merge_management(["contour6.shp", "contour7.shp", "contour8.shp"], "contour9.shp", fieldMappings)
        
    print("dissolving future coastline", RCP)
    arcpy.management.Dissolve("contour9.shp", "contour11.shp", None, None, "MULTI_PART", "DISSOLVE_LINES")
        
    
    
    #clip future coastline with 2x2 tile and append SLR rate
    RCP_coastline_out = SLR_coastline + "\\" + RCP + "_coastline.shp"
    arcpy.management.CreateFeatureclass(SLR_coastline, RCP + "_coastline.shp", "POLYLINE")
    arcpy.AddField_management(RCP_coastline_out, "SLR_cm", "LONG") 
    #loop through each tile and join nearest SLR rate from Kopp et al.
    arcpy.env.workspace = ws_geodatabase
    print("clipping coastline w/ tile and appending SLR value to tile coastlines", RCP)
    for i in range(0, len(DEM_grids)) : #for each grid

        arcpy.env.extent = "MAXOF"
             
        tile_poly = os.path.join(ws3, DEMpoly2x2[i])

        arcpy.analysis.Buffer(tile_poly, r"memory\contour12", "300 Meters", "FULL", "ROUND", "NONE", None, "PLANAR")
                
        arcpy.analysis.Clip(scratch[h] + "\\" + "contour11.shp", r"memory\contour12",  r"memory\contour13")
          
        #extract SLR rate -------------------
        #create centroid holder
        arcpy.FeatureToPoint_management(tile_poly, r"memory/tile_centroid", "CENTROID")

        #join Kopp et al. points to tile centroids
        fieldMappings = arcpy.FieldMappings()
        fieldMappings.addTable(r"memory\tile_centroid") 
        fieldMappings.addTable(Kopp)
        for field in fieldMappings.fields:
            if field.name not in RCP:
                fieldMappings.removeFieldMap(fieldMappings.findFieldMapIndex(field.name))
        arcpy.analysis.SpatialJoin(r"memory\tile_centroid", Kopp, r"memory\DEM_centroid_SLR", "JOIN_ONE_TO_ONE", "KEEP_COMMON", fieldMappings, "CLOSEST")
        
        with arcpy.da.SearchCursor(r"memory\DEM_centroid_SLR", RCP) as cursor:
            for row in cursor:
                SLR = row[0] #cm
                SLR = np.round(float(SLR), decimals=3)
        
        arcpy.AddField_management(r"memory\contour13", "SLR_cm", "LONG") 
        arcpy.management.CalculateField(r"memory\contour13", "SLR_cm", int(SLR));
        
        arcpy.Append_management(r"memory\contour13", RCP_coastline_out, "NO_TEST", None)
        
    #define coordinate system as WGS
    arcpy.management.DefineProjection(RCP_coastline_out, "GEOGCS['GCS_WGS_1984',DATUM['D_WGS_1984',SPHEROID['WGS_1984',6378137.0,298.257223563]],PRIMEM['Greenwich',0.0],UNIT['Degree',0.0174532925199433]]")
   
    #add length field and calculate length of coastline in each tile
    arcpy.AddField_management(RCP_coastline_out, "Length_km", "DOUBLE")
    arcpy.management.CalculateGeometryAttributes(RCP_coastline_out, "Length_km LENGTH_GEODESIC", "KILOMETERS", '', None, "SAME_AS_INPUT")
    print("future coastline w SLR (cm) value", RCP)
    
    coastline_tile_length_array = arcpy.da.TableToNumPyArray(RCP_coastline_out, 'Length_km')
    #convert to float
    coastline_tile_length_array = coastline_tile_length_array.astype(np.float32)
    
       
    
    #delineate streams, future catchments, and catchment coastlines------------
    coastline_global = SLR_coastline + "\\" + RCP + "_coastline.shp"
    
    arcpy.env.workspace = scratch[h]
    
    arcpy.analysis.Erase(coastal_buffer_buffer, RCP_submerged, "watershed1.shp", None)
    
    print("extracting flow direction raster outside submerged areas", RCP)
    out_raster = arcpy.sa.ExtractByMask(world_dir_buf, "watershed1.shp")
    out_raster.save("watershed2")
    
    #delineate streams for subaerial zones----------------------
    print("Calculating flow accumulations", RCP)
    out_accumulation_raster = arcpy.sa.FlowAccumulation("watershed2", None, "FLOAT", "D8");
    out_accumulation_raster.save("watershed2_accum.tif")
    
    #100 cell threashold from hydroshreds
    print("Calculating Nulls freom stream threshold", RCP)
    out_raster = arcpy.ia.SetNull("watershed2_accum.tif", "watershed2_accum.tif", "VALUE <= 100");
    out_raster.save("watershed2_accum_setNull.tif")
    
    #convert stream raster to int
    print("Converting flow accumulations to Int", RCP)
    out_raster = arcpy.ia.Int("watershed2_accum_setNull.tif");
    out_raster.save("watershed2_accum_setNull_int.tif")
    
    #convert stream raster to vector feature class
    print("Converting stream raster to vector", RCP)
    arcpy.sa.StreamToFeature("watershed2_accum_setNull_int.tif", world_dir_buf, "world_rivers_buf_calc.shp", "NO_SIMPLIFY")
    
    #delete temp files
    arcpy.Delete_management("watershed2_accum.tif")
    out_raster.save("watershed2_accum_setNull.tif")
    out_raster.save("watershed2_accum_setNull_int.tif")
    #----------------------------------------------------------
    
    
    #delineate future basins-----------------------------------
    print("delineating basins", RCP)
    out_raster = arcpy.sa.Basin("watershed2")
    out_raster.save("watershed3.tif")
    
    print("converting basins to polygons", RCP)
    arcpy.conversion.RasterToPolygon("watershed3.tif", "watershed4.shp", "NO_SIMPLIFY", "Value", "SINGLE_OUTER_PART", None)
    
    #select basins that intersect streams then invert 
    arcpy.MakeFeatureLayer_management("watershed4.shp", "watershed4_layer") 
    arcpy.SelectLayerByLocation_management("watershed4_layer", "INTERSECT", "world_rivers_buf_calc.shp", "", "NEW_SELECTION", "INVERT")             
    
    arcpy.management.CopyFeatures("watershed4_layer", "watershed5.shp", '', None, None, None)
    
    #dissolve catchments that share a boundary
    arcpy.management.Dissolve("watershed5.shp", "watershed6.shp", None, None, "SINGLE_PART", "DISSOLVE_LINES")
        
    arcpy.MakeFeatureLayer_management("watershed6.shp", "watershed6_layer") 
    
    #select catchments that intersect the coastline 
    arcpy.management.SelectLayerByLocation("watershed6_layer", "INTERSECT", RCP_coastline_out, "0.00225225 DecimalDegrees", "NEW_SELECTION", "NOT_INVERT")
      
    #future coastal catchments
    arcpy.management.CopyFeatures("watershed6_layer", 'watershed6_1.shp', '', None, None, None) #watershed_6_1.shp is future coastal catchments
        
    #calculate catchment areas
    print("calculating catchment area", RCP)  
    arcpy.AddField_management('watershed6_1.shp', "Area_km2", "DOUBLE")               
    arcpy.management.CalculateGeometryAttributes('watershed6_1.shp', "Area_km2 AREA_GEODESIC", "KILOMETERS", "SQUARE_KILOMETERS", None, "SAME_AS_INPUT")
                                 
    catchment_area_array = arcpy.da.TableToNumPyArray('watershed6_1.shp', 'Area_km2')
    catchment_area_array = catchment_area_array.astype(np.float32)
    #calculate catchment stats
    catchment_all_stats[h,0] = np.sum(catchment_area_array) #total catchment area [km2]
    catchment_all_stats[h,1] = np.median(catchment_area_array) #median catchment area [km2]
    catchment_all_stats[h,2] = np.mean(catchment_area_array) #mean catchment area [km2]
    catchment_all_stats[h,3] = np.shape(catchment_area_array)[0] #number of catchments
    #----------------------------------------------------------
    
    
    #catchment coastlines-----------------------------------------------------
    print("buffering coastal catchments", RCP)
    arcpy.analysis.Buffer('watershed6_1.shp', "watershed7.shp", "0.00225225 DecimalDegrees", "FULL", "ROUND", "NONE", None, "PLANAR")
        
    arcpy.analysis.Intersect("watershed7.shp", "watershed8.shp", "ALL", None, "INPUT")
    
    with arcpy.EnvManager(outputCoordinateSystem="GEOGCS['GCS_WGS_1984',DATUM['D_WGS_1984',SPHEROID['WGS_1984',6378137.0,298.257223563]],PRIMEM['Greenwich',0.0],UNIT['Degree',0.0174532925199433]]"):
        arcpy.analysis.Erase(RCP_coastline_out, "watershed8.shp", "watershed9.shp", None)
     
    print("dissolving", RCP)
    arcpy.management.Dissolve("watershed9.shp", "watershed10.shp", None, None, "MULTI_PART", "DISSOLVE_LINES")
        
    print("clipping", RCP)
    arcpy.analysis.Clip("watershed10.shp", "watershed7.shp", "watershed11.shp", None)
        
    print("multi-part to single-part", RCP)
    arcpy.management.MultipartToSinglepart("watershed11.shp", "watershed12.shp")
        
    print("locating coastal segment nearest to catchment", RCP)
    arcpy.Near_analysis("watershed12.shp", 'watershed6_1.shp', "#", "LOCATION", "NO_ANGLE")
        
    #dissolve by shared catchment NEAR_FID
    print("dissolving coastline using NEAR_FID", RCP)
    RCP_catchment_coastline = SLR_catchment_coastline + "\\" + RCP + "_catchment_coastline.shp"
    arcpy.management.Dissolve("watershed12.shp", RCP_catchment_coastline, "NEAR_FID", None, "MULTI_PART", "DISSOLVE_LINES")
       
    #calculate length of each multipart feature for each catchment
    #output is shapefile containing the coastline and its length for each catchment
    arcpy.AddField_management(RCP_catchment_coastline, "Length_km", "DOUBLE")
    arcpy.management.CalculateGeometryAttributes(RCP_catchment_coastline, "Length_km LENGTH_GEODESIC", "KILOMETERS", '', None, "SAME_AS_INPUT")
    print("cotchment coastline", RCP)
    
    
    #save runtime to variable        
    RCPruntime.append(round((time.time() - start_time)/(60*60), 1))
    print("--- %s hours ---" % RCPruntime, "Finished", RCP)   