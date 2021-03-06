function score = objective( x, y, func )

    switch func
        case 'ackley'
            s1 = -0.2*sqrt(x.^2/2+y.^2/2);
            s2 = (cos(2*pi*x)+cos(2*pi*y))/2;
            score = 20 + exp(1) - 20*exp(s1) - exp(s2);
        case 'griewank'
            score = 1 + x.^2/4000 + y.^2/4000 - cos(x).*cos(y/sqrt(2)); 
        case 'rastrigin'
            score = 20 + x.^2 - 10*cos(2*pi*x) + y.^2 - 10*cos(2*pi*y);
        case 'rosenbrock'
            score = 100*(y-x.^2).^2 + (x-1).^2;
        case 'schafferF4'
            numrtr = cos(sin(abs(x.^2-y.^2))) - 0.5;
            dnmntr = (1+0.001*(x.^2+y.^2)).^2;
            score = 0.5 + numrtr/dnmntr;
        case 'schwefel'
            score = 2*418.9829 - x.*sin(sqrt(abs(x))) - y.*sin(sqrt(abs(y)));
        case 'sphere'
            score = x.^2 + y.^2;
        case 'table'
            s = abs(1-sqrt(x.^2+y.^2)/pi);
            score = -abs(sin(x).*cos(y).*exp(s));
        case 'levy'
            s1 = (sin(3*pi*x)).^2;
            s2 = (x-1).^2.*(1+(sin(3*pi*y)).^2);
            s3 = (y-1).^2.*(1+(sin(2*pi*y)).^2);
            score = s1+s2+s3;
        case 'dropwave'
            numrtr = 1+cos(12*sqrt(x.^2+y.^2));
            dnmntr = 2+0.5*(x.^2+y.^2);
            score = -numrtr./dnmntr;
        otherwise
            error('Unidentified function');
    end

end

