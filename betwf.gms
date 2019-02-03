* betwf.gms

options OPTCR = 0
        MIP = CPLEX
        RESLIM = 3600
        THREADS = 0
        ITERLIM = 1e9;

sets t Perioden
     i Investitionsgueter
     k Komponenten
     j Teile
     s Schadensbilder;

alias(t, tau);
alias(t, tau2);

parameters
    ek(k,s,t)   Anzahl ankommender Teile von Komponente k mit Schadensbild s in Periode t
    due(i,k,j)  Bereistellungsfrist fuer Ersatzteil i k j
    nsa0(k,s)   Anfangsbestand Not-Serviceable Pool Teile von Komponente k mit Schadensbild s
    sa0(k)      Anfangsbestand Serviceable Pool Teile von Komponente k
    csa(k)      Bestellkosten von Komponente k
    cnsa(k,s)   Bestellkosten fuer Gebrauchtteil von Komponente k Schadensbild s
    c(i)        Verspätungskosten pro Periode pro Teil bei Regenerationsgut i
    d(k,s)      Reparaturdauer von Komponente k mit Schadensbild s;

free variables f;

binary variable
    x(i,k,j,t) 1 gdw. Ersatzteil i k j in Periode t bereitgestellt wird
    z(k,s,t)    Reparaturbeginn von einer Komponente k mit Schadensbild s aus NSA in Periode t;

integer variables
    ynsa(k,s,t) Bestellung von Gebrauchtteilen von Komponente k mit Schadensbild s in Periode t
    ysa(k,t)    Bestellung von Neuteilen von Komponente k in Periode t

    nsa(k,s,t)  Bestand in NSA-Pool von Komponente k mit Schadensbild s in Periode t
    sa(k,t)     Bestand in SA-Pool von Komponente k in Periode t
    v(i)        Verspätung aller Teile von Regenerationsgut i;


sets
     fw(k,s,t,tau) yes gdw. Reparatur von Komp k mit Schadenstyp s in tau begonnen werden kann wenn sie in t laueft;

equations
    obj         Zielfunktion
    versp       Bestimme Verspaetung aller Teile eines Guts
    once        Jedes Ersatzteil muss einmal bereitgestellt werden
    nsabilanz   Bilanzgleichung fuer NSA-Bestand
    sabilanz    Bilanzgleichung fuer SA-Bestand
    kaprestr    Maximal eine Reparatur von Komponente parallel;

obj .. f =e= sum(i, c(i)*v(i)) + sum((k,t), csa(k)*ysa(k,t))+sum((k,s,t),cnsa(k,s)*ynsa(k,s,t));
versp(i) .. v(i) =g= sum((k,j,t),x(i,k,j,t)*ord(t)-due(i,k,j));
once(i,k,j) .. sum(t, x(i,k,j,t)) =e= 1;
nsabilanz(k,s,t,tau)$(ord(tau)=ord(t)-1 and ord(t) > 1) .. nsa(k,s,t) =e= nsa(k,s,tau) - z(k,s,t) + ynsa(k,s,t) + ek(k,s,t);
sabilanz(k,t,tau)$(ord(tau)=ord(t)-1 and ord(t) > 1) .. sa(k,t) =e= sa(k,tau) + sum(s,sum(tau2$(ord(tau2)=ord(t)-d(k,s)), z(k,s,tau2))) + ysa(k,t) - sum((i,j), x(i,k,j,t));
kaprestr(k,t) .. sum((s,tau)$fw(k,s,t,tau), z(k,s,tau)) =l= 1;

model betwf /all/;

$include parsejson.inc
*$include instance.inc

fw(k,s,t,tau)$(ord(tau)>=ord(t)-d(k,s)+1 and ord(tau)<=ord(t)) = yes;

* Anfangsbestaende
nsa.fx(k,s,'t1')=nsa0(k,s);
sa.fx(k,'t1')=sa0(k);

solve betwf using mip minimizing f;

$include writejson.inc
execute_unload 'out.gdx'