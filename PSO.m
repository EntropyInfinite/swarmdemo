function [ ] = PSO( func, minBound, maxBound )
    NumOfParticles = 100;
    inertia = 0.2;
    indC = 0.4;
    groupC = 0.4;
    maxIter = 1000;

    pause on
    
    %initialize particles, velocities and positions
    particles = random('unif',minBound,maxBound,NumOfParticles,2);
    bestpositions = particles;
    values = objective(particles(:,1),particles(:,2),func);
    [M, I] = min(values);
    globalbest = bestpositions(I,:);
    t = abs(maxBound-minBound);
    velocities = random('unif',-t,t,NumOfParticles,2);
    
    %initialize plotting stuff
    plotbest = zeros(1,maxIter+1);
    plotbest(1) = M;
    plotcur = zeros(1,maxIter+1);
    plotcur(1) = M;
    
    %show plot
    lnsp = linspace(minBound,maxBound,200);
    [X, Y] = meshgrid(lnsp);
    Z = objective(X,Y,func);
    subplot(2,2,[1,2])
    p = surf(X,Y,Z);
    set(p,'LineStyle','none');
    title('Search space')
    hold on
    scatter3(particles(:,1),particles(:,2),values,[],'black','filled')
    hold off
    subplot(2,2,3)
    plot(plotbest)
    hold on
    plot(plotcur)
    hold off
    title('Best function value')
    legend('global','current')
    subplot(2,2,4)
    t = sqrt(velocities(:,1).^2+velocities(:,2).^2);
    histogram(t)
    title('Particle velocities')
    
    %main loop
    for i=1:maxIter
        % generate random numbers
        rn = random('unif',0,1,NumOfParticles,2);
        % recalculate particle velocities
        velocities(:,1) = inertia*velocities(:,1) ... 
            + indC*rn(:,1).*(bestpositions(:,1)-particles(:,1)) ...
            + groupC*rn(:,2).*(globalbest(:,1)-particles(:,1));
        velocities(:,2) = inertia*velocities(:,2) ... 
            + indC*rn(:,1).*(bestpositions(:,2)-particles(:,2)) ...
            + groupC*rn(:,2).*(globalbest(:,2)-particles(:,2));
        % move particles
        particles = particles + velocities;
        % recalculate best positions
        values = objective(particles(:,1),particles(:,2),func);
        oldvalues = objective(bestpositions(:,1),bestpositions(:,2),func);
        bestpositions(values<oldvalues,:) = particles(values<oldvalues,:);
        [M, I] = min(values);
        old = objective(globalbest(1),globalbest(2),func);
        if M < old
            globalbest = bestpositions(I,:); 
        end
        % update plotting buffers
        globalbest
        plotbest(i+1) = objective(globalbest(1),globalbest(2),func);
        plotcur(i+1) = M;
        % do the plotting again
        h = subplot(2,2,[1,2]);
        p = surf(X,Y,Z);
        set(p,'LineStyle','none');
        set(h,'View',[-45 60]);
        title('Search space')
        hold on
        scatter3(particles(:,1),particles(:,2),values,[],'black','filled')
        hold off
        subplot(2,2,3)
        plot(plotbest)
        hold on
        plot(plotcur)
        hold off
        title('Best function value')
        legend('global','current')
        subplot(2,2,4)
        t = sqrt(velocities(:,1).^2+velocities(:,2).^2);
        histogram(t)
        title('Particle velocities')
        drawnow
        pause(0.2)
    end
end

