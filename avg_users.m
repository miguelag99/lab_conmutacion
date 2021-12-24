function n = avg_users(array)
% Calculo de la media de usuarios a partir de un array con los tiempos y el
% numero total en el sistema
    stats = zeros(max(array(:,2))+1,2);
    stats(:,1)=[0:1:max(array(:,2))];
     
    aux = find(array(:,1) == -1,1,'first') - 1;
 
    for i = 2:length(array(1:aux))
       
        index = find(stats(:,1) == array(i-1,2),1,'first');
        dt = array(i,1)-array(i-1,1);
        stats(index,2) = stats(index,2) + dt;
    end
    
    n = (transpose(stats(:,1))*stats(:,2))/max(array(:,1));
    if n == -1 || isnan(n)
       n = 0; 
    end
end

