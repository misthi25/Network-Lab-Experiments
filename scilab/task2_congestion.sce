// =====================================================
// TASK 2 - Congestion Control Simulation
// Using Dijkstra Routing Time as Congestion Measure
// =====================================================

clc;
clear;
clf();

disp("Starting Task 2 Execution...");

// =====================================================
// PART A : 200 and 300 Node Networks
// =====================================================

nodesA = [200 300];
timeA = zeros(1, length(nodesA));

for k = 1:length(nodesA)

    n = nodesA(k);
    disp("Processing Network Size: " + string(n));

    L = 1000;
    dmax = 150;

    // Generate network
    g = NL_T_LocalityConnex(n, L, dmax);

    // Random source node
    src = NL_F_RandInt1n(length(g.node_x));

    // Measure routing time (5 runs)
    t = zeros(1,5);
    for i = 1:5
        timer();
        [dist, pred] = NL_R_Dijkstra(g, src);
        t(i) = timer();
    end

    timeA(k) = mean(t);

end

// Plot Graph 1
scf(1);
clf();
plot(nodesA, timeA, '-or');
xlabel("Number of Nodes");
ylabel("Time (seconds)");
title("Congestion Simulation: 200 vs 300 Nodes");

disp("Part A Completed");


// =====================================================
// PART B : 500 → 400 → 300 → 200 → 100
// =====================================================

sizes = [500 400 300 200 100];
timeB = zeros(1, length(sizes));

for k = 1:length(sizes)

    n = sizes(k);
    disp("Processing Network Size: " + string(n));

    L = 1000;
    dmax = 150;

    // Generate network
    g = NL_T_LocalityConnex(n, L, dmax);

    src = NL_F_RandInt1n(length(g.node_x));

    // Measure routing time (5 runs)
    t = zeros(1,5);
    for i = 1:5
        timer();
        [dist, pred] = NL_R_Dijkstra(g, src);
        t(i) = timer();
    end

    timeB(k) = mean(t);

end

// Plot Graph 2
scf(2);
clf();
plot(sizes, timeB, '-xb');
xlabel("Number of Nodes");
ylabel("Time (seconds)");
title("Congestion Simulation: 500 to 100 Nodes");

disp("Task 2 Completed Successfully");
