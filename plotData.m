function plotData
close all;
logsout_ee_voltreg_linear_feedback = evalin('base','logsout_ee_voltreg_linear_feedback')
transformer = logsout_ee_voltreg_linear_feedback.get(3).Values;
logsout_ee_voltreg_linear_feedback = logsout_ee_voltreg_linear_feedback.removeElement(3);

figure
for ii=1:10            
    house.load = logsout_ee_voltreg_linear_feedback.get(ii).Values;
    subplot(2,5,ii);
    plot(house.load, 'r');
    title(sprintf('House %d Load Data',ii));
    xlabel('Time (Minutes)')
    ylabel('Usage (kWh)')    
    hold on;
end

figure
plot(transformer);
xlabel('Time (Minutes)')
ylabel('Load (kWh)')    
legend('Electricity Usage (kWh)')

end