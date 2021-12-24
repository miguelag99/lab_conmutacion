function t = t_arrival(media)
%% Genera un valor aleatorio con distr. exponencial
    M = rand();
    t = -log(M)/media;
end

