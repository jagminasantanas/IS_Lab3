clear
close all
clc

% Aprašoma norima imituoti kreivė 
X_SK = 20;
x = 0.1:1/(X_SK+2):1;
fn = ((1 + 0.6*sin(2*pi*x/0.7)) + 0.3*sin(2*pi*x))./2;
hold on
plot(x, fn, '*')

% Spindulio tipo bazinių funkcijų parametrai
C1 = 0.19;
r1 = 0.2;
C2 = 0.91;
r2 = 0.21;

w = rand(1,3);

STEP = 0.1;
for k = 1:10
    for x_nr = 1:X_SK
        %1 Sluoksnio aktyvavimo funkcijos
        F1 = exp(-((x(x_nr)-C1)^2./(2*r1^2)));
        F2 = exp(-((x(x_nr)-C2)^2./(2*r2^2)));
        
        % Tinklo atsakas
        v = F1*w(1+1)+F2*w(2+1)+w(0+1);

        y = v;
        % Atsako klaida
        e = fn(x_nr)-y;
        % Ryšių svorių atnaujinimas
        w(1+1) = w(1+1) + STEP.*e.*F1;
        w(2+1) = w(2+1) + STEP.*e.*F2;
        w(0+1) = w(0+1) + STEP.*e;
    
    end
end
X2_SK = 100;
x = 0.1:(1/(X2_SK-1)):1;
for x_nr = 1:X2_SK-(X2_SK*x(1))
   F1 = exp(-((x(x_nr)-C1)^2./(2*r1^2)));
   F2 = exp(-((x(x_nr)-C2)^2./(2*r2^2)));
   % Tinklo atsakas
   v = F1*w(1+1)+F2*w(2+1)+w(0+1);
   y(x_nr) = v;
end

plot(x, y)
hold off
