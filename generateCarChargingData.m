function generateCarChargingData(arrayType)

minutePrice = evalin('base','minutePrice');
hijackedMinutePrice = evalin('base', 'hijackedMinutePrice');

tempCar = readtable('simulation/data/ev/Ev_data.csv');
assignin('base','tempCar', tempCar);

initialTimeVector = datetime(tempCar.initialTime,'InputFormat','HH:mm')
endTimeVector = datetime(tempCar.finalTime,'InputFormat','HH:mm')
normalTimeVector = datetime(tempCar.normalChargingTime,'InputFormat','HH:mm')

for ii=1:1:10   

    car.initialTime = initialTimeVector(ii).Minute + (initialTimeVector(ii).Hour * 60);
    car.endTime = endTimeVector(ii).Minute + (endTimeVector(ii).Hour * 60);
    car.chargingPower = tempCar(ii,:).chargingPower;
    car.batteryCapacity = tempCar(ii,:).batteryCapacity;
    car.finalBatteryState = tempCar(ii,:).finalBatteryCapacity;
    car.initialBatteryState = tempCar(ii,:).initialBatteryCapacity;

    car.requiredCharge = car.batteryCapacity * ( car.finalBatteryState - car.initialBatteryState ) / 100;
    car.requiredTimeToCharge = ceil(( car.requiredCharge / car.chargingPower) * 60);   
    car.requiredTimeToChargeInHours = ceil(car.requiredTimeToCharge / 60); 
    
    disp("for car #" + ii +" ---> required charge hours "+ car.requiredTimeToChargeInHours +", start time(in hours) "+ initialTimeVector(ii).Hour+ ", end time(in hours) "+endTimeVector(ii).Hour);
  
     kk = 1
    
    priceComparisonVector = [];

    for jj= car.initialTime : 1 : car.endTime - car.requiredTimeToCharge        

        priceComparisonVector(kk).normalPrice = sum(minutePrice(jj:jj+car.requiredTimeToCharge)) * (car.chargingPower/1000);
        priceComparisonVector(kk).hijackedPrice = sum(hijackedMinutePrice(jj:jj+car.requiredTimeToCharge)) * (car.chargingPower/1000);
        priceComparisonVector(kk).startIndex = jj;   
        kk = kk+1;      

    end

    car.normalChargingPrice = sum(minutePrice(car.initialTime: car.initialTime + car.requiredTimeToCharge)) * (car.chargingPower / 1000);

    
    assignin('base',sprintf('priceComparisonVector%d',ii),priceComparisonVector);
   [minPriceHijacked,hijackedPriceIndex] = min([priceComparisonVector(:).hijackedPrice])

   car.hijackedAlgorithmChargingPrice = minPriceHijacked;
   car.hijackedNormalAlgorithmChargingPrice = priceComparisonVector(hijackedPriceIndex).normalPrice;

   car.endChargingTimeHijacked = priceComparisonVector(hijackedPriceIndex).startIndex + car.requiredTimeToCharge;
   car.startChargingTimeHijacked = priceComparisonVector(hijackedPriceIndex).startIndex;

   [minPrice, index] = min([priceComparisonVector(:).normalPrice]);

   car.algorithmChargingPrice = minPrice;

   car.endChargingTime = priceComparisonVector(index).startIndex + car.requiredTimeToCharge;
   car.startChargingTime = priceComparisonVector(index).startIndex;
    
   ev_array_hijacked = zeros(1440,1);
   ev_array_hijacked(:,1) = 1:1:1440;
   
   ev_array_hijacked( car.startChargingTimeHijacked : 1 : car.endChargingTimeHijacked , 2) = car.chargingPower;

   ev_array_normal_pricing = zeros(1440,1);
   ev_array_normal_pricing(:,1) = 1:1:1440;
   
   ev_array_normal_pricing( car.startChargingTime : 1 : car.endChargingTime , 2) = car.chargingPower;

   ev_array_original = zeros(1440,1);
   ev_array_original(:,1) = 1:1:1440;
   ev_array_original(car.initialTime : 1 : car.initialTime + car.requiredTimeToCharge, 2) = car.chargingPower; 
   
   assignin('base',sprintf('car%d',ii),car);
   assignin('base',sprintf('house%d_ev_array_hijacked',ii),ev_array_hijacked);
   assignin('base', sprintf('house%d_ev_array_original',ii),ev_array_original);
   assignin('base',sprintf('house%d_ev_array_normal_pricing',ii),ev_array_normal_pricing);

   switch arrayType
       case 'no-algorithm'
           assignin('base',sprintf('house%d_ev_array',ii),ev_array_original)
       case 'algorithm'
           assignin('base',sprintf('house%d_ev_array',ii),ev_array_normal_pricing)
       case 'hijacked-algorithm'
           assignin('base',sprintf('house%d_ev_array',ii),ev_array_hijacked);

   end

   

end

    totalPricingVector.normalPrice = 0;
    totalPricingVector.algorithmPrice = 0;
    totalPricingVector.hijackedPrice = 0;

    for ii=1:10

    car = evalin('base',sprintf('car%d',ii));
    totalPricingVector.normalPrice = totalPricingVector.normalPrice + car.normalChargingPrice;
    totalPricingVector.algorithmPrice = totalPricingVector.algorithmPrice + car.algorithmChargingPrice;
    totalPricingVector.hijackedPrice = totalPricingVector.hijackedPrice + car.hijackedNormalAlgorithmChargingPrice;

    end

    assignin('base',"totalPricingVector",totalPricingVector);

end