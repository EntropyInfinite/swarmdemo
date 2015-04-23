function [ ] = firefly( func, minBound, maxBound )
    NumOfParticles = 50;
    gamma = 1/sqrt(abs(maxBound-minBound));
    alpha = 0.01*abs(maxBound-minBound);
    maxIter = 1000;

    pause on
    
    %initialize particles, velocities and positions
    particles = random('unif',minBound,maxBound,NumOfParticles,2);
    values = objective(particles(:,1),particles(:,2),func);
    light = -values;
    [M, I] = min(values);
    globalbest = particles(I,:);
    
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
    histogram(light)
    title('Brightness distribution')
    
    %main loop
    for i=1:maxIter
        % iterate through fireflies
        for k=1:NumOfParticles
            for l=1:NumOfParticles
                if light(l)<=light(k)
                    continue
                end
                r = (particles(k,1)-particles(l,1)).^2 ...
                    +(particles(k,2)-particles(l,2)).^2;
                particles(k,:) = particles(k,:) ...
                    + alpha*random('norm',0,1,1,2) ...
                    + exp(-gamma*r)*(particles(l,:)-particles(k,:));
                values(k) = objective(particles(k,1),particles(k,2),func);
                light(k) = -values(k);
            end
        end
        [M, I] = min(values);
        old = objective(globalbest(1),globalbest(2),func);
        if M < old
            globalbest = particles(I,:); 
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
        histogram(light)
        title('Brightness distribution')
        drawnow
        pause(0.2)
    end
end

