function loadSimData(priceScenario)

clc; close all;
loadPriceData(priceScenario)

%House Load & PV & EV Data Loading
for ii=1:1:10
        
    dataPv = load(sprintf('simulation/data/house/pv/house%d_pv.txt',ii));
    dataPv(:,2) = dataPv(:,1);
    dataPv(:,1) = 1:1:1440;
    assignin('base',sprintf('house%d_pv_array',ii), dataPv);  

    dataLoad = load(sprintf('simulation/data/house/load/house%d_load.txt',ii));
    dataLoad(:,2) = dataLoad(:,1);
    dataLoad(:,1) = 1:1:1440  ;

    assignin('base',sprintf('house%d_load_array',ii), dataLoad);

end   

end