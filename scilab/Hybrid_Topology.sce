

clear;
clc;
clf;


NameOfNetwork = 'Hybrid Network Topology (Bus + Star + Mesh)';
NumberOfNodes = 25; // Total 25 nodes as per requirement

// NODE COORDINATES PLACEMENT
// Nodes 1-10: Bus topology (horizontal line)
// Nodes 11-18: Star topology (center at node 11)
// Nodes 19-25: Mesh topology (cluster)

XCoordinatesOfNodes = [100, 150, 200, 250, 300, 350, 400, 450, 500, 550,700, 650, 750, 700, 650, 750, 700, 650, 900, 850, 950, 900, 850, 950, 900];

YCoordinatesOfNodes = [500, 500, 500, 500, 500, 500, 500, 500, 500, 500, 500, 450, 450, 550, 550, 550, 400, 600, 500, 450, 450, 550, 550, 550, 500];

// EDGE CONNECTIONS

// 1. BUS TOPOLOGY CONNECTIONS (Nodes 1-10)
// Linear connections: 1-2, 2-3, 3-4, ..., 9-10
BusStartingNodes = [1, 2, 3, 4, 5, 6, 7, 8, 9];
BusEndingNodes   = [2, 3, 4, 5, 6, 7, 8, 9, 10];

// 2. STAR TOPOLOGY CONNECTIONS (Nodes 11-18)
// Node 11 as hub, connecting to 12-18
StarStartingNodes = [11, 11, 11, 11, 11, 11, 11];
StarEndingNodes   = [12, 13, 14, 15, 16, 17, 18];

// 3. MESH TOPOLOGY CONNECTIONS (Nodes 19-25)
MeshStartingNodes = [ 19, 19, 19, 19, 20, 20, 20, 21, 21, 22, 22, 22, 23, 23, 24, 24, 25];

MeshEndingNodes = [20, 21, 22, 23, 21, 22, 24, 22, 25, 23, 24, 25, 24, 25, 25, 19, 19];

// 4. INTER-CONNECTION BETWEEN TOPOLOGIES
// Connect Bus to Star (node 10 to node 11)
// Connect Star to Mesh (node 18 to node 19)
InterStartingNodes = [10, 18];
InterEndingNodes   = [11, 19];

// COMBINE ALL EDGES
StartingNodesOfConnection = [
    BusStartingNodes, StarStartingNodes, MeshStartingNodes, InterStartingNodes
];

EndingNodesOfConnection = [
    BusEndingNodes, StarEndingNodes, MeshEndingNodes, InterEndingNodes
];


// Alternative with continuation character
[TopologyGraph] = NL_G_MakeGraph(...
    NameOfNetwork, ...
    NumberOfNodes, ...
    StartingNodesOfConnection, ...
    EndingNodesOfConnection, ...
    XCoordinatesOfNodes, ...
    YCoordinatesOfNodes...
);

WindowIndex = 1;
[Graphparameters] = NL_G_ShowGraph(TopologyGraph, WindowIndex);
xtitle("Hybrid Network Topology (Bus + Star + Mesh)", "X-Coordinates", "Y-Coordinates");


WindowIndex = 2;
[GraphVisualise] = NL_G_ShowGraphNE(TopologyGraph, WindowIndex);
xtitle("Hybrid Topology with Node & Edge Numbers", "X-Coordinates", "Y-Coordinates");


WindowIndex = 3;


[GraphVisualise] = NL_G_ShowGraph(TopologyGraph, WindowIndex);
xtitle("Colored Hybrid Topology", "X-Coordinates", "Y-Coordinates");

// Color Bus topology nodes (1-10) in BLUE
NodeColor = 2; // Blue
BorderThickness = 8;
NodeDiameter = 25;
ListOfBusNodes = 1:10;
[coloredGraph, nodes] = NL_G_HighlightNodes(TopologyGraph, ListOfBusNodes, NodeColor, BorderThickness, NodeDiameter, WindowIndex);

// Color Star topology nodes (11-18) in GREEN
NodeColor = 3; // Green
ListOfStarNodes = 11:18;
[coloredGraph, nodes] = NL_G_HighlightNodes(coloredGraph, ListOfStarNodes, NodeColor, BorderThickness, NodeDiameter, WindowIndex);

// Color Mesh topology nodes (19-25) in RED
NodeColor = 5; // Red
ListOfMeshNodes = 19:25;
[coloredGraph, nodes] = NL_G_HighlightNodes(coloredGraph, ListOfMeshNodes, NodeColor, BorderThickness, NodeDiameter, WindowIndex);

EdgeColor = 30; // Yellow
EdgeWidth = 4;
ListOfInterEdges = [length(StartingNodesOfConnection)-1, length(StartingNodesOfConnection)];
[finalGraph, nodes] = NL_G_HighlightEdges(coloredGraph, ListOfInterEdges, EdgeColor, EdgeWidth, WindowIndex);

xtitle("Colored Hybrid Topology (Blue=Bus, Green=Star, Red=Mesh, Yellow=Interconnections)", "X-Coordinates", "Y-Coordinates");

disp("=== NODE CONNECTIVITY ANALYSIS ===");
maxEdges = 0;
nodeWithMaxEdges = 0;

for i = 1:NumberOfNodes
    [EdgeIndices] = NL_G_EdgesOfNode(TopologyGraph, i);
    numEdges = length(EdgeIndices);
    
    mprintf("Node %d has %d edges\n", i, numEdges);
    
    if numEdges > maxEdges then
        maxEdges = numEdges;
        nodeWithMaxEdges = i;
    end
end

disp(" ");
mprintf("Node with maximum edges: Node %d with %d edges\n", nodeWithMaxEdges, maxEdges);

[ExtractedNode, ExtractedEdge] = NL_G_GraphSize(TopologyGraph);
disp(" ");
disp("=== TOPOLOGY SUMMARY ===");
mprintf("Total Number of Nodes: %d\n", ExtractedNode);
mprintf("Total Number of Edges: %d\n", ExtractedEdge);


// Edge lengths
[EdgeLength] = NL_G_EdgesLength(TopologyGraph.node_x, TopologyGraph.node_y, TopologyGraph.head, TopologyGraph.tail);
disp(" ");
mprintf("Average edge length: %.2f units\n", mean(EdgeLength));

// Node degree distribution
disp(" ");
disp("=== TOPOLOGY BREAKDOWN ===");
mprintf("Bus Topology: Nodes 1-10 (%d nodes)\n", 10);
mprintf("Star Topology: Nodes 11-18 (%d nodes, Hub: Node 11)\n", 8);
mprintf("Mesh Topology: Nodes 19-25 (%d nodes)\n", 7);

// ============================================================
// PART 2: SCENARIO-BASED QUESTION
// ============================================================

disp(" ");
disp("================================================");
disp("SCENARIO-BASED QUESTION");
disp("================================================");
disp(" ");
disp("Scenario: Network Failure Analysis");
disp(" ");
disp("Consider the hybrid network topology you created representing a corporate network:");
disp("1. The Bus segment (Nodes 1-10) represents the main office floor");
disp("2. The Star segment (Nodes 11-18) represents the server room");
disp("3. The Mesh segment (Nodes 19-25) represents the executive wing");
disp(" ");
disp("Question: If Node 11 (Star topology hub) fails completely,");
disp("a) How many nodes become completely disconnected from the network?");
disp("b) Which segments can still communicate with each other?");
disp("c) What is the impact on the Mesh segment connectivity?");
disp("d) Suggest a redundant connection to prevent such complete disconnection.");
disp(" ");
disp("================================================");
