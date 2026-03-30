// -------------------------------------------------------
// Task 1: Routing Performance Analysis
// Comparison of Bellman-Ford and Dijkstra Algorithms
// -------------------------------------------------------

// Clear console, memory and previous figures
clc;
clear;
clf();

// Arrays to store number of nodes and computation times
nodes = [];        // stores node sizes (5 to 100)
time_bf = [];      // stores average time for Bellman-Ford
time_dj = [];      // stores average time for Dijkstra

k = 1;  // index variable for storing results

// Loop to increase network size from 5 to 100 in steps of 5
for n = 5:5:100
    
    disp("Creating network with nodes: " + string(n));
    
    // -------------------------------------------------------
    // Step 1: Create Random Network Topology
    // -------------------------------------------------------
    L = 1000;     // Size of square simulation area (1000 x 1000)
    dmax = 150;   // Maximum connection radius between nodes
    
    // Generate network using Locality Connectivity method
    [g] = NL_T_LocalityConnex(n, L, dmax);
    
    // Select a random node as the source node
    src = NL_F_RandInt1n(length(g.node_x));
    
    // -------------------------------------------------------
    // Step 2: Apply Bellman-Ford Algorithm
    // -------------------------------------------------------
    // Run 5 iterations to calculate average computation time
    for i = 1:5
        timer();   // Start timer
        [dist1, pred1] = NL_R_BellmanFord(g, src);
        A(i) = timer();  // Store execution time
    end
    
    // Calculate average time for Bellman-Ford
    avg_bf = mean(A);
    
    // -------------------------------------------------------
    // Step 3: Apply Dijkstra Algorithm
    // -------------------------------------------------------
    // Run 5 iterations to calculate average computation time
    for j = 1:5
        timer();   // Start timer
        [dist2, pred2] = NL_R_Dijkstra(g, src);
        B(j) = timer();  // Store execution time
    end
    
    // Calculate average time for Dijkstra
    avg_dj = mean(B);
    
    // -------------------------------------------------------
    // Step 4: Store Results
    // -------------------------------------------------------
    nodes(k) = n;          // store number of nodes
    time_bf(k) = avg_bf;   // store Bellman-Ford time
    time_dj(k) = avg_dj;   // store Dijkstra time
    
    k = k + 1;  // increment index
    
end

// -------------------------------------------------------
// Step 5: Plot Performance Graph
// -------------------------------------------------------

// Plot Bellman-Ford execution time
plot(nodes, time_bf, '-or');

// Plot Dijkstra execution time
plot(nodes, time_dj, '-xb');

// Add legend and axis titles
legend("Bellman-Ford", "Dijkstra");
xtitle("Routing Time Comparison", "Number of Nodes", "Time (seconds)");

// Display completion message
disp("Task 1 Completed Successfully");
