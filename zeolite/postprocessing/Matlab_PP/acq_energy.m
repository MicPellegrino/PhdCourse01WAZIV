
for i=1:length(wm) 

datat=importdata(['Energy_' num2str(wm(i)) '.xvg'],' ',33);

En(i,:,:)=datat.data;
end



