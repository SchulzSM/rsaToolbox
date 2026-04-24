function [intercept,slope,R2,F,prob]=rsaToolboxRegression(y,x);

[n,p]=size(x);
[Q,R]=qr(x,0);
b=R\(Q'*y);
intercept=b(1);

slope=b(2);

RSS=norm(x*b-mean(y))^2;
TSS=norm(y-mean(y))^2;
R2=round((RSS/TSS)*1000)/1000;

nu=max(0,n-p);
if nu~=0
    rmse=norm(y-x*b)/sqrt(nu);
else
    rmse=Inf;
end;
if (p>1)
    F=(RSS/(p-1))/(rmse^2);
else
    F = NaN;
end;
F=round(F*1000)/1000;

prob = zeros(size(F));
t = (p-1 <= 0 | nu <= 0 | isnan(F) | isnan(p-1) | isnan(nu));
prob(t) = NaN;
s = (F==Inf) & ~t;
if any(s)
   prob(s) = 1;
   t = t | s;
end;
k = find(F > 0 & ~t & isfinite(p-1) & isfinite(nu));
if any(k), 
    FF = F(k)./(F(k) + nu./(p-1));
    prob(k) = betainc(FF, (p-1)/2, nu/2);
end;
if any(~isfinite(p-1) | ~isfinite(nu))
   k = find(F > 0 & ~t & isfinite(p-1) & ~isfinite(nu) & nu>0);
   if any(k)
        FTemp=v1(k).*F(k);
        aTemp=v1(k)/2;
        bTemp=2;
        probTemp = zeros(size(FTemp));
        probTemp(aTemp <= 0 | bTemp <= 0) = NaN;
        kTemp = find(FTemp > 0 & ~(aTemp <= 0 | bTemp <= 0));
        if any(kTemp), 
            probTemp(kTemp) = gammainc(FTemp(kTemp) ./ bTemp(kTemp),aTemp(kTemp));
        end
        prob(prob > 1) = 1;
        kTemp = ~isfinite(probTemp);
        if (any(kTemp)), probTemp(FTemp>=sqrt(realmax)) = 1; end
        prob=probTemp;
   end
   k = find(F > 0 & ~t & ~isfinite(p-1) & (p-1)>0 & isfinite(nu));
   if any(k)
        FTemp=v2(k)./F(k);
        aTemp=v2(k)/2;
        bTemp=2;
        probTemp = zeros(size(FTemp));
        probTemp(aTemp <= 0 | bTemp <= 0) = NaN;
        kTemp = find(FTemp > 0 & ~(aTemp <= 0 | bTemp <= 0));
        if any(kTemp), 
            probTemp(kTemp) = gammainc(FTemp(kTemp) ./ bTemp(kTemp),aTemp(kTemp));
        end
        prob(prob > 1) = 1;
        kTemp = ~isfinite(probTemp);
        if (any(kTemp)), probTemp(FTemp>=sqrt(realmax)) = 1; end
        prob=1-probTemp;
   end
   k = find(F > 0 & ~t & ~isfinite(p-1) & (p-1)>0 & ~isfinite(nu) & nu>0);
   if any(k)
      prob(k) = (F(k)>=1);
   end
end
prob=1-prob;