clear all
close all
clc

wm=[10,250];
cells=8; %2x2x2

acq_energy;
d_acq;
d=d*1e-9;

%% Import data

% Coul-recip             En(x,:,2)
% EN Potential           En(x,:,3)
% K-En                   En(x,:,4)
% Total-Energy           En(x,:,5)
% Coul-SR:Zeo_fmw-Water  En(x,:,6)
% LJ-SR:Zeo_fmw-Water    En(x,:,7)
% Coul-SR:Water-Water    En(x,:,8)
% LJ-SR:Water-Water      En(x,:,9)
% Coul-SR:Water-NA_cat   En(x,:,10)
% LJ-SR:Water-NA_cat     En(x,:,11)

 
 for i=1:length(wm)
     cou_wna(i)=mean(En(i,:,10));
     lj_wna(i)=mean(En(i,:,11));
     cou_wf(i)=mean(En(i,:,6));
     lj_wf(i)=mean(En(i,:,7));
     cou_ww(i)=mean(En(i,:,8));
     lj_ww(i)=mean(En(i,:,9));  
 end

en_ww=(cou_ww+lj_ww)./(wm*cells);
en_wz=(cou_wna+lj_wna+cou_wf+lj_wf)./(wm*cells);
en_tot=(en_wz-en_ww).*(-1);

%% Energy due to zeolite-water interactions
figure1 = figure;
axes1 = axes('Parent',figure1,'FontSize',30);
box(axes1,'on');
hold(axes1,'all');
l1=plot(wm,en_ww,'s-','MarkerFaceColor',[0 0 0],...
   'MarkerEdgeColor',[0 0 0],'MarkerSize',16,'linewidth',2);
l2=plot(wm,en_wz,'o-','MarkerFaceColor',[0 0 1],...
     'MarkerEdgeColor',[0 0 1],'MarkerSize',16,'linewidth',2);
legend([l1,l2], {'WAT-WAT Energy','WAT-ZEO Energy'})
set(legend,'Interpreter','tex','fontsize',20);
xlim([0 300])
xlabel('Hydration level [WAT/UC] ','FontSize',36);
ylabel('Specific Energy [kJ/(mol*WAT)]','FontSize',36); 
title('Energy Interaction W-W, W-Z','fontsize',36)


%% Diffusivity
figure2 = figure;
axes1 = axes('Parent',figure2,'FontSize',30);
box(axes1,'on');
hold(axes1,'all');
l1=errorbar(wm,d(:,1),d(:,2),'s-','MarkerFaceColor',[0 0 0],...
   'MarkerEdgeColor',[0 0 0],'MarkerSize',16,'linewidth',2);
xlim([0 300])
xlabel('Hydration level [WAT/UC]','FontSize',36);
ylabel('D [m^2/s]','FontSize',36); 
title('Self Diffusion Coefficient','fontsize',36)

