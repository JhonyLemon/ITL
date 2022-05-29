function DrawCircleOnGeoPlot(handle,latitude,longitude,radius)
lat=[];
lon=[];
for i=0:1:360
  lon(end+1)=radius*1*cosd(i)+longitude;  
  lat(end+1)=radius*sind(i)+latitude;  
end
geoplot(handle,lat,lon,'color','r','LineWidth',1,'AlignVertexCenters','off')
end