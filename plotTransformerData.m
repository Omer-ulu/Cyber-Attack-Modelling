function plotTransformerData

algorithm = load('results/transformer/algorithmPricing.mat');
noAlgortihm = load('results/transformer/no-algorithm.mat');
hijackedAlgorithm = load('results/transformer/hijacked-algorithm.mat');
loadPv = load('results/transformer/loadPvTransformer.mat');

plot(algorithm.logsout_ee_voltreg_linear_feedback.get(3).Values,'b');
hold on; grid on;
plot(noAlgortihm.logsout_ee_voltreg_linear_feedback.get(3).Values,'r');
plot(hijackedAlgorithm.logsout_ee_voltreg_linear_feedback.get(3).Values,'g');
plot(loadPv.logsout_ee_voltreg_linear_feedback.get(3).Values,'k');
xlabel('Time (Minutes)');
ylabel('Power Usage (kWh)');
legend('Charging Algorithm','No Algorithm','Hijacked Algorithm','Only Load & PV');
title('Power on Transformer');

end