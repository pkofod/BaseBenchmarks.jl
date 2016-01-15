module MicroBenchmarks

# This module contains the Julia microbenchmarks shown in the language
# comparison table at http://julialang.org/.

import BaseBenchmarks
using BenchmarkTrackers

#######################
# recursive fibonacci #
#######################

perf_micro_fib(n) = n < 2 ? n : perf_micro_fib(n-1) + perf_micro_fib(n-2)

@track BaseBenchmarks.TRACKER begin
    @benchmarks begin
        (:micro_fib,) => perf_micro_fib(20)
    end
    @tags "micro" "recursion" "fibonacci" "fib"
end

############
# parseint #
############

function perf_micro_parseint(t)
    local n, m
    for i=1:t
        n = BaseBenchmarks.samerand(UInt32)
        s = hex(n)
        m = UInt32(parse(Int64,s,16))
    end
    @assert m == n
    return n
end

@track BaseBenchmarks.TRACKER begin
    @benchmarks begin
        (:micro_parseint,) => perf_micro_parseint(1000)
    end
    @tags "micro" "parse" "parseint"
end

##############
# mandelbrot #
##############

function mandel(z)
    c = z
    maxiter = 80
    for n = 1:maxiter
        if abs(z) > 2
            return n-1
        end
        z = z^2 + c
    end
    return maxiter
end

perf_micro_mandel() = [mandel(complex(r,i)) for i=-1.:.1:1., r=-2.0:.1:0.5]

@track BaseBenchmarks.TRACKER begin
    @benchmarks begin
        (:micro_mandel,) => perf_micro_mandel()
    end
    @tags "micro" "mandel" "mandelbrot"
end

#############
# quicksort #
#############

function quicksort!(a, lo, hi)
    i, j = lo, hi
    while i < hi
        pivot = a[(lo+hi)>>>1]
        while i <= j
            while a[i] < pivot; i += 1; end
            while a[j] > pivot; j -= 1; end
            if i <= j
                a[i], a[j] = a[j], a[i]
                i, j = i+1, j-1
            end
        end
        if lo < j; quicksort!(a,lo,j); end
        lo, j = i, hi
    end
    return a
end

perf_micro_quicksort(n) = quicksort!(BaseBenchmarks.samerand(n), 1, n)

@track BaseBenchmarks.TRACKER begin
    @benchmarks begin
        (:micro_quicksort,) => perf_micro_quicksort(5000)
    end
    @tags "micro" "sort" "quicksort"
end

########
# πsum #
########

function perf_micro_πsum()
    sum = 0.0
    for j = 1:500
        sum = 0.0
        for k = 1:10000
            sum += 1.0/(k*k)
        end
    end
    return sum
end

@track BaseBenchmarks.TRACKER begin
    @benchmarks begin
        (:micro_πsum,) => perf_micro_πsum()
    end
    @tags "micro" "pi" "π" "sum" "pisum" "πsum"
end

###############
# randmatstat #
###############

function perf_micro_randmatstat(t)
    n = 5
    v = zeros(t)
    w = zeros(t)
    for i=1:t
        a = randn(n,n)
        b = randn(n,n)
        c = randn(n,n)
        d = randn(n,n)
        P = [a b c d]
        Q = [a b; c d]
        v[i] = trace((P.'*P)^4)
        w[i] = trace((Q.'*Q)^4)
    end
    return (std(v)/mean(v), std(w)/mean(w))
end

@track BaseBenchmarks.TRACKER begin
    @benchmarks begin
        (:micro_randmatstat,) => perf_micro_randmatstat(1000)
    end
    @tags "micro" "rand" "randmatstat"
end

##############
# randmatmul #
##############

perf_micro_randmatmul(t) = BaseBenchmarks.samerand(t,t)*BaseBenchmarks.samerand(t,t)

@track BaseBenchmarks.TRACKER begin
    @benchmarks begin
        (:micro_randmatmul,) => perf_micro_randmatmul(1000)
    end
    @tags "micro" "rand" "randmatmul"
end

end # module