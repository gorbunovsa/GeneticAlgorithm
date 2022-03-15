const
    N=10000; {number of iterations}
    M=5000; {number of iterations without improvement}
type
    functionrezult=array[1..10] of real;
    selectmas=array[1..5,1..2] of byte;
    individual=array[1..16] of byte;
    population=array[1..10] of individual;
var
    absmin,funcmin1,funcmin2:real;
    funcrez:functionrezult;
    S:selectmas;
    ncount,mcount:integer;
    pop:population;
function f(x:real):real;
begin
    f:=(x-2)*(x-0.5)*(x-0.25)*(x-1.5)*sin(x/5)
end;
function pow (x,n:integer):real;
var
    i:integer;
    p:real;
begin
    if n=0 then pow:=1
    else if n>0 then
    begin
        p:=1;
        for i:=1 to n do
            p:=p*x;
        pow:=p
    end
    else
    begin
        p:=1;
        for i:=1 to -n do
            p:=p/x;
        pow:=p
    end
end;
function dec(var a:individual):real;
var
    x:real;
    i:integer;
begin
    x:=0;
    for i:=1 to 16 do
        x:=x+pow(2,-i+2)*a[i];
    dec:=x
end;
procedure generate(var pop:population);
var
    i,j:integer;
begin
    for i:=1 to 10 do
        for j:=1 to 16 do pop[i,j]:=random(2)
end;
procedure selection(var S:selectmas);
var i,x,y:integer;
begin
    for i:=1 to 5 do
    begin
        x:=random(10)+1;
        S[i,1]:=x;
        y:=random(10)+1;
        while y=x do y:=random(10)+1;
        S[i,2]:=y
    end
end;
procedure crossing(var pop:population; var S:selectmas);
var
    newpop:population;
    i,j:integer;
    t:boolean;
begin
    t:=true;
    for i:=1 to 5 do
        for j:=1 to 16 do
        begin
            if j>8 then t:=false;
            if t then
            begin
                newpop[2*i-1,j]:=pop[S[i,1],j];
                newpop[2*i,j]:=pop[S[i,2],j]
            end
            else
            begin
                newpop[2*i-1,j]:=pop[S[i,2],j];
                newpop[2*i,j]:=pop[S[i,1],j]
            end
        end;
    pop:=newpop
end;
procedure mutation(var pop:population); {chance of mutation = 25%}
var
    x,i,j:integer;
begin
    for i:=1 to 10 do
        for j:=1 to 16 do
        begin
            x:=random(4);
            if x=0 then
                if pop[i,j]=0 then pop[i,j]:=1
                else pop[i,j]:=0
        end
end;
function funcmin(var A:functionrezult):real;
var
    x:real;
    i:integer;
begin
    x:=A[1];
    for i:=2 to 10 do
        if A[i]<x then x:=A[i];
    funcmin:=x
end;
procedure createfuncrez(var funcrez:functionrezult; var pop:population);
var
    i:integer;
begin
    for i:=1 to 10 do
        funcrez[i]:=f(dec(pop[i]))
end;
begin
    absmin:=-0.0425;
    funcmin2:=absmin;
    ncount:=0;
    mcount:=0;
    randomize;
    generate(pop);
    createfuncrez(funcrez,pop);
    funcmin1:=funcmin(funcrez);
    repeat
        if ncount>N then
        begin
            writeln('Было сделано ',N,' итераций');
            writeln(funcmin2:18:18);
            exit
        end;
        if mcount>M then
        begin
            writeln('Было сделано ',M,' итераций без улучшения значения функции');
            writeln(funcmin2:18:18);
            exit
        end;
        selection(S);
        crossing(pop,S);
        mutation(pop);
        ncount:=ncount+1;
        createfuncrez(funcrez,pop);
        funcmin2:=funcmin(funcrez);
        if funcmin2>=funcmin1 then mcount:=mcount+1
        else
        begin
            mcount:=0;
            funcmin1:=funcmin2
        end
    until funcmin1<absmin;
    writeln('Достигнуто заданое значение! Найден экстремум ',funcmin1:18:18)
end.
