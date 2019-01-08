function [S] = init_particles(M, bound_t, bound_l)
    S = [rand(1,M)*(bound_t(2) - bound_t(1)) + bound_t(1);
             rand(1,M)*(bound_l(2) - bound_l(1)) + bound_l(1);
             1/M*ones(1,M)];
end

